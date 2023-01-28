-- Advanced SQL topics

-- MySQL Indexes
/* data is taken from a column of the table and is stored in a certain order in a distinct place - called an index
The larger the DB, the slower the process of finding the reccord(s) you need 

CREATE INDEX index_name ON table_name (column_1, column_2, ...); */

SELECT * FROM employees WHERE hire_date > '2000-01-01';

CREATE INDEX i_hire_date ON employees(hire_date);

# composite indexes applied to multiple columns

SELECT * FROM employees WHERE first_name = 'Georgi' AND last_name = 'Facello';

CREATE INDEX i_composite ON employees(first_name, last_name);

SHOW INDEX FROM employees FROM employees;

ALTER TABLE employees DROP INDEX i_hire_date;

SELECT * FROM salaries WHERE salary > 89000;

CREATE INDEX i_salary ON salaries(salary);

-- The CASE statement
/* Used within SELECT  */

SELECT 
    emp_no,
    first_name,
    last_name,
    CASE gender
        WHEN 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM
    employees;

-- IF can only have one condition, CASE can have as many as you want 
SELECT 
    emp_no,
    first_name,
    last_name,
	IF(gender = 'M', 'Male', 'Female') AS gender
FROM employees;

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE 
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
	END AS is_manager
FROM 
	employees e
		LEFT JOIN 
	dept_manager dm ON dm.emp_no = e.emp_no
WHERE e.emp_no > 109990;

SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary raise is over $30,000'
        ELSE 'Salary raise was under/equal to $30,000'
    END AS salary_raise
FROM
    dept_manager dm
        JOIN
    employees e ON dm.emp_no = e.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

SELECT 
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE 
		WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employeed'
        ELSE 'Not an employee anymore'
	END AS current_employee
FROM employees e
	JOIN 
    dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100;