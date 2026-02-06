# Order Management Service

## What Is This
REST API for managing customer orders, inventory, and payment processing in an e-commerce platform.

## Tech Stack
- **Language**: Java 17
- **Framework**: Spring Boot 3.3
- **Database**: PostgreSQL 16 (primary), Redis 7 (cache/sessions)
- **Messaging**: Kafka (order events, inventory sync)
- **Infra**: Docker, Kubernetes, GitHub Actions CI/CD

## How to Run
```bash
# Start dependencies (PostgreSQL, Redis, Kafka)
docker-compose up -d

# Run locally
./mvnw spring-boot:run -Dspring-boot.run.profiles=local

# Run tests
./mvnw test

# Run integration tests (requires Docker)
./mvnw verify -P integration

# Build
./mvnw clean package -DskipTests
```

## Project Structure
```
src/main/java/com/example/orders/
  config/              # Spring config, Redis, Kafka, security beans
  domain/              # JPA entities, enums, value objects
  repository/          # Spring Data JPA repositories
  service/             # Business logic (OrderService, PaymentService, InventoryService)
  controller/          # REST controllers (/api/v1/orders, /api/v1/inventory)
  dto/                 # Request/response records (CreateOrderRequest, OrderResponse)
  exception/           # Custom exceptions + GlobalExceptionHandler
  event/               # Kafka producers/consumers (OrderPlacedEvent, InventoryUpdatedEvent)
  mapper/              # MapStruct mappers

src/main/resources/
  application.yml      # Default config
  application-local.yml
  application-prod.yml
  db/migration/        # Flyway migrations (V1__, V2__, ...)

src/test/
  java/                # Unit + integration tests
  resources/           # Test configs, Testcontainers setup
```

## Key Decisions / Quirks
- UUID v7 for all entity IDs (time-sortable, used as public-facing identifiers)
- Flyway for schema migrations — never modify a released migration
- Redis cache-aside pattern with 15min TTL on product catalog, 5min on user sessions
- Kafka topics: `orders.order.placed`, `orders.order.completed`, `inventory.stock.updated`
- All money amounts stored as `BigDecimal` with scale 2 — never use `double` for money
- Optimistic locking (`@Version`) on Order and Inventory entities
- Auth handled by API Gateway (Kong) — services receive validated JWT in `X-User-Id` header

## Environment Variables
```bash
# Required
DATABASE_URL=jdbc:postgresql://localhost:5432/orders
DATABASE_USERNAME=orders_svc
DATABASE_PASSWORD=
REDIS_URL=redis://localhost:6379
KAFKA_BOOTSTRAP_SERVERS=localhost:9092

# Optional
LOG_LEVEL=INFO
CACHE_TTL_MINUTES=15
SERVER_PORT=8080
```

## Don't Touch
- `db/migration/V1__` through `V5__` — released migrations, never modify
- `/api/v1/legacy/` endpoints — consumed by mobile app v2.x, deprecated but not removable yet
- `SecurityConfig.java` — reviewed and approved by security team, coordinate changes

## Current Focus
- Adding order cancellation flow with inventory rollback
- Migrating from RestTemplate to WebClient for external payment API calls
- Adding distributed tracing with Micrometer + Zipkin
