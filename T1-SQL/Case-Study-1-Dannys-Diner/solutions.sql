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

   -- Interpretation 1: What is the most popular "first purchase" after becoming a member?
   
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
    INNER JOIN members m ON s.customer_id = m.customer_id
        -- Since it's an INNER JOIN we are already excluding non-members from the query
    WHERE
        s.order_date >= m.join_date  -- Issue: order_date is on same day as join_date but the purchases happened before joining
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
    times_as_first_purchase DESC
;
   
   -- Interpretation 2: What is the most popular item (favorite item) for each customer post-membership?




-- 6. Which item was purchased first by the customer after they became a member?



-- 7. Which item was purchased just before the customer became a member?



-- 8. What is the total items and amount spent for each member before they became a member?



-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?



-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


