# Java 17 + Spring Boot 3

## Java 17 Features (Use Actively)
- Records for DTOs, value objects, and API responses.
- Sealed interfaces/classes for domain modeling with exhaustive pattern matching.
- `switch` expressions (not statements) with pattern matching.
- Text blocks for multi-line strings (SQL, JSON templates).
- `Optional` for return types that may be absent. Never pass `Optional` as a parameter.

## Spring Boot 3 Standards
- Use constructor injection (not `@Autowired` on fields). Single constructor = no annotation needed.
- Prefer `@Configuration` + `@Bean` over component scanning for infrastructure beans.
- Use `@ConfigurationProperties` with records for type-safe config. Never read `@Value` inline.
- Use `spring-boot-starter-validation` with Jakarta `@Valid` on controller inputs.
- Profiles: `application.yml` for defaults, `application-{profile}.yml` for overrides.

## Project Structure
```
src/main/java/com/example/
  config/          # Spring configuration, beans
  domain/          # Entities, value objects, enums (no Spring dependencies)
  repository/      # Data access interfaces
  service/         # Business logic
  controller/      # REST endpoints (thin, delegates to service)
  dto/             # Request/Response records
  exception/       # Custom exceptions + @ControllerAdvice handler
```

## REST API Conventions
- Use `ResponseEntity<>` with proper HTTP status codes.
- Global exception handler via `@RestControllerAdvice`.
- Validate request bodies with `@Valid`. Return 400 with field-level errors.
- Pagination: use Spring `Pageable`. Return `Page<T>` or a custom wrapper.
- API versioning via URL path: `/api/v1/`.

## Data Access
- Spring Data JPA for PostgreSQL. Spring Data MongoDB for Mongo.
- Define repository interfaces. Use `@Query` for complex queries, not derived method names beyond 2 conditions.
- Use `@Transactional` on service methods, not repositories.
- Flyway or Liquibase for PostgreSQL schema migrations. Never use `ddl-auto` in production.

## Redis Usage
- Use `spring-boot-starter-data-redis` with `RedisTemplate` or `@Cacheable`.
- Cache strategy: cache-aside with TTL. Set explicit TTLs on every cache entry.
- Use `@Cacheable`, `@CacheEvict`, `@CachePut` for method-level caching.
- Prefix all keys with service name: `myapp:users:{id}`.

## Async & Messaging
- `@Async` with custom `TaskExecutor` for CPU-bound work.
- Spring Kafka: `@KafkaListener` for consumers, `KafkaTemplate` for producers.
- Use `spring-kafka` JSON serializer/deserializer with schema registry when available.

## Logging
- Use SLF4J (`@Slf4j` from Lombok or `LoggerFactory.getLogger()`).
- Structured logging: include correlation IDs, user context.
- Log levels: ERROR (action needed), WARN (attention), INFO (business events), DEBUG (dev only).
- Never log sensitive data (passwords, tokens, PII).
