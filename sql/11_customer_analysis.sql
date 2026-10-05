-- ============================================
-- Étape 11 : Analyse des clients (Customer Analytics)
-- ============================================
USE ecommerce_analysis;

-- Top 10 clients (CA)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.region,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS nb_commandes
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.region
ORDER BY revenue DESC
LIMIT 10;

-- Clients inactifs (n'ont jamais commandé)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.region
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

-- Clients avec une seule commande
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS nb_commandes
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) = 1;

-- Clients les plus fidèles (plus grand nombre de commandes)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS nb_commandes
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY nb_commandes DESC
LIMIT 10;

-- Clients à forte valeur (CA supérieur à 2x la moyenne)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * oi.unit_price) > 2 * (
        SELECT AVG(ca_client.ca)
        FROM (
            SELECT SUM(oi2.quantity * oi2.unit_price) AS ca
            FROM orders o2
            JOIN order_items oi2 ON oi2.order_id = o2.order_id
            GROUP BY o2.customer_id
        ) AS ca_client
      )
ORDER BY revenue DESC;
