CREATE DATABASE ooo;
DROP DATABASE ooo;

CREATE DATABASE giraffe;
USE giraffe;

CREATE TABLE employees(
    employee_id int,
    first_name varchar(50),
    last_name varchar(50),
    hourly_pay decimal(5,2),
    hire_date date
);
SELECT * FROM employees;

RENAME TABLE employees TO workers;
SELECT * FROM workers;

RENAME TABLE workers TO employees;

ALTER TABLE employees
ADD phone_nums VARCHAR(15);

ALTER TABLE employees
DROP COLUMN phone_nums;

ALTER TABLE employees
RENAME COLUMN phone_num  TO email;

ALTER TABLE employees
MODIFY COLUMN  email VARCHAR(100);

ALTER TABLE employees
MODIFY email VARCHAR(100)
AFTER last_name;

ALTER TABLE employees
MODIFY email VARCHAR(100)
FIRST;

ALTER TABLE employees
DROP COLUMN email;

INSERT INTO employees
VALUES (1,"Eugene", "Krabs", 25.50, "2020-01-02");

INSERT INTO employees
VALUES  (2, "Squidward", "Tentacles", 12.30, "2023-01-05"),
        (3, 'Spongebob', 'Squarepants', 15.20, "2023-01-12"), 
        (4, "Patrick", 'Star', 10.00, "2023-01-06"),
        (5, 'Sandy',"Cheeks", 18.29, "2023-01-01");

INSERT INTO employees (employee_id, first_name, last_name)
VALUES (6,'Sheldon', 'Plankton');

SELECT * FROM employees;

SELECT last_name, first_name
FROM employees;

SELECT * FROM employees
WHERE employee_id = 2;

SELECT *
FROM employees
WHERE last_name = "Squarepants";

SELECT * FROM employees
WHERE NOT employee_id = 4;

SELECT * FROM employees
WHERE hourly_pay >= 16;

SELECT * FROM employees
WHERE employee_id != 1 AND first_name != 'Patrick';

SELECT * 
FROM employeeS
WHERE hourly_pay IS NULL;

SELECT * FROM employees
WHERE hourly_pay IS NOT NULL;

UPDATE employees
SET hourly_pay =10.50 , 
    hire_date = "2023-01-25"
WHERE employee_id = 6;

SELECT * FROM employees;

CREATE TABLE products(
    product_id INT,
    product_name VARCHAR(25) UNIQUE,
    price DECIMAL(4,2)
);

SELECT * FROM products;

ALTER TABLE products
DROP CONSTRAINT product_name;

ALTER TABLE products
ADD CONSTRAINT UNIQUE(product_name);

INSERT INTO products
VALUES  (100, 'hamburger', 3.99),
        (101, 'fries', 1.89),
        (102, 'soda', 1.00),
        (103, 'ice cream', 1.50);

SELECT * FROM products;

INSERT INTO products (product_name)
VALUES('fries');

ALTER TABLE products
MODIFY price DECIMAL (4,2) NOT NULL;

ALTER TABLE employees
ADD CONSTRAINT chk_hourly_pay CHECK(hourly_pay > 5.00);

SELECT * FROM employees;

ALTER TABLE employees
DROP CHECK hourly_pay;

ALTER TABLE employees
ADD CONSTRAINT chk_pay CHECK(hourly_pay > 3.00);

ALTER TABLE employees
DROP CHECK chk_pay,
DROP CHECK chk_hourly_pay;

CREATE TABLE customers(
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)

);

SELECT * FROM customers;

INSERT INTO customers (first_name, last_name)
VALUES  ('fred', 'fish'),
        ('larry', 'lobster'),
        ('bubble', 'bass');

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL (5,2),
    customer_id INT,
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

ALTER TABLE transactions
AUTO_INCREMENT = 1000;

INSERT INTO transactions (amount, customer_id)
VALUES  (4.99,3),
        (2.89,2),
        (3.38,3),
        (4.99,1);

SELECT * FROM transactions;

INSERT INTO TRANSACTIONS (amount, customer_id)
VALUES (1.00, NULL);

INSERT INTO customers (first_name, last_name)
VALUES ('poppy', 'puff');

SELECT * FROM customers;

SELECT *
FROM transactions INNER JOIN customers
ON transactions.customer_id = customers.customer_id;

SELECT transactions.transaction_id, transactions.amount, customers.first_name, customers.last_name
FROM transactions INNER JOIN customers
ON transactions.customer_id = customers.customer_id;

SELECT MAX(amount) AS maximum
FROM transactions;

SELECT COUNT(amount) AS 'count', AVG(amount) AS average, MIN(amount) AS minimum, MAX(amount) AS maximum
FROM transactions;


-- concat last & first names

SELECT CONCAT(first_name, ' ', last_name) AS 'full name'
FROM employees;

ALTER TABLE employees
ADD COLUMN job VARCHAR(25) AFTER hourly_pay;

UPDATE employees
SET job = 'manager'
WHERE employee_id = 1;

UPDATE employees
SET job = 'cashier'
WHERE employee_id =2;

UPDATE employees
SET job ='cook'
WHERE employee_id = 3;

UPDATE employees
SET job = 'cook'
WHERE employee_id = 4;

UPDATE employees
SET job = 'asst manager'
WHERE employee_id = 5;

UPDATE employees
SET job = 'janitor'
WHERE employee_id = 6;

SELECT * FROM employees
WHERE job = 'cook' AND hire_date < '2023-01-12';

SELECT * FROM employees
WHERE NOT job = 'cook' AND NOT job = 'manager';

SELECT * FROM employees
WHERE hire_date BETWEEN '2023-01-05' AND '2023-01-12'
ORDER BY hire_date DESC;

SELECT * FROM employees
WHERE hire_date BETWEEN '2023-01-05' AND '2023-01-12'
ORDER BY job DESC, hire_date ASC;

SELECT * FROM employees 
WHERE hire_date NOT BETWEEN '2023-01-05' AND '2023-01-12'
ORDER BY hire_date;

SELECT * FROM employees
WHERE employee_id IN (2,3,4);

SELECT * FROM employees
WHERE employee_id NOT IN (2,3,4);

SELECT * FROM employees
WHERE job NOT IN ('janitor','manager');

SELECT * FROM employees
WHERE hire_date LIKE "____-01-0_";

SELECT * FROM employees
WHERE hire_date NOT LIKE "____-01-0_";

SELECT * FROM employees
WHERE job LIKE "__ni%";

SELECT * FROM employees
WHERE job LIKE "%ni%";

SELECT * FROM employees
WHERE first_name LIKE "%a%";

SELECT * FROM employees
WHERE first_name LIKE 'S%d';

SELECT * FROM employees
WHERE first_name LIKE 'S%e%';

SELECT * FROM employees
LIMIT 3;

SELECT * FROM employees
LIMIT 2,1;

SELECT * FROM employees
LIMIT 2,2;

SELECT * FROM employees
LIMIT 3,2;

SELECT * FROM employees
ORDER BY hourly_pay DESC LIMIT 4;

SELECT * FROM employees;

CREATE VIEW employee_attendance_view AS
SELECT first_name, last_name
FROM employees;

SELECT * FROM employee_attendance_view
ORDER BY last_name LIMIT 3;

SELECT AVG(hourly_pay) AS average
FROM employees;

SELECT first_name, last_name, (SELECT AVG(hourly_pay) FROM employees) AS "average_pay" 
FROM employees;

SELECT * FROM transactions;

SELECT first_name, last_name
FROM customers
WHERE customer_id IN 
(SELECT DISTINCT customer_id
FROM transactions
WHERE customer_id IS NOT NULL);

SELECT first_name, last_name
FROM customers
WHERE customer_id NOT IN 
(SELECT DISTINCT customer_id
FROM transactions
WHERE customer_id IS NOT NULL);
