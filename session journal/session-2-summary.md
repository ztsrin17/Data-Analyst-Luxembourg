# Session 2 Summary

## What I Learned

### Aggregate Functions & Grouping
- **Core aggregate functions**: `COUNT()`, `SUM()`, `AVG()`, `MAX()`, `MIN()`
- **`COUNT()` variations**: `COUNT(*)` for all rows vs `COUNT(column_name)` for non-null values
- **`COUNT(DISTINCT column)`**: Count unique values only
- **Handling NULLs**: Aggregate functions ignore NULL values (except `COUNT(*)`)

### GROUP BY Fundamentals
- **Purpose**: Groups rows with identical values into summary rows for aggregate calculations
- **Mental model**: Creates "buckets" of similar rows, then applies aggregate functions to each bucket
- **Multiple columns**: Can group by multiple columns for more detailed analysis
- **Query structure**: `SELECT <columns>, <aggregates> FROM <table> WHERE <condition> GROUP BY <columns>`

### WHERE vs HAVING
- **WHERE**: Filters individual rows before grouping occurs
- **HAVING**: Filters grouped results after aggregation is performed
- **Use case**: WHERE for row-level filtering, HAVING for aggregate-level filtering

### Advanced Filtering
- **Tuple filtering limitation**: `WHERE (a,b) IN ((1,2), (3,4))` works for exact values only
- **Complex conditions**: Use multiple OR conditions when not dealing with exact matches
- **NULL handling**: Use `IS NULL` and `IS NOT NULL` for proper NULL filtering

### Number Formatting & Advanced Concepts
- **Rounding techniques**: `ROUND(AVG(column), 1)` for decimal precision, `CAST(AVG(column) AS INTEGER)` for whole numbers
- **`CASE` statement**: Noted as more advanced conditional logic (not yet explored)

## What I Did
- Applied **Claude's feedback** to polish Session 1 critical thinking analysis (structured approach)
- Completed **W3Resource aggregate function exercises** (1-10)
- Practiced **SQLZoo SUM and COUNT** problems (world database)
- Solved **2 DataLemur easy problems** (NULL filtering, DISTINCT queries)
- Created **Excel-SQL bridge exercise** using Google Sheets to visualize GROUP BY concept
- Documented **aggregate function formulas** and explanations

## Key Takeaway
GROUP BY creates conceptual "buckets" of rows with identical values, then aggregate functions operate on each bucket separately - this mental model makes complex grouping operations intuitive to understand and write.