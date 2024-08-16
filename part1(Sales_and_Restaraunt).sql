
create database projectsql1;
use projectsql1;
select*from orders_dimen;
select*from cust_dimen;
-- Question 1: Find the top 3 customers who have the maximum number of orders

select*from(
select * ,dense_rank()over(order by cnt desc) rnk from
(select cd.customer_name,cd.cust_id,count(od.order_id) cnt
from cust_dimen cd join market_fact mf using(cust_id)
join orders_dimen od using(ord_id)
group by customer_name,cust_id)t)t2
where rnk in (1,2,3);

-- Question 2: Create a new column DaysTakenForDelivery that contains the date difference between Order_Date and Ship_Date.

select *,datediff(str_to_date(sd.Ship_date,'%d-%m-%Y'),str_to_date(od.Order_Date,'%d-%m-%Y'))
as DaysTakenforDelivery from
orders_dimen od join market_fact mf using(ord_id) join shipping_dimen sd using(Ship_id);

-- Question 3: Find the customer whose order took the maximum time to get delivered.
select* from(
select *,dense_rank()over(order by DaysTakenforDelivery desc) rnk from
(
select mf.cust_id,datediff(str_to_date(sd.Ship_date,'%d-%m-%Y'),str_to_date(od.Order_Date,'%d-%m-%Y'))
as DaysTakenforDelivery from
orders_dimen od join market_fact mf using(ord_id) join shipping_dimen sd using(Ship_id))t)t2
where rnk=1;

-- Question 4: Retrieve total sales made by each product from the data (use Windows function)
select*from market_fact;
select distinct Prod_id,round((sum(Sales)over(partition by prod_id)),2) as Total_sales from market_fact;

-- Question 5: Retrieve the total profit made from each product from the data (use windows function)
select* from(
select distinct prod_id,round((sum(profit)over(partition by prod_id)),2) as Total_profit from market_fact)t
where Total_profit>0;

-- Question 6: Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
#count of customers in january
select*from(
select  count(distinct mf.cust_id) cust_cnt,
str_to_date(order_date,"%d-%m-%Y") as orderdate from market_fact mf join orders_dimen od using(Ord_id)
group by orderdate)t
where year(orderdate)=2011 and  month(orderdate)=01 ;

#count of customers who came back every month over the entire year in 2011
select count(customer_id) from(
select mf.cust_id as customer_id  from market_fact mf join orders_dimen od using(Ord_id)
where year(str_to_date(order_date,"%d-%m-%Y"))=2011
group by customer_id
having count(distinct month(str_to_date(order_date,"%d-%m-%Y"))=12))t;


#Extra Questions
#1 What is the overall profit trend over the last decade?
select year(str_to_date(od.order_date,"%d-%m-%Y")) as Order_Year , round(sum(Profit),2) as total_profit
from orders_dimen od join market_fact mf using(ord_id) 
group by Order_Year
order by Order_Year; 

#2 How does the order quantity vary with different shipping modes?

select sd.Ship_Mode, sum(mf.Order_Quantity) AS Avg_Order_Quantity
from market_fact mf join orders_dimen od using(Ord_ID)
join Shipping_Dimen sd using(Order_ID)
GROUP BY Ship_Mode;

# Which 3 product sub-category has the highest average shipping cost?
select Product_Sub_category, round(avg(Shipping_Cost),2) AS Avg_Shipping_Cost
from Market_Fact mf
join Prod_Dimen pd using(prod_id)
group by Product_Sub_category
order by  Avg_Shipping_Cost desc limit 3;







