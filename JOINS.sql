-- JOINS
/* Allow us to draw on relationships between tables
Joins show a result set containing fields derived from two or more tables
Need to find related columns (PK/FK)
Can add other fields from the tables */

ALTER TABLE departments_dup DROP COLUMN dept_manager;

ALTER TABLE departments_dup CHANGE COLUMN dept_no dept_no CHAR(4) NULL;
ALTER TABLE departments_dup CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
	emp_no INT(11) NOT NULL,
	dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
);

INSERT INTO dept_manager_dup SELECT * FROM dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES 
(999904, '2017-01-01'),
(999905, '2017-01-01'),
(999906, '2017-01-01'),
(999907, '2017-01-01');

DELETE FROM dept_manager_dup
WHERE dept_no = 'd001';

INSERT INTO departments_dup (dept_name) VALUES ('Public Relations');

DELETE FROM departments_dup WHERE dept_no = 'd002'; 

-- INNER JOIN
-- SELECT (designate tables data is from) FROM table 1 JOIN table 2 ON (tables and columns)
/* Helps extract the results set (middle of venn diagram)
Non matching records won't appear 
Null values, or values appearing in just one of the tables and not 
appearing in the other won't be displayed */

SELECT * FROM dept_manager_dup ORDER BY dept_no;
SELECT * FROM departments_dup ORDER BY dept_no;

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
INNER JOIN departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM employees e
INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no;

-- Dealing with duplicates
-- Use group BY with the field that differs most among records
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
INNER JOIN departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY m.dept_no;

-- LEFT JOIN
/* Centre and left side of the venn diagram - 
1) all matching values of the two tables 
2) all values from the left table that match no values from the right table 
The order that you join the tables matters*/

DELETE FROM dept_manager_dup WHERE emp_no = '110228';
DELETE FROM departments_dup WHERE dept_no ='d009';

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

-- use a WHERE column_name IS NULL for just left side of venn diagram 

SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
FROM employees e
LEFT JOIN dept_manager dm ON e.emp_no = dm.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY dm.dept_no DESC, e.emp_no;

-- RIGHT JOIN
-- Just the opposite of the left join ! Right side and middle of venn diagram
-- left and right joins are one-to-many relationships

-- Old join syntax (WHERE)
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM employees e, dept_manager dm 
WHERE e.emp_no = dm.emp_no;

-- JOIN and WHERE
-- JOIN used to join the tables WHERE used to set the conditons

SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary > 145000;

set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE e.first_name = 'Margareta' AND e.last_name = 'Markovitch';

-- CROSS JOIN
/* will take the values from a certain table and connect them with all 
the values from the tables we want to join it with - connects all values
not just those that match 
Useful when tables are not well connected */

SELECT dm.*, d.*
FROM dept_manager dm
CROSS JOIN departments d
ORDER BY dm.emp_no, d.dept_no;

-- does the same thing
SELECT dm.*, d.*
FROM dept_manager dm, departments d
ORDER BY dm.emp_no, d.dept_no;

-- does the same thing but not best practice
SELECT dm.*, d.*
FROM dept_manager dm
JOIN departments d
ORDER BY dm.emp_no, d.dept_no;

SELECT dm.*, d.*
FROM dept_manager dm
CROSS JOIN departments d
WHERE dm.emp_no != d.dept_no
ORDER BY dm.emp_no, d.dept_no;

-- can cross join more than two tables NB: result might get too big
SELECT e.*, d.*
FROM dept_manager dm
CROSS JOIN departments d
JOIN employees e ON dm.emp_no = e.emp_no
WHERE dm.emp_no != d.dept_no
ORDER BY dm.emp_no, d.dept_no;

SELECT d.*, dm.*
FROM dept_manager dm
CROSS JOIN departments d
WHERE d.dept_no = 'd009';

SELECT e.*, d.*
FROM employees e
CROSS JOIN departments d 
WHERE e.emp_no < 10011
ORDER BY e.emp_no, d.dept_name;

-- Using aggregate functions with joins 
SELECT e.gender, AVG(s.salary) AS average_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY gender;

-- Joining more than one table
SELECT e.first_name, e.last_name, e.hire_date, m.from_date, d.dept_name
FROM employees e 
JOIN dept_manager m ON e.emp_no = m.emp_no
JOIN departments d ON m.dept_no = d.dept_no;

SELECT e.first_name, e.last_name, e.hire_date, t.title, dm.from_date, d.dept_name
FROM employees e 
JOIN titles t ON e.emp_no = t.emp_no
JOIN dept_manager dm ON t.from_date = dm.from_date
JOIN departments d ON dm.dept_no = d.dept_no;

SELECT d.dept_name, AVG(salary) AS average_salary
FROM departments d
JOIN dept_manager m ON d.dept_no = m.dept_no
JOIN salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING average_salary > 60000
ORDER BY average_salary DESC;

SELECT e.gender, COUNT(dm.emp_no) 
FROM employees e 
JOIN dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;

-- UNION vs UNION ALL
/* Used to combine a few SELECT statements in a single output
Allows you to unify tables 
SELECT N columns FROM table_1 UNION ALL SELECT N columns FROM table_2 
We have to select the same number of columns from each table
These columns should have the same name, 
should be in the smae order and should contain related data types */

CREATE TABLE employees_dup (
	emp_no INT(11),
    birth_date DATE,
    first_name VARCHAR(14),
    last_name VARCHAR(16),
    gender ENUM('M','F'),
    hire_date DATE
);

INSERT INTO employees_dup SELECT e.* FROM employees e LIMIT 20;

INSERT INTO employees_dup VALUES
('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');

SELECT e.emp_no, e.first_name, e.last_name, NULL AS dept_no, NULL AS from_date
FROM employees_dup e
WHERE e.emp_no = 10001
UNION ALL SELECT NULL AS emp_no, NULL AS first_name, NULL AS last_name, m.dept_no, m.from_date
FROM dept_manager m;

SELECT e.emp_no, e.first_name, e.last_name, NULL AS dept_no, NULL AS from_date
FROM employees_dup e
WHERE e.emp_no = 10001
UNION SELECT NULL AS emp_no, NULL AS first_name, NULL AS last_name, m.dept_no, m.from_date
FROM dept_manager m;

/* WHEN uniting 2 identically organised tables
 - UNION displayes only distinct values in the output
	- Uses more MySQL resources 
 - UNION ALL retrieves the duplicated as well
 So depends if you're looking get better results or optimise performance */
 
 
    






