# Security

## Pre-Commit Checklist
- [ ] No hardcoded secrets, API keys, passwords, or tokens in code.
- [ ] All user input is validated and sanitized.
- [ ] SQL queries use parameterized statements (never string concatenation).
- [ ] API endpoints have proper authentication and authorization checks.
- [ ] Sensitive data is not logged (passwords, tokens, PII, card numbers).
- [ ] Error responses don't leak internal details (stack traces, DB schema, file paths).

## Authentication & Authorization
- Use JWT or session-based auth. Never roll your own crypto.
- Validate tokens on every request via middleware/filter.
- Implement role-based access control (RBAC). Check permissions at the service layer.
- Hash passwords with bcrypt or argon2. Never MD5 or SHA for passwords.
- Token expiry: short-lived access tokens (15-60 min), longer refresh tokens.

## Secret Management
- Store secrets in environment variables or a secret manager (Vault, AWS Secrets Manager, K8s Secrets).
- Validate all required secrets at application startup. Fail fast if missing.
- Never commit `.env` files. Add to `.gitignore` immediately.
- Rotate secrets if ever exposed. Treat any committed secret as compromised.

## API Security
- Enable CORS with explicit allowed origins. Never `*` in production.
- Rate limiting on all public endpoints. Stricter limits on auth endpoints.
- Use HTTPS everywhere. Redirect HTTP to HTTPS.
- Validate Content-Type headers. Reject unexpected content types.
- Set security headers: `X-Content-Type-Options`, `X-Frame-Options`, `Strict-Transport-Security`.

## Data Protection
- Encrypt sensitive data at rest (DB-level or field-level encryption).
- Use TLS for all data in transit (DB connections, API calls, message queues).
- Implement audit logging for sensitive operations (login, data access, admin actions).
- Follow principle of least privilege for DB users, API keys, and service accounts.

## Container & Infrastructure Security
- Scan Docker images for vulnerabilities (Trivy, Snyk).
- Run containers as non-root. Drop unnecessary Linux capabilities.
- Use network policies in K8s to restrict pod-to-pod communication.
- Keep dependencies updated. Monitor for CVEs with Dependabot or similar.
