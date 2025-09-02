# Session 7 Summary

## What I Revised & Learned

### Advanced JOIN Operations and Self-Joins
- **Three-table JOIN structure**: Movie-Actor-Casting relationship through linking tables
- **Self-join concept**: Joining a table to itself with different aliases to compare different rows
- **Subquery vs Self-join approaches**: Two valid methods for complex filtering with different performance characteristics
- **JOIN alias strategy**: Using descriptive aliases (`julies_role`, `lead_role`) for clarity in self-joins
- **Step-by-step development**: Built query incrementally with LIMIT for faster debugging, habit sinked in

### Complex Filtering with Subqueries
- **IN clause with subqueries**: Finding records based on conditions in related tables
- **Subquery execution order**: Inner query runs first to create filter list for outer query
- **Two-step logical thinking**: Break complex requirements into separate conditions that apply to different rows

### Window Functions and Partitioning
- **RANK() function**: `RANK() OVER (ORDER BY column DESC)` for ordering with ties
- **PARTITION BY clause**: `PARTITION BY column` creates separate ranking groups
- **Window function syntax**: `RANK() OVER (PARTITION BY group_col ORDER BY sort_col DESC)`
- **String range filtering**: `BETWEEN 'S14000021' AND 'S14000026'` for alphanumeric sequences

### Subquery Patterns and Applications
- **Filtering by calculated values**: Using subqueries to find records above/below averages
- **Relationship traversal**: Following foreign key relationships through subqueries
- **Performance considerations**: Self-joins vs subqueries have different optimization characteristics

## What I Did

### SQLZoo More JOIN Operations (Exercises 9-15)
- **Exercise 9**: Found Harrison Ford's non-starring roles using `c.ord > 1` condition
- **Exercise 10**: Listed 1962 films with lead actors using `c.ord = 1` filter
- **Exercise 11**: Analyzed Rock Hudson's busiest years with `GROUP BY` and `HAVING COUNT() > 2`
- **Exercise 12**: **Most challenging** - Found Julie Andrews movies with their lead actors using both subquery and self-join approach with help of AI
- **Exercise 13**: Listed actors with 15+ starring roles using `GROUP BY` and `HAVING COUNT() >= 15`
- **Exercise 14**: Ranked 1978 films by cast size with `ORDER BY COUNT() DESC, title ASC`
- **Exercise 15**: Found Art Garfunkel's co-workers using subquery pattern from Exercise 12

### Subquery Practice (W3Resource Exercises 1-6)
- **Exercise 1-2**: Basic IN subqueries for salesman/location filtering
- **Exercise 3**: Complex relationship traversal - orders by salesmen who worked with specific customer
- **Exercise 4**: Comparison subqueries using `AVG()` calculations
- **Exercise 5-6**: Repeated pattern recognition with city-based filtering

### Window Functions (SQLZoo Exercises 1-6)
- **Exercise 1-2**: Basic RANK() function with single ordering
- **Exercise 3**: PARTITION BY year for separate rankings per time period
- **Exercise 4**: PARTITION BY constituency for Edinburgh election analysis
- **Exercise 5**: **Complex filtering** - Found election winners using subquery with window functions
- **Exercise 6**: Combined window functions with GROUP BY for party seat counts

### Danny's Diner Case Study (Questions 1-2)
- **Question 1**: Customer total spending with SUM() and GROUP BY
- **Question 2**: Customer visit frequency with COUNT(DISTINCT date)

## Key Challenges and Solutions

### Self-Join Conceptual Understanding
- **Challenge**: Initial confusion about joining a table to itself
- **Solution**: Used descriptive aliases and step-by-step breakdown from AI assistance
- **Key insight**: Self-joins connect different rows from same table via common parent (movie)
- **Learning**: Two casting rows for same movie can represent different actors/roles

### Subquery vs Self-Join Decision Making
- **Challenge**: Choosing between two valid approaches for Exercise 12
- **Analysis considered**:
  - **Readability**: Subquery more intuitive for beginners
  - **Performance**: Self-join potentially faster with proper indexing
  - **Functionality**: Both approaches functionally equivalent
- **Decision**: Focused on self-join for new learning, kept subquery as backup

### String Range Filtering
- **Challenge**: Filtering Edinburgh constituencies (S14000021 to S14000026)
- **Solution**: `BETWEEN` operator works with string alphanumeric ordering
- **Learning**: PostgreSQL handles string ranges naturally when prefix and padding consistent

## Key SQL Patterns Learned

### Self-Join for Same-Table Relationships
```sql
SELECT m.title, a2.name AS leading_actor
FROM movie m
JOIN casting c ON m.id = c.movieid        -- First role connection
JOIN actor a ON a.id = c.actorid
JOIN casting c2 ON m.id = c2.movieid      -- Second role connection (self-join)
JOIN actor a2 ON a2.id = c2.actorid
WHERE a.name = 'Julie Andrews'
AND c2.ord = 1;
```

### Subquery Alternative for Complex Filtering
```sql
SELECT m.title, a.name AS leading_actor
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor a ON a.id = c.actorid
WHERE c.ord = 1
AND m.id IN (
    SELECT m2.id
    FROM movie m2
    JOIN casting c2 ON m2.id = c2.movieid
    JOIN actor a2 ON a2.id = c2.actorid
    WHERE a2.name = 'Julie Andrews'
);
```

### Window Functions with Partitioning
```sql
SELECT 
    constituency,
    party,
    RANK() OVER (
        PARTITION BY constituency
        ORDER BY votes DESC
    ) AS posn
FROM ge
WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
    AND yr = 2017;
```

### Subquery in FROM Clause (Alternative to CTE)
```sql
SELECT constituency, party
FROM (
    SELECT
        constituency,
        party,
        RANK() OVER (
            PARTITION BY constituency
            ORDER BY votes DESC
        ) AS posn
    FROM ge
    WHERE constituency LIKE 'S%' AND yr = 2017
) AS ranked_results
WHERE posn = 1
ORDER BY constituency;
```

### Aggregate Filtering Pattern
```sql
SELECT column
FROM table
WHERE condition
GROUP BY column
HAVING COUNT(*) >= threshold
ORDER BY column;
```