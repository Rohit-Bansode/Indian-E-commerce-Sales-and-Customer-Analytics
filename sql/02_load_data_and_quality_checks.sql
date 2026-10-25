
-- --------------------------------------
-- 2. Data Quality Checks
-- --------------------------------------

-------------- Checks Tables is exists after loading --------------
Select * from ecommerce.customers;

Select * from ecommerce.products;
Select * from ecommerce.orders;
Select * from ecommerce.order_items;
Select * from ecommerce.payments;
Select * from ecommerce.shipments;
Select * from ecommerce.returns;
Select * from ecommerce.customer_reviews;


------------- 1. Check Total Number of Rows in Each Tables --------------

SELECT 'customers' As table_name, COUNT(*) AS total_rows from customers
UNION ALL
SELECT 'products' , COUNT(*) FROM products
UNION ALL
SELECT 'orders' , COUNT(*) FROM orders
UNION ALL
SELECT 'order items' , COUNT(*) FROM order_items
UNION ALL
SELECT 'payments' , COUNT(*) FROM payments
UNION ALL
SELECT 'shipments' , COUNT(*) FROM shipments
UNION ALL
SELECT 'returns' , COUNT(*) FROM returns
UNION ALL
SELECT 'customer reviews', COUNT(*) FROM customer_reviews
ORDER BY table_name;

------------- 2. Check Missing Values (NULL) In important columns --------------


-- Check Customers Tables NULL values

SELECT 'customers - age' AS check_name, COUNT(*) AS null_count 
FROM customers WHERE age IS NULL
UNION ALL
SELECT 'customers - last_order_date', COUNT(*)
FROM customers WHERE last_order_date IS NULL
UNION ALL
SELECT 'customers-preferred_device', COUNT(*)
FROM customers WHERE preferred_device IS NULL; 

-- Check Products table null values

SELECT 'Products - rating_average' AS check_name, COUNT(*) AS null_count
FROM products WHERE rating_average IS NULL;

-- Check Orders Table Null Values

SELECT 'orders - coupon_code' AS check_name, COUNT(*) AS null_count 
FROM orders WHERE coupon_code IS NULL;



-- Checks Shipments Table Null Values

SELECT 'shipments - actual_delivery_date' AS check_name, COUNT(*) AS null_count 
FROM shipments WHERE actual_delivery_date IS NULL
UNION ALL
SELECT 'shipments - delivery_days', COUNT(*) 
FROM shipments WHERE delivery_days IS NULL;

-- Checks Customers_review Table NULL Values

SELECT 'customer review - review_sentiment' as check_name, COUNT(*) As null_count
FROM customer_reviews WHERE review_sentiment IS NULL;

------------------------ 3.Checks for Duplicates Primary Keys ----------------------------

-- Customers
SELECT 'Customers' As table_name, customer_id,count(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Products
SELECT 'products' AS table_name, product_id,Count(*)
FROM products
GROUP BY product_id
HAVING COUNT(*)>1;

-- Orders
SELECT 'orders' AS table_name, order_id, COUNT(*) 
FROM orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- Order Items
SELECT 'order_items' AS table_name, order_item_id, COUNT(*) 
FROM order_items 
GROUP BY order_item_id 
HAVING COUNT(*) > 1;

-- Payments
SELECT 'payments' AS table_name, payment_id, COUNT(*) 
FROM payments 
GROUP BY payment_id 
HAVING COUNT(*) > 1;

-- Shipments
SELECT 'shipments' AS table_name, shipment_id, COUNT(*) 
FROM shipments 
GROUP BY shipment_id 
HAVING COUNT(*) > 1;

-- Returns
SELECT 'returns' AS table_name, return_id, COUNT(*) 
FROM returns 
GROUP BY return_id 
HAVING COUNT(*) > 1;

-- Customer Reviews
SELECT 'customer_reviews' AS table_name, review_id, COUNT(*) 
FROM customer_reviews 
GROUP BY review_id 
HAVING COUNT(*) > 1

---------------- 4. Check Referential Integrity -----------------

-- Orders that have customer_id not present in customers table
SELECT 'Orphan Orders' as issue, COUNT(*) AS problem_count
FROM orders o LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Order Items that have invalid order_id
SELECT 'Orphan Order Items (order_id)' AS issue, COUNT(*) AS problem_count
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Order Items that have invalid product_id
SELECT 'Orphan Order Items (product_id)' AS issue, COUNT(*) AS problem_count
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

----------------------- 5. Basic Business Logic Checks ----------------------

-- Orders with negative or zero final_amount
SELECT 'orders with final_amount <= 0' AS issue , count(*) AS Problem_count
FROM orders
WHERE final_amount <=0;

-- Orders items with quantity <= 0

SELECT 'order Items with quantity <=0' AS issue, COUNT(*) AS problem_count
FROM order_items
WHERE quantity <= 0;

-- Products where cost_price >= price (should not happen normally)
SELECT 'Products with cost_price >= price' AS issue, COUNT(*) AS problem_count
FROM products
WHERE cost_price >= price;


-------------- 6. Data Range Check ------------------

SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS lastest_order
FROM orders;

