with t1 as (SELECT date_format(convert(rental_date,date), '%m-%Y') as Month
, date_format(convert(rental_date,date), '%Y') as Year
, count(distinct customer_id) as active_customers
from sakila.rental
group by 1,2)

, active_users as (select *
, LAG(active_customers) OVER (order by year) as previous_month
from t1
order by year asc)

select *
, active_customers - previous_month as retained_customers
, round(100*(active_customers - previous_month)/previous_month,2) as percentage_change
from active_users