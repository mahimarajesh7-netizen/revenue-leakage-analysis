-- ============================================================
-- Phase 1: Data Audit Queries
-- Project: Revenue Leakage Analysis — Olist Dataset
-- ============================================================

-- 1. Row counts per table
SELECT 'orders'              AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'order_items',                        COUNT(*) FROM order_items
UNION ALL
SELECT 'payments',                           COUNT(*) FROM payments
UNION ALL
SELECT 'customers',                          COUNT(*) FROM customers
UNION ALL
SELECT 'products',                           COUNT(*) FROM products
UNION ALL
SELECT 'sellers',                            COUNT(*) FROM sellers
UNION ALL
SELECT 'reviews',                            COUNT(*) FROM reviews
UNION ALL
SELECT 'category_translation',               COUNT(*) FROM category_translation
ORDER BY row_count DESC;

-- 2. Date range of orders
SELECT
    MIN(order_purchase_timestamp)  AS earliest_order,
    MAX(order_purchase_timestamp)  AS latest_order,
    COUNT(DISTINCT order_id)       AS total_orders,
    COUNT(DISTINCT customer_id)    AS unique_customers
FROM orders;

-- 3. Order status breakdown (key leakage signal)
SELECT
    order_status,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM orders
GROUP BY order_status
ORDER BY count DESC;

-- 4. Orders with no payment (leakage!)
SELECT COUNT(*) AS orders_with_no_payment
FROM orders o
WHERE NOT EXISTS (
    SELECT 1 FROM payments p WHERE p.order_id = o.order_id
);

-- 5. Orders with no items (leakage!)
SELECT COUNT(*) AS orders_with_no_items
FROM orders o
WHERE NOT EXISTS (
    SELECT 1 FROM order_items i WHERE i.order_id = o.order_id
);
