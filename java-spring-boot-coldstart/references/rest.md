# REST APIs

## Controller

A controller is a thin adapter: parse the request, call a service, return a DTO. Keep business logic in services.

```java
@RestController
@RequestMapping("/orders")
public class OrderController {
    private final OrderService service;

    public OrderController(OrderService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public OrderResponse create(@Valid @RequestBody CreateOrderRequest request) {
        return service.create(request);
    }

    @GetMapping("/{id}")
    public OrderResponse get(@PathVariable String id) {
        return service.findById(id);
    }
}
```

Notes:
- `@Valid` triggers Bean Validation on the body. Without it, the constraints on the record are ignored.
- Return DTOs (records), never JPA entities. Entities leak persistence concerns and risk lazy-loading explosions during serialization.
- `@ResponseStatus(HttpStatus.CREATED)` keeps status code declaration next to the handler. For dynamic status, return `ResponseEntity<...>` instead.

## Validation

Annotate request records with `jakarta.validation.constraints.*`:

```java
public record CreateOrderRequest(
    @NotBlank @Size(max = 64) String customerId,
    @NotEmpty @Valid List<LineItem> items,
    @Email String notifyEmail
) {
    public record LineItem(
        @NotBlank String sku,
        @Min(1) int quantity
    ) {}
}
```

Use `@Valid` on the nested list element type so each item is also validated. `@NotEmpty` on the list rejects `[]`; `@NotNull` only rejects `null`.

## Error handling

Spring Boot 3 renders errors as RFC 7807 `ProblemDetail` JSON when you opt in:

```yaml
spring:
  mvc:
    problemdetails:
      enabled: true
```

Throw domain exceptions; translate them to HTTP in one place with `@RestControllerAdvice`:

```java
@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(OrderNotFoundException.class)
    public ProblemDetail handleNotFound(OrderNotFoundException ex) {
        return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleValidation(MethodArgumentNotValidException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(
            HttpStatus.BAD_REQUEST, "Validation failed");
        pd.setProperty("errors", ex.getBindingResult().getFieldErrors().stream()
            .map(fe -> Map.of("field", fe.getField(), "message", fe.getDefaultMessage()))
            .toList());
        return pd;
    }
}
```

Domain exceptions stay framework-agnostic — they don't know about HTTP. The advice owns the translation. Don't `catch` exceptions in controllers just to convert them.

## Pagination

Accept `Pageable` directly; Spring binds `?page=0&size=20&sort=createdAt,desc` automatically.

```java
@GetMapping
public Page<OrderResponse> list(Pageable pageable) {
    return service.list(pageable);
}
```

## Common pitfalls

- **Returning entities** — couples API to schema. Always map to a DTO.
- **`@RequestBody` without `@Valid`** — validation silently does nothing.
- **Throwing `RuntimeException` for "not found"** — produces a 500. Define a real exception and map it to 404.
- **Catching exceptions in controllers** — defeats `@RestControllerAdvice`. Let them propagate.
