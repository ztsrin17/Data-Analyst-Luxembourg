# Session 5 Summary

## What I Learned

### Table Aliases and Query Efficiency
- **Table alias syntax**: `FROM submissions s` creates alias 's' for cleaner queries
- **Consistency rule**: Once defined, must use alias (not original name) for column references
- **Best practice**: Choose meaningful abbreviations for complex multi-table queries

### Complex JOIN Patterns with Aggregation
- **Central table strategy**: Use table with most foreign key relationships as FROM table (submissions in this case)
- **Multi-level filtering**: WHERE for row-level conditions, HAVING for aggregate conditions
- **DISTINCT in aggregates**: `COUNT(DISTINCT column)` prevents duplicate counting in complex scenarios
- **Pattern recognition**: "Number of X per Y" → GROUP BY Y, COUNT(X)

### CTE (Common Table Expressions) Mastery
- **Column naming requirement**: Must alias calculated columns in CTE to reference them later
- **Subquery alternative**: CTEs don't eliminate need for subqueries in all cases (still needed for MAX comparison)
- **Readability advantage**: Breaking complex logic into named, reusable components
- **Syntax reminder**: `WITH cte_name AS (inner_query) SELECT * FROM cte_name`

### CASE Statements - Conditional Logic
- **Core syntax**: `CASE WHEN condition THEN result ELSE alternative END AS alias`
- **Row-by-row evaluation**: CASE evaluates each row individually against conditions
- **Boolean conditions required**: WHEN clause needs full boolean expression (not just column names)
- **Alias limitation**: Cannot reference column aliases within same SELECT statement
- **CTE solution**: Use CTE when needing to reference calculated values multiple times

### Advanced CASE Patterns
- **Multiple conditions**: `WHEN score >= 90 AND attendance > 80 THEN 'Honor Roll'`
- **BETWEEN operator**: `WHEN score BETWEEN 75 AND 89 THEN 'B'`
- **IN operator**: `WHEN EXTRACT(DOW FROM date) IN (0, 6) THEN 'Weekend'`
- **Aggregate CASE**: `SUM(CASE WHEN status = 'Paid' THEN amount ELSE NULL END)`
- **Nested CASE**: Complex logic requiring inner CASE within outer CASE conditions
- **Business logic considerations**: In discount tier exercise, identified flaw where a Gold member spending 501 to 1000 wouldn't get a discount. Suggested fix using `WHEN membership_level IN ('Gold','Silver') AND total_spent > 500 THEN '10% Discount'`.

### EXTRACT Function for Date Manipulation
- **Day of week**: `EXTRACT(DOW FROM date)` returns 0 for Sunday, 6 for Saturday
- **Month extraction**: `EXTRACT(MONTH FROM submit_date)` for grouping by month
- **Business applications**: Weekend/weekday analysis, seasonal patterns, day-of-week trends
- **Future application**: Realized potential use for Danny's Diner hypothesis testing

### SQL Tuple Comparison Limitations
- **Invalid pattern**: `(written_score, practical_score) > 50` is not allowed for comparing multiple columns to a single scalar.
- **Valid tuple usage**: `(col1, col2) > (val1, val2)` works lexicographically in some databases (PostgreSQL, MySQL), not portable, not the same as checking both individually.
- **Solution**: Use `col1 > value AND col2 > value` for clarity and compatibility.

### Window Functions - Advanced Analytics
- **Core concept**: Perform calculations across related rows without collapsing groups
- **Required syntax**: `FUNCTION() OVER (PARTITION BY column ORDER BY column)`
- **PARTITION BY**: Creates windows/sections for calculation (like GROUP BY but keeps individual rows)
- **ORDER BY in OVER**: Determines row sequence for running calculations

### Ranking Functions Comparison
| Function | Handles Ties | Skips Ranks | Use Case |
|----------|-------------|-------------|-----------|
| `ROW_NUMBER()` | No (sequential) | N/A | Unique numbering needed |
| `RANK()` | Yes (same rank) | Yes (gaps) | Traditional ranking |
| `DENSE_RANK()` | Yes (same rank) | No (no gaps) | Compact ranking |

### Window Function Applications
- **Running totals**: `SUM(amount) OVER (PARTITION BY user ORDER BY date)`
- **Rolling averages**: `AVG(score) OVER (PARTITION BY team ORDER BY game_date)`
- **First/Last values**: `FIRST_VALUE()` and `LAST_VALUE()` in windows
- **Ranking within groups**: `RANK() OVER (PARTITION BY category ORDER BY score DESC)`

### NULL Handling Techniques
- **COALESCE function**: Returns first non-NULL value from list
- **Syntax**: `COALESCE(mobile, '07986 444 2266')` replaces NULL with default
- **JOIN considerations**: LEFT/RIGHT JOINs can introduce NULLs requiring COALESCE
- **Business logic**: Essential for data cleaning and default value assignment

## What I Did

### Technical Practice
- **HackerRank "Top Competitors"**: Complex 4-table JOIN with GROUP BY and HAVING (with AI guidance)
- **HackerRank "Top Earners" CTE version**: Solved using CTE approach instead of subquery-only method
- **AI-generated CASE exercises**: Completed 10 progressive exercises plus 1 advanced nested CASE challenge
- **DataLemur tutorial**: Window functions theory and ranking functions
- **StratasScratch attempt**: "Top 3 Wineries" problem (stopped partway, missing tools at that moment)
- **DataLemur "Average Review Ratings"**: Practice with EXTRACT and GROUP BY
- **SQLZoo NULL exercises**: Practiced COALESCE and JOIN variations (exercises 1-6)

### Problem-Solving Patterns
- **Step-by-step approach**: Breaking complex problems into smaller, manageable queries
- **Table relationship mapping**: Drawing out foreign key connections before writing JOINs
- **CTE for readability**: Using CTEs when calculations needed multiple times
- **Alternative solution exploration**: Considering different approaches (nested CASE vs CTE)

## Key Challenges and Solutions

### HackerRank "Top Competitors" - Multi-table Logic
- **Challenge**: Understanding which table to use as central point for 4-table JOIN
- **Solution**: Identified submissions table had foreign keys to all other tables
- **Key insight**: `submissions.score = difficulty.score` after proper JOINs determines full scores
- **Learning**: Complex JOINs require careful relationship mapping before coding

### CTE Column Naming
- **Challenge**: Forgot to name calculated column in CTE, causing reference errors
- **Solution**: Always alias calculated columns: `SELECT (salary * months) AS earnings`
- **Pattern**: CTE column names must be explicit for later reference

### CASE Statement Alias Limitation
- **Challenge**: Tried to reference `bonus_rate` alias within same SELECT clause
- **Error**: SQL evaluates columns in order - alias doesn't exist until SELECT completes
- **Solutions**: 
  1. Repeat CASE expression
  2. Use CTE to calculate once, reference multiple times (preferred)

### Nested CASE Complexity
- **Challenge**: Creating performance + tenure bonus logic with nested conditions
- **CTE solution**: Clean, readable approach separating performance calculation from tenure adjustment
- **Nested solution**: Functional but repetitive - requires CASE expression 4 times

### Window Function Practice Problem Mismatch
- **Challenge**: Tutorial taught ranking functions, but AI's selected practice problem required different window techniques
- **Solution**: Found alternative problem that directly tested learned concepts

## Key SQL Patterns Reinforced

### Multi-table Analysis Pattern
```sql
SELECT target_columns
FROM central_table ct
INNER JOIN related_table1 rt1 ON ct.key1 = rt1.key1
INNER JOIN related_table2 rt2 ON ct.key2 = rt2.key2
WHERE row_level_conditions
GROUP BY grouping_columns
HAVING aggregate_conditions
ORDER BY sorting_logic;
```

### CTE for Complex Calculations
```sql
WITH calculations AS (
    SELECT base_columns,
           calculated_expression AS calc_name
    FROM source_table
    WHERE conditions
)
SELECT base_columns, calc_name,
       additional_calculations_using_calc_name
FROM calculations
WHERE calc_name meets_criteria;
```

### Window Function Standard Pattern
```sql
SELECT columns,
       WINDOW_FUNCTION() OVER (
           PARTITION BY grouping_column 
           ORDER BY sorting_column
       ) AS result_alias
FROM table_name;
```