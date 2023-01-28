CREATE DATABASE IF NOT EXISTS sales;
USE sales;

CREATE TABLE sales 
(
	purchase_no INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_of_purchase DATE NOT NULL,
    customer_id INT,
    item_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)ON DELETE CASCADE
);

-- ALTER TABLE sales ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id)ON DELETE CASCADE;

CREATE TABLE customers
(
	customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT,
    UNIQUE KEY (email_address)
);

ALTER TABLE customers
ADD COLUMN gender ENUM('M','F') AFTER last_name;

INSERT INTO customers (first_name, last_name, gender, email_address, number_of_complaints)
VALUES ('John','Mackinley','M','john.mckinley@365careers.com',0);

ALTER TABLE customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT 0;

INSERT INTO customers (first_name, last_name, gender)
VALUES ('Peter', 'Figaro', 'M');


CREATE TABLE items
(
	item_code VARCHAR(255) PRIMARY KEY,
    item VARCHAR(255),
    unit_price NUMERIC(10,2),
    company_id VARCHAR(255)
);

CREATE TABLE companies
(
	company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    hq_phone_number VARCHAR(255)
);

DROP TABLE sales;
DROP TABLE customers;
DROP TABLE items;
DROP TABLE companies;