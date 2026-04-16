# Security

Spring Security 6 (Boot 3.x) configures via a `SecurityFilterChain` bean and a fluent **lambda DSL**. The old `WebSecurityConfigurerAdapter` class is gone — don't use examples that extend it.

## Default behavior

Adding `spring-boot-starter-security` to the classpath secures every endpoint with HTTP Basic and a generated password (printed at startup). That is the default — it must be replaced before deploying.

## Filter chain: JWT resource server

Most internal services authenticate via a JWT issued by an upstream identity provider. Configure the app as an OAuth2 resource server:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/health/**").permitAll()
                .requestMatchers(HttpMethod.GET, "/orders/**").hasAuthority("SCOPE_orders:read")
                .requestMatchers(HttpMethod.POST, "/orders/**").hasAuthority("SCOPE_orders:write")
                .anyRequest().authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .csrf(csrf -> csrf.disable());  // safe to disable for stateless JSON APIs
        return http.build();
    }
}
```

```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: https://auth.example.com/realms/internal
```

Spring fetches the JWKS from the issuer's well-known endpoint and validates incoming `Authorization: Bearer <jwt>` headers automatically.

## Authority mapping

By default, JWT scopes become authorities prefixed with `SCOPE_` (e.g. `orders:read` → `SCOPE_orders:read`). To use roles from a custom claim, register a `JwtAuthenticationConverter`:

```java
@Bean
public JwtAuthenticationConverter jwtAuthConverter() {
    JwtGrantedAuthoritiesConverter authorities = new JwtGrantedAuthoritiesConverter();
    authorities.setAuthoritiesClaimName("roles");
    authorities.setAuthorityPrefix("ROLE_");

    JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
    converter.setJwtGrantedAuthoritiesConverter(authorities);
    return converter;
}
```

Spring picks up the bean automatically; no extra wiring needed.

## Method security

For finer-grained checks inside services, enable method security and use `@PreAuthorize`:

```java
@Configuration
@EnableMethodSecurity
public class MethodSecurityConfig {}
```

```java
@PreAuthorize("hasAuthority('SCOPE_orders:write')")
public OrderResponse cancel(String orderId) { ... }

@PreAuthorize("hasAuthority('SCOPE_orders:read') and #customerId == authentication.name")
public List<OrderResponse> myOrders(String customerId) { ... }
```

Use sparingly — most authz belongs at the URL level in the filter chain. Method security shines for object-level permissions (e.g. "can this user touch this specific order?").

## CORS

If the API is called by browsers from a different origin, enable CORS in the filter chain and define the allowed origins centrally:

```java
http.cors(Customizer.withDefaults());

@Bean
CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowedOrigins(List.of("https://app.example.com"));
    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE"));
    config.setAllowedHeaders(List.of("Authorization", "Content-Type"));
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", config);
    return source;
}
```

Don't use `*` for allowed origins on an authenticated API — browsers reject it.

## Common pitfalls

- **Looking up old `WebSecurityConfigurerAdapter` examples** — removed in Spring Security 6. Always use the `SecurityFilterChain` bean.
- **Disabling CSRF without thinking** — fine for stateless JSON APIs called by SPAs/services, dangerous for browser-rendered apps with cookies.
- **Wide-open actuator** — only `/actuator/health` should be public. Everything else (`/actuator/env`, `/actuator/beans`) leaks internals.
- **`permitAll()` on a path that should be authenticated** — the filter chain matches in order; check the order when something is unexpectedly public.
- **Not testing security** — see [testing.md](testing.md) for `@WithMockUser` and `MockMvc` security helpers.
