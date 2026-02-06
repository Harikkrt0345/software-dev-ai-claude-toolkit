# Infrastructure — Docker, Kubernetes, Kafka, Flink

## Docker
- Multi-stage builds to minimize image size. Separate build and runtime stages.
- Use specific base image tags (e.g., `eclipse-temurin:17-jre-alpine`), never `latest`.
- Run as non-root user. Add `USER appuser` after setup.
- Order Dockerfile layers: OS deps -> app deps -> source code (maximizes cache hits).
- Use `.dockerignore` to exclude `.git`, `node_modules`, `target/`, `__pycache__/`, `.env`.
- One process per container. Use docker-compose for multi-container local dev.
- Health checks: add `HEALTHCHECK` instruction or define in compose/K8s.

## Kubernetes
- Use Deployments for stateless apps. StatefulSets only for stateful workloads (databases).
- Define resource requests AND limits for every container. No unbounded pods.
- Use ConfigMaps for config, Secrets for sensitive data. Mount as env vars or volumes.
- Liveness probe: is the process alive? Readiness probe: can it serve traffic? Startup probe: for slow-starting apps.
- Use namespaces to isolate environments (dev, staging, prod).
- Use Horizontal Pod Autoscaler (HPA) based on CPU/memory or custom metrics.
- Rolling updates by default. Set `maxUnavailable: 0` for zero-downtime deploys.
- Use `PodDisruptionBudget` for critical services.

## Kafka
- Topic naming: `<domain>.<entity>.<event>` (e.g., `orders.payment.completed`).
- Use Avro or Protobuf with Schema Registry for message serialization. Avoid plain JSON in production.
- Partition key: choose a key that distributes evenly and maintains ordering where needed (e.g., user ID, order ID).
- Consumer groups: one group per logical consumer. Set `enable.auto.commit=false`, commit after processing.
- Idempotent consumers: design for at-least-once delivery. Use deduplication or idempotency keys.
- Retention: set per-topic based on use case. Event sourcing = long retention. Transient events = short.
- Dead letter topic for messages that fail processing after retries.
- Monitor: consumer lag, under-replicated partitions, broker disk usage.

## Flink
- Use DataStream API for event-time processing. Avoid ProcessFunction unless absolutely needed.
- Always set watermarks for event-time windows. Handle late data with side outputs.
- Use keyed state (ValueState, ListState, MapState) for stateful processing. Clear state when no longer needed.
- Checkpointing: enable with reasonable interval (30s-5min). Use incremental checkpoints with RocksDB backend.
- Exactly-once semantics: enable checkpointing + use Kafka transactions for sinks.
- Backpressure: monitor through Flink UI. Fix by scaling parallelism or optimizing slow operators.
- Job naming and metrics: tag jobs clearly, expose custom metrics for business logic monitoring.
