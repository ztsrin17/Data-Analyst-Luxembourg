# Case Study #1: Danny's Diner

Source of case: https://8weeksqlchallenge.com/case-study-1/

Although the name of this website states 8 weeks we are going to be doing a faster pace. 
It will then weave itself into Excel and Python. 

To reproduce my analysis, first run the schema.sql script to build and populate the database.  
Then, you can run the queries in solutions.sql to see the answers to the case study questions.  

To be updated.

## Business Problem

Danny wants to use his sales data to gain a better understanding of his customers' purchasing habits to improve his customer loyalty program.

**Key Questions**: Analyze customer visiting patterns, total money spent, and their favorite menu items.
**Deliverable**: Write fully functioning SQL queries to answer these essential questions and more.
**Secondary Task**: Generate basic datasets for non-SQL users on Danny's team to easily inspect the data.

## The Data

The project uses three tables:

- **sales**: Records each customer transaction.
    customer_id     VARCHAR(1)
    order_date      DATE
    product_id      INTEGER

- **menu**: Contains information about each menu item.
    product_id      INTEGER
    product_name    VARCHAR(5)
    price           INTEGER

- **members**: Stores details about when each customer became a member.
    customers_id    VARCHAR(1)
    join_date       DATE

A sample dataset is provided due to privacy concerns.

## Tools Used

- **SQL** for data querying and analysis.
- **DB Browser for SQLite** as the database management tool.

## Methodology & Solutions

### Question 1: What is the total amount each customer spent at the restaurant?

#### Approach

Based on the question we will need to use the following:
 - s.customer_id, s.product_id from sales table
 - mu.product_id, mu.price from menu table

The table members is not needed as the question refers to each customer and not members.
So we only need to **JOIN** sales & menu

We want to know:
- what each customer has bought
- how much have they spent

To determine the total amount spent by each customer, the following procedures come to mind:

- **GROUP BY** s.customer_id to group all purchases for each customer.
- **SUM** mu.price for each customer group for the total spent value.

This query will directly sum up the cost of all items purchased by each customer, we'll also order by most to least spent total.

#### Findings

Customer A was the highest paying customer at $76.
Notable addition: Customer B was a very close second at $74.

---

### Question 2: How many days has each customer visited the restaurant?

#### Approach

Based on the question we will only need to use the following:
 - s.customer_id and s.order_date from the sales table

The tables `menu` & `members` are not needed as everything is in `sales`, no JOINs needed.

We want to know how many unique days each customer visited

To do so we can:
- **GROUP BY** s.customer_id
- **COUNT DISTINCT** s.order_date, and rename AS days_visited for column name.

**DISTINCT** is important here! A customer can buy multiple items on the same day but we only want to count each day once.
(Without DISTINCT we would be counting number of items bought in total)

We'll also order by COUNT DISTINCT highest to lowest.

#### Findings

Customer B has visited the most with 6 visits.
Customer A has visited the second most with 4 visits.

---

### 3. What was the first item from the menu purchased by each customer?

#### Approach

Based on the question we will need to use the following:
 - s.order_date, s.customer_id and s.product_id from sales
 - mu.product_id, mu.product_name (only for better readability in query result) and mu.price for extra sorting from menu

The table 'members' is not needed as the question refers to each customer and not members.

So: we already know we only need to JOIN sales & menu

To determine the first item purchased by each customer the following procedures come to mind:

- **PARTITION BY** (and not GROUP BY due to the 2nd point) by s.customer_id
- **RANK** by order_date ASC (oldest to most recent)
- and lastly filter for rank 1

An important consideration: what if a customer bought multiple items on their first visit?
As nothing is specified in the question, s.order_date values are dates without timestamps, and it refers to item in singular terms, we must decide ourselves.

- by product name (ASC/DESC)
- by product id (ASC/DESC)
- by price (ASC/DESC)

The best approach, in my opinion, will be our second one answering a slightly different question: what are ALL the items bought on each customer's first visit?
If we absolutely want a single answer, and as it relates to a restaurant, for now we can break the tie by selecting the most expensive item the customer bought on that first date. This prioritizes the item that contributed the most to revenue, immediately highlighting valuable/high-spending customers.

Let's update a previous point, RANK to ROW_NUMBER:
- **ROW NUMBER by s.order_date ASC, mu.price DESC**

Back to SQL. I see 2 ways to go about this: CTE or subquery.
- **WITH cte_name AS ()** which will **ROW_NUMBER** by **order_date ASC, price DESC** prior to final SELECT

Or 

- **FROM subquery** which will function the same but cannot be refered to in a following query as easily.

As a self-reflection note: if the CTE has 2 columns with same name (but from different joined tables) that aren't equal, which isn't the case in this exercise currently, I can also rename with AS in the CTE to properly refer to them in the main query without creating any ambiguity and bugs (as the joined table abreviations do not exist there in the above sql).

Now, for the second approach it only required a slight adjustement to the query to list out every item bought by each customer on their very first visit:
- switched **ROW_NUMBER** to **RANK**, allowing multiple rank 1s
- removed in the above window the 2nd sorting by price so that is not a tie-breaker for ranking, allowing only s.order_date to matter

#### Findings

The first items purchased by each customer, additionally sorted by price in case of multiple items being bought on their first visit, were:
- Curry for Customer A & B
- Ramen for Customer C

Variation 2 also gives useful information:
- Customer C orderd 2 Ramen on their first visit, not just 1.
- Customer A did order Curry as their most expensive purchase but also Sushi.

---

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

#### Approach

Based on the question we will need to use the following:
 - s.product_id from sales
 - mu.product_id, mu.product_name (only for better readability in query result) and optionally mu.price for extra-sorting from menu

The table 'members' is not needed as the question refers to each customer and not members, so we only need to JOIN sales & menu.

We want to know:
- which is the most purchased item
- how many times was it bought in TOTAL (no distinction between customers)

I find it too valuable to know which are the most purchased items regardless of their price, so I'm opting to have the query show multiple products in case of a rank 1 tie.
We'll stick to using **RANK** again (**DENSE RANK** would work as well, did not mention this last question) in this case and not **ROW_NUMBER**.

Let's note down what we'll do:
- in a CTE for ease of use & optimizing for ties: **RANK** by **COUNT(s.product_id)**
- **ORDER BY** count&price both DESC
- query and show CTE's rank 1 + count (+ optional: price)

\
I also noted another possibility:
- **GROUP BY & COUNT s.product_id**

and we could either:
- filter with **HAVING** the **MAX** of **COUNT()** in a subquery
(this will also show a tie, but less clean&flexible than CTE imo)

or

- **ORDER BY COUNT() DESC, price DESC**
- **LIMIT 1**
 
but if there are still ties, even with more filters, we cannot efficiently control which output will show up. I believe we are also losing too much valuable information in this case unless we want something very specific.

We can exclude mu.price/price in CTE's select, group by & outer query's select if we renamed or indicated elsewhere that total_purchases is also sorted by price DESC (in case of a tie, and if we want to do so).
Otherwise I believe it's a good visual aid and relevant information to show and I've kept it as bonus.

#### Findings

The most purchased item on the menu is Ramen at 8 times.
(Extra: The 2nd most purchased item on the menu is Curry only at 4 times.)

---

### 5. Which item was the most popular for each customer?

NOTE
Doing Q5 I realized I did not look at it correctly, and thought it was asking most popular item for each customer post-membership.
The following, answering that question, is quasi-identical to the query for the real Q5, only had to remove one JOIN and one WHERE filter.
Either way working out a double CTE took time. The experience was well appreciated.

In solutions.sql I kept the logical order (true Q5, alternative) and decided to follow suit here.

#### True Q5: Which item was the most popular for each customer?

We can refer to the code below and disregard members table, so:
    - remove JOIN members mb (etc)
    - remove WHERE order_date & join_date

The rest can stay as is.

#### Bonus: What keeps customers coming back after becoming members?

#### Approach

One hiccup with our data for questions like these is we cannot determine which is first between s.order_date & mb.join_date if the date is identical.
Did a customer place said order, became a member, then placed his first 'member' order right after, or on a future date?
Did a customer become a member, placed said order?

Since there is no way of knowing, we will go with this scenario:
A customer was a member for the order on the same date as joining.
The owner could have set-up a system that retroactively rewards/counts an order on the same date as joining, even if it was placed first.

For these we could only **JOIN** sales with members table, but to refer to the item by name we will also **JOIN** the menu table.
The first occasion to have all 3 tables joined in this case study!
An idea: we will only **JOIN** the menu table at the end as it is not needed for the first part, which will be a CTE again to determine first purchase (via **RANK** in case of multiple items, which I believe always matters)

We'll use:
    - s.customer_id, s.order_date, s.product_id from sales s table
    - mb.customer_id, mb.join_date from members mb table
    - mu.product_id, mu.product_name from menu mu table (only to identify products by their name)

We want to answer and identify these:
    - Determine what are the orders after a customer has become a member
    - For each member, count how many times each product has been purchased
    - For each member, select the product that has been purchased the most (their favorite)

(In the case a member quits being a member we would require a leave_date and only look at purchases between join & leave date, but this is not yet the case in Danny's Diner Case scenario.)
    
To do so we can:
    - A first CTE to:
        COUNT how many times each s.customer_id has bought which s.product_id (the count will be **AS** purchase_count)
        filtered by **WHERE** s.order_date >= mb.join_date
    - A second CTE, **FROM** previous_CTE
        **RANK() OVER (PARTITION BY** customer_id **ORDER BY** purchase_count DESC (**AS** favorite_rank)
        partition is *again important* as we are looking at each customer (member) independently
        (this queries product favoritism per customer)
    Final **SELECT** will just need to
    - **JOIN** menu to better identify products by name in final query
    - Filter by rank 1
    - **ORDER BY** what we want to know: most bought, customer id


#### Findings

The most popular item (favorite item) for each customer is:
    - Ramen for Customer A
    - Ramen for Customer C
    - Sushi, Curry and Ramen for Customer B

The most popular item for each customer post-membership is:
    - Ramen for Customer A & B

---

### 6. Which item was purchased first by the customer after they became a member?

Why are customers deciding to become members?

#### Approach

We'll use:
    - s.customer_id, s.order_date, s.product_id from sales s table
    - mb.customer_id, mb.join_date from members mb table
    - mu.product_id, mu.product_name from menu mu table (only to identify products by their name)
    
We want to answer and identify these:
    - Determine the first order(s) after a customer becomes a member
    
To do so we can:
    - Query from a CTE
        **RANK() OVER (PARTITION BY** s.customer_id **ORDER BY** s.order_date ASC
        partition is important as we are looking at each customer (member) independently
        filtered by **WHERE** s.order_date >= mb.join_date
    (we'll use **RANK**)
    - Outer SELECT will have a **GROUP BY** mu.product_name and **COUNT** them
    - Filter by rank 1
    - **ORDER BY** the above **COUNT**


#### Findings

Sushi and Curry are the 2 most popular "first purchase"s after becoming a member.
(Bonus: We can see the most popular first purchase post-membership differed from the favorite item post-membership.)

---

### 7. Which item was purchased just before the customer became a member?

#### Approach



#### Findings



---

### 8. What is the total items and amount spent for each member before they became a member?

#### Approach



#### Findings



---

### 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

#### Approach



#### Findings



---

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B 
have at the end of January?

#### Approach



#### Findings



---

### Extra 1

#### Approach



#### Findings



---

### Extra 2

#### Approach



#### Findings



## Summary of Insights & Recommendations

After analyzing the initial sales data, several key customer profiles have emerged:

**Insight 1: Customer A is the "High-Value Spender."**
    - While only visiting 4 times (Finding from Q2), they have the highest total spend of $76 (Finding from Q1). This indicates a high average spend per visit.
    - On their first visit, Customer A purchased Curry (their most expensive purchase) and Sushi (Finding from Q3), suggesting a willingness to try different items or an appreciation for a varied meal.

**Insight 2: Customer B is the "Loyal Regular."**
    - They are the most frequent visitor with 6 visits (Finding from Q2), but their total spending is slightly lower at $74 (Finding from Q1).
    - Their initial purchase was Curry (Finding from Q3), indicating a preference for a popular and perhaps more substantial dish from the outset.

**Insight 3: Customer C may be a "Ramen Enthusiast."**
    - Customer C's first purchase was two Ramen dishes (Finding from Q3), highlighting an immediate and strong preference for this specific item.
    (note for futre ref: it might also be a fluke if follow-up visits they did not purchase this)


**Strategic Recommendations:**

1.  **For Customer A:** The business objective should be to **increase visit frequency**.
        - Targeted "we miss you" campaign
        - Special offer after a certain number of days

2.  **For Customer B:** The objective should be to **increase average spend per visit**.
        - Recommendations could include upselling high-margin items
        - Presenting combo deals encouraging a higher cart value.

3.  **For Customer C:** The objective could possibly be to **leverage their specific preference for Ramen**.

**The Menu, insights and strategies:**

1.  **Curry:** 
        - The most expensive item.
        - The 2nd most bought item (although 50% less than 1st most bought)

2.  **Ramen:** 
        - The second-most expensive item.
        - The most bought item (capitalize on this)

3.  **Sushi:** 
        - The cheapest item (still at 66% price of the most expensive item)
        - The least bought item (not even bought half as many times as the most bought item)