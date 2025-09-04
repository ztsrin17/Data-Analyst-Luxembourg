-- solutions.sql for Case-Study-1-Dannys-Diner
-- NOTE: Run schema.sql first to create database and load data

/* -----------------------------
   Case Study Questions Overlook
   ----------------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- There are 2 bonus questions : recreating table outputs
-- Join All The Things & Rank All The Things

/* ------------------
   Case Study Answers
   ------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT
s.customer_id AS customer,
SUM(mu.price) AS total_amount_spent
FROM
sales s
INNER JOIN
menu mu ON s.product_id = mu.product_id
-- We do not need to join the members table as the question concerns each customer no matter their membership status
GROUP BY
s.customer_id
ORDER BY
total_amount_spent DESC --optional, clean
;

-- 2. How many days has each customer visited the restaurant?

SELECT
s.customer_id AS customer,
COUNT(DISTINCT s.order_date) AS days_visited
/* Distinct is specified because there can be multiple items bought in one day
We want to count the distinct days visited amount and not number of items bought */
FROM
sales s
-- No need for JOINs here, everything needed is in sales
GROUP BY
s.customer_id
ORDER BY
days_visited DESC --optional, clean
;

-- 3. What was the first item from the menu purchased by each customer?

WITH purchase_order AS (
    SELECT
        s.customer_id,
        s.order_date,
        mu.product_name,
        mu.price,
        ROW_NUMBER() OVER (
            PARTITION BY
                s.customer_id
            ORDER BY
                s.order_date ASC,
                mu.price DESC
        ) AS purchase_row
    FROM sales s
    INNER JOIN menu mu ON s.product_id = mu.product_id
)
SELECT
    customer_id,
    product_name
FROM purchase_order
WHERE purchase_row = 1
;

-- Variation 2 to see every item bought on the first visit:

WITH purchase_order AS (
    SELECT
        s.customer_id,
        s.order_date,
        mu.product_name,
        mu.price,
        RANK() OVER ( --RANK instead of ROW_NUMBER
            PARTITION BY
                s.customer_id
            ORDER BY
                s.order_date ASC
                -- removed second sorting
        ) AS purchase_row
    FROM sales s
    INNER JOIN menu mu ON s.product_id = mu.product_id
)
SELECT
    customer_id,
    product_name
FROM purchase_order
WHERE purchase_row = 1
;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

-- Note: Proceeding with a CTE to list multiple 'most purchased item' if needed, as all of the items would matter in this case.

WITH product_purchases AS (
    SELECT
        mu.product_name,
        mu.price,
        COUNT(mu.product_id) AS total_purchases,
        RANK() OVER (
               --no partition needed as we're not comparing counts between categories here
            ORDER BY
                COUNT(mu.product_id) DESC,
                mu.price DESC
	) AS purchase_rank
    FROM sales s
    INNER JOIN menu mu ON s.product_id = mu.product_id
    GROUP BY
        mu.product_name,
        mu.price
)
SELECT
    product_name,
    total_purchases,
    price --bonus information, facilitating understanding the 2nd sorting order (mu.price)
FROM product_purchases
WHERE purchase_rank = 1
;

-- Alternative, only a single result is possible:

SELECT
   mu.product_name,
   COUNT(mu.product_id) AS total_purchases
FROM sales s
INNER JOIN menu mu ON s.product_id = mu.product_id
GROUP BY
   mu.product_name
ORDER BY
   COUNT(mu.product_id) DESC,
   mu.price DESC,  --tie-breaker
   mu.product_name --tie-breaker 2
LIMIT 1
;

-- 5. Which item was the most popular for each customer?

   -- Original:

WITH customer_purchases AS ( --CTE1
    SELECT
        s.customer_id,
        s.product_id,
        COUNT(*) AS purchase_count -- Counting how many times each product has been purchased by each customer
    FROM sales s
     -- No JOIN for membership status, no date WHERE filter either
    GROUP BY
        s.customer_id,
        s.product_id
),
ranked_favorites AS ( --CTE2
    SELECT
        cs.customer_id,
        cs.product_id,
        cs.purchase_count,
        RANK() OVER ( -- RANK instead of ROW_NUMBER in case of equals
            PARTITION BY cs.customer_id -- We want to distinguish favorite item per customer so we partition
            ORDER BY cs.purchase_count DESC -- Favorite = highest count
        ) AS fav_rank
    FROM customer_purchases cs -- We are using CTE1 which as COUNTed already
)
SELECT
    rf.customer_id,
    mu.product_name,
    rf.purchase_count
FROM ranked_favorites rf -- Abbreviation required for follow-up JOIN
INNER JOIN menu mu ON rf.product_id = mu.product_id -- Late JOIN of menu only for full product names
WHERE
    rf.fav_rank = 1 -- We only want the favorite item
ORDER BY
    rf.purchase_count DESC, -- The goal, the favorite items
    rf.customer_id ASC -- Per customer, extra sorting
;
   
   -- Alternative: What is the most popular item (favorite item) for each customer post-membership?

WITH post_membership_purchases AS ( --CTE1
    SELECT
        s.customer_id,
        s.product_id,
        COUNT(*) AS purchase_count -- Counting how many times each product has been purchased by each member
    FROM sales s
    INNER JOIN members m ON s.customer_id = m.customer_id  -- We are limiting to members-only
    WHERE
        s.order_date >= m.join_date  -- Only looking at orders after joining
            -- (As mentioned in readme.md: we have no exit_date for membership, but it would be filtered here as well)
    GROUP BY
        s.customer_id,
        s.product_id
),
ranked_favorites AS ( --CTE2
    SELECT
        pmp.customer_id,
        pmp.product_id,
        pmp.purchase_count,
        RANK() OVER ( -- RANK instead of ROW_NUMBER in case of equals
            PARTITION BY pmp.customer_id -- We want to distinguish favorite item per member so we partition
            ORDER BY pmp.purchase_count DESC -- Favorite = highest count
        ) AS fav_rank
    FROM post_membership_purchases pmp -- We are only using the table of post-membership orders which has COUNTed already
)
SELECT
    rf.customer_id,
    mu.product_name,
    rf.purchase_count
FROM ranked_favorites rf -- Abbreviation required for follow-up JOIN
INNER JOIN menu mu ON rf.product_id = mu.product_id -- Late JOIN of menu only for full product names
WHERE
    rf.fav_rank = 1 -- We only want the favorite item
ORDER BY
    rf.purchase_count DESC, -- The goal, the favorite items
    rf.customer_id ASC -- Per member, extra sorting
;


-- 6. Which item was purchased first by the customer after they became a member?

WITH member_first_purchases AS (
    SELECT
        s.customer_id,  -- PARTITION BY
        s.product_id,   -- KEY for outer SELECT join
        RANK() OVER (
            PARTITION BY    -- Necessary to check first s.order_date per each customer
                s.customer_id
            ORDER BY
                s.order_date ASC -- ASC to sort by oldest order first
        ) AS purchase_rank
    FROM sales s
    INNER JOIN members mb ON s.customer_id = mb.customer_id
        -- Since it's an INNER JOIN we are already excluding non-members from the query
    WHERE
        s.order_date >= mb.join_date  -- Issue: order_date is on same day as join_date but the purchases happened before joining
         -- fix: If you purchased on the same day as joining you get the bonus/points/etc.
)
SELECT
    mu.product_name,
    COUNT(mu.product_name) AS times_as_first_purchase
FROM member_first_purchases mfp -- Abbreviation required for follow-up JOIN
INNER JOIN menu mu ON mfp.product_id = mu.product_id
    -- We only needed to identify by name in this late stage
WHERE
    mfp.purchase_rank = 1 -- Filter to only first purchase(s) of each member
GROUP BY
    mu.product_name
ORDER BY
    times_as_first_purchase DESC -- Looks better
;


-- 7. Which item was purchased just before the customer became a member?



-- 8. What is the total items and amount spent for each member before they became a member?



-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?



-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


