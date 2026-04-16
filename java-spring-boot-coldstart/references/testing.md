# Testing

`spring-boot-starter-test` brings JUnit 5, Mockito, AssertJ, and Spring's test support. Pick the smallest test that proves the thing.

## Levels of test

| Test type             | Annotation              | Loads                          | Use for |
|-----------------------|-------------------------|--------------------------------|---------|
| Plain unit            | (none)                  | Nothing — `new` the class      | Pure logic in services |
| Web slice             | `@WebMvcTest`           | One controller + MVC infra     | Controller routing, validation, error handling |
| Data slice            | `@DataJpaTest`          | JPA + in-memory DB             | Repository queries |
| Full integration      | `@SpringBootTest`       | Whole context                  | End-to-end flows, wiring |

Default to a plain unit test. Step up to a slice test only when you need the framework. `@SpringBootTest` is slow — use sparingly.

## Plain unit test

```java
class OrderServiceTest {
    private final OrderRepository repository = mock(OrderRepository.class);
    private final PricingClient pricing = mock(PricingClient.class);
    private final OrderService service = new OrderService(repository, pricing);

    @Test
    void calculatesTotalFromPricing() {
        when(pricing.priceFor("sku-1")).thenReturn(new BigDecimal("9.99"));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        OrderResponse result = service.create(new CreateOrderRequest("cust-1",
            List.of(new LineItem("sku-1", 2))));

        assertThat(result.total()).isEqualByComparingTo("19.98");
        verify(repository).save(any(Order.class));
    }
}
```

Notes:
- Constructor injection makes this trivial — no Spring needed.
- AssertJ (`assertThat`) reads better than JUnit's `assertEquals` and gives clearer failure messages.
- `verify` on side-effecting calls (saves, sends), not on every interaction. Tests that mirror the implementation break on every refactor.

## Web slice test

```java
@WebMvcTest(OrderController.class)
class OrderControllerTest {
    @Autowired private MockMvc mvc;
    @MockBean private OrderService service;
    @Autowired private ObjectMapper json;

    @Test
    @WithMockUser(authorities = "SCOPE_orders:write")
    void rejectsBlankCustomerId() throws Exception {
        var bad = new CreateOrderRequest("", List.of());

        mvc.perform(post("/orders")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(bad)))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.detail").value("Validation failed"));
    }
}
```

`@WebMvcTest` only loads the named controller plus MVC + Security. Service layers must be `@MockBean`'d in.

## Security in tests

`@WithMockUser` sets an authenticated principal. For JWT-style scope checks, set `authorities`:

```java
@WithMockUser(authorities = {"SCOPE_orders:read"})
```

For per-test customization, use the request post-processor:

```java
mvc.perform(get("/orders/123").with(jwt().jwt(j -> j.claim("sub", "user-42"))))
```

(`jwt()` comes from `org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors`.)

## Integration tests with Testcontainers

For tests against a real DB or LocalStack (SQS), use Testcontainers and Spring Boot's `@ServiceConnection`:

```java
@SpringBootTest
@Testcontainers
class OrderFlowIT {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @Container
    static LocalStackContainer localstack = new LocalStackContainer(
        DockerImageName.parse("localstack/localstack:3"));

    @DynamicPropertySource
    static void awsProps(DynamicPropertyRegistry registry) {
        registry.add("spring.cloud.aws.sqs.endpoint", localstack::getEndpoint);
        registry.add("spring.cloud.aws.region.static", localstack::getRegion);
        registry.add("spring.cloud.aws.credentials.access-key", localstack::getAccessKey);
        registry.add("spring.cloud.aws.credentials.secret-key", localstack::getSecretKey);
    }
}
```

`@ServiceConnection` (Spring Boot 3.1+) wires standard containers (Postgres, Redis, Kafka) automatically. LocalStack still needs `@DynamicPropertySource` since Spring Boot doesn't ship a connection detail for it.

Name integration tests `*IT.java` so the Failsafe plugin runs them in the `verify` phase, separate from unit tests in `test`.

## Common pitfalls

- **Reaching for `@SpringBootTest` first** — it boots the whole app per test class. Slice tests are 10–100× faster.
- **Mocking the class under test** — only mock collaborators. If you find yourself mocking the thing you're testing, you're testing the mock.
- **Asserting on internal calls** (`verify(...).times(3)`) — couples tests to implementation. Assert on outcomes (returned values, persisted state, messages sent).
- **Forgetting `@WithMockUser` on a `@WebMvcTest`** — every endpoint will return 401 and the failure message won't say why.
