-- DELETE statement

COMMIT;

SELECT * FROM titles WHERE emp_no = 999903;

DELETE FROM employees WHERE emp_no = 999903;

ROLLBACK;

DELETE FROM departments WHERE dept_no = 'd010';

-- Once you DROP a table it's gone for good
-- TRUNCATE removes all records from a table (auto_inc values will be reset)
-- DELETE removes records row by row
-- TRUNCATE faster than DELETE without WHERE + auto_inc not reset w/ DELETE