<p align="center">
  <img src="https://weclouddata.s3.amazonaws.com/images/logos/wcd_logo_new_2.png" width="30%">
</p>

# SQL Exercises - Part 2: Solutions

## Retail Database Schema

<img src="https://www.mysqltutorial.org/wp-content/uploads/2023/10/mysql-sample-database.png">


## Section 1 - Case, Subqueries

<h3>
1. Create a column to identify if a productName contains the brand "Ford"
</h3>

**Expected Output:**

| productName                                 | isFord |
|---------------------------------------------|--------|
| 1969 Harley Davidson Ultimate Chopper       | no     |
| 1952 Alpine Renault 1300                    | no     |
| 1996 Moto Guzzi 1100i                       | no     |
| 2003 Harley-Davidson Eagle Drag Bike        | no     |
| 1972 Alfa Romeo GTA                         | no     |
| 1962 LanciaA Delta 16V                      | no     |
| 1968 Ford Mustang                           | yes    |
| 2001 Ferrari Enzo                           | no     |
| 1958 Setra Bus                              | no     |
| 2002 Suzuki XREO                            | no     |
| 1969 Corvair Monza                          | no     |
| 1968 Dodge Charger                          | no     |
| 1969 Ford Falcon                            | yes    |
|...

```sql
select
  productName,
  case
    when productName like '%Ford%'
      then 'yes'
    else 'no'
  end as isFord
from products;
```

---------- ---------- ---------- ---------- ----------
<h3>
2. Categorize the quantityInStock column of the products table into:
'High Quantity', 'Medium Quantity', or 'Low Quantity' based on whether the
quantityInStock is greater than 2000, between 500-2000, or less than 500
respectively.
</h3>

**Expected Output:**

| quantityInStock | quantityCategory |
|-----------------|------------------|
|            7933 | High Quantity    |
|            7305 | High Quantity    |
|            6625 | High Quantity    |
|            5582 | High Quantity    |
|            3252 | High Quantity    |
|            6791 | High Quantity    |
|              68 | Low Quantity     |
|            3619 | High Quantity    |
|            1579 | Medium Quantity  |
|            9997 | High Quantity    |
|...

```sql
select
  quantityInStock,
  case
    when quantityInStock <= 500
      then 'Low Quantity'
    when quantityInStock between 501 and 2000
      then 'Medium Quantity'
    else
      'High Quantity'
  end as quantityCategory
from products;
```

---------- ---------- ---------- ---------- ----------
<h3>
3. Create a pivot table from the products with each row as productScale,
each column as productLine and the values showing the total quantityInStock.
</h3>

**Expected Output:**

| productScale | classicCars | motorcycles | planes | ships | trains |
|--------------|-------------|-------------|--------|-------|--------|
| 1:10         |       17348 |       20140 |      0 |     0 |      0 |
| 1:12         |       26845 |        9997 |      0 |     0 |      0 |
| 1:18         |      118929 |       12046 |   5330 |  4259 |   6450 |
| 1:72         |           0 |           0 |   6400 |   414 |      0 |
| 1:24         |       56061 |       13858 |  19137 |  1898 |      0 |
| 1:32         |           0 |       12760 |      0 |     0 |   8601 |
| 1:50         |           0 |         600 |      0 |     0 |   1645 |
| 1:700        |           0 |           0 |  31420 | 20262 |      0 |

```sql
select
  productScale,
  sum(case when productLine = 'Classic Cars' then quantityInStock else 0 end) as classicCars,
  sum(case when productLine = 'Motorcycles' then quantityInStock else 0 end) as motorcycles,
  sum(case when productLine = 'Planes' then quantityInStock else 0 end) as planes,
  sum(case when productLine = 'Ships' then quantityInStock else 0 end) as ships,
  sum(case when productLine = 'Trains' then quantityInStock else 0 end) as trains
from products
group by productScale;
```

---------- ---------- ---------- ---------- ----------
<h3>
4. Get the customerNames for customers that have made a SINGLE payment greater
than 100000.
</h3>

**Expected Output:**

| customerName                 |
|------------------------------|
| Dragon Souveniers, Ltd.      |

```sql
select
  customerName
from customers
where customerNumber in (
  select customerNumber
  from payments
  where amount > 100000
  group by customerNumber
  having count(checkNumber) = 1
);
```

---------- ---------- ---------- ---------- ----------
<h3>
5. Get the customerNames for customers that have made TOTAL payments greater
than 100000.
</h3>

**Expected Output:**

| customerName                 |
|------------------------------|
| Australian Collectors, Co.   |
| La Rochelle Gifts            |
| Baane Mini Imports           |
| Mini Gifts Distributors Ltd. |
| Land of Toys Inc.            |
| Euro+ Shopping Channel       |
| Danish Wholesale Imports     |
| Saveley & Henriot, Co.       |
| Dragon Souveniers, Ltd.      |
| Muscle Machine Inc           |
| Technics Stores Inc.         |
| Handji Gifts& Co             |
| AV Stores, Co.               |
| Anna's Decorations, Ltd      |
| Rovelli Gifts                |
| Vida Sport, Ltd              |
| Mini Creations Ltd.          |
| Corporate Gift Ideas Co.     |
| Down Under Souveniers, Inc   |
| Suominen Souveniers          |
| Reims Collectables           |
| Online Diecast Creations Co. |
| Tokyo Collectables, Ltd      |
| Corrida Auto Replicas, Ltd   |
| Kelly's Gift Shop            |


```sql
select
  customerName
from customers
where customerNumber in (
  select
    customerNumber
  from payments
  group by customerNumber
  having sum(amount) > 100000
);
```

---------- ---------- ---------- ---------- ----------
<h3>
6. What is the average number of customers that each salesRepEmployee has?
(Hint: Use salesRepEmployeeNumber and do not count the NULLs)
</h3>

**Expected Output:**

| avgSalesRepCustomerCount |
|--------------------------|
|                   6.6667 |


```sql
select
  avg(salesRepCustomerCount) as avgSalesRepCustomerCount
from (
  select
    salesRepEmployeeNumber,
    count(*) as salesRepCustomerCount
  from customers
  where salesRepEmployeeNumber is not null
  group by salesRepEmployeeNumber
) as s;
```

## Section 2 - Joins

<h3>
1. Which city does each employee work in?
</h3>

**Expected Output:**

| officeCode | firstName | city          |
|------------|-----------|---------------|
| 1          | Diane     | San Francisco |
| 1          | Mary      | San Francisco |
| 1          | Jeff      | San Francisco |
| 6          | William   | Sydney        |
| 4          | Gerard    | Paris         |
|...


```sql
select
  employees.officeCode,
  firstName,
  city
from employees
inner join offices
on employees.officeCode = offices.officeCode;
```

---------- ---------- ---------- ---------- ----------
<h3>
2. Create the following table using multiple inner joins
</h3>

**Expected Output:**

| orderNumber | orderDate  | customerName                 | orderLineNumber | productName                         | quantityOrdered | priceEach |
|-------------|------------|------------------------------|-----------------|-------------------------------------|-----------------|-----------|
|       10100 | 2003-01-06 | Online Diecast Creations Co. |               3 | 1917 Grand Touring Sedan            |              30 |    136.00 |
|       10100 | 2003-01-06 | Online Diecast Creations Co. |               2 | 1911 Ford Town Car                  |              50 |     55.09 |
|       10100 | 2003-01-06 | Online Diecast Creations Co. |               4 | 1932 Alfa Romeo 8C2300 Spider Sport |              22 |     75.46 |
|...


```sql
select
  orderNumber,
  orderDate,
  customerName,
  orderLineNumber,
  productName,
  quantityOrdered,
  priceEach
from
  orders
inner join orderdetails
  using (orderNumber)
inner join products
  using (productCode)
inner join customers
  using (customerNumber);
```

---------- ---------- ---------- ---------- ----------
<h3>
3. Which customers have never made an order?
</h3>

**Expected Output:**

| customerNumber | customerName                   | orderNumber |
|----------------|--------------------------------|-------------|
|            125 | Havel & Zbyszek Co             |        NULL |
|            168 | American Souvenirs Inc         |        NULL |
|            169 | Porto Imports Co.              |        NULL |
|...

```sql
select
  customers.customerNumber,
  customerName,
  orderNumber
from customers
left join orders
  on customers.customerNumber = orders.customerNumber
where orderNumber is null;
```

---------- ---------- ---------- ---------- ----------
<h3>
4. Get the 5 largest orders by totalSales that have been shipped.
Where totalSales can be calculated from quantityOrdered and priceEach
</h3>

**Expected Output:**

| orderNumber | status  | totalSales |
|-------------|---------|------------|
|       10165 | Shipped |   67392.85 |
|       10287 | Shipped |   61402.00 |
|       10310 | Shipped |   61234.67 |
|       10212 | Shipped |   59830.55 |
|       10207 | Shipped |   59265.14 |
|...


```sql
select
  orders.orderNumber,
  orders.status,
  sum(quantityOrdered * priceEach) as totalSales
from
  orders
inner join orderdetails
  on orders.orderNumber = orderdetails.orderNumber
where status = 'Shipped'
group by orderNumber
order by totalSales desc
limit 5;
```

---------- ---------- ---------- ---------- ----------
<h3>
5. Create a summary table to show each employees firstName, the customerName
they represent, and the payment amount that customer has made. The table
should have NULL values if an employee does not have a customer and
if the customer has not made a payment.
</h3>

**Expected Output:**

| firstName | customerName                       | amount    |
|-----------|------------------------------------|-----------|
| Diane     | NULL                               |      NULL |
| Mary      | NULL                               |      NULL |
| Jeff      | NULL                               |      NULL |
| William   | NULL                               |      NULL |
| Gerard    | NULL                               |      NULL |
| Anthony   | NULL                               |      NULL |
| Leslie    | Mini Gifts Distributors Ltd.       | 101244.59 |
| Leslie    | Mini Gifts Distributors Ltd.       |  85410.87 |
| Leslie    | Mini Gifts Distributors Ltd.       |  11044.30 |
|...
| Foon Yue  | American Souvenirs Inc             |      NULL |
|...

```sql
select
  firstName,
  customerName,
  amount
from
  employees
left join customers on
  employees.employeeNumber = customers.salesRepEmployeeNumber
left join payments on
  payments.customerNumber = customers.customerNumber;
```