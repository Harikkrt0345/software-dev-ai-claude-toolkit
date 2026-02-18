---
description: Design database schema for a feature
---

# Database Schema Design

Design the database schema for: $ARGUMENTS

## Process

1. **Identify entities** — what are the main objects and their relationships?
2. **Choose database** — MySQL (relational, transactional) vs MongoDB (document, flexible) for each entity. Justify the choice.
3. **Design schema**:
   - MySQL: tables, columns, types, constraints, indexes, foreign keys
4. **Plan migrations** — Flyway (Java) or Alembic (Python) migration files needed.

## Output Format

### For MYSQL
```sql
CREATE TABLE table_name (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    ...
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
                    ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE INDEX idx_table_column ON table_name(column);

```

### For MongoDB
```json
{
  "_id": "ObjectId",
  "field": "type",
  "embedded": { ... },
  "createdAt": "ISODate",
  "updatedAt": "ISODate"
}
```
With index definitions and schema validation rules.

## Guidelines
- Every table/collection gets `created_at` and `updated_at`.
- MySQL: use TIMESTAMP (or DATETIME with UTC enforcement), BINARY(16) (or CHAR(36)) for UUID public IDs, BIGINT AUTO_INCREMENT for internal primary keys.
- PostgreSQL: use `TIMESTAMPTZ`, `UUID` for public IDs, `BIGSERIAL` for internal PKs.
- MongoDB: embed data that's read together, reference data that's updated independently.
- Add indexes for every query pattern. Explain each index choice.
- Consider data growth — will this work at 10x/100x current scale?

## Rules
- DO NOT write application code yet. Schema design only.
- WAIT for approval before generating migration files.
