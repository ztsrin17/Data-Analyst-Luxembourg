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
total_amount_spent DESC --Order for readability
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
days_visited DESC --Order for readability
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
    times_as_first_purchase DESC --Order for readability
;


-- 7. Which item was purchased just before the customer became a member?

WITH member_last_purchases AS (
    SELECT
        s.customer_id,  -- PARTITION BY
        s.product_id,   -- KEY for outer SELECT join
        RANK() OVER (
            PARTITION BY    -- Necessary for each customer seperation
                s.customer_id
            ORDER BY
                s.order_date DESC -- DESC to rank by most recent
        ) AS purchase_rank
    FROM sales s
    INNER JOIN members mb ON s.customer_id = mb.customer_id
        -- Since it's an INNER JOIN we exclude non-members from the query
    WHERE
        s.order_date < mb.join_date -- s.order_date has to be before a join date this time
)
SELECT
    mu.product_name,
    COUNT(mu.product_name) AS times_as_first_purchase,
	mlp.customer_id
FROM member_last_purchases mlp -- Abbreviation required for follow-up JOIN
INNER JOIN menu mu ON mlp.product_id = mu.product_id
    -- We only needed to identify by name in this late stage
WHERE
    mlp.purchase_rank = 1 -- Filter to only most recent purchase(s) of each member
GROUP BY
    mu.product_name,
	mlp.customer_id
ORDER BY
    times_as_first_purchase DESC, --Order for readability
    mlp.customer_id ASC --Order for readability
;

-- 8. What is the total items and amount spent for each member before they became a member?

WITH purchases_pre_membership AS (
    SELECT
        s.customer_id,
        s.product_id,   -- KEY for outer SELECT join
        COUNT(s.product_id) AS count_per_product
    FROM sales s
    INNER JOIN members mb ON s.customer_id = mb.customer_id
        -- Since it's an INNER JOIN we exclude non-members from the query
    WHERE
        s.order_date < mb.join_date -- s.order_date has to be before a join date this time
	GROUP BY
		s.customer_id,
		s.product_id
)
SELECT
	mprem.customer_id,
	SUM(mu.price * mprem.count_per_product) AS total_amount_spent,  -- SUM price of all products bought 
    SUM(mprem.count_per_product) AS total_items_bought -- SUM count of all products bought	
FROM purchases_pre_membership mprem -- Abbreviation required for follow-up JOIN
INNER JOIN menu mu ON mprem.product_id = mu.product_id
    -- We only needed to identify by name and use the value of each product in this late stage
GROUP BY
    mprem.customer_id
ORDER BY
	total_amount_spent DESC,
	total_items_bought ASC,
	mprem.customer_id ASC
	-- Sorting is by highest value spender per least items bought, lastly alphabetically
;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN mu.product_name = 'sushi' THEN mu.price * 10 * 2 -- 10 points per $1, 2x multiplier for sushi
            -- case-sensitive
            ELSE mu.price * 10 -- 10 points per $1, no multiplier
		END
	) AS total_score
FROM sales s
INNER JOIN menu mu ON s.product_id = mu.product_id
GROUP BY
    s.customer_id
ORDER BY
    total_score DESC, -- highest points first
    s.customer_id -- alphabetical
;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN mu.product_name = 'sushi' THEN mu.price * 10 * 2 -- 10 points per $1, 2x multiplier for sushi
            WHEN
                ((mu.product_name != 'sushi') AND
                 (s.order_date BETWEEN mb.join_date AND DATE(mb.join_date, '+6 days')) -- 1 week including join_date, so +6 days
                 )
                THEN mu.price * 10 * 2 -- Same scoring system as sushi 1 week after becoming member for every item
            ELSE mu.price * 10 -- 10 points per $1, no multiplier
		END
	) AS total_score
FROM sales s
INNER JOIN menu mu ON s.product_id = mu.product_id
INNER JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date < '2021-02-01' -- String comparison works for ISO dates (YYYY-MM-DD)
GROUP BY
    s.customer_id
ORDER BY
    total_score DESC, -- highest points first
    s.customer_id -- alphabetical
;

/* If we want to answer the above to include all customers
and not only members we only need to change the
INNER JOIN members to a LEFT JOIN members.
CASE WHEN ordering can be slightly changed as well
for larger databases/runtime efficiency? or clarity */

-- Extra 1: Join all the things.

SELECT
    s.customer_id,
    s.order_date,
    mu.product_name,
    mu.price,
    CASE
        WHEN mb.join_date IS NULL THEN 'N'  -- Instantly exclude if not a membered purchase
        WHEN mb.join_date > s.order_date THEN 'N' -- Exclude if purchase is done before joining
        ELSE 'Y'
    END AS member
FROM sales s
INNER JOIN menu mu ON s.product_id = mu.product_id
LEFT JOIN members mb ON s.customer_id = mb.customer_id
ORDER BY
    s.customer_id ASC,
    s.order_date ASC,
    mu.product_name ASC
;

-- Extra 2: Rank all the things.

WITH
    base AS ( -- our EXTRA 1 query as a CTE, it seperates member orders from non-member orders
        SELECT
            s.customer_id,
            s.order_date,
            mu.product_name,
            mu.price,
            CASE
                WHEN mb.join_date IS NULL THEN 'N'
                WHEN mb.join_date > s.order_date THEN 'N'
                ELSE 'Y'    -- we will select these in the next CTE
            END AS member
        FROM sales s
        INNER JOIN menu mu ON s.product_id = mu.product_id
        LEFT JOIN members mb ON s.customer_id = mb.customer_id
        -- No need for ORDER BY yet
    ),
    member_orders AS ( -- Here we make a CTE to filter out non-member orders from the previous one
        SELECT         -- We continue needing customer_id and the order_date
            customer_id,
            order_date
        FROM base
        WHERE member = 'Y' -- Filter out non-member orders
        GROUP BY
            customer_id,
            order_date 
    ),
    member_orders_ranks AS ( -- Here a last CTE using the previous one to order the orders by date
        SELECT               -- We continue needing customer_id and the order_date
            customer_id,
            order_date,
            DENSE_RANK() OVER
                (PARTITION BY customer_id        -- rank by customers seperately
                 ORDER BY order_date ASC)        -- oldest order first
            AS ranking
    FROM member_orders
    )
SELECT
    b.customer_id,
    b.order_date,
    b.product_name,
    b.price,
    b.member,                 -- from the first CTE (and originally EXTRA 1 answer), distinguishing member order from non-member order
    mor.ranking               -- from the last CTE DENSE_RANKing member orders for each member seperately, NULL for non-member orders
FROM base b
LEFT JOIN member_orders_ranks mor ON
    b.customer_id = mor.customer_id
    AND b.order_date = mor.order_date
    -- LEFT JOIN to not exclude non-member orders, based on two primary keys for distinctiveness
    -- LEFT JOIN also allows NULL for non-member orders in ranking column
ORDER BY    -- same ORDER as EXTRA 1 for consistency
    b.customer_id ASC,
    b.order_date ASC,
    b.product_name ASC;
;