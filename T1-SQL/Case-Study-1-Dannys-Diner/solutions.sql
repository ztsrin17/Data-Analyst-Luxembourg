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

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?



-- 5. Which item was the most popular for each customer?



-- 6. Which item was purchased first by the customer after they became a member?



-- 7. Which item was purchased just before the customer became a member?



-- 8. What is the total items and amount spent for each member before they became a member?



-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?



-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


