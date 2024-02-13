-- 1. Create a column to identify if a productName contains the brand "Ford"
select * from products;
select productName, 
	case
		when productName like '%Ford%'
        then 'yes'
        else 'no'
	end as isFord
from products;



/** 2. Categorize the quantityInStock column of the products table into: 
'High Quantity', 'Medium Quantity', or 'Low Quantity' based on 
whether the quantityInStock is greater than 2000, between 500-2000,
or less than 500 respectively.
**/
select * from products;
select quantityInStock,
case
	when quantityInStock > 2000
		then 'High Quantity'
	when quantityInStock between 500 and 2000
		then 'Medium Quantity'
	when quantityInStock < 500
		then 'Low Quantity'
	end as quantityCategory
from products;

/** 
3. Create a pivot table from the products with each row as productScale, 
each column as productLine and the values showing the total quantityInStock.
**/
select * from products;
select productScale,
	sum(case when productLine = 'Classic Cars' then quantityInStock else 'no' end) as classicCars,
	sum(case when productLine = 'Motercycles' then quantityInStock else 'no' end) as motorcycles,
    sum(case when productLine = 'Planes' then quantityInStock else 'no' end) as planes,
    sum(case when productLine = 'Ships' then quantityInStock else 0 end) as ships,
	sum(case when productLine = 'Trains' then quantityInStock else 0 end) as trains
from products
group by productScale;
  
  
-- 4. Get the customerNames for customers that have made a SINGLE payment greater than 100000.
select * from customers;

select customerNames,
	
from customers