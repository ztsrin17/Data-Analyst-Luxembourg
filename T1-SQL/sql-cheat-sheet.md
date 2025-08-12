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

## JOIN Operations

### Database Normalization
Real-world data is split across multiple tables to reduce duplication. JOINs combine related tables using shared keys (primary/foreign key relationships).

### Basic JOIN Syntax
```sql
SELECT column, another_table_column, …
FROM mytable
[INNER/LEFT/RIGHT/FULL] JOIN another_table 
    ON mytable.id = another_table.matching_id
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

### JOIN Types

- `JOIN` = `INNER JOIN` (default)
- `LEFT JOIN` = `LEFT OUTER JOIN` (OUTER is implied)  
- `RIGHT JOIN` = `RIGHT OUTER JOIN` (OUTER is implied)
- `FULL JOIN` = `FULL OUTER JOIN` (OUTER is implied)

**INNER JOIN**: Only rows that exist in BOTH tables
```sql
-- Mental model: People in both your contacts AND Facebook friends
SELECT movies.title, boxoffice.rating
FROM movies
INNER JOIN boxoffice ON movies.id = boxoffice.movie_id;
```

**LEFT JOIN**: ALL rows from left table + matching rows from right table  
```sql
-- Mental model: All your contacts + their Facebook info (NULL if no Facebook)
SELECT customers.name, orders.amount
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id;
-- Shows all customers, even those with no orders
```

**RIGHT JOIN**: ALL rows from right table + matching rows from left table

**FULL JOIN**: ALL rows from BOTH tables (shows NULLs where matches don't exist)

### JOIN Best Practices
- **Table qualification**: Use `table.column` notation when column names are ambiguous (required for ambiguous columns)
- **Table aliases**: `FROM movies m JOIN directors d ON m.director_id = d.id`
- **FROM table choice**: 
  - 2 tables: doesn't matter which is FROM vs JOIN
  - 3+ tables: use most central table as FROM, chain other JOINs
- **Multiple conditions**: Use OR in JOIN: `ON (game.team1 = team.id OR game.team2 = team.id)`
- **Key identification**: Look for connecting columns (often `id` fields) between tables

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

**What is NULL?**
- Represents missing or unknown data
- NULL ≠ 0, NULL ≠ empty string, NULL ≠ NULL
- Common in OUTER JOINs when no matching row exists
- **Prefer defaults** (0, empty strings) when possible
- **Use NULL when** default values would skew analysis (like averages)

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

**Key rule**: When using GROUP BY, every non-aggregated column in SELECT must appear in GROUP BY.

```sql
-- Basic grouping
SELECT category, COUNT(*) FROM products GROUP BY category;

-- Multiple column grouping
SELECT category, brand, AVG(price) FROM products 
GROUP BY category, brand;

-- GROUP BY determines your result categories
GROUP BY eteam.teamname  -- Shows team names in results
GROUP BY goal.teamid     -- Shows team IDs in results
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
-- Important in JOINs to avoid duplicate results
```

### ORDER BY

```sql
ORDER BY column1 ASC, column2 DESC;
-- Sort by multiple columns
-- Note: Query result order can vary without ORDER BY
-- Add ORDER BY for consistent, predictable results
```

### LIMIT & OFFSET

```sql
LIMIT 10 OFFSET 20;
-- Skip first 20 rows, return next 10 (pagination)
```

## Advanced Concepts

### CASE Statements - Conditional logic in queries
```sql
-- Basic CASE syntax (don't forget END!)
CASE WHEN condition THEN value
     WHEN condition THEN value
     ELSE default_value
END

-- Example: Conditional counting with aggregation
SELECT 
    game.mdate,
    game.team1,
    SUM(CASE WHEN goal.teamid = game.team1 THEN 1 ELSE 0 END) AS score1,
    game.team2,
    SUM(CASE WHEN goal.teamid = game.team2 THEN 1 ELSE 0 END) AS score2
FROM game
LEFT JOIN goal ON game.id = goal.matchid
GROUP BY game.mdate, game.id, game.team1, game.team2;
```

### EXISTS Clause (Advanced)
More flexible alternative to OR conditions in JOINs
```sql
-- Find games where Fernando Santos coached either team
SELECT game.mdate 
FROM game 
WHERE EXISTS (
    SELECT 1 FROM eteam 
    WHERE coach = 'Fernando Santos' 
    AND (id = game.team1 OR id = game.team2)
);
```

## Professional Query Writing

### Formatting Best Practices
- **Vertical > Horizontal**: Stack columns and clauses vertically
- **Explicit > Implicit**: Never SELECT *, always specify columns
- **Table qualification**: Always use `table.column` notation in multi-table queries
- **Consistent aliases**: Use meaningful, consistent table aliases
- **Visual chunking**: Group related operations with spacing

```sql
-- Good formatting example
SELECT 
    g.mdate,
    g.team1,
    e1.teamname AS team1_name,
    g.team2,
    e2.teamname AS team2_name
FROM game g
    INNER JOIN eteam e1 ON g.team1 = e1.id
    INNER JOIN eteam e2 ON g.team2 = e2.id
WHERE g.mdate >= '2012-06-01'
ORDER BY g.mdate ASC, g.id ASC;
```

### Debugging Strategy
**Step-by-step approach**:
1. Check if expected matches exist in both tables
2. Use LEFT JOIN to see all rows from main table
3. Verify data types and case sensitivity match
4. Test individual components before combining
5. Add ORDER BY for consistent result ordering

```sql
-- Step 1: Check if matches exist
SELECT game.id, game.team1, game.team2
FROM game 
WHERE game.team1 = 'POL' OR game.team2 = 'POL';

-- Step 2: Check if related data exists
SELECT game.id, goal.matchid
FROM game 
LEFT JOIN goal ON game.id = goal.matchid
WHERE game.team1 = 'POL' OR game.team2 = 'POL';

-- Step 3: Build full query
SELECT game.id, game.mdate, COUNT(goal.matchid)
FROM game
INNER JOIN goal ON game.id = goal.matchid
WHERE game.team1 = 'POL' OR game.team2 = 'POL'
GROUP BY game.id, game.mdate
ORDER BY game.id ASC;
```

## Tips

### Performance
-   **Performance**: Use WHERE to filter before SELECT and GROUP BY
-   **JOIN strategy**: Choose central table as FROM for multi-table JOINs

### Readability  
-   **Readability**: Use IN instead of multiple ORs
-   **Table qualification**: Always use `table.column` notation in JOINs
-   **Consistent aliases**: Use meaningful, consistent table aliases
-   **Vertical formatting**: Stack columns and clauses vertically
-   **Explicit columns**: Never SELECT *, always specify columns

### JOIN Debugging
- **INNER vs OUTER**: INNER excludes rows without matches, OUTER includes them with NULLs
- **Missing data detection**: Use LEFT JOIN to find records without matches
- **Multiple conditions**: Use OR in JOIN conditions for complex matching scenarios

### Common Pitfalls
-   **Case sensitivity**: Varies by database (use COLLATE for special handling)
-   **Wildcards**: `%` matches any length, `_` matches exactly one character
-   **Tuple filtering**: `WHERE (a,b) IN ((1,2), (3,4))` works for exact values only
-   **Complex conditions**: Use multiple OR conditions when not dealing with exact matches
-   **NULL comparisons**: Must use IS NULL, not = NULL  
-   **GROUP BY requirement**: All non-aggregated SELECT columns must be in GROUP BY
-   **Result ordering**: Different GROUP BY orders can affect result row order
-   **CASE syntax**: Don't forget the END keyword in CASE statements
-   **Automated testing**: Exercise websites can be picky about result formatting/ordering

### Cross-Domain Knowledge
-   **Statistics context**: Sample data uses n-1 for standard deviation, population data uses n