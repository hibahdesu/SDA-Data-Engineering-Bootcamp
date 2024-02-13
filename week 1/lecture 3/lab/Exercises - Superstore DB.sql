# Lab Exercises - Superstore DB


## 1. The owner of superstore company X wants to know how many customers brought in more than 3000$ in sales on their first purchase.

- Note** - some customers may have purchased more than one type of product in a single order and may appear as multiple entries in the table. (count together as a single purchase/single sale)


select count(*)
from(
    select *,
           -- Creating a ranking to number the orders one customer has made
           row_number() over (partition by CustomerID order by OrderDate) as ranking
    from (
        -- Creating a table to find the total of each separate orders
        select customerid,
               orderid,
               orderdate,
               sum(sales) as amount
        from orders
        group by orderid, customerid,orderdate) as sub
    ) as sub2
-- Filter to keep only the first order of each customer and if the amount is
-- more than 3000
where ranking = 1 and amount > 3000;


## 2. Return the top 3 most ordered `ProductSubCategory` within each `Product Category`
- ProductSubCategory with the largest total OrderQuantity


select *
from(
    select *,
           -- Creating a ranking of the Product Sub Category for each Product Category
           row_number() over (partition by ProductCategory order by total_orders desc) as ranking
    from(
        -- Creating a table to count the orderquantities for each subcategory
        select ProductCategory,
                ProductSubCategory,
                sum(OrderQuantity) as total_orders
        from orders
            left join products on orders.ProductID = products.ProductID
        group by ProductSubCategory, ProductCategory) as sub
    ) as sub2
-- Selecting only the subcategories that have a ranking of 3 or less
where ranking <= 3;


## 3. How many customers had a time gap of less than 30 days between their first and second order?
- Hint: Use the DATEDIFF function to find the difference in days between two dates



select count(*)
from (
    select *,
           -- Calculate the difference between the current order and the previous order date
           datediff(OrderDate, previous) as daysBetween
    from (

        select *,
               -- Creating a column for the previous purchases of each customer
               lag(OrderDate,1) over (partition by CustomerID) as previous
        from(
            select *,
                -- Creating an order for each customer's purchases
                row_number() over (partition by CustomerID order by OrderDate) as ranking
            from(
                -- Creating a table to find the total of each separate orders
                select CustomerID,
                        OrderID,
                       OrderDate,
                       sum(sales) as total
                from orders
                where CustomerID in (
                    select CustomerID
                    from (
                        -- Creating a table to find the total of each separate orders
                        select CustomerID,
                                 OrderID,
                                 OrderDate,
                                 sum(sales) as total
                        from orders
                        group by CustomerID, OrderID, OrderDate) as t
                    group by CustomerID
                    -- Selecting customerID that have more than 1 orders
                    having count(*) > 1)
                group by CustomerID, OrderID, OrderDate) as u) as v) as w
    -- ranking of 2 means the second purchase of each customer
    where ranking = 2
    -- filter out results of daysBetween first and second purchases that is more
    -- than 30 days
    having daysBetween < 30) as x;


# 4. Superstore company X wants to know after how many purchases does it most commonly take for a customer to reach over a $5000 life time value.
- How many purchases does it take to reach 5000$ in sales from a customer


SELECT w.order_number, count(*)
FROM (SELECT *, row_number() OVER (PARTITION BY CustomerID ORDER BY OrderDate ASC) order_counts
      FROM (SELECT *, row_number() OVER (PARTITION BY CustomerID ORDER BY OrderDate ASC) order_number
            FROM (SELECT *,
                         sum(Sales)
                             OVER (PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_sales
                  FROM (SELECT CustomerId, OrderDate, OrderID, sum(Sales) Sales
                        FROM orders
                        GROUP BY CustomerId, OrderDate, OrderID) AS t) AS u) AS v
      WHERE v.running_sales > 5000) w
WHERE w.order_counts = 1
GROUP BY 1
;


select num_of_orders,
       count(*) as cnt
from (
    select *,
           -- Creating a 'helper' column to get the first occurrence when the customer
           -- spend 5000 or more
           row_number() over (partition by CustomerID order by OrderDate) as ranking
    from(
        select *,
               -- Counting how many orders the customer has made
               row_number() over (partition by CustomerID order by orderdate) as num_of_orders
        from (
            select *,
                   -- Find the running total of each customer
                   sum(total) over(partition by CustomerID order by OrderDate) as running_total
            from (
                -- Find total of each orders
                select CustomerID,
                       OrderID,
                       OrderDate,
                       sum(sales) as total
                from orders
                group by CustomerID, OrderID, OrderDate) as t
            ) as u
        ) as v
    -- Filter out the rows that have less than 5000 running total
    having running_total >= 5000) as x
-- Picking the first occurrence of when customer spent 5000 or more
where ranking = 1
group by num_of_orders
order by num_of_orders;



# Lab Exercises - Classicmodels DB


use classicmodels;


## 1. How many orders contain more than a 50% revenue contribution made by Vintage Cars or Classic cars (productLine column)
- revenue = quantityOrdered * priceEach
- Calculate the total revenue generated by each order, and the percentage contribution by each product towards the order


select productLine,
       count(*)
from (
    select *,
           productLine_revenue/order_total as percent
    from(
        select orderNumber,
               productLine,
               sum(revenue) as productLine_revenue, order_total
        from (
            select *,
                   sum(revenue) over (partition by orderNumber) as order_total
            from (
                select productCode,
                       productLine,
                       orderNumber,
                       quantityOrdered * priceEach as revenue
                from orderdetails
                    left join products
                        using (productCode)) as t
            ) as u
        group by productline, ordernumber) as v
    where productLine in ('Classic Cars', 'Vintage Cars')
    having percent > .5) as x
group by productLine;



## 2. Calculate the year over year growth generated by Company X 
- Calculate the yearly revenue (2003,2004,2005) generated from all the orders
- revenue = quantityOrdered * priceEach
- Year over year growth formula = (Current year revenue - Previous year revenue / Previous year revenue) * 100


select yr,
       -- Calculating the year over year growth
       (revenue - previous_revenue)/previous_revenue * 100 as yr_over_yr
from (
    select *,
           -- Create a column for the previous year's revenue
           lag(revenue) over() as previous_revenue
    from (
        select year(orderDate) as yr,
               -- Find yearly revenue
               sum(quantityOrdered * priceEach) as revenue
        from orders
            left join orderdetails
                using(orderNumber)
        group by yr) as t
    ) as u;
