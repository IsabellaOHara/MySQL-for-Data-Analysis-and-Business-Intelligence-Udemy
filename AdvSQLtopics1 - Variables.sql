-- Advanced SQL topics

-- Local Vairables
/* SCOPE: region of a computer program where a phenomenon, e.g. a variable is considered valid 
LOCAL VARIABLE: a variable that is visible only in the BEGIN-END block in which it was created 
DECLARE - can be only used when decalring local variables */

SELECT v_avg_salary; -- won't work becuase it's a local variable (out of scope)

-- this won't work because v_avg_salary_2 not in scope
DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE v_avg_salary DECIMAL(10,2);

BEGIN
	DECLARE v_avg_salary_2 DECIMAL(10,2);
END;

SELECT 
    AVG(s.salary)
INTO v_avg_salary_2 FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
RETURN v_avg_salary_2;
END$$
DELIMITER ;

-- Session Variables
/* SESSION: a series of information exchange interactions, 
or a dialogue, between a computer and a user 


1. Set up a connection
2. Establish connection
3. workbench interface opens immediately 
4. end a connection

There are certain SQL objects that a valid for a specific session only

SESSION VARIABLE: A variable that exists only for the session in which you're operating
=> defined on our server and lives there
=> is visible to the connection being used only 

SET SESSION @variable_name = ...
*/

SET @s_var1 = 3;
SELECT @s_var1;

-- Global variables
/* GLOBAL VARIABLES: apply to all connections related to a specific server 
SET GLOBAL var_name = value;
SET @@global.var_name = value; 
Can't just set any variable as global - specific group of pre-defined variables in MySQL - system variables
.max_connections() => indicates max number of connections to a server that can be est at one time
.max_join_size() => sets maximum memory space allocated for the joins created by a certain connection */

SET GLOBAL max_connections = 1000;

-- User defined vs System variables
/* varibales can be characterised according to the way they have been created 
User defiend => set by the user manually
System => are pre-defined on out system - the MySQL server 
Both user-defined and system variables can be set as session variables (there are limitations to this!) 
Some of the system variables can be defined as gloabl only 
- can't be session varibales (e.g. max_connections() )

A user can define a local or session variable
system variables can be set as session variables or global variales
Not all variables can be set as session
*/
