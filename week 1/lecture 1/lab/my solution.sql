SET GLOBAL local_infile = 'ON';
/** 
	Using SQL, do the following:
		Show all databases
		Switch to the classicmodels database
		How many tables are there?
		For each table, how many rows and columns are there?
		For the columns in the tables, what are the data types?
		Take a look at the first 5 rows of each table
		Compare the table details to the ER-Diagram
		Try and understand the relationship between the tables
**/

-- Show all databases
show databases;

-- Switch to the classicmodels database
use classicmodels;

-- How many tables are there?
show tables;

-- For each table, how many rows and columns are there?
-- For the columns in the tables, what are the data types?
describe customers;

select count(*) from customers;

-- Take a look at the first 5 rows of each table
select * from customers limit 5;

describe orders;

select count(*) from orders;

select * from orders limit 5;

describe employees;

select count(*) from employees;

select * from employees limit 5;

show tables;

describe offices;

select count(*) from offices;

select * from offices limit 5;

show tables;

-- orderdetails
describe orderdetails;
select count(*) from orderdetails;
select * from orderdetails limit 5;

-- payments
describe payments;
select count(*) from payments;
select * form payments limit 5;

-- productlines
describe productlines;
select count(*) from productlines;
select * from productlines limit 5;

-- products
describe products;
select count(*) from products;
select * from products limit 5;



/**
	1. Show the `customerNumber`, `customerName`, and `city` of all customers
**/

select customerNumber, customerName, city from customers;


/**
	Show the `customerNumber`, `customerName`, and `city` 
    of customers from Boston
**/

select customerNumber, customerName, city 
from customers 
where city = 'Boston';

/**
	3. Show the `customerName` and `creditLimit` 
    of customers with a credit limit greater than 200,000
**/

select customerName, creditLimit 
from customers
where creditLimit > 200000;


/**
	4. Which products are 
    Ships and have an MSRP greater than 50 and less than 100?
**/

select * from products;

select productName, productLine, MSRP
from products
where productLine = 'Ships' 
and MSRP between 50 and  100;

/** 
	Based on the `productName`, which products are `Ford` models?
**/

select
  productName
from products
where productName like '%Ford%';

/**
	6. Sort the orderdetails table by lowest quantityOrdered 
    and highest priceEach
**/

select * from orderdetails
order by quantityOrdered asc, priceEach desc;


/**
	7. Which 3 products have the largest profit? 
    Hint: You'll have to calculate profit and create the column
**/


select productName, MSRP - buyPrice as profit
from products
order by profit desc
limit 3;

/**
	How many unique countries are the customers from?
**/

select count(distinct country) as uniqueCountries from customers;

/**
	How many customers are from North America? ('USA', 'Canada', 'Mexico')
**/

select count(*) from customers 
where country in ('USA', 'Canada', 'Mexico');

/**
	10. In the customers table, 
    how many NULL values are in the salesRepEmployeeNumber column?
**/

select count(*) from customers where salesRepEmployeeNumber is null;

/**
	11. Are there any orders that were shipped late? 
    What was the reason?
**/

select * from orders;

select orderNumber, comments from orders
where shippedDate > requiredDate;