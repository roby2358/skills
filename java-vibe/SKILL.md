---
name: java-vibe
description: Onboarding guide for Python programmers moving to Java 21 + Spring Boot 3. Half "getting into the Java groove" (syntax, types, collections, tooling), half "getting into Spring Boot" (annotations, DI, controllers, config). Use when writing Java for the first time, translating Python instincts into Java idioms, or explaining Java concepts to a Python-fluent user. For code in a running project, see java-spring-boot. For bootstrapping a new project, see java-spring-boot-coldstart.
---

# Java Vibe

For Python programmers making the leap. Java is more ceremony, less improvisation — but the JVM and Spring Boot pay back the investment. Lean on what you already know; when Java does something different, we'll name why.

---

## Part 1: Getting into the Java groove

### The shape of a Java file

Python files are modules. Java files are **classes**. One public class per file, filename matches the class name exactly. `OrderService.java` contains `public class OrderService`.

```java
package com.example.orders;   // matches the directory: com/example/orders/

import java.util.List;         // per-class, not per-module

public class OrderService {    // everything lives inside a class
    public String greet(String name) {
        return "hello " + name;
    }
}
```

- **Packages are directories.** `com.example.orders` is the folder `com/example/orders/`. The compiler enforces it.
- **No free functions.** A module-level function becomes a `public static` method on a class. Think `MyModule.myFunction()`.
- **No `__init__.py`.** Being in the right directory is enough.

### Static typing is mandatory

Every variable, parameter, and return type is typed. The compiler is the first test suite you'll run.

```java
int count = 10;                     // primitive
String name = "alice";              // object
List<String> names = List.of("a");  // generic
var total = 0;                      // type inferred — like Python, but only for locals
```

Python `list[int]` ≈ Java `List<Integer>`. The `<>` is generics; it's required for collections.

### Primitives vs objects — the one that bites

Java has two number worlds:

- **Primitives** (`int`, `long`, `double`, `boolean`) — lowercase, no methods, can't be `null`.
- **Wrappers** (`Integer`, `Long`, `Double`, `Boolean`) — uppercase, full objects, can be `null`.

Auto-boxing converts between them, mostly invisibly. Two consequences:

- `int` can never be null. `Integer` can. Prefer primitives by default.
- `==` on `Integer` compares references, not values.

```java
Integer a = 200, b = 200;
a == b          // false! reference comparison
a.equals(b)     // true — value comparison
```

This is Java's version of Python's `is` vs `==` — except the trap is inverted (Python interns small ints; Java caches them only up to 127). **Rule: never use `==` on anything except primitives.** For strings and numbers, use `.equals()` or `Objects.equals(a, b)` (null-safe).

### Collections: the rough Python map

| Python                     | Java                                |
|----------------------------|-------------------------------------|
| `list`                     | `List<T>` → `new ArrayList<>()`     |
| `dict`                     | `Map<K, V>` → `new HashMap<>()`     |
| `set`                      | `Set<T>` → `new HashSet<>()`        |
| named `tuple` / dataclass  | `record`                            |
| `[1, 2, 3]`                | `List.of(1, 2, 3)` (immutable)      |
| `[x for x in ys if ok(x)]` | `ys.stream().filter(Thing::ok).toList()` |

Declare with the interface, instantiate the concrete: `List<Order> orders = new ArrayList<>();`. Lets you swap implementations later without changing callers.

### `null` is `None`, but more dangerous

`null` has no methods and no type. A `NullPointerException` is Java's `AttributeError: 'NoneType'...` — but the stack trace may be far from the real cause. Two habits:

- **Fail fast in constructors:** `this.repo = Objects.requireNonNull(repo);`. NPE at construction beats NPE three calls deep in a request.
- **Empty, not null, for collections.** Return `List.of()`, never `null`. Empty ≠ absent.

`Optional<T>` exists for return types where absence is meaningful. Don't use it for parameters, fields, or "maybe-null property" — that's not what it's for.

### Records are dataclasses

Records are Java's dataclass / Pydantic model for simple data:

```java
public record OrderRequest(String customerId, List<LineItem> items) {}
```

You get `equals`, `hashCode`, `toString`, and immutability for free. Use them for DTOs, value objects, and configuration. The accessor is `order.customerId()` — no `get` prefix.

### Strings

- **Concatenation** with `+` works but is slow in tight loops. For many pieces, `StringBuilder` or `String.join`.
- **Formatting:** `String.format("hello %s", name)` or `"hello %s".formatted(name)`. No f-strings. Text blocks `"""..."""` for multi-line (SQL, JSON).
- **Equality:** `.equals()`. Never `==`.

### Exceptions

Python: every exception is unchecked; you choose what to catch.
Java: historically had **checked** exceptions the compiler forces you to handle or declare with `throws`. In modern code, **avoid creating new checked exceptions** — wrap them in `RuntimeException`. They poison every signature up the stack and add no real safety.

```java
try {
    return Files.readString(path);
} catch (IOException e) {
    throw new RuntimeException(e);   // or a domain-specific unchecked exception
}
```

Catch narrow exception types, not `Exception`. Swallowing everything hides bugs.

### The `with` statement is `try-with-resources`

Anything implementing `AutoCloseable` (files, JDBC connections, HTTP clients):

```java
try (var in = Files.newBufferedReader(path)) {
    return in.readLine();
}   // close() is called automatically — even if the body throws
```

### Build tools: Maven is your `pip` + `poetry` + `setup.py`

- **`pom.xml`** declares dependencies and build config — `requirements.txt` on steroids, in XML.
- **`./mvnw`** is the Maven wrapper. Commit it; teammates don't need Maven installed.
- **Common commands:**
  - `./mvnw compile` — compile
  - `./mvnw test` — unit tests
  - `./mvnw verify` — tests + integration tests + static checks (run this before pushing)
  - `./mvnw spring-boot:run` — run the app
  - `./mvnw package` — build the JAR

Gradle exists too (uses `build.gradle` / `build.gradle.kts`); the commands are similar (`./gradlew build`, `./gradlew bootRun`).

### Running Java

No REPL by default, but **`jshell`** gives you one — handy for scratching out a snippet. Otherwise run via your build tool or IDE. There's always a compile step; no editing code while it runs (Spring DevTools gets close).

### A few more "yes, really"s

- **`final`** on a field or local = "don't reassign". Use it liberally; it's the closest thing to `const`. Python equivalent: convention only.
- **`var`** (Java 10+) is local type inference: `var orders = new ArrayList<Order>();`. Use when the right-hand side makes the type obvious; skip when it would hide an opaque return type.
- **`enum`** is a real keyword and a real type. Prefer it over string constants for closed sets (status, role, mode).
- **Streams** replace comprehensions: `.stream().filter(...).map(...).toList()`. A terminal operation (`toList`, `forEach`, `reduce`) is required — intermediate ops are lazy.
- **`java.time`** for dates: `Instant`, `Duration`, `LocalDate`. Never `Date` or `SimpleDateFormat` (not thread-safe, confusing API).
- **`BigDecimal`** for money. Never `double` or `float` — you will lose cents.
- **Interfaces > duck typing.** Python's "if it has `.read()`, it's a file" becomes "declare and implement an interface." Feels heavy at first; the compiler makes up for it.

---

## Part 2: Getting into Spring Boot

### The Django / FastAPI comparison

- Spring Boot ≈ Django or FastAPI with batteries included.
- **Annotations** (`@RestController`, `@GetMapping`) ≈ FastAPI decorators (`@app.get`). They *look* similar, but at startup Spring scans them with reflection and wires proxies — it's not simple function wrapping.
- **Dependency injection** ≈ FastAPI `Depends`, but it's the default wiring mechanism, not opt-in. Spring finds your components and hands them to constructors.
- **`application.yml`** ≈ `.env` + `settings.py`, but typed and profile-aware.

### The shape of a Spring Boot app

```
src/main/java/com/example/app/
├── AppApplication.java        # @SpringBootApplication — the entry point
└── orders/
    ├── OrderController.java   # HTTP adapter
    ├── OrderService.java      # business logic
    ├── OrderRepository.java   # data access
    └── Order.java             # entity or record
src/main/resources/
└── application.yml            # config
src/test/java/...              # tests mirror main/
```

Organize by **feature** (`orders/`, `shipments/`), not by **layer** (`controllers/`, `services/`). Related code changes together; feature packages keep diffs small.

### A minimal controller

```java
@RestController
@RequestMapping("/orders")
public class OrderController {
    private final OrderService service;

    public OrderController(OrderService service) {
        this.service = service;   // constructor injection — Spring wires this
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public OrderResponse create(@Valid @RequestBody CreateOrderRequest request) {
        return service.create(request);
    }

    @GetMapping("/{id}")
    public OrderResponse get(@PathVariable String id) {
        return service.get(id);
    }
}
```

- **`@RestController`** — "methods return JSON, not templates."
- **`@RequestMapping("/orders")`** — path prefix for the whole class.
- **`@GetMapping` / `@PostMapping`** — verb + path suffix.
- **`@RequestBody`** — deserializes JSON into the parameter type (Jackson, like Pydantic).
- **`@Valid`** — triggers Bean Validation (`@NotBlank`, `@Positive` on the DTO). **Without `@Valid`, the constraints are silently ignored.**
- **`@PathVariable`** — pulls `{id}` from the URL.

### Dependency injection: constructor-only

One constructor, all dependencies `final`. **No `@Autowired` on fields.** Spring sees the constructor and passes in its parameters. The class is trivially testable with plain `new` — no framework needed for unit tests.

```java
@Service
public class OrderService {
    private final OrderRepository repo;
    private final PricingClient pricing;

    public OrderService(OrderRepository repo, PricingClient pricing) {
        this.repo = repo;
        this.pricing = pricing;
    }
}
```

The **stereotype annotations** (`@Service`, `@Repository`, `@Component`) tell Spring "create an instance of this and make it available for injection." `@RestController` is one too.

### Config: `application.yml` + typed properties

```yaml
# application.yml
app:
  pricing:
    base-url: https://pricing.example.com
    timeout: 2s
```

```java
@ConfigurationProperties("app.pricing")
@Validated
public record PricingProperties(
    @NotBlank String baseUrl,
    @Positive Duration timeout
) {}
```

Enable scanning with `@ConfigurationPropertiesScan` on the application class. Invalid config becomes a startup error — fail fast beats a 3 AM page. Use `application-local.yml` and `application-prod.yml` (activated with `--spring.profiles.active=prod`) for environment differences. **Never commit secrets** — use env vars or a secrets manager.

### Running it

```
./mvnw spring-boot:run
```

This runs the `public static void main` in your `@SpringBootApplication` class. Add `spring-boot-devtools` to `pom.xml` for the `uvicorn --reload` equivalent — it restarts on code changes.

### Health and ops

Add `spring-boot-starter-actuator`. `/actuator/health` is what load balancers hit. Lock down the rest (`/env`, `/beans`, `/configprops` leak internals).

### Testing

- **Unit test** — plain JUnit + Mockito, no Spring:
  ```java
  @Test
  void createsOrder() {
      var repo = mock(OrderRepository.class);
      var service = new OrderService(repo, pricing);
      var result = service.create(request);
      assertThat(result.id()).isEqualTo("o-123");
  }
  ```
- **Controller test** — `@WebMvcTest` + `MockMvc` loads just the controller and validation.
- **JPA queries** — `@DataJpaTest`.
- **Full wiring** — `@SpringBootTest`. Slow; use sparingly.

Mock collaborators, never the class under test. Assert on outcomes (return values, saved state, messages sent), not on `verify(...).times(3)` — that couples tests to implementation.

### Things that will feel odd at first

- **The app does a lot at startup.** Component scanning, bean creation, auto-configuration. When startup fails, read the *cause chain* at the bottom of the stack trace, not the giant wall at the top — the real message is usually `Caused by: ...` several layers down.
- **Annotations have invisible effects.** `@Transactional` only works when called *across* a Spring proxy. Calling a `@Transactional` method from another method in the same class silently bypasses it.
- **Never return JPA entities from controllers.** They're tied to the DB session; serializing them can trigger lazy loads and leak the schema. Map to a DTO (usually a record).
- **Dependency trees are deep.** `./mvnw dependency:tree` shows who brought what.
- **Logging:** get a logger once per class, use SLF4J parameterized messages:
  ```java
  private static final Logger log = LoggerFactory.getLogger(OrderService.class);
  log.info("processing order {}", id);   // not "processing order " + id
  ```

---

## Where to go next

- **Comfortable with the basics?** See `java-spring-boot` for tighter guidance on production code.
- **Bootstrapping a new project?** See `java-spring-boot-coldstart` for the team's starter setup.
- **Don't reach for Lombok.** Records + a one-line SLF4J logger cover most of its value; the build and IDE entanglement isn't worth it.
