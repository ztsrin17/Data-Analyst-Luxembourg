# Case Study #1: Danny's Diner

Source of case: https://8weeksqlchallenge.com/case-study-1/

Although the name of this website states 8 weeks we are going to be doing a faster pace. 
It will then weave itself into Excel and Python. 

**How to Use This Repository**
    **Case Study Source:** [8 Week SQL Challenge - Case Study #1](https://8weeksqlchallenge.com/case-study-1/)
    **Solutions:** The final, commented SQL queries can be found in the [`solutions.sql`](./solutions.sql) file.
    **Database Setup:** The `schema.sql` file contains all the necessary code to build and populate the SQLite database.

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
- **HACKMD.io** for code development & note-taking
- **GitHub** for platform
- **VSCode** for occasional code development

## Methodology & Solutions

### Question 1: What is the total amount each customer spent at the restaurant?

#### Approach

A straightforward query to start. The goal was to sum the cost of all items for each customer. This required a simple `JOIN` between the `sales` and `menu` tables on `product_id`. I then used `GROUP BY` on the `customer_id` and `SUM()` on the `price` column to get the final totals.

#### Findings

-   **Customer A** was the highest paying customer at **$76**.
-   **Customer B** was a very close second at **$74**.

---

### Question 2: How many days has each customer visited the restaurant?

#### Approach

To count the unique visit days, I queried the `sales` table. The key was to `GROUP BY` `customer_id` and then apply `COUNT(DISTINCT order_date)`. Using `DISTINCT` here is crucial, as a customer can buy multiple items on the same day, but we only want to count each day once!

#### Findings

-   **Customer B** has visited the most with **6 visits**.
-   **Customer A** has visited the second most with **4 visits**.

---

### 3. What was the first item from the menu purchased by each customer?

#### Approach

This question was more interesting, as it required handling ties—what if a customer bought multiple items on their first visit? My approach was to rank each customer's purchases chronologically. I opted to use a Common Table Expression (CTE) with the `RANK()` window function, which allows for multiple items to be ranked #1. This provides a more complete answer than `ROW_NUMBER()`, which would arbitrarily pick one.

#### Findings

-   The first items purchased were **Curry for Customer A & B**, and **Ramen for Customer C**.
-   **Deeper Insight:** The tie-handling revealed **Customer C** ordered *two* Ramen dishes on their first visit, and **Customer A** purchased both Curry and Sushi.

---

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

#### Approach

Similar to the last question, I wanted to ensure my query could handle a tie for the most popular item. I again used a CTE with `RANK()` to count the purchases for each `product_id` and then rank them. I find this approach cleaner and more robust than a subquery in a `HAVING` clause or a simple `LIMIT 1`, which can hide valuable information.

#### Findings

-   The most purchased item on the menu is **Ramen**, ordered a total of **8 times**.
-   **Deeper Insight:** The 2nd most purchased item on the menu is **Curry** only at **4 times**.)

---

### 5. Which item was the most popular for each customer?

> **Note:** This was a fun one! I initially misinterpreted the question and solved a more complex version: "What is the most popular item for each customer *after they become a member*?" I realized my error, solved the correct question, but decided to keep both solutions as they tell a more complete story about customer behavior.

#### Approach

To find each customer's overall favorite, I used a CTE and the `RANK()` window function to count and rank the purchase frequency of each item for each customer individually. The "Bonus" question followed the same logic but first required joining with the `members` table to filter for purchases made on or after the `join_date`.

#### Findings

-   The favorite item for **Customer A** and **Customer C** is **Ramen**.
-   **Customer B** has **Sushi, Curry, and Ramen** all tied as their favorite items.
-   **Bonus Finding:** After becoming members, **Ramen** is the clear favorite for both **Customer A & B**.

---

### 6. Which item was purchased first by the customer after they became a member?

#### Approach

This query required joining all three tables and filtering for purchases where the `order_date` was on or after the `join_date`. I used a CTE with `RANK()`, partitioned by `customer_id` and ordered by `order_date`, to isolate the first purchase for each member. The final query then aggregated these results to find the most popular "first item."

#### Findings

-   **Sushi and Curry** are tied as the most popular "first purchases" after becoming a member.
-   **Insight:** We can notice that their "first purchases" post-membership differs from their "favorite purchases" post-membership (Ramen).

---

### 7. Which item was purchased just before the customer became a member?

#### Approach

This query was the logical inverse of the previous one. The method was very similar, using a CTE and `RANK()`. The key differences were filtering for `order_date < join_date` and ordering the rank by `order_date DESC` to find the most recent pre-membership purchase.

#### Findings

-   **Customer A's** last purchases before joining were **Sushi and Curry**.
-   **Customer B's** last purchase before joining was **Sushi**.

---

### 8. What is the total items and amount spent for each member before they became a member?

#### Approach

A straightforward query that required a `JOIN` between all three tables and a `WHERE` clause to filter for purchases made before the `join_date`. The results were then grouped by `customer_id` to `COUNT` the total items and `SUM` the total price.

#### Findings

-   Before joining, **Customer A** spent **$25** on **2 items**.
-   Before joining, **Customer B** spent **$40** on **3 items**.

---

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

#### Approach

This required implementing conditional business logic. I used a `CASE` statement inside a `SUM()` function. The `CASE` statement checked if the `product_name` was 'sushi' to apply the correct point multiplier (`price * 20` vs `price * 10`), and this was all aggregated and grouped by `customer_id`.

#### Findings

-   **Customer B** has the highest point total with **940 points**.
-   **Customer A** is a close second with **860 points**.
-   **Customer C** is last with **360 points**.

---

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

#### Approach

Several criterias to meet here. The query required a multi-layered `CASE` statement to handle the three different point conditions (first week bonus, sushi bonus, standard points). It also required careful date filtering in the `WHERE` clause, for which I used SQLite's `DATE()` function to perform the date arithmetic.

#### Findings

-   At the end of January, **Customer A** has a total of **1,370 points**.
-   At the end of January, **Customer B** has a total of **820 points**.

---

### Extra Question 1: Join All The Things

#### Approach

The goal here was to create a single, unified view of all customer transactions with their membership status at the time of purchase.

My approach involved a `LEFT JOIN` from the `sales` table to the `members` table, as this correctly includes all sales, regardless of whether the customer was a member. I then used an `INNER JOIN` to the `menu` table to retrieve product details. The core logic was a `CASE` statement that checked two conditions to determine membership status:
1.  Was the purchase made *before* the customer's `join_date`?
2.  Was the customer a member at all (`join_date IS NULL`)?
If either of these was true, the status was 'N'; otherwise, it was 'Y'.

---

### Extra Question 2: Rank All The Things

#### Approach

This was a great exercise that built directly on the previous question. The goal was to add a chronological rank to each member's purchases, while leaving non-member purchases as `NULL`.

My methodology involved a multi-step process using Common Table Expressions (CTEs) for clarity:
1.  **First CTE (`base`):** I started with the complete query from "Join All The Things" to create a base table with all the necessary columns, including the calculated `member` status.
2.  **Second CTE (`member_orders`):** I queried from the first CTE, filtering `WHERE member = 'Y'`
3.  **Third CTE (`member_orders_ranks`) :** I applied the `DENSE_RANK()` window function. I chose `DENSE_RANK()` specifically to handle days with multiple purchases without skipping rank numbers, partitioning by `customer_id` and ordering by `order_date`.
3.  **Final `SELECT`:** I performed a `LEFT JOIN` from the original `base` CTE to my new `member_orders_ranks` CTE. This final join was the key: it allowed me to append the rank to only the member purchases while correctly leaving `NULL` for all non-member purchases, creating the exact table requested.

---

## Summary of Insights & Recommendations

### Customers

After analyzing the initial sales data, several key customer profiles have emerged:

**Insight 1: Customer A is a "Premium Patron"**
    - While only visiting 4 times (Finding from Q2), they have the highest spending power at $76 (Finding from Q1). This indicates a high average spend per visit.
    - On their first visit, Customer A purchased Curry (the most expensive menu item) and Sushi (Finding from Q3), suggesting a willingness to try different items or an appreciation for a varied meal no matter the item price.
    - Although initially exploring both Curry and Sushi on their first visit (Finding Q3), Customer A has developed a clear preference for Ramen over time (Finding Q5).

**Insight 2: Customer B is the "Loyal Regular."**
    - They are the most frequent visitor with 6 visits (Finding from Q2), but their total spending is slightly lower at $74 (Finding from Q1).
    - Their initial purchase was Curry (Finding from Q3), indicating a preference for a popular and perhaps more substantial dish from the outset.
    - Customer B shows a broad appreciation for the menu, having purchased Sushi, Curry, and Ramen equally (Finding Q5), further reinforcing their loyalty and willingness to try various offerings.

**Insight 3: Customer C may be a "Ramen Enthusiast."**
    - Customer C's first purchase was two Ramen dishes (Finding from Q3), highlighting an immediate and strong preference for this specific item.
    - However, their overall engagement is low; they are the lowest spender with only one additional visit where Ramen was again purchased (Findings Q1, Q2, Q5), suggesting limited overall attraction beyond their initial specific interest.
    - This pattern suggests their interest is narrowly focused on a single menu item, making them a potential churn risk if their preferences change or are not met.


**Strategic Recommendations:**

**Customer A**
    **Recommendation 1:** Implement a targeted *"We Miss You" campaign*. If they haven't visited in a while, an email with a special offer (e.g., "Try our new limited-time side dish on us") could reactivate their interest.
    **Recommendation 2:** Encourage variety through *personalized combo offers.* Since they now prefers Ramen (Finding Q5), offer a special price on "Ramen + Sushi" to remind them of their initial exploratory purchase (Finding Q3).

**Customer B**
    **Recommendation 1:** *Upsell with high-margin items.* Since they like everything, staff could be trained to recommend adding a side of sushi or a special drink to their order.
    **Recommendation 2:** Introduce *combo deals* that encourage a higher cart value, like a "Danny's Special Set" (e.g., any main + side + drink for a set price).

**Customer C**
    **Recommendation 1:** Create a Ramen-specific loyalty program. A simple "Buy 4 Ramens, Get the 5th Free" punch card could be highly effective and doesn't require full membership.
    **Recommendation 2:** Use Ramen as the gateway to membership. Run an in-store promotion: "Sign up today and get a free bowl of Ramen on your next visit."

---

### Menu

**The Menu, insights and strategies:**

1.  **Curry:** 
    Popularity: 2nd most popular (Finding Q4).
    Price Point: Most expensive item.
    Role in the Menu: The luxury menu item.

2.  **Ramen:** 
    Popularity: Ramen is by far the most popular item on the mnu (Finding Q4).
    Price Point: 2nd most expensive.
    Role in the Menu: The star menu item, the favorite item.

3.  **Sushi:** 
    Popularity: Least popular (Finding Q4).
    Price Point: Cheapest.
    Role in the Menu: The quick bite or the overlooked option.
    

**Strategic Recommendations:**

**Ramen**
    **Strategy:** Solidify its *"Signature Dish"* status. Rebrand it on the menu as *"Danny's Signature Ramen."*
    This creates a strong link between the restaurant's identity and its most popular item. Capitalize on its popularity by making it the centerpiece of combo deals.

**Curry**
    **Strategy:** Reinforce its premium positioning. Instead of cutting the price, justify it. Use descriptive menu language ("Rich & Aromatic Chef's Special Curry") or introduce a "Curry of the Month" with premium ingredients to create excitement and scarcity.

**Sushi**
    **Strategy:** Position Sushi as the perfect add-on. Create a "Sushi Side" offer (e.g., "Add a 3-piece roll to any main for $X"). This lowers the barrier to entry and can significantly increase the average check size, leveraging it as a high-margin upsell.

---

### Membership Program

**The Loyalty Program**

**Insight 4: The Loyalty Program's Incentives Are Misaligned with Customer Preference.**
    The program successfully uses the Sushi 2x points multiplier to drive memberships; customers strategically purchase high-point items like Sushi and Curry around their join date (Findings 6 & 7). However, this behavior is purely transactional. Post-membership, members' purchasing habits revert to their actual favorite, Ramen, even though it provides a lower points reward (Finding 5).

**Insight 5: The Welcome Bonus Encourages Short-Term Splurging, Not Long-Term Loyalty.**
    The "2x points for the first week" promotion is a powerful short-term driver, as seen with Customer A's massive 1,370 point total (Finding 10). However, it proved ineffective at building a lasting habit, as the customer's visits ceased immediately after the promotional period, indicating they "cashed in" on the offer without developing sustained loyalty.

**Strategic Recommendations**

**1. Refocus the Points System on Rewarding Behavior, Not Just Items.**
    **Strategy:** Introduce a *"Variety Bonus."* Award 1.5x or 2x points to a customer when they order a different main dish than their previous visit. This rewards loyal
        Ramen lovers while gently encouraging them to explore the menu, increasing their overall engagement and preventing "menu fatigue."

**2. Restructure the Welcome Bonus to Build a Lasting Habit.**
    **Strategy:** Convert the "one-week sprint" into a "four-week journey." Gate the rewards to encourage return visits. For example:
        **Visit 1 (Join Week):** Get 2x points on all items.
        **Visit 2 (in a separate week):** Unlock a free side dish.
        **Visit 3 (in a separate week):** Unlock 500 bonus points.

This model incentivizes a consistent pattern of visits, which is far more valuable for building a loyal customer.

**3. Implement High-Visibility Perks to Drive New Member Sign-Ups. Use FOMO.**
    **Strategy:** Introduce a suite of low-cost, high-perceived-value benefits that are visible in the restaurant:
        **Priority Seating:** Members get seated first during busy times.
        **Reserved high-top tables:** Best seats marked *"Members Only."*
        **Complimentary Upgrades:** Offer members free green tea refills or an upgrade on their side dish.
        **Early Access:** Give members a one-week exclusive window to try new menu items.
        **Exclusive events and/or items:** Advertise in-restaurant certain members-only on-goings, items or timed benefits visibly.