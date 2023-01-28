-- Advanced SQL topics

-- MySQL triggers
/* a MySQL trigger is a type of stored program, associated with a table, 
that will be activated automatically once a specific event related to the table of association occurs.
The event must be related to INSERT, UPDATE or DELETE
Can assign a 'before' or 'after' trigger */
USE employees;
COMMIT;

# BEFORE INSERT
DELIMITER $$

CREATE TRIGGER before_salaries_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = 0; 
	END IF; 
END $$

DELIMITER ;

SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';
    
    
INSERT INTO salaries VALUES ('10001', -92891, '2010-06-22', '9999-01-01');
    
# BEFORE UPDATE
DELIMITER $$

CREATE TRIGGER trig_upd_salary
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = OLD.salary; 
	END IF; 
END $$

DELIMITER ;

SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';

UPDATE salaries 
SET 
    salary = - 50000
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
 
 # SYSDATE() delivers the date and time of the moment at which you have invoked this function.
SELECT SYSDATE();

# Another frequently employed function, “Date Format”, assigns a specific format to a given date. For instance, the following query 
# could extract the current date, quoting the year, the month, and the day. 
SELECT DATE_FORMAT(SYSDATE(), '%y-%m-%d') as today;


DELIMITER $$

CREATE TRIGGER trig_ins_dept_mng
AFTER INSERT ON dept_manager
FOR EACH ROW
BEGIN
	DECLARE v_curr_salary int;
    
    SELECT 
		MAX(salary)
	INTO v_curr_salary FROM
		salaries
	WHERE
		emp_no = NEW.emp_no;

	IF v_curr_salary IS NOT NULL THEN
		UPDATE salaries 
		SET 
			to_date = SYSDATE()
		WHERE
			emp_no = NEW.emp_no and to_date = NEW.to_date;

		INSERT INTO salaries 
			VALUES (NEW.emp_no, v_curr_salary + 20000, NEW.from_date, NEW.to_date);
    END IF;
END $$

DELIMITER ;

INSERT INTO dept_manager VALUES ('111534', 'd009', date_format(sysdate(), '%y-%m-%d'), '9999-01-01');

SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no = 111534;
    
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = 111534;

# Conceptually, this was an ‘after’ trigger that automatically added $20,000 to the salary of the employee who was just promoted as a manager. 
# Moreover, it set the start date of her new contract to be the day on which you executed the insert statement.

ROLLBACK;

DELIMITER $$

CREATE TRIGGER trig_hire_date
BEFORE INSERT ON employees
FOR EACH ROW

BEGIN 
	IF NEW.hire_date > DATE_FORMAT(SYSDATE(), '%y-%m-%d')
    THEN SET NEW.hire_date = DATE_FORMAT(SYSDATE(), '%y-%m-%d');
	END IF;
END$$

DELIMITER ;

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

SELECT  
    * 
FROM  
    employees
ORDER BY emp_no DESC;
