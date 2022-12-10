-- A. ROll metrics
-- B. Driver and customer experience
-- C. Ingredient Optimisation
-- D. Pricings and Ratings

select * from Project4..customer_orders
select * from Project4..driver
select * from Project4..driver_order
select * from Project4..rolls_recipes
-- A. Roll Metrics
---------------------------------------------------------------------------------------------------------------------------------
-- 1. How many rolls were ordered?
select COUNT(roll_id) TotalRollorders from Project4..customer_orders

---------------------------------------------------------------------------------------------------------------------------------
--2. How many unique customer orders were made?
select COUNT(DISTINCT customer_id) CustomerOrders from Project4..customer_orders

----------------------------------------------------------------------------------------------------------------------------------
-- 3. How many successful orders were delivered by each driver?
select driver_id, COUNT(DISTINCT order_id) SuccessfulDeliveries from Project4..driver_order
where cancellation not in ('Cancellation', 'Customer Cancellation')
GROUP BY driver_id 

----------------------------------------------------------------------------------------------------------------------------------
-- 4. How many of each type of roll was delivered?
select order_id from
(select *, case when cancellation in ('Cancellation', 'Customer Cancellation') 
		  then 'Cancelled' else 'Not Canceled' end as Order_cancel_details
from Project4..driver_order)a
where Order_cancel_details = 'Not Canceled'   -- this will order Ids of successfuly delivered orders


select roll_id, count(roll_id) RollsCount from Project4..customer_orders where order_id IN
(select order_id from
(select *, case when cancellation in ('Cancellation', 'Customer Cancellation') 
		  then 'Cancelled' else 'Not Canceled' end as Order_cancel_details
from Project4..driver_order)a
where Order_cancel_details = 'Not Canceled') 
group by roll_id						-- this will give the number of successfully delivered rolls

--------------------------------------------------------------------------------------------------------------------------------------
-- 5. How many Veg and Non-Veg rolls were ordered by each customer?
select a.*, b.roll_name from
(select  customer_id, roll_id, count(roll_id) RollsCount
from Project4..customer_orders
group by customer_id, roll_id)a INNER JOIN Project4..rolls b ON a.roll_id = b.roll_id

--------------------------------------------------------------------------------------------------------------------------------------
-- 6. What was the maximum of no. of rolls delivered in a single order?
select order_id, count(roll_id)RollsOrdered from
(select * from Project4..customer_orders where order_id in(
select order_id from 
(select *, case when cancellation in ('Cancellation', 'Customer Cancellation') 
		  then 'Cancelled' else 'Not Canceled' end as Order_cancel_details
from Project4..driver_order)a
where Order_cancel_details = 'Not Canceled'))b
group  by  order_id									 -- this gives the total number of rolls delivered in an order

-- For finding the maximum no. of rolls in an order, we use Rank function
select * from
(select *, RANK() over(order by RollsOrdered desc) rnk from
(select order_id, count(roll_id)RollsOrdered from
(select * from Project4..customer_orders where order_id in(
select order_id from 
(select *, case when cancellation in ('Cancellation', 'Customer Cancellation') 
		  then 'Cancelled' else 'Not Canceled' end as Order_cancel_details
from Project4..driver_order)a
where Order_cancel_details = 'Not Canceled'))b
group  by  order_id)c)d where rnk=1                         -- this will give the max number of rolls ordered in a single order

------------------------------------------------------------------------------------------------------------------------------------------