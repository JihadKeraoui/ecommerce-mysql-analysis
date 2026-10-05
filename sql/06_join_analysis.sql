-- ============================================
-- Étape 6 : Analyse avec JOIN
-- ============================================
USE ecommerce_analysis;

-- CA par client (permet de trouver les meilleurs clients)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.region,
    COUNT(DISTINCT o.order_id)              AS nb_commandes,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.city, c.region
ORDER BY revenue DESC
LIMIT 10;
-- CA par catégorie
SELECT
    cat.category_id,
    cat.category_name,
    COUNT(DISTINCT oi.order_id) AS nb_commandes,
    SUM(oi.quantity) AS unites_vendues,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM categories cat
JOIN products p
    ON p.category_id = cat.category_id
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY
    cat.category_id,
    cat.category_name
ORDER BY revenue DESC;
-- CA et volume par produit
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    SUM(oi.quantity) AS unites_vendues,
    COUNT(DISTINCT oi.order_id) AS nb_commandes,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN categories cat
    ON cat.category_id = p.category_id
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    cat.category_name
ORDER BY revenue DESC
LIMIT 10;
-- CA par région
SELECT
    c.region,
    COUNT(DISTINCT c.customer_id) AS nb_clients,
    COUNT(DISTINCT o.order_id) AS nb_commandes,
    SUM(oi.quantity) AS unites_vendues,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY revenue DESC;