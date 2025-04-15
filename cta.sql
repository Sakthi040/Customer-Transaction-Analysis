-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name TEXT,
    email TEXT,
    join_date DATE,
    region TEXT
);

-- Accounts Table
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    account_type TEXT,
    open_date DATE,
    balance NUMERIC(12, 2)
);

-- Transactions Table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    amount NUMERIC(12, 2),
    transaction_date DATE,
    transaction_type TEXT
);

INSERT INTO customers (customer_id, name, email, join_date, region) VALUES
(1, 'Customer_1', 'customer1@bank.com', NULL, 'North'),
(2, 'Customer_2', 'customer2@bank.com', NULL, 'West'),
(3, 'Customer_3', 'customer3@bank.com', NULL, 'East'),
(4, 'Customer_4', 'customer4@bank.com', NULL, 'North'),
(5, 'Customer_5', 'customer5@bank.com', NULL, 'North'),
(6, 'Customer_6', 'customer6@bank.com', NULL, 'West'),
(7, 'Customer_7', 'customer7@bank.com', NULL, 'South'),
(8, 'Customer_8', 'customer8@bank.com', NULL, 'North'),
(9, 'Customer_9', 'customer9@bank.com', NULL, 'East'),
(10, 'Customer_10', 'customer10@bank.com', NULL, 'East');

INSERT INTO accounts (account_id, customer_id, account_type, open_date, balance) VALUES
(1, 1, 'Checking', NULL, 7536.42),
(2, 2, 'Checking', NULL, 804.99),
(3, 2, 'Checking', NULL, 1349.1),
(4, 3, 'Checking', NULL, 9982.5),
(5, 3, 'Checking', NULL, 2230.78),
(6, 4, 'Checking', NULL, 8774.66),
(7, 4, 'Checking', NULL, 1598.88),
(8, 5, 'Savings', NULL, 4006.54),
(9, 6, 'Savings', NULL, 2165.79),
(10, 6, 'Checking', NULL, 582.73),
(11, 7, 'Checking', NULL, 7598.23),
(12, 8, 'Savings', NULL, 3152.35),
(13, 8, 'Savings', NULL, 6635.68),
(14, 9, 'Checking', NULL, 7069.08),
(15, 9, 'Checking', NULL, 1886.85),
(16, 10, 'Checking', NULL, 5126.55),
(17, 10, 'Savings', NULL, 8888.28);

INSERT INTO transactions (transaction_id, account_id, amount, transaction_date, transaction_type) VALUES
(1, 1, 449.68, NULL, 'debit'),
(2, 1, 233.39, NULL, 'credit'),
(3, 1, 817.67, NULL, 'credit'),
(4, 1, 902.36, NULL, 'credit'),
(5, 1, 691.42, NULL, 'credit'),
(6, 1, 523.18, NULL, 'debit'),
(7, 1, 441.06, NULL, 'credit'),
(8, 1, 863.46, NULL, 'credit'),
(9, 1, 684.92, NULL, 'credit'),
(10, 1, 592.74, NULL, 'credit'),
(11, 1, 737.24, NULL, 'credit'),
(12, 2, 106.0, NULL, 'debit'),
(13, 2, 964.52, NULL, 'credit'),
(14, 2, 397.17, NULL, 'credit'),
(15, 2, 404.56, NULL, 'credit'),
(16, 2, 328.8, NULL, 'credit'),
(17, 2, 694.36, NULL, 'debit'),
(18, 2, 980.7, NULL, 'credit'),
(19, 2, 765.76, NULL, 'credit'),
(20, 2, 341.62, NULL, 'credit'),
(21, 2, 215.73, NULL, 'debit'),
(22, 3, 216.26, NULL, 'credit'),
(23, 3, 126.41, NULL, 'credit'),
(24, 3, 730.51, NULL, 'credit'),
(25, 3, 815.08, NULL, 'debit'),
(26, 3, 176.22, NULL, 'debit'),
(27, 3, 933.82, NULL, 'credit'),
(28, 3, 630.53, NULL, 'credit'),
(29, 3, 136.92, NULL, 'debit'),
(30, 3, 348.99, NULL, 'credit'),
(31, 3, 715.28, NULL, 'credit'),
(32, 3, 129.61, NULL, 'debit'),
(33, 3, 479.64, NULL, 'debit'),
(34, 4, 523.66, NULL, 'credit'),
(35, 4, 408.06, NULL, 'credit'),
(36, 4, 974.49, NULL, 'credit'),
(37, 4, 412.65, NULL, 'credit'),
(38, 4, 458.54, NULL, 'credit'),
(39, 4, 271.15, NULL, 'debit'),
(40, 4, 501.52, NULL, 'credit'),
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.item_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(AVG(o.total_amount), 2) AS average_order_value
FROM orders o
GROUP BY month
ORDER BY month;
SELECT 
    DATE_TRUNC('month', signup_date) AS month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY month
ORDER BY month;
WITH customer_order_counts AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
),
repeat_customers AS (
    SELECT COUNT(*) AS repeat_count
    FROM customer_order_counts
    WHERE order_count > 1
),
total_customers AS (
    SELECT COUNT(*) AS total_count
    FROM customer_order_counts
)
SELECT 
    ROUND(100.0 * r.repeat_count / t.total_count, 2) AS repeat_customer_percentage
FROM repeat_customers r, total_customers t;
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS total_sales
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY month
ORDER BY month;
SELECT 
    p.category,
    SUM(oi.quantity * oi.item_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;
SELECT 
    c.region,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_orders DESC;
