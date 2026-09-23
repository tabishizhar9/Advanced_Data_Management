-- =============================================================
-- SQL Practice Queries
-- Topics: joins, self join, compound join, USING, outer joins,
--         cross join, UNION, and creating a table from a query
-- =============================================================


-- =============================================================
-- 1. INNER JOINS
-- =============================================================

USE sql_store;

-- Join order items with products to show product names
SELECT order_id, o.product_id, quantity, p.name, o.unit_price
FROM order_items o
JOIN products p
    ON o.product_id = p.product_id;


USE sql_invoicing;

-- Joining multiple tables: clients, payments, and payment methods
SELECT c.client_id, c.name, pm.name
FROM clients c
JOIN payments p
    ON c.client_id = p.client_id
JOIN payment_methods pm
    ON p.payment_method = pm.payment_method_id;


-- =============================================================
-- 2. SELF JOIN
-- =============================================================

USE sql_hr;

-- Show each employee with their manager's name
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
JOIN employees m
    ON e.reports_to = m.employee_id;


-- =============================================================
-- 3. COMPOUND JOIN (joining on more than one column)
-- =============================================================

USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
    ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;


-- =============================================================
-- 4. USING CLAUSE
-- =============================================================

USE sql_store;

-- USING with two columns
SELECT *
FROM order_items
JOIN order_item_notes
    USING (order_id, product_id);


USE sql_invoicing;

-- USING combined with a normal ON join
SELECT
    p.date,
    c.name AS client,
    p.amount,
    pm.name
FROM payments p
JOIN clients c
    USING (client_id)
JOIN payment_methods pm
    ON (p.payment_method = pm.payment_method_id);


-- =============================================================
-- 5. OUTER JOINS
-- =============================================================

USE sql_store;

-- Left join: show all products, even ones never ordered
SELECT p.product_id, p.name, oi.quantity
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id;


-- Outer joins between multiple tables
SELECT o.order_date,
       o.order_id,
       c.first_name AS customer,
       sh.name AS shipper,
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
    ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
    ON o.status = os.order_status_id;


-- =============================================================
-- 6. CROSS JOIN
-- =============================================================

USE sql_store;

-- Explicit cross join
SELECT
    s.name AS shipper,
    p.name AS product
FROM shippers s
CROSS JOIN products p
ORDER BY s.name;


-- Implicit cross join
SELECT
    s.name AS shipper,
    p.name AS product
FROM shippers s, products p
ORDER BY s.name;


-- =============================================================
-- 7. UNION
-- =============================================================

USE sql_store;

-- Label customers as Bronze, Silver, or Gold based on points
SELECT
    c.customer_id,
    c.first_name,
    c.points,
    'Bronze' AS type
FROM customers c
WHERE c.points < 2000
UNION
SELECT
    c.customer_id,
    c.first_name,
    c.points,
    'Silver' AS type
FROM customers c
WHERE c.points BETWEEN 2000 AND 3000
UNION
SELECT
    c.customer_id,
    c.first_name,
    c.points,
    'Gold' AS type
FROM customers c
WHERE c.points >= 3000
ORDER BY first_name;


-- =============================================================
-- 8. CREATE A TABLE FROM A QUERY
-- =============================================================

USE sql_invoicing;

-- Copy paid invoices (with client names) into a new archive table
CREATE TABLE invoices_archived AS
SELECT i.invoice_id,
       i.number,
       c.name AS client,
       i.invoice_total,
       i.payment_total
FROM invoices i
JOIN clients c
    ON i.client_id = c.client_id AND i.payment_date IS NOT NULL;

SELECT *
FROM invoices_archived;


-- =============================================================
-- 9. CLAUSE SNIPPETS (practice parts, not full queries)
-- These are kept commented because they are only parts of
-- queries (WHERE / ORDER BY / LIMIT) and cannot run alone.
-- =============================================================

-- ORDER BY and LIMIT
-- ORDER BY points DESC
-- LIMIT 3

-- WHERE order_id = 2
-- ORDER BY quantity * unit_price DESC

-- IS NULL
-- WHERE shipped_date IS NULL

-- REGEXP
-- WHERE last_name REGEXP 'B[RU]'
-- WHERE last_name REGEXP '^MY|ON'
-- WHERE last_name REGEXP 'EY$|ON$'
-- WHERE first_name REGEXP 'ELKA|AMBUR'

-- LIKE
-- WHERE address LIKE '%TRAIL%' OR address LIKE '%AVENUE%';
-- WHERE phone LIKE '%9'