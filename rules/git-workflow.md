# Git Workflow

## Commit Format
Use conventional commits: `<type>: <description>`

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`

Examples:
- `feat: add user registration endpoint`
- `fix: handle null pointer in payment service`
- `refactor: extract email validation to shared util`

Keep subject line under 72 characters. Use body for details when needed.

## Branch Strategy
- `main` — production-ready, always deployable.
- `dev` or `develop` — integration branch (if used).
- Feature branches: `feat/short-description`, `fix/short-description`.
- Delete branches after merging.

## PR Process
- Keep PRs focused. One feature or fix per PR.
- Write a summary: what changed and why.
- Include test plan or evidence that it works.
- Self-review diff before requesting review.

## Workflow
1. Create feature branch from `main` (or `dev`).
2. Make small, atomic commits as you go.
3. Push and create PR when ready.
4. Address review feedback in new commits (don't force-push during review).
5. Squash merge into main.

## What NOT to Commit
- `.env` files, API keys, secrets, credentials.
- IDE config (`.idea/`, `.vscode/` unless team-shared).
- Build artifacts (`target/`, `dist/`, `node_modules/`, `__pycache__/`).
- Large binary files.
