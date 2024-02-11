
# SQL Exercises - 1: Solutions

## Retail Database Setup

To setup the database follow the instructions [HERE:](https://www.mysqltutorial.org/wp-content/uploads/2023/10/mysql-sample-database.png)

## Retail Database Schema

## Section 1 - Explore database
1. Setup the database according to the instructions
2. Skim the first few lines of the `mysqlsampledatabase.sql` file and get a
feel for how it works
3. Using SQL, do the following:
  - Show all databases
  - Switch to the `classicmodels` database
  - How many tables are there?
  - For each table, how many rows and columns are there?
  - For the columns in the tables, what are the data types?
  - Take a look at the first 5 rows of each table
  - Compare the table details to the ER-Diagram
  - Try and understand the relationship between the tables

```sql
show databases;

use classicmodels;

show tables;

describe customers;

select * from customers limit 5;
```

-------------------------------------------------------------------------------
## Section 2 - Basic queries

<h3>
1. Show the `customerNumber`, `customerName`, and `city` of all customers
</h3>

**Expected Output:**

| customerNumber | customerName         | city |
|----------------|----------------------|------|
|            131 | Land of Toys Inc.    | NYC  |
|            151 | Muscle Machine Inc   | NYC  |
|            181 | Vitachrome Inc.      | NYC  |
|...

```sql
select
  customerNumber,
  customerName,
  city
from customers;
```

---------- ---------- ---------- ---------- ----------
<h3>
2. Show the `customerNumber`, `customerName`, and `city` of customers
from Boston
</h3>

**Expected Output:**

| customerNumber | customerName         | city   |
|----------------|----------------------|--------|
|            362 | Gifts4AllAges.com    | Boston |
|            495 | Diecast Collectables | Boston |

```sql
select
  customerNumber,
  customerName,
  city
from customers
where city = 'Boston';
```

---------- ---------- ---------- ---------- ----------
<h3>
3. Show the `customerName` and `creditLimit` of customers with a credit limit
greater than 200,000
</h3>

**Expected Output:**

| customerName                 | creditLimit |
|------------------------------|-------------|
| Mini Gifts Distributors Ltd. |   210500.00 |
| Euro+ Shopping Channel       |   227600.00 |

```sql
select
  customerName,
  creditLimit
from customers
where creditLimit > 200000;
```

---------- ---------- ---------- ---------- ----------
<h3>
4. Which products are Ships and have an MSRP greater than 50 and less than 100?
</h3>

**Expected Output:**

| productName               | productLine | MSRP  |
|---------------------------|-------------|-------|
| 1999 Yamaha Speed Boat    | Ships       | 86.02 |
| The Schooner Bluenose     | Ships       | 66.67 |
| The Mayflower             | Ships       | 86.61 |
|...

```sql
select
  productName,
  productLine,
  MSRP
from products
where productLine = 'Ships'
  and MSRP between 50 and 100;
```

---------- ---------- ---------- ---------- ----------
<h3>
5. Based on the `productName`, which products are `Ford` models?
</h3>

**Expected Output:**

| productName                      |
|----------------------------------|
| 1968 Ford Mustang                |
| 1969 Ford Falcon                 |
| 1940 Ford Pickup Truck           |

```sql
select
  productName
from products
where productName like '%Ford%';
```

---------- ---------- ---------- ---------- ----------
<h3>
6. Sort the orderdetails table by lowest quantityOrdered and highest priceEach
</h3>

**Expected Output:**

| orderNumber | productCode | quantityOrdered | priceEach | orderLineNumber |
|-------------|-------------|-----------------|-----------|-----------------|
|       10409 | S18_2325    |               6 |    104.25 |               2 |
|       10407 | S18_4409    |               6 |     91.11 |               3 |
|       10419 | S12_3380    |              10 |    111.57 |              11 |
|       10423 | S18_2949    |              10 |     89.15 |               1 |
|       10418 | S24_4620    |              10 |     66.29 |               3 |
|...

```sql

select *
from orderdetails
order by quantityOrdered asc, priceEach desc;
```

---------- ---------- ---------- ---------- ----------
<h3>
7. Which 3 products have the largest profit?
Hint: You'll have to calculate profit and create the column
</h3>

**Expected Output:**

| productName                          | profit |
|--------------------------------------|--------------|
| 1952 Alpine Renault 1300             |       115.72 |
| 2001 Ferrari Enzo                    |       112.21 |
| 2003 Harley-Davidson Eagle Drag Bike |       102.64 |

```sql
select
  productName,
  MSRP - buyPrice as profit
from products
order by profit desc
limit 3;
```

---------- ---------- ---------- ---------- ----------
<h3>
8. How many unique countries are the customers from?
</h3>

**Expected Output:**

| numCountries |
|--------------|
|           27 |

```sql
select
  count(distinct country) as numCountries
from customers;
```

---------- ---------- ---------- ---------- ----------
<h3>
9. How many customers are from North America? ('USA', 'Canada', 'Mexico')
</h3>

**Expected Output:**

| NAmericaCount |
|---------------|
|            39 |

```sql
select
  count(*) as NAmericaCount
from customers
where country in ('USA', 'Canada', 'Mexico')
;
```

---------- ---------- ---------- ---------- ----------
<h3>
10. In the customers table, how many NULL values are in the
salesRepEmployeeNumber column?
</h3>

**Expected Output:**

| count(*) |
|----------|
|       22 |

```sql
select
  count(*)
from customers
where salesRepEmployeeNumber is null;
```

---------- ---------- ---------- ---------- ----------
<h3>
11. Are there any orders that were shipped late? What was the reason?
</h3>

**Expected Output:**

| orderNumber | comments |
|-------------|----------|
|       10165 | ...      |

```sql
select
  orderNumber,
  comments
from orders
where shippedDate > requiredDate;
```

-------------------------------------------------------------------------------
## Section 3 - Functions

<h3>
1. What is the average price of all products (Rounded to two decimal places)?
</h3>

**Expected Output:**

| averagePrice |
|--------------|
|       100.44 |

```sql
select
  round(avg(MSRP), 2) as averagePrice
from products;
```

---------- ---------- ---------- ---------- ----------
<h3>
2. How many years does the `orders` table span?
</h3>

**Expected Output:**

| years |
|-------|
|  2003 |
|  2004 |
|  2005 |

```sql
select
  distinct year(orderDate) as years
from orders;
```

---------- ---------- ---------- ---------- ----------
<h3>
3. Create a new column to show whether a customerNumber is an even/odd number
</h3>

**Expected Output:**

| customerNumber | evenCustomerNumber |
|----------------|--------------------|
|            125 |                  1 |
|            169 |                  1 |
|            206 |                  0 |


```sql
select
  customerNumber,
  customerNumber % 2 as evenOddCustomerNumber
from customers;
```

---------- ---------- ---------- ---------- ----------
<h3>
4. Show a table with `Classic Cars` that are ordered from newest to oldest
by year
</h3>

**Expected Output:**

| productName                         | productYear |
|-------------------------------------|-------------|
| 2002 Chevy Corvette                 |        2002 |
| 2001 Ferrari Enzo                   |        2001 |
| 1999 Indy 500 Monte Carlo SS        |        1999 |
| 1998 Chrysler Plymouth Prowler      |        1998 |
| 1995 Honda Civic                    |        1995 |
|...

```sql
select
  productName,
  cast(substr(productName, 1, 4) as unsigned) as productYear
from products
where productLine = 'Classic Cars'
order by productYear desc;
```

---------- ---------- ---------- ---------- ----------
<h3>
5. What is the newest `OrderDate`?  What is the oldest `OrderDate`? How many
days are there between the newest and oldest dates?
</h3>

**Expected Output:**

| newestOrderDate | oldestOrderDate | totalDays |
|-----------------|-----------------|-----------|
| 2005-05-31      | 2003-01-06      |     20425 |

```sql
select
  max(orderDate) as newestOrderDate,
  min(orderDate) as oldestOrderDate,
  max(orderDate) - min(orderDate) as totalDays
from orders;
```

---------- ---------- ---------- ---------- ----------
<h3>
6. Imagine it takes 5 days to process a payment, using paymentDate, create a
new column called paymentProcessedDate that is 5 days later
</h3>

**Expected Output:**

| paymentDate | paymentProcessedDate |
|-------------|----------------------|
| 2004-10-19  | 2004-10-24           |
| 2003-06-05  | 2003-06-10           |
| 2004-12-18  | 2004-12-23           |

```sql
select
  paymentDate,
  date_add(paymentDate, interval 5 day) as paymentProcessedDate
from payments;
```

-------------------------------------------------------------------------------
## Section 4 - Groupby/Aggregations

<h3>
1. How many customers are there from each country?
</h3>

**Expected Output:**

| country      | count(*) |
|--------------|----------|
| France       |       12 |
| USA          |       36 |
| Australia    |        5 |
|...

```sql
select
  country,
  count(*)
from customers
group by country;
```

---------- ---------- ---------- ---------- ----------
<h3>
2. What are the top 5 customers by total payment amount?
</h3>

**Expected Output:**

| customerNumber | totalAmount |
|----------------|-------------|
|            141 |   715738.98 |
|            124 |   584188.24 |
|            114 |   180585.07 |
|            151 |   177913.95 |
|            148 |   156251.03 |

```sql
select
  customerNumber,
  sum(amount) as totalAmount
from payments
group by customerNumber
order by totalAmount desc
limit 5;
```

---------- ---------- ---------- ---------- ----------
<h3>
3. Which month overall has the most orders?
</h3>

**Expected Output:**

| orderMonth | totalOrders |
|------------|-------------|
|         11 |          63 |
|         10 |          31 |
|          4 |          29 |
|...

```sql
select
  month(orderDate) as orderMonth,
  count(*) as totalOrders
from orders
group by orderMonth
order by totalOrders desc;
```

---------- ---------- ---------- ---------- ----------
<h3>
4. Which month of which year has the most orders?
</h3>

**Expected Output:**

| orderYear | orderMonth | totalOrders |
|-----------|------------|-------------|
|      2004 |         11 |          33 |
|      2003 |         11 |          30 |
|      2003 |         10 |          18 |
|...

```sql
select
  year(orderDate) as orderYear,
  month(orderDate) as orderMonth,
  count(*) as totalOrders
from orders
group by orderYear, orderMonth
order by totalOrders desc;
```

---------- ---------- ---------- ---------- ----------
<h3>
5. Which employees have more than 5 people working under them?
</h3>

**Expected Output:**

| reportsTo | subordinateCount |
|-----------|------------------|
|      1102 |                6 |
|      1143 |                6 |


```sql
select
  reportsTo,
  count(*) as subordinateCount
from employees
group by reportsTo
having subordinateCount > 5
;
```