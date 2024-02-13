/******************************************************************************
*******************************************************************************

WeCloudData - Data Engineering Program

Lecture #4 - Subqueries, Joins

*******************************************************************************
******************************************************************************/

/********************************
  Create Database/Tables
********************************/

-- List databases
show databases;

-- Drop a database
drop database if exists company;

-- Create a database
create database company;

-- Select default database
use company;

-- Check selected database
select database();

-- Create employee table
drop table if exists employee;

create table employee(
    employee_id varchar(1), -- varchar means varying characters. The number is the longest string expected
    team varchar(10),
    salary int
);

-- Check table created
show tables;

-- Insert data to employee table
truncate employee;

insert into employee
values
  ('a', 'red', 80), -- row 1
  ('b', 'red', 75),  -- row 2
  ('c', 'red', 110),
  ('d', 'green', 80),
  ('e', 'green', 80),
  ('f', 'blue', 50),
  ('g', 'blue', 200);

-- Show employee table
select * from employee;

-- Create hobby table
drop table if exists hobby;

create table hobby (
  employee_id varchar(1),
  hobby varchar(20)
);

-- Insert data to hobby table
truncate hobby;

insert into hobby
values
  ('b', 'soccer'),
  ('e', 'cooking'),
  ('g', 'knitting'),
  ('h', 'music');

-- Create hire table
drop table if exists hire;

create table hire (
  employee_id varchar(1),
  hire_date int
);

-- Insert data to hire table
truncate hire;

insert into hire
values
  ('a', 2011),
  ('b', 2015),
  ('c', 2017),
  ('d', 2017),
  ('e', 2016),
  ('f', 2017);

-- Create review table
drop table if exists review;

create table review (
  name varchar(1),
  performance int
);

-- Insert data to review table
truncate review;

insert into review
values
  ('a', 10),
  ('b', 10),
  ('c', 9),
  ('d', 10),
  ('e', 5),
  ('f', 9);

-- Check database/tables
show tables;
select count(*) from employee;
select count(*) from hobby;
select count(*) from hire;
select count(*) from review;

/*********************************
  Subqueries
*********************************/
-- Use subquery as a table
-- What is the average number of employees for each team?
select * from employee;
-- (1) Get the number of employees for each team
select team,
       count(employee_id)
from employee
group by team;
-- (2) Average on this result
select avg(team_size)
from (
     select team,
       count(employee_id) as team_size
from employee
group by team
         ) as subquery;

-- Subquery can be used as a filter condition
-- Which employee(s) had the highest performance score?
select * from review;
select *
from review
where performance = 10;
-- (1) Find the highest (max) performance score
select max(performance) from review;
-- (2) Use this score as a filter
select *
from review
where performance = (select max(performance) from review);
-- These subqueries can only have ONE (1) column

-- Multiple nested subquery
-- What is the average salary of employees with the highest performance score?
-- Not using join
select * from review;
select * from employee;

select avg(salary)
from employee
where employee_id in (
select name
from review
where performance = (select max(performance) from review));


/****************************************
  Exercise
****************************************/
use superstore;

-- 1. What was the total Sales loss due to returned products?
-- (1) get the order id of all returned products
select OrderID
from returns
where status = 'Returned';
-- (2) Filter the Orders table using the result
select sum(sales)
from orders
where orderID in (select OrderID
from returns
where status = 'Returned'
);

-- 2. What is the highest single day total sales amount?
select * from orders order by orderdate;
-- (1) for the total of each orderdate
select orderdate,
       sum(sales) as singletotal
from orders
group by orderdate;
-- (2) find the maximum in this result
select max(singletotal)
from (
     select orderdate,
       sum(sales) as singletotal
from orders
group by orderdate
         ) as subquery;

-------------------------------------------------------------------------------
/*********************************
  Joins
*********************************/
-- What are joins and why do we need them?
-- Usually we combine the tables using a common field (column)

use company;

-- Inner join
select * from employee;
select * from hobby;

select *
from employee
inner join hobby
on employee.employee_id = hobby.employee_id;

select employee.employee_id,
       employee.team,
       hobby.hobby
from employee
inner join hobby
on employee.employee_id = hobby.employee_id;

-- Left join
select employee.employee_id,
       employee.team,
       hobby.hobby
from employee
left join hobby
on employee.employee_id = hobby.employee_id;

-- Right join
select hobby.employee_id,
       employee.team,
       hobby.hobby
from employee
right join hobby
on employee.employee_id = hobby.employee_id;

-- Union (Full outer join)
select hobby.employee_id,
       employee.team,
       hobby.hobby
from employee
right join hobby
on employee.employee_id = hobby.employee_id
union
select employee.employee_id,
       employee.team,
       hobby.hobby
from employee
left join hobby
on employee.employee_id = hobby.employee_id
;

-- Union all (Have duplicates)
select hobby.employee_id,
       employee.team,
       hobby.hobby
from employee
right join hobby
on employee.employee_id = hobby.employee_id
union all
select employee.employee_id,
       employee.team,
       hobby.hobby
from employee
left join hobby
on employee.employee_id = hobby.employee_id
;

-- Different number of columns in the results
select hobby.employee_id,
       employee.team,
       hobby.hobby
from employee
right join hobby
on employee.employee_id = hobby.employee_id
union
select employee.employee_id,
       hobby.hobby
from employee
left join hobby
on employee.employee_id = hobby.employee_id
;

-- The naming of the columns in the first result determine the name of the final output

select hobby.employee_id as id,
       employee.team,
       hobby.hobby
from hobby left join employee
on employee.employee_id = hobby.employee_id
union
select
       employee.team,
       employee.employee_id,
       hobby.hobby
from employee left join hobby
on employee.employee_id = hobby.employee_id
;

-- Inner join by default
select *
from employee inner join hobby
on employee.employee_id = hobby.employee_id;

select employee.employee_id
from employee join hobby
on employee.employee_id = hobby.employee_id;

-- Using, if join columns are the same name
select employee_id
from employee right join hobby
using (employee_id);

select * from review;
select *
from employee join review
on employee.employee_id = review.name;

select *
from employee join employee as e

-- Use alias to simplify query
select e.employee_id
from employee as e join employee e2
on e.employee_id = e2.employee_id;

/****************************************
	Exercise
 ***************************************/
-- 1. Create a summary table that has 3 columns:
--    employee_id, team, and hire_date
select employee_id,
       team,
       hire_date
from employee join hire using (employee_id);
-- Includes NULL values in hire if theres any.
select employee_id,
       team,
       hire_date
from employee left join hire using (employee_id)
union
select employee_id,
       team,
       hire_date
from hire left join employee using (employee_id)
;

-- 2. Create a summary table that has 4 columns:
--    employee_id, team, hire_date and performance
-- HINT: just add the second join after the first in the same query
select employee_id,
       team,
       hire_date,
       performance
from employee e
left join hire h using (employee_id)
left join review r on e.employee_id = r.name;


-- 3. What is the average performance score for each team?
select team, avg(performance)
from employee
left join review
on employee.employee_id = review.name
group by team
;
-- This doesn't take into account with employee not having performance.
select team, sum(performance)/count(employee_id)
from employee
left join review
on employee.employee_id = review.name
group by team
;

/****************************************
	Remarks
 ***************************************/
/** Subqueries **/
-- We can use subquery as a table or a filter condition
-- As a table, we need to give it an alias
-- As a filter condition, it can only have 1 column

/**Union**/
-- Make sure the number of columns for each result matches
-- The name of columns in the first result determines the name of the final output
-- Make sure the order of the columns in the results are the same
-- Note: If you want to keep the duplicates, add the keyword 'ALL' behind union

/** Joins **/
-- Inner join (default join) and left join
-- Inner join outputs results that matches in both table (using the column(s) you defined)
-- Left join outputs results with the first table as base and shows the values if there are matches
-- If the join condition is the same column name in both table, we can use USING
-- We can give aliases to the tables, but the tables are only recognized by the aliases now

-- HINT: Sometimes it is better to use subquery to filter the tables before the join