-- Aggregate functions 

-- COUNT()
-- COUNT(*) includes the null values of a column
SELECT * FROM salaries ORDER BY salary DESC LIMIT 10;
SELECT COUNT(salary) FROM salaries;
SELECT COUNT(DISTINCT from_date) FROM salaries;
SELECT COUNT(DISTINCT dept_no) FROM dept_emp;

-- SUM()
SELECT SUM(salary) FROM salaries;
SELECT SUM(salary) FROM salaries WHERE from_date > '1997-01-01';

-- MIN() / MAX()
SELECT MAX(salary) FROM salaries;
SELECT MIN(salary) FROM salaries;

SELECT MAX(emp_no) FROM employees;
SELECT MIN(emp_no) FROM employees;

-- AVG()
SELECT AVG(salary) FROM salaries;
SELECT AVG(salary) FROM salaries WHERE from_date > '1997-01-01';

-- ROUND()
SELECT ROUND(AVG(salary)) FROM salaries;
SELECT ROUND(AVG(salary), 2) FROM salaries;
SELECT ROUND(AVG(salary), 2) FROM salaries WHERE from_date > '1997-01-01';

-- COALESCE() / IFNULL()
ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;
INSERT INTO departments_dup (dept_no) VALUES ('d010'), ('d011');
SELECT * FROM departments_dup ORDER BY dept_no ASC;

ALTER TABLE employees.departments_dup
ADD COLUMN dept_manager VARCHAR(255) NULL AFTER dept_name;

COMMIT;

SELECT dept_no, IFNULL(dept_name, 'Department name not provided') AS dept_name
FROM departments_dup;

-- coalesce is ifnull with more than 2 parameters
SELECT dept_no, COALESCE(dept_name, 'Department name not provided') AS dept_name
FROM departments_dup;

SELECT dept_no, dept_name, COALESCE(dept_manager, dept_name, 'N/A') AS dept_manager
FROM departments_dup ORDER BY dept_no ASC;

SELECT dept_no, dept_name, COALESCE(dept_no, dept_name) AS dept_info FROM departments_dup 
ORDER BY dept_no ASC;

SELECT IFNULL(dept_no, 'N/A') AS dept_no, 
IFNULL(dept_name, 'Department name not provided') AS dept_name,
COALESCE(dept_no, dept_name) AS dept_info 
FROM departments_dup ORDER BY dept_no ASC;
