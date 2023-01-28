-- Stored routines
/* An SQL statement, or set of SQL statements, that can be stored on the DB server
Routine can be called/referenced/invoked 
Only requires 1 line of code
Stored procedures
Functions - various types
	=> user defined functionss
	=> built in functions */

-- Stored procedures 
USE employees;

-- set up a temporary delimiter
-- CREATE PROCEDURE procedure_name(param_1, param_2)
-- CALL db_name.procedure_name();

DROP PROCEDURE IF EXISTS select_employees;
DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
	SELECT * FROM employees
    LIMIT 1000;
END$$

DELIMITER ;

CALL employees.select_employees();

DROP PROCEDURE IF EXISTS average_salary_all_emps;
DELIMITER $$
CREATE PROCEDURE average_salary_all_emps()
BEGIN
	SELECT ROUND(AVG(salary), 2) 
    FROM salaries;
END$$

DELIMITER ;

CALL employees.average_salary_all_emps();

DROP PROCEDURE select_employees;

-- With an Input parameter
DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER $$
CREATE PROCEDURE emp_avg_salary(IN p_emp_no INTEGER)
BEGIN
SELECT e.first_name, e.last_name, AVG(s.salary)
FROM employees e
	JOIN
salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;
END$$
DELIMITER ;

CALL emp_avg_salary(11300);

-- with output parameter
-- CREATE PROCEDURE procedure_name(in param, out param) 
-- SELECT INTO

DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER $$
CREATE PROCEDURE emp_avg_salary_out(IN p_emp_no INTEGER, OUT p_avg_salary DECIMAL(10,2))
BEGIN
SELECT AVG(s.salary)
INTO p_avg_salary
FROM employees e
	JOIN
salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS emp_info;
DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(255), IN p_last_name VARCHAR(255), OUT p_emp_no INTEGER)
BEGIN
	SELECT
		e.emp_no
        INTO p_emp_no
        FROM employees e
	WHERE e.first_name = p_first_name 
    AND e.last_name = p_last_name;
END$$
DELIMITER ;

-- VARIABLES
/* Parameters are more abstract term 
Once the structure ahs been solidified, then it will be applied to the DB. 
The input value you inserted is typically referred to as the 'argument', while the obtained output value is
stored in a 'variable' */
-- SET

SET @v_avg_salary = 0;
CALL employees.emp_avg_salary_out(11300, @v_avg_salary);
SELECT @v_avg_salary;

SET @v_emp_no = 0;
CALL employees.emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;

-- User-defined functions
/* DELIMITER $$
CREATE FUNCTION function_name(parameter data_type) RETURNS data_type
DECLARE variable_name data_type
BEGIN 
SELECT ...
RETURN variable_name
END$$
DELIMITER ;
*/

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE v_avg_salary DECIMAL(10,2);
SELECT 
    AVG(s.salary)
INTO v_avg_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
RETURN v_avg_salary;
END$$

DELIMITER ;

SELECT f_emp_avg_salary(11300);

DELIMITER $$
CREATE FUNCTION f_emp_info (p_first_name VARCHAR(255), p_last_name VARCHAR(255)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
DECLARE v_salary DECIMAL(10,2); 
DECLARE v_max_from_date DATE;
SELECT 
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;
    
SELECT 
    s.salary
INTO v_salary FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;
    RETURN v_salary;
END$$

DELIMITER ;

SELECT f_emp_info('Aruna','Journel');


/* if you need to obtain more than one value as a result of a calc - better off using a procedure
if need just one value to be returned - can use a function 
functions must return a value (don't use w INSERT/UPDATE/DELETE)
function can be used within normal SELECT query 
Can't use a procedure in a select statement */