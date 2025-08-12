# Session 3 Summary

## A brief look at Danny's Diner - Case Study #1

URL: https://8weeksqlchallenge.com/case-study-1/

A Reveal at what JOIN is:
Which column could you use to connect the sales table to the members table?
-> Sales table and members table are connected by customer_id.
Which column could you use to connect the sales table to the menu table?
-> Sales table and menu table are connected by product_id

## What I Learned

### JOIN Operations & Database Design
- **Database normalization**: Real-world data is split across multiple tables to reduce duplication and improve efficiency
- **JOIN fundamentals**: Combine related tables using shared keys (primary/foreign key relationships)
- **Key identification**: Understanding how to identify connecting columns between tables (e.g., `customer_id`, `product_id`)
- **Table relationships**: Recognizing central "hub" tables that connect to multiple other tables

### JOIN Types & Syntax
- **INNER JOIN**: Returns only rows that exist in BOTH tables
- **LEFT JOIN**: Returns ALL rows from left table + matching rows from right table (fills unmatched with NULL)
- **RIGHT JOIN**: Returns ALL rows from right table + matching rows from left table  
- **FULL JOIN**: Returns ALL rows from BOTH tables (shows NULLs where matches don't exist)
- **JOIN defaults**: `JOIN` = `INNER JOIN`, `LEFT JOIN` = `LEFT OUTER JOIN` (OUTER is implied)

### JOIN Best Practices
- **Table qualification**: Use `table.column` notation, especially when column names are ambiguous
- **Table aliases**: Use consistent, meaningful aliases (`FROM movies m JOIN directors d`)
- **FROM table strategy**: For 2 tables doesn't matter; for 3+ tables use most central table as FROM
- **Multiple conditions**: Use OR in JOIN conditions for complex matching

### NULL Handling in JOINs
- **NULL behavior**: NULL ≠ 0, NULL ≠ empty string, NULL ≠ NULL
- **NULL testing**: Must use `IS NULL` and `IS NOT NULL`, never `=` or `!=`
- **OUTER JOIN NULLs**: Common in LEFT/RIGHT/FULL JOINs when no matching row exists
- **Aggregate functions**: All ignore NULL values except `COUNT(*)`

### Advanced JOIN Concepts
- **CASE statements**: Conditional logic within queries using `CASE WHEN ... THEN ... ELSE ... END`
- **Complex aggregation**: Using `SUM(CASE WHEN ...)` for conditional counting
- **Missing data detection**: Using LEFT JOIN to find records without matches
- **INNER vs OUTER debugging**: INNER excludes unmatched rows, OUTER includes them with NULLs

### Professional Query Writing & Debugging
- **Formatting habits**: Vertical > horizontal layout, explicit column names, consistent aliases
- **Table qualification**: Always use `table.column` notation in multi-table queries
- **Query structure**: Organize complex queries with visual chunking and proper indentation
- **Step-by-step debugging approach**: Systematic method of checking if matches exist, then checking if goals exist, then building the full query to isolate issues

### Cross-Domain Insights
- **Statistics note**: Recognition that sample data requires n-1 division for standard deviation calculations vs n for entire populations (from Danny's Diner context)

## What I Did
- Analyzed **Danny's Diner case study** table relationships and identified connecting keys
- Completed **SQLBolt JOIN lessons** (lessons 6-8) covering INNER, OUTER JOINs, and NULL handling
- Practiced **SQLZoo JOIN exercises** (1-13) with increasingly complex scenarios
- Created **Excel-SQL bridge** using VLOOKUP to visualize JOIN concepts
- Debugged **query result ordering** issues and learned about automated testing limitations
- Applied **CASE statements** for conditional aggregation in match scoring scenarios
- Learned **professional formatting habits** for complex multi-table queries
- Solved **1 DataLemur easy problem** (GROUP BY)

## Key Takeaways
- **Mental models matter**: INNER JOIN = "both contacts AND Facebook friends", LEFT JOIN = "all contacts + Facebook info if available"
- **OUTER JOINs reveal gaps**: Essential for finding missing relationships and incomplete data
- **GROUP BY controls categories**: Determines what appears as row labels in results, not just what gets counted
- **Professional habits early**: Use table qualification, consistent aliases, and vertical formatting from the start
- **Debugging strategy**: Break complex queries into steps to isolate issues (check matches exist, verify JOIN conditions, test with LEFT JOIN)