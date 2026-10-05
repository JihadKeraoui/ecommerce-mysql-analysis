-- ============================================
-- Étape 13 : CTE (Common Table Expressions)
-- ============================================
USE ecommerce_analysis;

-- 1. CTE simple : clients à fort CA, filtrés par rapport à la moyenne
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.region,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id  = o.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.region
)
SELECT *
FROM customer_revenue
WHERE revenue > (SELECT AVG(revenue) FROM customer_revenue)
ORDER BY revenue DESC;

-- 2. CTE : CA mensuel avec évolution vs mois précédent
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS mois,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    mois,
    chiffre_affaires,
    LAG(chiffre_affaires) OVER (ORDER BY mois) AS ca_mois_precedent,
    ROUND(chiffre_affaires - LAG(chiffre_affaires) OVER (ORDER BY mois), 2) AS evolution
FROM monthly_revenue
ORDER BY mois;

-- 3. CTE chaînées : part de chaque catégorie dans le CA total
WITH category_revenue AS (
    SELECT
        c.category_name,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires
    FROM categories c
    JOIN products p     ON p.category_id = c.category_id
    JOIN order_items oi ON oi.product_id = p.product_id
    GROUP BY c.category_id, c.category_name
),
total_revenue AS (
    SELECT SUM(chiffre_affaires) AS total FROM category_revenue
)
SELECT
    cr.category_name,
    cr.chiffre_affaires,
    ROUND(100 * cr.chiffre_affaires / tr.total, 2) AS pct_du_ca
FROM category_revenue cr
CROSS JOIN total_revenue tr
ORDER BY cr.chiffre_affaires DESC;
