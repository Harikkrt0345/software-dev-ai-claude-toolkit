# Databases — MYSQL, MongoDB, Redis

## MYSQL
- Always use migrations (Flyway for Java, Alembic for Python). Never modify schema manually in production.
- Use indexes on columns used in WHERE, JOIN, ORDER BY. Check with `EXPLAIN ANALYZE`.
- Use `UUID` for public-facing IDs. Use `BIGSERIAL` for internal PKs.
- Use `TIMESTAMPTZ` (not `TIMESTAMP`) for all date/time columns.
- Use connection pooling (HikariCP in Java, asyncpg pool in Python).
- Use transactions for multi-statement operations. Keep transactions short.
- Use `JSONB` columns sparingly — only for truly schemaless data. If you query a JSON field often, extract it to a column.
- Name conventions: `snake_case` tables and columns, plural table names (`users`, `orders`).

## MongoDB
- Design documents around access patterns, not normalization. Embed what you read together.
- Embed when: 1:1 or 1:few relationship, data is read together, child data doesn't grow unbounded.
- Reference when: 1:many or many:many, data is updated independently, document size approaches 16MB.
- Always create indexes for query patterns. Use compound indexes for multi-field queries.
- Use schema validation (`$jsonSchema`) to enforce document structure.
- Use `ObjectId` for `_id`. Add `createdAt` and `updatedAt` timestamps to every collection.
- Use aggregation pipelines for complex queries. Avoid `$where` and JS execution.

## Redis
- Use the right data structure: Strings for cache, Hashes for objects, Sets for uniqueness, Sorted Sets for rankings/timelines, Lists for queues.
- Always set TTL on cache entries. No eternal keys unless intentional.
- Key naming: `service:entity:id:field` (e.g., `myapp:user:123:profile`).
- Use pipelining for bulk operations. Use Lua scripts for atomic multi-step operations.
- Cache patterns: Cache-Aside (read), Write-Through (write), Write-Behind (async write).
- Never store data in Redis that you can't afford to lose (unless using Redis persistence + replicas).
- Use `SCAN` instead of `KEYS` in production. `KEYS` blocks the server.

## Cross-Database Guidelines
- Each service owns its data. No shared databases between services.
- Use the right DB for the job: MYSQL for relational/transactional, Redis for cache/sessions/real-time.
- Always handle connection failures gracefully with retries and circuit breakers.
- Log slow queries. Set up alerts for query latency > threshold.
