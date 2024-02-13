create table employee(
    employee_id varchar(1),
    team varchar(10),
    salary int
);


insert into employee
values
  ('a', 'red', 80),
  ('b', 'red', 75),
  ('c', 'red', 110),
  ('d', 'green', 80),
  ('e', 'green', 80),
  ('f', 'blue', 50),
  ('g', 'blue', 200);
  
  
  create table hobby (
  employee_id varchar(1),
  hobby varchar(20)
);


insert into hobby
values
  ('b', 'soccer'),
  ('e', 'cooking'),
  ('g', 'knitting'),
  ('h', 'music');
  
  
  create table hire (
  employee_id varchar(1),
  hire_date int
);


insert into hire
values
  ('a', 2011),
  ('b', 2015),
  ('c', 2017),
  ('d', 2017),
  ('e', 2016),
  ('f', 2017);
  
  
  
  create table review (
  name varchar(1),
  performance int
);


insert into review
values
  ('a', 10),
  ('b', 10),
  ('c', 9),
  ('d', 10),
  ('e', 5),
  ('f', 9);
  
  
select count(*) from employee; -- 7
select count(*) from hobby; -- 4
select count(*) from hire; -- 6
select count(*) from review; -- 6