show databases;

use classicmodels;

show tables;

describe customers;

-- 1. What is the average price of all products (Rounded to two decimal places)?

select round(avg(buyPrice), 2) as avgPrice from products;

-- 2. How many years does the `orders` table span?
select * from orders;

select
  distinct year(orderDate) as years
from orders;

-- 3. Create a new column to show whether a customerNumber is an even/odd number

select * from customers;

select customerNumber,
	case
		when customerNumber % 2 then 1
        else 0
	end customerNumber
from customers;

select
  customerNumber,
  customerNumber % 2 as evenOddCustomerNumber
from customers;

-- 4. Show a table with `Classic Cars` that are ordered from newest to oldest by year
select * from products;

select productLine, cast(substr(productName, 1, 4) as unsigned) as productYear 
from products
where productLine = 'Classic Cars'
order by productYear desc;


-- 5. What is the newest `OrderDate`? What is the oldest `OrderDate`? How many days are there between the newest and oldest dates?
select  max(OrderDate) as newest,
		min(OrderDate) as oldest,
        datediff(max(OrderDate), min(OrderDate)) as diff
from orders;

-- 6. Imagine it takes 5 days to process a payment, using paymentDate, create a new column called paymentProcessedDate that is 5 days later
select paymentDate, date_add(paymentDate, interval 5 day) as paymentProcessedDate from payments;

-- 1. How many customers are there from each country?
select * from customers;

select country, 
	count(*) 
from customers
group by country;

-- What are the top 5 customers by total payment amount?
select * from payments;

select customerNumber, sum(amount) as most
from payments
group by customerNumber
order by most desc
limit 5;


-- 3. Which month overall has the most orders?
select month(orderDate) as orderMonth, count(*) as orderTotal
from orders
group by orderMonth
order by orderTotal
limit 5;

-- 4. Which month of which year has the most orders?
select year(orderDate) as orderYear, month(orderDate) as orderMonth, count(*) as orderTotal
from orders
group by orderYear, orderMonth
order by orderTotal
limit 5;

-- 5. Which employees have more than 5 people working under them?

select * from employees;

select reportsTo, count(*) as subordinateCount 
from employees
group by reportsTo
having subordinateCount > 5;
