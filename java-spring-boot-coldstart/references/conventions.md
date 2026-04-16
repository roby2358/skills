# Conventions

## Project layout

Spring Initializr places code under `src/main/java/<group>/<artifact>/`. Inside that root package, organize by feature, not by layer:

```
com.example.ordersapi/
├── OrdersApiApplication.java          # @SpringBootApplication entrypoint
├── config/                            # @Configuration classes (security, web, AWS)
├── orders/                            # one feature package
│   ├── OrderController.java
│   ├── OrderService.java
│   ├── Order.java                     # domain record/class
│   └── OrderRepository.java
└── shipments/                         # another feature
    └── ...
```

Feature packages keep related code together so a change to "orders" rarely touches "shipments". Shared cross-cutting code (error handlers, configuration) lives at the root or under `config/`.

## Dependency injection: constructor only

Spring picks up a single public constructor automatically — no `@Autowired` needed. `final` fields make dependencies immutable and the class trivially testable (just `new`).

```java
@Service
public class OrderService {
    private final OrderRepository repository;
    private final PricingClient pricing;

    public OrderService(OrderRepository repository, PricingClient pricing) {
        this.repository = repository;
        this.pricing = pricing;
    }
}
```

Do **not** use field injection (`@Autowired` on a field). It hides dependencies, breaks immutability, and forces reflection in tests.

## Records for DTOs

Use Java records for request/response payloads and value objects. They are immutable, get `equals`/`hashCode`/`toString` for free, and serialize cleanly with Jackson.

```java
public record CreateOrderRequest(
    @NotBlank String customerId,
    @NotEmpty List<@Valid LineItem> items
) {}

public record OrderResponse(String id, String status, BigDecimal total) {}
```

Bean Validation annotations work directly on record components.

## Configuration

Prefer `@ConfigurationProperties` over scattered `@Value` injections. It groups related settings, validates them at startup, and shows up in IDE autocomplete (the `configuration-processor` dependency provides this).

```java
@ConfigurationProperties("app.pricing")
@Validated
public record PricingProperties(
    @NotBlank String baseUrl,
    @Positive Duration timeout
) {}
```

Enable in the application class:

```java
@SpringBootApplication
@ConfigurationPropertiesScan
public class OrdersApiApplication { ... }
```

Bind from `application.yml`:

```yaml
app:
  pricing:
    base-url: https://pricing.example.com
    timeout: 2s
```

## On Lombok

Lombok is popular in older Spring codebases (`@Data`, `@RequiredArgsConstructor`, `@Slf4j`) but adds a compile-time agent and can fight Java records, IDE refactors, and newer language features. Records + a one-line SLF4J logger usually replace 80% of what teams use Lombok for. **Don't add it to a new project; if a code review brings it up, you'll have a clear answer.**

For a logger without Lombok:

```java
private static final Logger log = LoggerFactory.getLogger(OrderService.class);
```

## Java 21 features worth using

- **Records** — DTOs, value objects, configuration properties (above).
- **Pattern matching for `switch`** — replaces nested `if/instanceof` chains.

  ```java
  String describe(Shape s) {
      return switch (s) {
          case Circle c    -> "circle r=" + c.radius();
          case Square sq   -> "square s=" + sq.side();
          case null        -> "none";
      };
  }
  ```

- **Sealed interfaces** — model a closed set of variants (e.g. event types) and let the compiler enforce exhaustive `switch`.
- **Virtual threads** — set `spring.threads.virtual.enabled=true` to run web request handlers on virtual threads. Big win for I/O-heavy workloads (HTTP calls, DB queries). Don't use them for CPU-bound work.
- **Text blocks** (`"""..."""`) — for SQL, JSON test fixtures, prompts.

## Build hygiene

- Run `./mvnw verify` before pushing — runs tests + checks.
- Use `./mvnw spring-boot:run` for local dev; it picks up `application.yml` and any `application-local.yml` profile.
- Pin the Spring Boot parent version in `pom.xml`. Don't auto-bump.
