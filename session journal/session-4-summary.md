# Session 4 Summary

## What I Learned

### GROUP BY and HAVING Fundamentals
- **WHERE vs HAVING distinction**: WHERE filters individual rows before grouping, HAVING filters grouped results after aggregation
- **HAVING syntax**: Always follows GROUP BY, used for aggregate-level filtering (`HAVING MAX(purch_amt) > 2000`)
- **Efficiency considerations**: Use WHERE for non-aggregated conditions to reduce data before grouping (more efficient than HAVING)
- **Combined filtering**: Can use both WHERE and HAVING in same query for comprehensive filtering

### Decision Framework for WHERE vs HAVING
| **Question** | **Use** | **Example** |
|-------------|---------|-------------|
| Does condition depend on aggregate function? | **HAVING** | `HAVING MAX(purch_amt) > 2000` |
| Filter raw rows before aggregation? | **WHERE** | `WHERE salesman_id BETWEEN 5003 AND 5008` |
| Column not aggregated but in GROUP BY? | Either (WHERE usually more efficient) | `WHERE salesman_id = 5005` |
| Need both raw values and aggregates? | Use both | `WHERE status = 'shipped' HAVING SUM(purch_amt) > 5000` |

### Advanced SQL Functions and Concepts
- **ABS() function**: For absolute values in calculations (Manhattan distance formula)
- **ROUND() and CAST()**: Proper decimal formatting with `CAST(ROUND(value, 4) AS DECIMAL(10,4))`
- **Subqueries in WHERE**: Using nested SELECT statements for complex filtering
- **IN vs = operators**: Use IN when subquery returns multiple values, = for single values

### Common Table Expressions (CTE) Introduction
- **Basic CTE syntax**: `WITH cte_name AS (inner_query) SELECT * FROM cte_name`
- **Purpose**: Creates temporary, named result sets for cleaner, more readable queries
- **Use cases**: Breaking complex queries into logical steps, avoiding repetitive subqueries
- **Step-by-step approach**: Build inner query first, then reference CTE in main query

### Manhattan Distance and Mathematical Functions
- **Formula**: `|x1 - x2| + |y1 - y2|` for two points on a 2D plane
- **SQL implementation**: `ABS(MIN(LAT_N) - MAX(LAT_N)) + ABS(MIN(LONG_W) - MAX(LONG_W))`
- **Optimization note**: `MAX(col) - MIN(col)` is always ≥ 0, so ABS() technically unnecessary

### Business Intelligence: Pivot Tables vs SQL
- **Pivot Tables strengths**: Interactive drag-and-drop, user-friendly, ideal for exploratory analysis and ad-hoc reporting, no coding required
- **Pivot Tables limitations**: Limited to spreadsheet size, slower with large datasets
- **SQL GROUP BY strengths**: Scalable, precise, automated workflows, handles millions of rows
- **SQL GROUP BY limitations**: Requires technical knowledge, less flexible for instant visual changes
- **Use case**: Pivot Tables for hands-on visual analysis, SQL for repeatable large-scale data processing

### Hypothesis Generation for Data Analysis
- **Testable hypotheses**: Must be provable/disprovable with available data
- **Business relevance**: Focus on actionable insights (member retention, peak staffing)
- **Data limitations**: Recognize when missing metrics (e.g., product costs) limit analysis scope
- **Legal/practical considerations**: EU dynamic pricing rules vs customer relations impact

## What I Did

### Technical Practice
- Completed **SQLBolt Lesson 11** on aggregate functions with HAVING clause
- Solved **W3Resource exercises 11-20** on aggregate functions and GROUP BY/HAVING combinations
- Tackled **HackerRank problems**: Revising Aggregations, Weather Observation Station 18, Top Earners
- Completed **2 DataLemur challenges** including CTE practice with tweet histogram problem
- Started **SQLZoo More JOIN operations** for continued JOIN practice
- **SQLZoo movie database practice**: Worked through exercises 1-8 with movie, actor, and casting tables

### Conceptual Learning
- **CTE introduction**: Learned Common Table Expression syntax and use cases
- **Pivot Tables hands-on**: Created pivot tables in Excel/Google Sheets, compared to SQL
- **Critical thinking log**: Crafted 5 testable hypotheses for Danny's Diner case study
- **Cheat sheet maintenance**: Updated personal SQL reference materials during the session

## Key Challenges and Solutions

### HackerRank "Top Earners" Problem
- **Challenge**: Count employees with maximum total earnings required subquery knowledge not yet learned
- **Solution**: Used `WHERE (salary * months) = (SELECT MAX(salary * months) FROM employee)`
- **Alternative approaches**: CTE method and CASE WHEN with window functions (for future learning)

### Weather Observation Station 18 - Manhattan Distance
- **Challenge**: Mathematical formula implementation with proper decimal formatting
- **Solution**: Combined ABS(), MIN(), MAX(), ROUND(), and CAST() functions
- **Learning**: HackerRank formatting requirements needed `CAST AS DECIMAL(10,4)`

### DataLemur Tweet Histogram with CTE
- **Challenge**: Two-step aggregation problem (count tweets per user, then count users per tweet count)
- **Solution**: CTE for first aggregation, main query for second aggregation
- **Process**: Step 1 - count tweets per user, Step 2 - group by tweet count and count users

### SQLZoo Exercise 8 - Harrison Ford Movies
- **Challenge**: Query returned error because subquery returned multiple Harrison Ford IDs (duplicate actor names)
- **Initial attempts**: Used = operator with subquery, causing failure
- **Solution**: Switched to IN operator: `WHERE casting.actorid IN (SELECT actor.id FROM actor WHERE actor.name = 'Harrison Ford')`
- **Insight**: Database design reality - same names can have different IDs, requiring careful operator selection

## Key Takeaways
- **HAVING is for aggregates**: Use HAVING only when filtering on aggregate functions, otherwise use WHERE for efficiency
- **Subqueries unlock complexity**: Many "impossible" problems become solvable with nested SELECT statements
- **CTE improves readability**: Complex queries become manageable when broken into named, logical steps
- **Date formatting matters**: Different databases have different date formats; stick to ISO standard when possible
- **Business context crucial**: Technical queries must serve business questions and actionable insights
- **Step-by-step debugging**: Break complex problems into smaller, testable components
- **Multiple solution paths**: Same problem often solvable with subqueries, CTEs, or window functions
- **Query flexibility**: Same result achievable through subqueries OR JOINs - choose based on readability and performance
- **Cross-platform practice**: Using different interfaces (SQL Fiddle, HackerRank, DataLemur) builds adaptability and reinforces core concepts
```