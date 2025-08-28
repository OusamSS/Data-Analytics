set search_path = pizza_runner;

--A. Pizza Metrics


--How many pizzas were ordered?

select count(pizza_id) 
from customer_orders;

--How many unique customer orders were made?

select count(distinct order_id) from customer_orders;

--How many successful orders were delivered by each runner?

select count(order_id)
from runner_orders
where duration <> 'null';

--How many of each type of pizza was delivered?

select pizza_id, count(1) 
from runner_orders join customer_orders using(order_id)
where duration is not null
group by pizza_id
order by pizza_id;

--How many Vegetarian and Meatlovers were ordered by each customer?

select 
	customer_id,
	pizza_name,
	count(pizza_id)
from pizza_names 
join customer_orders using(pizza_id)
group by customer_id, pizza_name
order by customer_id;

--What was the maximum number of pizzas delivered in a single order?

select count(pizza_id), order_id
from customer_orders
group by order_id
order by count desc
limit 1;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select 
	customer_id,
	sum(case when exclusions is null or extras is null then 1 else 0 end) as no_change,
	sum(case when exclusions is not null or extras is not null then 1 else 0 end) as change
from customer_orders join runner_orders using(order_id) 
where cancellation = 'null'
group by customer_id;


--How many pizzas were delivered that had both exclusions and extras?

select 
	customer_id,
	sum(case when exclusions is not null and extras is not null then 1 else 0 end) as bth
from customer_orders join runner_orders using(order_id)
where cancellation= 'null'
group by customer_id;

--What was the total volume of pizzas ordered for each hour of the day?

select count(1), extract('hour' from order_time) as h
from customer_orders
group by h
order by h;

--What was the volume of orders for each day of the week?

select count(1), date_trunc('day',order_time) as d
from customer_orders
group by d
order by d;

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select 
	count(runner_id),
	date_trunc('week',registration_date) as week	
from runners
group by week;

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select
	round(avg(extract('minutes' from pickup_time)),2) as minutes
from runner_orders
where pickup_time is not null;

--Is there any relationship between the number of pizzas and how long the order takes to prepare?

select
	order_id,
	count(1),
	pickup_time - order_time as diff
from customer_orders join runner_orders using(order_id)
where pickup_time is not null
group by order_id, diff
order by diff desc;

--What was the average distance travelled for each customer?

select 
	customer_id,
	floor(avg(distance)) as d
from customer_orders join runner_orders using(order_id)
group by customer_id
order by d;

--What was the difference between the longest and shortest delivery times for all orders?

select 
	max(duration) - min(duration) as diff
from runner_orders;

--What was the average speed for each runner for each delivery and do you notice any trend for these values?

select 
	runner_id,
	order_id,
	floor(avg(duration)) 
from runner_orders
where pickup_time is not null
group by runner_id, order_id
order by floor;


SELECT 
  r.runner_id, 
  c.customer_id, 
  c.order_id, 
  COUNT(c.order_id) AS pizza_count, 
  r.distance, 
  (r.duration / 60) AS duration_hr , 
  ROUND((r.distance / r.duration * 60)::numeric, 2) AS avg_speed
FROM runner_orders AS r
JOIN customer_orders AS c
  ON r.order_id = c.order_id
WHERE distance != 0
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY c.order_id;



--What is the successful delivery percentage for each runner?

SELECT 
  runner_id, 
  ROUND(100 * SUM(
    CASE WHEN distance = 0 THEN 0
    ELSE 1 END) / COUNT(*), 0) AS success_perc
FROM runner_orders
GROUP BY runner_id;
