# Session 8 Summary

## What I Revised & Learned

### Window Functions with CTEs
- **ROW_NUMBER() vs RANK()**: ROW_NUMBER() assigns unique sequential numbers even for ties, while RANK() allows tied values
- **Multiple ORDER BY criteria**: Using `ORDER BY s.order_date ASC, mu.price DESC` for complex tie-breaking logic
- **Business logic in tie-breaking**: Prioritizing most expensive items for revenue insights when dates are equal
- **CTE advantages**: WITH clauses provide cleaner, more readable code than subqueries for complex window operations

### Aggregate Functions with Window Functions
- **RANK() with aggregates**: Using `RANK() OVER (ORDER BY COUNT() DESC)` to rank grouped results
- **Multiple column GROUP BY**: Grouping by both product attributes for comprehensive analysis
- **Tie handling strategies**: Different approaches (RANK, ROW_NUMBER, LIMIT) have different implications for tied results

### Project Structure and Documentation
- **README.md template**: Standardized case study documentation format with sections for problem, data, methodology, and insights
- **Code organization**: Separating documentation (README) from implementation (solutions.sql)
- **Self-reflection practices**: Adding notes about column naming and CTE aliasing considerations

## What I Did

### Danny's Diner Case Study (Questions 3-4)
- **Question 3**: Found first item purchased by each customer using ROW_NUMBER() with PARTITION BY
  - Used tie-breaking logic: order by date ASC, then price DESC for business relevance
  - Implemented CTE approach for clarity and reusability
  - Considered edge cases where customers bought multiple items on first visit
- **Question 4**: Identified most purchased menu item using RANK() with COUNT()
  - Used GROUP BY with multiple columns for complete product information
  - Applied tie-handling to show all products in case of equal purchase counts
  - Included price as secondary sorting criteria for business insights
  - Explained and developed other approaches as well as why I believe RANK() to be best in this scenario 

### Project Documentation Setup
- **README structure**: Created standardized template with Business Problem, Data, Tools, Methodology sections
- **Question format**: Individual sections with Approach and Finding subsections
- **Code separation**: Keeping complete SQL code in separate solutions.sql file

## Key Challenges and Solutions

### Tie-Breaking Logic for First Purchases
- **Challenge**: Multiple items purchased on same first date by customer
- **Business consideration**: Which item represents the "first" purchase?
- **Solution**: Used price DESC as tie-breaker to highlight high-value customer behavior
- **Implementation**: `ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date ASC, price DESC)`

### Handling Ties in Most Purchased Items
- **Challenge**: Multiple products could have same purchase count
- **Analysis considered**:
  - **ROW_NUMBER()**: Would arbitrarily pick one item, losing information
  - **RANK()**: Shows all tied items, preserving complete picture
  - **LIMIT approach**: Could miss ties entirely
- **Decision**: Used RANK() to show all top items with price as secondary sort

### CTE vs Subquery Decision Making
- **Challenge**: Choosing between CTE and subquery approaches
- **CTE advantages identified**:
  - **Readability**: Named result sets easier to understand
  - **Reusability**: Can reference CTE multiple times if needed
  - **Debugging**: Easier to test CTE logic independently
- **Decision**: Consistently used CTEs for complex window function operations

## Key SQL Patterns Employed

### ROW_NUMBER() with Multiple Ordering Criteria
```sql
WITH purchase_order AS (
    SELECT
        s.customer_id,
        s.order_date,
        mu.product_name,
        mu.price,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date ASC, mu.price DESC
        ) AS purchase_row
    FROM sales s
    INNER JOIN menu mu ON s.product_id = mu.product_id
)
SELECT customer_id, product_name
FROM purchase_order
WHERE purchase_row = 1;
```

### RANK() with Aggregate Functions
```sql
WITH product_purchases AS (
    SELECT
        mu.product_name,
        mu.price,
        COUNT(mu.product_name) AS total_purchases,
        RANK() OVER (
            ORDER BY COUNT(mu.product_name) DESC, mu.price DESC
        ) AS purchase_rank
    FROM sales s
    INNER JOIN menu mu ON s.product_id = mu.product_id
    GROUP BY mu.product_name, mu.price
)
SELECT product_name, total_purchases, price
FROM product_purchases
WHERE purchase_rank = 1;
```

### README.md Case Study Template

```
# Case Study
## Business Problem
## The Data
## Tools Used
## Methodology & Solutions
### Question 1
#### Approach
#### Finding
---
### Question 2
#### Approach
#### Finding
...
## Summary of Insights & Recommendations
```

### CTE Column Aliasing Best Practice
- **Consideration**: When CTEs have joins with same column names, use AS aliases in CTE SELECT
- **Benefit**: Eliminates ambiguity in main query references
- **Example**: `s.product_id AS sales_product_id, mu.product_id AS menu_product_id`