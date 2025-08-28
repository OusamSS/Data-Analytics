set search_path = danny_dinner;

-- What is the total amount each customer spent at the restaurant?

select customer_id, sum(price) as total_amount
from sales join menu using(product_id)
group by customer_id;

--How many days has each customer visited the restaurant?

select customer_id, count(distinct order_date)
from sales
group by customer_id;

--What was the first item from the menu purchased by each customer?

WITH RANKED AS
	(SELECT CUSTOMER_ID,
			PRODUCT_NAME,
			DENSE_RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS RNK
	 FROM SALES
	 JOIN MENU USING(PRODUCT_ID))

SELECT *
FROM RANKED
WHERE RNK = 1;


--What is the most purchased item on the menu and how many times was it purchased by all customers?

select count(product_name) as cnt,product_name
from menu join sales using(product_id)
group by product_name
order by cnt desc
limit 1;


--Which item was the most popular for each customer?
WITH COUNTED AS
	(SELECT CUSTOMER_ID,
	 		PRODUCT_NAME,
			RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(product_name) DESC) AS rnk
		FROM SALES
		JOIN MENU USING(PRODUCT_ID)
		GROUP BY CUSTOMER_ID,
			PRODUCT_NAME
		ORDER BY CUSTOMER_ID)
			
SELECT customer_id, product_name as "favorite products"
FROM COUNTED
WHERE rnk = 1;

--Which item was purchased first by the customer after they became a member?

WITH AFTER_MEMBER AS
	(SELECT CUSTOMER_ID,
			PRODUCT_NAME,
			ORDER_DATE,
			JOIN_DATE,
			ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS ROW_NUM
		FROM SALES
		JOIN MEMBERS USING(CUSTOMER_ID)
		JOIN MENU USING(PRODUCT_ID)
		WHERE ORDER_DATE > JOIN_DATE )
		
SELECT *
FROM AFTER_MEMBER
WHERE ROW_NUM = 1;

--Which item was purchased just before the customer became a member?

WITH BEFORE_MEMBER AS
	(SELECT CUSTOMER_ID,
			PRODUCT_NAME,
			ORDER_DATE,
			JOIN_DATE,
			ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE DESC) AS ROW_NUM
		FROM SALES
		JOIN MEMBERS USING(CUSTOMER_ID)
		JOIN MENU USING(PRODUCT_ID)
		WHERE ORDER_DATE <= JOIN_DATE ) --depending if we count the day of join or not 
		
SELECT *
FROM BEFORE_MEMBER WHERE ROW_NUM=1;

--What is the total items and amount spent for each member before they became a member?

select 
	customer_id, count(product_id), sum(price)
from sales 
	join menu using(product_id)
	join members using(customer_id)
where order_date < join_date
group by customer_id
order by customer_id;

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 1 = sushi, 2 = curry, 3 = ramen

with cte as(
select 
	customer_id,
	case 
		when product_id = 1 then sum(price)*20
		else sum(price) * 10
	end as points
from menu 
join sales using(product_id)
group by customer_id, product_id
	)
	
select customer_id, sum(points) 
from cte 
group by customer_id
order by customer_id;
	

--In the first week after a customer joins the program 
--(including their join date) they earn 2x points on all items, not just sushi 
-- how many points do customer A and B have at the end of January?


WITH dates_cte AS (
  SELECT 
    customer_id, 
    join_date, 
    join_date + 6 AS valid_date, 
    DATE_TRUNC(
      'month', '2021-01-31'::DATE)
      + interval '1 month' 
      - interval '1 day' AS last_date
  FROM members
)

SELECT 
  sales.customer_id, 
  SUM(CASE
    WHEN product_name = 'sushi' THEN 2 * 10 * price
    WHEN order_date BETWEEN join_date AND valid_date THEN 2 * 10 * price
    ELSE 10 * price END) AS points
FROM sales
JOIN dates_cte AS dates
  ON sales.customer_id = dates.customer_id
  AND sales.order_date <= dates.last_date
JOIN menu
  ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;
