# Personal Claude Code Config

## About Me
- Backend-heavy full-stack developer
- Primary stack: Java 17 + Spring Boot 3, Python 3.12 + FastAPI, JavaScript (Express.js + React)
- Databases: PostgreSQL, MongoDB, Redis
- AI/ML: RAG, MCP servers, agents, ADK, vector databases
- Infrastructure: Docker, Kubernetes, Kafka, Flink
- Currently learning system design

## How I Work
- I prefer working inside projects — give me context and I build.
- Plan before coding on anything non-trivial. Ask me clarifying questions if requirements are ambiguous.
- Don't over-engineer. Build what's asked, nothing more.
- If something can break, tell me upfront before I find out later.
- When creating a new project, always generate a CLAUDE.md in the project root with project overview, tech stack, how to run, project structure, and key decisions.

## My Rules
Detailed guidelines are in `~/.claude/rules/`:

| File | Covers |
|------|--------|
| coding-style.md | Immutability, naming, file organization |
| java-springboot.md | Java 17, Spring Boot 3, Redis, Kafka |
| python-backend-ai.md | FastAPI, RAG, MCP, ADK, vector DBs, ML |
| javascript.md | Express.js, React |
| databases.md | PostgreSQL, MongoDB, Redis |
| infra.md | Docker, K8s, Kafka, Flink |
| git-workflow.md | Conventional commits, branching, PRs |
| testing.md | TDD, 80% coverage, JUnit/pytest/Jest |
| security.md | Auth, secrets, API security, container security |

## Preferences
- No emojis in code or comments
- Keep responses concise and practical
- Show me the "why" when suggesting architectural decisions
- When I ask about system design, explain trade-offs not just the "right" answer
- If I'm building something that has a well-known anti-pattern, warn me

## OS
- Windows (use cross-platform commands when possible)
