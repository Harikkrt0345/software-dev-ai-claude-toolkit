# Python Backend & AI/ML

## Python Standards
- Python 3.12. Type hints on all function signatures.
- Use `@dataclass(frozen=True)` or Pydantic `BaseModel` for data structures.
- Format with `black`. Lint with `ruff`. Type check with `mypy` or `pyright`.
- Use `logging` module, never `print()` in production code.
- Virtual environments: `venv` or `poetry`. Pin all dependencies.

## FastAPI Conventions
- Pydantic models for all request/response schemas. Never use raw dicts for API I/O.
- Use `Depends()` for dependency injection (DB sessions, auth, services).
- Async endpoints (`async def`) for I/O-bound work. Sync for CPU-bound.
- Router organization by domain: `routers/users.py`, `routers/orders.py`.
- Global exception handlers with `@app.exception_handler()`.
- Use `BackgroundTasks` for fire-and-forget work.

## Project Structure
```
app/
  main.py           # FastAPI app, middleware, startup events
  config.py         # Settings via pydantic-settings
  routers/          # API route handlers
  models/           # Pydantic schemas (request/response)
  services/         # Business logic
  repositories/     # Database access
  core/             # Auth, middleware, exceptions
```

## Database Access
- PostgreSQL: use `SQLAlchemy 2.0` async with `asyncpg`, or `SQLModel`.
- MongoDB: use `motor` (async) or `beanie` ODM.
- Redis: use `redis.asyncio` for async access.
- Always use connection pooling. Close sessions properly with context managers.

## AI/ML Patterns
- **RAG Pipeline**: chunk documents (500-1000 tokens with overlap) -> embed -> store in vector DB -> retrieve top-k -> augment prompt -> generate.
- **Vector DB**: use pgvector with PostgreSQL, or dedicated (Pinecone, Qdrant, Weaviate, ChromaDB). Always store metadata alongside embeddings.
- **LLM Calls**: use structured outputs (Pydantic models) where possible. Set temperature, max_tokens explicitly. Handle rate limits with exponential backoff.
- **Prompt Engineering**: keep system prompts in separate files, not inline strings. Version control prompts.

## Agent & MCP Patterns
- **ADK (Agent Development Kit)**: define tools as typed functions. Keep tool descriptions concise and unambiguous.
- **MCP Servers**: each server = one capability domain. Use typed schemas for tool inputs/outputs.
- **Agent Architecture**: plan -> execute -> observe -> reflect loop. Limit max iterations to prevent runaway.
- **Tool Design**: tools should be atomic, idempotent when possible, and return structured results.

## ML Best Practices
- Separate training, evaluation, and inference code.
- Use config files (YAML/TOML) for hyperparameters, not hardcoded values.
- Log experiments with MLflow, W&B, or similar. Track metrics, params, artifacts.
- Data validation: validate input shapes, types, and ranges before model inference.
- Model versioning: tag models with version, training date, dataset hash.
