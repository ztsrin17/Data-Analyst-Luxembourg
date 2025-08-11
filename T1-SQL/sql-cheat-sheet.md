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
GROUP BY column1, column2
HAVING aggregate_conditions
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

### NULL Handling

```sql
WHERE column IS NULL
WHERE column IS NOT NULL
-- Use IS/IS NOT, never = or != with NULL
```

## Aggregate Functions

### Core Functions
- `COUNT(*)` - Count all rows
- `COUNT(column_name)` - Count non-null values in column
- `COUNT(DISTINCT column)` - Count unique values only
- `SUM(column)` - Add up numeric values
- `AVG(column)` - Calculate average of numeric values
- `MAX(column)` - Find highest value
- `MIN(column)` - Find lowest value

**Note**: All aggregate functions ignore NULL values (except COUNT(*))

```sql
SELECT COUNT(*) FROM orders;
SELECT COUNT(DISTINCT customer_id) FROM orders;
SELECT AVG(purchase_amount) FROM orders;
```

### Number Formatting
```sql
-- Round to 1 decimal place
SELECT ROUND(AVG(column), 1) FROM table;

-- Convert to integer
SELECT CAST(AVG(column) AS INTEGER) FROM table;
```

## Grouping & Filtering

### GROUP BY
Groups rows with identical values into summary rows for aggregate calculations.
**Mental model**: Creates "buckets" of similar rows, then applies aggregate functions to each bucket.

```sql
-- Basic grouping
SELECT category, COUNT(*) FROM products GROUP BY category;

-- Multiple column grouping
SELECT category, brand, AVG(price) FROM products 
GROUP BY category, brand;
```

### WHERE vs HAVING
- **WHERE**: Filters individual rows before grouping occurs
- **HAVING**: Filters grouped results after aggregation is performed

```sql
-- Filter rows first, then group
SELECT category, COUNT(*) FROM products
WHERE price > 100
GROUP BY category;

-- Group first, then filter groups
SELECT category, COUNT(*) FROM products
GROUP BY category
HAVING COUNT(*) > 5;

-- Combined usage
SELECT category, AVG(price) FROM products
WHERE brand = 'Samsung'
GROUP BY category
HAVING AVG(price) > 200;
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

## Advanced Concepts (Not Yet Explored)
- `CASE` statements - Conditional logic in queries

## Tips

-   **Performance**: Use WHERE to filter before SELECT and GROUP BY
-   **Readability**: Use IN instead of multiple ORs
-   **Case sensitivity**: Varies by database (use COLLATE for special handling)
-   **Wildcards**: `%` matches any length, `_` matches exactly one character
-   **Tuple filtering**: `WHERE (a,b) IN ((1,2), (3,4))` works for exact values only
-   **Complex conditions**: Use multiple OR conditions when not dealing with exact matches