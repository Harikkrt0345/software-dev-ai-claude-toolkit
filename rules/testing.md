# Testing

## Coverage Target
- Minimum 80% code coverage for business logic.
- 100% coverage on critical paths (auth, payments, data mutations).

## Test Types
- **Unit tests**: isolated, fast, mock external dependencies. Every service method gets unit tests.
- **Integration tests**: test real DB interactions, API endpoints, message consumers.
- **E2E tests**: critical user flows only. Don't over-invest here — they're slow and brittle.

## TDD Workflow
1. **RED** — Write a failing test that defines what you want.
2. **GREEN** — Write the minimal code to make it pass.
3. **IMPROVE** — Refactor while keeping tests green.

## Stack-Specific Tools
- **Java/Spring Boot**: JUnit 5 + Mockito. `@SpringBootTest` for integration. Testcontainers for real DB/Redis/Kafka in tests.
- **Python/FastAPI**: `pytest` + `pytest-asyncio`. `httpx.AsyncClient` for API tests. `unittest.mock` or `pytest-mock` for mocking.
- **JavaScript/Express**: Jest or Vitest. `supertest` for API tests.
- **React**: React Testing Library. Test behavior, not implementation. Avoid testing internal state.

## Test Naming
- Describe the scenario and expected outcome.
- Java: `shouldReturnUserWhenIdExists()`, `shouldThrowWhenEmailInvalid()`
- Python: `test_returns_user_when_id_exists()`, `test_raises_when_email_invalid()`
- JS: `it('returns user when id exists')`, `it('throws when email is invalid')`

## Rules
- Tests must be independent. No shared mutable state between tests.
- No sleeping in tests. Use awaitility (Java), polling, or async assertions.
- Fix flaky tests immediately. A flaky test is worse than no test.
- Don't test framework code. Test YOUR logic.
- Mock external services (HTTP calls, third-party APIs). Use Testcontainers or embedded servers for databases.
