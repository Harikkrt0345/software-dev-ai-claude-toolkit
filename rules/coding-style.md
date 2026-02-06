# Coding Style

## Immutability
- Never mutate existing objects or collections. Create new instances.
- Java: use `List.of()`, `Map.of()`, records, `Collections.unmodifiable*`.
- Python: use `@dataclass(frozen=True)`, tuples, `frozenset`.
- JS: use spread operator, `Object.freeze()`, `const` by default.

## File Organization
- Small, focused files: 200-400 lines typical, 800 lines max.
- Organize by feature/domain, not by technical layer.
- One public class/component per file.

## Naming
- Be descriptive. No single-letter variables except loop counters.
- Java: `camelCase` methods, `PascalCase` classes, `UPPER_SNAKE` constants.
- Python: `snake_case` functions/variables, `PascalCase` classes.
- JS/TS: `camelCase` functions/variables, `PascalCase` components/classes.

## Functions
- Single responsibility. Max 50 lines per function.
- Max 4 parameters. Use an object/record/dataclass for more.
- Return early to avoid deep nesting. Max 3 levels of nesting.

## Error Handling
- Handle errors explicitly at every level. Never swallow exceptions.
- User-facing: friendly messages. Server-side: detailed logging with context.
- Use custom exception classes grouped by domain.

## Code Quality Checklist
- [ ] Readable without comments?
- [ ] Functions < 50 lines?
- [ ] Files < 800 lines?
- [ ] Nesting < 4 levels?
- [ ] No hardcoded values (use config/env)?
- [ ] No mutation of shared state?
