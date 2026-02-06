# JavaScript — Express.js & React

## General JS Standards
- Use `const` by default, `let` when reassignment is needed. Never `var`.
- Use arrow functions for callbacks and inline functions.
- Destructure objects and arrays at point of use.
- Use template literals over string concatenation.
- Use `async/await` over `.then()` chains.

## Express.js API Conventions
- Organize routes by domain: `routes/users.js`, `routes/orders.js`.
- Use a central error-handling middleware. Never let unhandled rejections crash the server.
- Validate request bodies with `joi`, `zod`, or `express-validator`.
- Use `helmet` for security headers, `cors` for CORS config.
- Environment config via `dotenv`. Access through a config module, not `process.env` everywhere.
- Use HTTP status codes correctly: 200 success, 201 created, 400 bad input, 401 unauthorized, 404 not found, 500 server error.

## Express Project Structure
```
src/
  app.js            # Express app setup, middleware
  server.js         # Server startup
  routes/           # Route handlers
  controllers/      # Request handling logic
  services/         # Business logic
  models/           # Database models/schemas
  middleware/       # Auth, validation, error handling
  config/           # Environment, DB connection
```

## React Conventions
- Functional components only. No class components.
- Use hooks: `useState`, `useEffect`, `useContext`, `useMemo`, `useCallback`.
- Custom hooks for reusable logic. Prefix with `use`.
- Keep components small and focused. Extract when a component exceeds ~150 lines.
- Props: destructure in function signature. Use default values where sensible.
- State management: React Context for simple state. Consider Zustand or Redux Toolkit for complex state.
- Use `fetch` or `axios` with a centralized API client. Never call APIs directly from components.

## React Project Structure
```
src/
  components/       # Reusable UI components
  pages/            # Route-level components
  hooks/            # Custom hooks
  context/          # React context providers
  services/         # API client and calls
  utils/            # Helper functions
```

## Common Pitfalls to Avoid
- No `console.log` in production code. Use a logger or remove before commit.
- No `any` if using TypeScript. No untyped API responses.
- No direct DOM manipulation in React. Use refs only when necessary.
- No inline styles for anything beyond one-off dynamic values.
- No business logic in route handlers (Express) or components (React). Delegate to services.
