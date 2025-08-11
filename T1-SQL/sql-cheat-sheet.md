# SQL Cheat Sheet

## Database Basics
A database table is like a digital filing cabinet organized in rows and columns (similar to Excel).
- **Rows**: Complete records (e.g., one customer's info)
- **Columns**: Types of information (e.g., name, email, age)

## Query Execution Order
```sql
FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT/OFFSET

```

## Basic Query Structure

```sql
SELECT column1, column2, * 
FROM table_name
WHERE conditions
ORDER BY column ASC/DESC
LIMIT number OFFSET start_row;

```

## Operators & Comparisons

### Numerical

-   `=, !=, <>, <, <=, >, >=`
-   `BETWEEN val1 AND val2` (inclusive)
-   `NOT BETWEEN val1 AND val2`
-   `IN (val1, val2, val3)`
-   `NOT IN (val1, val2, val3)`

`IN` shorthand for multiple `OR`, more readable than chained `OR`

### Text & Pattern Matching

-   `=, != (is) <>` (exact match, case-sensitive)
-   `LIKE, NOT LIKE` (pattern matching)
    -   `%` = any sequence of characters
    -   `_` = single character
-   `IN ('text1', 'text2')` (shorthand for multiple ORs)
-   All text values must be quoted: `'example'`
```sql
WHERE name LIKE 'John%'     -- Starts with "John"
WHERE name LIKE '%son'      -- Ends with "son"
WHERE name LIKE '_ohn'      -- Second letter is "o", ends with "hn"
WHERE email LIKE '%@gmail.com'

-- Using IN with tuples (cleaner)
WHERE (subject, year) IN (('Physics', 1970), ('Economics', 1971));
```

### Logical

-   `AND, OR` (combine conditions)
-   Use parentheses for complex logic: `(A AND B) OR (C AND D)`
```sql
-- Using OR
WHERE (subject = 'Physics' AND year = 1970)
   OR (subject = 'Economics' AND year = 1971)
```

## Key Clauses

### DISTINCT

```sql
SELECT DISTINCT column1, column2 FROM table;
-- Returns unique combinations only

```

### ORDER BY

```sql
ORDER BY column1 ASC, column2 DESC;
-- Sort by multiple columns

```

### LIMIT & OFFSET

```sql
LIMIT 10 OFFSET 20;
-- Skip first 20 rows, return next 10 (pagination)

```

## Tips

-   **Performance**: Use WHERE to filter before SELECT
-   **Readability**: Use IN instead of multiple ORs
-   **Case sensitivity**: Varies by database (use COLLATE for special handling)
-   **Wildcards**: `%` matches any length, `_` matches exactly one character
