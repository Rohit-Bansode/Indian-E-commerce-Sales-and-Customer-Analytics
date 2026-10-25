-- ============================================================
-- 04_analytical_queries.sql
-- ============================================================

-- 1. High-Level KPIs
SELECT
    COUNT(DISTINCT order_id)    AS total_orders,
    COUNT(DISTINCT customer_id)   AS total_customers,
    ROUND(SUM(final_amount)::NUMERIC, 2) AS total_revenue,
    ROUND(AVG(final_amount)::NUMERIC, 2)  AS average_order_value
FROM orders;

-- 2. Monthly Sales Trend

SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date)          AS month,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(final_amount)::NUMERIC, 2)        AS total_revenue
FROM orders
GROUP BY 1, 2
ORDER BY 1, 2;

-- 3. Sales by Category

SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id)      AS total_orders,
    ROUND(SUM(oi.item_revenue)::NUMERIC, 2)   AS total_sales,
    ROUND(SUM(oi.profit)::NUMERIC, 2)     AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- 4. Top 10 Products by Sales

SELECT 
    p.product_name,
    p.category,
    ROUND(SUM(oi.item_revenue)::NUMERIC, 2) AS total_sales,
    SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_sales DESC
LIMIT 10;

-- 5. Sales by State

SELECT
    delivery_state              As state,
    COUNT(DISTINCT order_id)    As total_order,
    ROUND(SUM(final_amount)::NUMERIC,2)    AS total_revenue
FROM orders
GROUP BY delivery_state
ORDER BY total_revenue DESC;


-- 6. Order Status Distribution

SELECT
    order_status     As total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) As percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 7. Payment Method Analysis

SELECT 
    payment_method,
    COUNT(*)                               AS total_transactions,
    ROUND(SUM(amount_paid)::NUMERIC, 2)       AS total_amount,
    ROUND(AVG(amount_paid)::NUMERIC, 2)  AS avg_amount
FROM payments
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- 8. Payment Status Summary

SELECT 
    payment_status,
    COUNT(*)                                    AS total_payments,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM payments
GROUP BY payment_status
ORDER BY total_payments DESC;


-- 9. Return Analysis

-- Overall Return Rate
SELECT 
    (SELECT COUNT(*) FROM returns) * 100.0 / 
    (SELECT COUNT(DISTINCT order_id) FROM orders) AS return_rate_percentage;

-- Top Return Reasons
SELECT 
    return_reason,
    COUNT(*)                                    AS total_returns,
    ROUND(SUM(refund_amount)::NUMERIC, 2)       AS total_refund_amount
FROM returns
GROUP BY return_reason
ORDER BY total_returns DESC;

-- 10. Delivery Performance

SELECT 
    CASE 
        WHEN delayed_flag = 1 THEN 'Delayed'
        ELSE 'On-Time'
    END                                         AS delivery_status,
    COUNT(*)                                    AS total_shipments,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    ROUND(AVG(delivery_days)::NUMERIC, 2)       AS avg_delivery_days
FROM shipments
GROUP BY delayed_flag
ORDER BY total_shipments DESC;


-- 11. Customer Reviews Summary

SELECT 
    rating,
    COUNT(*)                                    AS total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM customer_reviews
GROUP BY rating
ORDER BY rating;

-- Sentiment Distribution
SELECT 
    review_sentiment,
    COUNT(*)                                    AS total_reviews
FROM customer_reviews
GROUP BY review_sentiment
ORDER BY total_reviews DESC;


-- 12. Top 10 Customers by Revenue

SELECT 
    c.customer_id,
    c.customer_segment,
    c.state,
    COUNT(DISTINCT o.order_id)                  AS total_orders,
    ROUND(SUM(o.final_amount)::NUMERIC, 2)      AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_segment, c.state
ORDER BY total_spent DESC
LIMIT 10;


SELECT 'Analytical Queries Completed Successfully!' AS status;