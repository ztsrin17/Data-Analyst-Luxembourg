# Session 1 Summary

## What I Learned

### SQL Fundamentals
- Core query syntax: `SELECT`, `FROM`, `WHERE`, `ORDER BY`, `LIMIT/OFFSET`
- Filtering with operators: 
  - Comparison: `=`, `!=`, `<`, `>`, `<=`, `>=`
  - Range: `BETWEEN`, `NOT BETWEEN`
  - Lists: `IN`, `NOT IN`
  - Logical: `AND`, `OR`
- Query execution order: `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `DISTINCT` → `ORDER BY` → `LIMIT/OFFSET`

### Advanced Techniques
- **`IN` with tuples**: Clean alternative to multiple `OR` conditions  
  Example: `WHERE (col1, col2) IN (('col1val1','col2val1'), ('col1val2','col2val2'))` ('if string')
- **Pattern matching**:
  - `LIKE`/`NOT LIKE` with wildcards: `%` (any sequence), `_` (single character)
  - How case/accent can be handled (e.g., `COLLATE NOCASE`, `unaccent()` extension)
    - More of this another time
- **`DISTINCT`**: Retrieve unique values or combinations

### Optimization & Best Practices
- Filter early with `WHERE` for better performance
- Prefer `IN` over chained `OR` for readability
- Use parentheses for complex logical conditions

## What I Did
- Completed **SQLBolt Lessons 1-5** (Basic queries → Advanced filtering/sorting)
- Solved **19 practice problems** on W3Resource (sql-retrieve-from-table)
- Analyzed a **BBC article - Why it matters where your data is stored** on data sovereignty (critical thinking exercise) (\CTL\)
- Created a **SQL Cheat Sheet** documenting key concepts (\T1-SQL\)

## Key Takeaway
Discovered that `IN` with tuples is a powerful, clean alternative to multiple `OR` conditions or `UNION` queries for combined filters.