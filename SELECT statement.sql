-- SELECT statement

USE employees;

SELECT first_name, last_name FROM employees;

SELECT dept_no FROM departments;
SELECT * FROM departments;

-- The WHERE clause
SELECT * FROM employees WHERE first_name = 'Denis';
SELECT * FROM employees WHERE first_name = 'Elvis';

-- AND
SELECT * FROM employees WHERE first_name = 'Denis' AND gender = 'M';
SELECT * FROM employees WHERE first_name = 'Kellie' AND gender = 'F';

-- OR
SELECT * FROM employees WHERE first_name = 'Denis' OR first_name = 'Elvis';
SELECT * FROM employees WHERE first_name = 'Kellie' OR first_name = 'Aruna';

-- Operator presidence
SELECT * FROM employees 
WHERE last_name = 'Denis' AND (gender = 'M' OR gender = 'F');
SELECT * FROM employees 
WHERE gender = 'F' AND (first_name = 'Kellie' OR first_name = 'Aruna');

-- IN/NOT IN 
SELECT * FROM employees WHERE first_name IN ('Cathie', 'Mark', 'Nathan');
SELECT * FROM employees WHERE first_name NOT IN ('Cathie', 'Mark', 'Nathan');
SELECT * FROM employees WHERE first_name IN ('Denis', 'Elvis');
SELECT * FROM employees WHERE first_name NOT IN ('John', 'Mark', 'Jacob');

-- LIKE/NOT LIKE -- NB case insensitive
SELECT * FROM employees WHERE first_name LIKE ('Mar%');
SELECT * FROM employees WHERE first_name LIKE ('Mar_');
SELECT * FROM employees WHERE first_name NOT LIKE ('Mar%');
SELECT * FROM employees WHERE first_name LIKE ('Mark%');
SELECT * FROM employees WHERE hire_date LIKE ('2000%');
SELECT * FROM employees WHERE emp_no LIKE ('1000_');

-- Wildcard characters
SELECT * FROM employees WHERE first_name LIKE ('%Jack%');
SELECT * FROM employees WHERE first_name NOT LIKE ('%Jack%');

-- BETWEEN ... AND ... - inclusive (NOT BETWEEN - exclusive)
SELECT * FROM employees WHERE hire_date BETWEEN '1990-01-01' AND '2000-01-01';
SELECT * FROM employees WHERE hire_date NOT BETWEEN '1990-01-01' AND '2000-01-01';
SELECT * FROM salaries WHERE salary BETWEEN 66000 AND 70000;
SELECT * FROM employees WHERE emp_no NOT BETWEEN '10004' AND '10012';
SELECT dept_name FROM departments WHERE dept_no BETWEEN 'd003' AND 'd006';

-- IS NOT NULL / IS NULL
SELECT * FROM employees WHERE first_name IS NOT NULL;
SELECT * FROM employees WHERE first_name IS NULL;
SELECT dept_name FROM departments WHERE dept_no IS NOT NULL;

-- Other comparison operators (maths ones)
SELECT * FROM employees WHERE first_name != 'Mark';
SELECT * FROM employees WHERE first_name <> 'Mark'; -- same as above
SELECT * FROM employees WHERE hire_date > '2000-01-01';
SELECT * FROM employees WHERE gender = 'F' AND hire_date >= '2000-01-01';
SELECT * FROM salaries WHERE salary > 150000;

-- SELECT DISTINT
SELECT DISTINCT gender FROM employees;
SELECT DISTINCT hire_dates FROM employees;

-- Aggregate functions 
SELECT COUNT(emp_no) FROM employees;
SELECT COUNT(DISTINCT first_name) FROM employees;
SELECT COUNT(*) FROM salaries WHERE salary >= 100000;
SELECT COUNT(*) FROM dept_manager;

-- ORDER BY (ASC is the default)
SELECT * FROM employees ORDER BY first_name;
SELECT * FROM employees ORDER BY first_name DESC;
SELECT * FROM employees ORDER BY first_name, last_name ASC;
SELECT * FROM employees ORDER BY hire_date DESC;

-- GROUP BY
SELECT first_name FROM employees GROUP BY first_name; -- showing distinct first names
SELECT first_name, COUNT(first_name) FROM employees GROUP BY first_name;
SELECT first_name, COUNT(first_name) FROM employees 
GROUP BY first_name ORDER BY first_name DESC;

-- Aliases (AS)
SELECT first_name, COUNT(first_name) AS names_count FROM employees 
GROUP BY first_name ORDER BY first_name DESC;

SELECT salary, COUNT(emp_no) AS emps_with_same_salary FROM salaries
WHERE salary > 80000 GROUP BY salary ORDER BY salary;

-- HAVING
-- refines the output from record that do not satisfy certain conditions
-- Applied to the GROUP BY block
SELECT first_name, COUNT(first_name) AS names_count FROM employees 
GROUP BY first_name HAVING COUNT(first_name) > 250 ORDER BY first_name DESC;

SELECT emp_no, AVG(salary) FROM salaries 
GROUP BY emp_no HAVING AVG(salary) > 120000 ORDER BY emp_no;

-- WHERE vs HAVING
SELECT frist_name, COUNT(first_name) AS names_count FROM employees
WHERE hire_date > '1999-01-01' GROUP BY first_name 
HAVING COUNT(first_name) < 200 ORDER BY first_name DESC;
-- can't have an aggregated and non-agreggated function in the HAVING block
-- SELECT FROM WHERE GROUP BY HAVING ORDER BY LIMIT
SELECT emp_no, COUNT(emp_no) AS num_contracts_signed FROM dept_emp
WHERE from_date > '2000-01-01' GROUP BY emp_no HAVING COUNT(from_date) > 1;

SELECT emp_no FROM dept_emp WHERE from_date > '2000-01-01' GROUP BY emp_no 
HAVING COUNT(from_date) > 1 ORDER BY emp_no;

-- LIMIT
SELECT emp_no, salary FROM salaries ORDER BY salary DESC LIMIT 10;
SELECT * FROM dept_emp LIMIT 100;

