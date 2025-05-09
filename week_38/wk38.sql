se database exercises;
use schema frosty_friday; 


-- Create first table
CREATE or replace TABLE employees (
id INT,
name VARCHAR(50),
department VARCHAR(50)
);

-- Insert example data into first table

INSERT INTO employees (id, name, department)
VALUES
(1, 'Alice', 'Sales'),
(2, 'Bob', 'Marketing'),
(4, 'Xena', 'Macrodata Refinement');


-- Create second table
CREATE or replace TABLE sales (
id INT,
employee_id INT,
sale_amount DECIMAL(10, 2)
);

-- Insert example data into second table
INSERT INTO sales (id, employee_id, sale_amount)
VALUES
(1, 1, 100.00),
(2, 1, 200.00),
(3, 2, 150.00);

-- Create view that combines both tables
CREATE or replace VIEW employee_sales AS
SELECT e.id, e.name, e.department, s.sale_amount
FROM employees e
JOIN sales s ON e.id = s.employee_id;

-- Query the view to verify the data
SELECT * FROM employee_sales;

-----------------------------------
-----------------------------------

-- Add a stream to the employee_sales VIEW
-- Keep track of every deletion that was made
-- Move these into a new table called ‘deleted_sales

create or replace stream wk38stream
on view employee_sales;

-- test with an insert:
INSERT INTO sales (id, employee_id, sale_amount)
VALUES
(5, 4, 600.00);

select * from employee_sales; -- OK, see new row
select * from wk38stream; -- OK, see INSERT

-- test with a delete:
delete from sales 
where id=5;

select * from employee_sales; -- OK, gone
select * from wk38stream; -- INSERT is gone, now table is empty! 

-- let's try with a delete of an existing row:
delete from employees
where name = 'Bob';

select * from employee_sales; -- OK, Bob is gone
select * from wk38stream; -- Now we see a DELETE
-- so, it looks like DELETEing a prior INSERT just erases the insert. 

-----------------------------------
-----------------------------------
-- create table with no rows; just copying schema 
create or replace view wk38deletes as 
select * 
from wk38stream
where METADATA$ACTION = 'DELETE';


select * from wk38deletes;

select *
from employee_sales;

-- test one more time. Will wk38deletes pick up this DELETE since it's already created?
delete from sales
where sale_amount > 199;

select * from employee_sales;

-- Success!
select * from wk38deletes;