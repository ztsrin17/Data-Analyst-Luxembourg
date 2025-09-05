# Session 10 Summary

## What I Revised & Learned

### Pre-Membership Purchase Analysis
- **Reverse chronological ranking**: Using `ORDER BY s.order_date DESC` in RANK() to find most recent purchases before membership
- **Date filtering logic**: Using `s.order_date < mb.join_date` to exclude same-day and post-membership purchases
- **Consistent methodology**: Applying similar CTE patterns from Q6 but with reversed temporal logic

### Aggregate Calculations with Conditional Logic
- **Multi-level aggregation**: First aggregating counts per product per customer, then summing across products
- **Price multiplication**: Using `mu.price * count_per_product` for accurate total spend calculations
- **Comprehensive totals**: Calculating both item counts and monetary totals simultaneously

### Complex Scoring Systems
- **Nested CASE WHEN logic**: Building multi-conditional scoring rules for different scenarios
- **Product-specific multipliers**: Implementing 2x multiplier for sushi using case-sensitive matching
- **Time-based multipliers**: Adding temporal conditions for first-week membership bonuses

### SQLite Date Functions
- **Cross-SQL compatibility awareness**: Recognizing that date functions vary between SQL implementations
- **SQLite-specific syntax**: Learning `DATE(mb.join_date, '+6 days')` for date arithmetic
- **Testing approach**: Validating date range logic with smaller test queries before full implementation

## What I Did

### Danny's Diner Case Study Questions
- **Question 7**: "Which item was purchased just before the customer became a member?"
- **Question 8**: "What is the total items and amount spent for each member before they became a member?"
- **Question 9**: "If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?"
- **Question 10**: "In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?"

### Complex Query Development Process
- **Q7**: Last purchase before membership
  - Used RANK() with `ORDER BY s.order_date DESC` for reverse chronological order
  - Filtered by `s.order_date < mb.join_date` for pre-membership purchases only
  - Added customer_id to SELECT and GROUP BY for cleaner presentation per customer
- **Q8**: Pre-membership spending analysis
  - CTE for aggregating purchase counts per customer per product
  - Calculated total spend using `SUM(mu.price * count_per_product)`
  - Calculated total items using `SUM(count_per_product)`
- **Q9**: Basic points system implementation
  - CASE WHEN for sushi-specific 2x multiplier
  - Base scoring of 10 points per $1 spent
  - Applied to all customer purchases regardless of membership status
- **Q10**: Complex temporal and conditional scoring
  - Multi-condition CASE WHEN with sushi rules and first-week membership bonus
  - Date range filtering for first week: `BETWEEN mb.join_date AND DATE(mb.join_date, '+6 days')`
  - End-of-January cutoff: `WHERE s.order_date < '2021-02-01'`

### Database-Specific Adaptations
- **PostgreSQL vs SQLite**: Adapted date arithmetic from `INTERVAL '6 days'` to `DATE(date, '+6 days')`
- **Testing methodology**: Built small verification queries to validate date logic before full implementation
- **ISO date string comparison**: Leveraged string comparison for date filtering with YYYY-MM-DD format

## Key Challenges and Solutions

### Temporal Logic Reversal
- **Challenge**: Adapting Q6 logic for "before" instead of "after" membership
- **Solution**: Changed ORDER BY from ASC to DESC and filter from >= to < join_date
- **Learning**: Importance of careful attention to temporal direction in business questions

### Multi-Level Aggregation Strategy
- **Challenge**: Calculating both item counts and total spend from the same grouped data
- **CTE approach**: First aggregate counts per product per customer
- **Final aggregation**: Sum across products with price multiplication
- **Benefit**: Cleaner logic and easier debugging

### Complex Conditional Scoring
- **Challenge**: Implementing overlapping conditions (sushi bonus + first-week bonus)
- **Logical precedence**: Sushi always gets 2x multiplier regardless of timing
- **Additional conditions**: Non-sushi items get 2x only during first week of membership
- **Date range precision**: Including join_date but limiting to 6 additional days

### Database Function Compatibility
- **Challenge**: Date arithmetic differences between SQL implementations
- **Research approach**: Looking up SQLite-specific date functions
- **Testing strategy**: Validating date calculations with simple SELECT queries
- **Documentation**: Noting the difference between PostgreSQL and SQLite syntax

## Key SQL Patterns Employed

### Reverse Chronological Ranking
```sql
WITH member_last_purchases AS (
    SELECT
        s.customer_id,
        s.product_id,
        RANK() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date DESC -- DESC for most recent
        ) AS purchase_rank
    FROM sales s
    INNER JOIN members mb ON s.customer_id = mb.customer_id
    WHERE
        s.order_date < mb.join_date -- Before membership
)
```

### Multi-Level Aggregation Pattern
```sql
WITH purchases_pre_membership AS (
    SELECT
        s.customer_id,
        s.product_id,
        COUNT(s.product_id) AS count_per_product
    FROM sales s
    INNER JOIN members mb ON s.customer_id = mb.customer_id
    WHERE
        s.order_date < mb.join_date
    GROUP BY
        s.customer_id,
        s.product_id
)
SELECT
    customer_id,
    SUM(mu.price * count_per_product) AS total_amount_spent,
    SUM(count_per_product) AS total_items_bought
```

### Complex Conditional Scoring
```sql
CASE
    WHEN mu.product_name = 'sushi' THEN mu.price * 10 * 2
    WHEN
        ((mu.product_name != 'sushi') AND
         (s.order_date BETWEEN mb.join_date AND DATE(mb.join_date, '+6 days'))
         )
        THEN mu.price * 10 * 2
    ELSE mu.price * 10
END
```

### SQLite Date Range Logic
```sql
WHERE s.order_date BETWEEN mb.join_date AND DATE(mb.join_date, '+6 days')
AND s.order_date < '2021-02-01' -- ISO date string comparison
```

### Progressive Analysis Building
- **Session conclusion**: Completed all 10 case study questions
- **Insight development**: Started building customer and menu item insights from completed analysis
- **Next session planning**: Moving to recommendations and strategic analysis phase