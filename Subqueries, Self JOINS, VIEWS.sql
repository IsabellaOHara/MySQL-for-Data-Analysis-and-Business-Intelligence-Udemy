-- SQL subqueries 
USE employees;

-- IN nested inside WHERE
/* Subqueries should always be in brackets 
Can have multiple inner queries - goes in order of innermost, to outer-most */
SELECT * FROM dept_manager;
SELECT e.first_name, e.last_name FROM employees e
WHERE e.emp_no IN (SELECT dm.emp_no FROM dept_manager dm);

SELECT * FROM dept_manager dm 
WHERE emp_no IN (SELECT emp_no FROM employees WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');

-- SQL subqueries with EXISTS-NOT EXISTS nested inside WHERE
/* EXISTS checks whether certain row values are found within a subquery 
- goes row by row
- returns boolean 
- If true corresponding record extracted 
- Quicker than IN for larger datasets */
SELECT e.first_name, e.last_name FROM employees e
WHERE EXISTS (SELECT * FROM dept_manager dm WHERE dm.emp_no = e.emp_no);

-- Add ORDER BY - more professional to do it in the outer query
SELECT e.first_name, e.last_name FROM employees e
WHERE EXISTS (SELECT * FROM dept_manager dm WHERE dm.emp_no = e.emp_no ORDER BY emp_no);

SELECT e.first_name, e.last_name FROM employees e
WHERE EXISTS (SELECT * FROM dept_manager dm WHERE dm.emp_no = e.emp_no) ORDER BY emp_no;

SELECT * FROM employees e
WHERE EXISTS (SELECT * FROM titles t WHERE e.emp_no = t.emp_no AND title = 'Assistant Engineer');

-- Subqueries nested in SELECT and FROM
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;

DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
	emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

INSERT INTO emp_manager
SELECT U.* FROM 
(SELECT A.* FROM
 (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B
UNION SELECT
	C.* FROM
	(SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no
    ) AS C
UNION SELECT
    D.*
FROM
(SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no
    ) AS D
    ) AS U;

-- Self JOIN
/* applied when a table must join itself 
Using aliases is obligatory
These references to the original table let you use different blocks of the available data 
Can either filter both in the join, or can filter one of them in the WHERE clause and 
the other one in the join */

SELECT * FROM emp_manager ORDER BY emp_manager.emp_no;
SELECT DISTINCT e1.* FROM emp_manager e1
JOIN emp_manager e2 ON e1.emp_no = e2.manager_no;

SELECT  e1.* FROM emp_manager e1
JOIN emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE e2.emp_no IN (SELECT manager_no FROM emp_manager);

-- VIEWS 
/* a virtual table whose contents are obtained from existing table(s) called base tables 
Acts as a shortcut for writing the same SELECT statement every time a new request has been made 
Occupies no extra memory 
Acts as dynamic table as it instantly reflects data and structural changes in the base table */

SELECT * FROM dept_emp;

SELECT emp_no, from_date, to_date, COUNT(emp_no) AS Num 
FROM dept_emp GROUP BY emp_no HAVING Num > 1;


-- CREATE OR REPLACE VIEW V_name AS SELECT
CREATE OR REPLACE VIEW V_dept_emp_latest_date AS 
SELECT 
emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
FROM dept_emp
GROUP BY emp_no;

CREATE OR REPLACE VIEW v_average_managers_salarys AS
SELECT ROUND(AVG(salary),2) AS average_salary
FROM salaries 
WHERE emp_no IN (SELECT emp_no FROM dept_manager);