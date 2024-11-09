#Q1: Find top 10 highest reveue generating products 
select product_id, round(sum((sale_price + discount) * quantity),2) total_sales
from orders
group by 1
order by 2 desc
limit 10;

#Q2: Find top 5 highest selling products in each region
with cte as(
select region, product_id, round(sum(sale_price),2) sales,
rank() over(partition by region order by round(sum(sale_price),2) desc) as rnk
from orders
group by 1,2) 
select region, product_id, sales
from cte
where rnk <= 5;

#Q3: Find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as(
select year(order_date) order_year, month(order_date) order_month, round(sum(sale_price),2) sales
from orders
group by 1,2
order by 3 desc)
select order_month,
sum(case when order_year = 2022 then sales else 0 end) as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by 1
order by 1;

#Q4: For each category which month had highest sales 
with cte as
(select category, DATE_FORMAT(order_date, '%Y%m') order_year_month, round(sum(sale_price),2) sales,
row_number() over(partition by category order by round(sum(sale_price),2) desc) as rnk
from orders
group by 1,2)
select category, order_year_month, sales
from cte
where rnk = 1
order by 3 desc;

#Q5: Which 3 subcategory had highest growth by profit in 2023 compare to 2022
with cte as(
select sub_category, year(order_date) order_year, round(sum(sale_price),2) sales
from orders
group by 1,2),
cte2 as(
select sub_category,
sum(case when order_year = 2022 then sales else 0 end) as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by 1
order by 1)
select sub_category, round(((sales_2023 - sales_2022)/sales_2022) * 100,1) as ratio
from cte2
order by 2 desc
limit 3;







