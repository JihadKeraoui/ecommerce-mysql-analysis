-- ============================================
-- Étape 12 : Sous-requêtes
-- ============================================
USE ecommerce_analysis;

-- 1. Produits dont le CA est supérieur au CA moyen des produits
SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * oi.unit_price) > (
    SELECT AVG(product_revenue)
    FROM (
        SELECT SUM(oi2.quantity * oi2.unit_price) AS product_revenue
        FROM order_items oi2
        GROUP BY oi2.product_id
    ) AS t
)
ORDER BY revenue DESC;


-- 2. Produits jamais commandés
SELECT
    p.product_id,
    p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
);


-- 3. Clients dont le CA dépasse la moyenne des clients
SELECT
    c.first_name,
    c.last_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * oi.unit_price) > (
    SELECT AVG(client_revenue)
    FROM (
        SELECT SUM(oi2.quantity * oi2.unit_price) AS client_revenue
        FROM orders o2
        JOIN order_items oi2
            ON oi2.order_id = o2.order_id
        GROUP BY o2.customer_id
    ) AS t
)
ORDER BY revenue DESC;


-- 4. Commandes au-dessus du panier moyen
SELECT
    o.order_id,
    o.order_date,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_commande
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_date
HAVING SUM(oi.quantity * oi.unit_price) > (
    SELECT AVG(order_total)
    FROM (
        SELECT SUM(oi2.quantity * oi2.unit_price) AS order_total
        FROM order_items oi2
        GROUP BY oi2.order_id
    ) AS t
)
ORDER BY total_commande DESC;