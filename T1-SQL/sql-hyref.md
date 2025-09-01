# SQL – Mental Models + Mini Syntax

**Execution flow:**  
Think: `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY` → `LIMIT`  
(Memory trick: “From Where Groups Have Selective Orders Limited.”)

**Joins:**  
- INNER = overlap only  
  `... FROM A INNER JOIN B ON A.id = B.id`  
- LEFT = keep all left rows + match right  
- RIGHT = mirror of LEFT  
- FULL = keep all rows from both

**Filters:**  
- Row-level (before grouping): `WHERE price > 100`  
- Group-level (after grouping):  
```sql
  GROUP BY category
  HAVING COUNT(*) > 5
```

**Patterns:**

* LIKE fuzzy match:
  `WHERE name LIKE 'A%'`  -- starts with A
  `WHERE name LIKE '_b%'` -- 2nd char is b

**Aggregates:**

* Ignore NULL: `COUNT(col)` skips nulls, `COUNT(*)` counts all
* Multi-agg example:
  `SELECT category, AVG(price), MAX(price) FROM products GROUP BY category`

**CASE:**

```sql
CASE WHEN price > 100 THEN 'Premium'
     ELSE 'Standard'
END AS price_tag
```

**NULL logic:**
`WHERE col IS NULL` or `WHERE col IS NOT NULL`

**Best Practices:*** Always name columns (avoid `SELECT *`)
* Alias tables: `customers c`
* Build in steps: test FROM → WHERE → GROUP BY before adding HAVING/ORDER BY
**Other Useful Clauses:**
- DISTINCT: `SELECT DISTINCT col1, col2 FROM table;` – removes duplicates.
- ORDER BY: `ORDER BY col1 ASC, col2 DESC;` – multi-column sorting.
- LIMIT/OFFSET: `LIMIT 10 OFFSET 20;` – pagination.

**COALESCE for NULLs:**
```sql
SELECT name, COALESCE(mobile, 'N/A') AS contact_number
FROM customers;
```

**HAVING vs WHERE Tip:**
- WHERE filters rows before grouping.
- HAVING filters after grouping (use for aggregates).

**String Functions:**
```sql
SELECT city, LENGTH(city) AS len FROM station;
SELECT UPPER(LEFT(occupation,1)) FROM occupations;
```

**Math Functions:**
```sql
SELECT ABS(-5);      -- 5
SELECT year % 2;     -- 0 even, 1 odd
```

**Date Functions:**
```sql
-- Day of week: 0=Sunday
SELECT EXTRACT(DOW FROM order_date) FROM orders;
-- Month grouping
SELECT EXTRACT(MONTH FROM submit_date) AS month, COUNT(*) FROM apps GROUP BY month;
```

**Subqueries:**
```sql
SELECT name FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);
```

**CTE (Common Table Expression):**
```sql
WITH totals AS (
  SELECT dept, SUM(salary) AS dept_total FROM employees GROUP BY dept
)
SELECT * FROM totals WHERE dept_total > 100000;
```

**Window Functions:**
```sql
SELECT student_id, score,
  RANK() OVER (ORDER BY score DESC) AS rnk
FROM test_scores;
```