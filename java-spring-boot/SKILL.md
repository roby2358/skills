---
name: java-spring-boot
description: Best practices for Java 21 web services and Spring Boot 3 applications. Use when writing or reviewing Java code in a Spring Boot project — controllers, services, configuration, data access, tests. For bootstrapping a brand-new project, see java-spring-boot-coldstart instead.
---

# Java Spring Boot

Pragmatic guidance for code that's already running. Half is modern Java 21; half is Spring Boot 3 idiom.

---

## Java 21 for web services

### Warm up: things that bite

- **One public class per file; filename matches class name.** `OrderService.java` contains `public class OrderService`. Inner classes are fine; sibling top-level classes go in their own files.

- **Naming is load-bearing.** `PascalCase` for classes, records, interfaces, enums. `camelCase` for methods and fields. `UPPER_SNAKE_CASE` for `static final` constants. `lowercase.dotted` for packages. Spring, Jackson, and JPA all infer behavior from these.

- **`==` vs `.equals()`.** `==` compares references; `.equals()` compares value. For `String`, **always** `.equals()` — or `Objects.equals(a, b)` if either side might be null. Same trap with boxed numbers: `Integer a = 200, b = 200; a == b` is `false`.

- **Declare with the interface, instantiate the concrete.** `List<Order> orders = new ArrayList<>();` not `ArrayList<Order> orders = ...`. Decouples callers from the implementation choice.

- **Try-with-resources for anything `AutoCloseable`.** Files, JDBC connections, HTTP clients. The resource is closed even when the body throws.

  ```java
  try (var in = Files.newBufferedReader(path)) {
      return in.readLine();
  }
  ```

- **Fail fast with `Objects.requireNonNull`.** In a constructor: `this.repo = Objects.requireNonNull(repo);`. NPE at construction beats NPE three calls deep in a request.

- **Catch narrow.** Handle the specific exception you can do something about. Swallowing `Exception` hides bugs and breaks Spring's `@Transactional` rollback (it only rolls back on unchecked exceptions by default).

- **Use `enum` for closed sets.** Status codes, roles, modes. Far better than `String` constants — type-checked, exhaustive in `switch`, free `valueOf`.

### Use records for data

Records replace getter/setter classes for DTOs, configuration objects, and value types. They are immutable, get `equals`/`hashCode`/`toString` for free, and serialize cleanly with Jackson.

```java
public record OrderRequest(String customerId, List<LineItem> items) {}
```

Bean Validation annotations (`@NotBlank`, `@Valid`, etc.) work directly on record components.

### Constructor injection with `final` fields

No `@Autowired`, no field injection. One constructor, all dependencies `final`. Spring picks up the constructor automatically. The class is trivially testable with `new`.

```java
public OrderService(OrderRepository repository, PricingClient pricing) { ... }
```

### Prefer immutability

`final` fields, `List.copyOf(...)` for defensive copies, `Map.of` / `List.of` for literals. Mutable shared state is the main source of subtle bugs in concurrent code — and a web request handler is concurrent code.

### Pattern matching for `switch`

Replaces nested `if/instanceof` chains. Sealed types let the compiler enforce exhaustiveness.

```java
String describe(Event e) {
    return switch (e) {
        case OrderCreated o   -> "created " + o.id();
        case OrderCancelled c -> "cancelled " + c.id();
    };
}
```

### Virtual threads for I/O

Set `spring.threads.virtual.enabled=true` to run request handlers on virtual threads. Big throughput win when most of the request is waiting on DB queries, downstream HTTP, or messaging. **Don't** use them for CPU-bound work — they help with blocking I/O, not computation.

### Use the modern APIs

- **Time** — `Instant`, `Duration`, `LocalDate` from `java.time`. Never `Date`, `Calendar`, or `SimpleDateFormat`.
- **Money** — `BigDecimal`, never `double` or `float`. Compare with `compareTo`, not `equals` (`1.0` ≠ `1.00`).
- **Streams** — `.toList()` (Java 16+) instead of `.collect(Collectors.toList())`.
- **Text blocks** — `"""..."""` for SQL, JSON fixtures, multi-line prompts.
- **Optional** — return type only. Never a parameter, never a field. Don't use it for "maybe-null property"; use a nullable field with documentation.

### Avoid

- **Checked exceptions in new code.** Wrap in unchecked. They poison every signature up the stack and add no safety in practice.
- **Null returns from collections.** Return `List.of()`, not `null`. Empty is not absent.
- **`Lombok`.** Records + a one-line SLF4J logger replace 80% of it; the rest isn't worth the build-tool entanglement and IDE quirks.
- **`var` everywhere.** Use it when the type is obvious from the right-hand side (`var orders = new ArrayList<Order>()`) and harmful when it isn't (`var x = service.find(id)` — what type?).

---

## Spring Boot 3

### Project layout: by feature, not by layer

```
com.example.app/
├── orders/    OrderController, OrderService, Order, OrderRepository
└── shipments/ ShipmentController, ...
```

Layered packages (`controllers/`, `services/`, `repositories/`) scatter related code. Feature packages keep change footprints small.

### Configuration: `@ConfigurationProperties`, not `@Value`

Group related settings into a typed record, validate at startup, and get IDE autocomplete via `spring-boot-configuration-processor`.

```java
@ConfigurationProperties("app.pricing")
@Validated
public record PricingProperties(@NotBlank String baseUrl, @Positive Duration timeout) {}
```

Enable scanning with `@ConfigurationPropertiesScan` on the application class. Bind from `application.yml`. Use profiles (`application-local.yml`, `application-prod.yml`) for environment differences. **Never commit secrets** — use env vars or a secrets manager.

### Controllers are thin adapters

Parse the request, call a service, return a DTO. Business logic lives in services.

```java
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public OrderResponse create(@Valid @RequestBody CreateOrderRequest request) {
    return service.create(request);
}
```

`@Valid` is what activates Bean Validation on the body. Without it, the constraints are silently ignored.

### Never return entities from controllers

Map to a DTO. Entities leak the persistence model, change with the schema, and risk lazy-loading explosions during JSON serialization.

### Centralize error handling

Throw domain exceptions in services; map them to HTTP in one place with `@RestControllerAdvice` and `ProblemDetail` (RFC 7807). Domain code stays framework-agnostic.

```java
@ExceptionHandler(OrderNotFoundException.class)
public ProblemDetail handleNotFound(OrderNotFoundException ex) {
    return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
}
```

Don't `catch` exceptions in controllers just to convert them — let them propagate.

### Spring Security 6: `SecurityFilterChain` bean

The old `WebSecurityConfigurerAdapter` is gone. Configure auth as a `SecurityFilterChain` bean using the lambda DSL. For services behind a JWT-issuing IdP, configure as an OAuth2 resource server (`oauth2ResourceServer(o -> o.jwt(...))`) and let Spring fetch the JWKS.

Lock down actuator: only `/actuator/health` should be public. `/env`, `/beans`, `/configprops` leak internals.

### `@Transactional` deliberately

Annotate at the **service** layer, not on repositories or controllers. Use `readOnly = true` for queries — it's a hint to the JDBC driver and skips dirty-checking. Never call a `@Transactional` method from inside the same class (self-invocation bypasses the proxy).

### Tests: pick the smallest one that proves the thing

| Need to test            | Use |
|-------------------------|-----|
| Pure logic              | Plain JUnit + `new`, mock collaborators with Mockito |
| Controller routing/validation | `@WebMvcTest` + `MockMvc` |
| JPA queries             | `@DataJpaTest` |
| End-to-end wiring       | `@SpringBootTest` (sparingly — slow) |

Default to plain unit tests. Step up only when you need framework infrastructure. Mock collaborators, **never the class under test**. Assert on outcomes (returned values, persisted state, messages sent) — not on `verify(...).times(3)`, which couples tests to implementation.

For real DB / AWS in integration tests, use Testcontainers with `@ServiceConnection` (Boot 3.1+).

### Logging

```java
private static final Logger log = LoggerFactory.getLogger(OrderService.class);
```

SLF4J with parameterized messages — `log.info("processing order {}", id)`, never `log.info("processing order " + id)` (concatenation runs even when the level is disabled, and breaks structured logging).

### Build & runtime hygiene

- **Pin** the Spring Boot parent version. Don't auto-bump.
- Run `./mvnw verify` (not `test`) before pushing — `verify` runs Failsafe integration tests too.
- Name unit tests `*Test.java`, integration tests `*IT.java`.
- Add `spring-boot-starter-actuator` early — `/actuator/health` is what your load balancer wants.
- Fail fast at startup: `@Validated` on `@ConfigurationProperties` turns missing/invalid config into a startup error, not a 3 AM page.
