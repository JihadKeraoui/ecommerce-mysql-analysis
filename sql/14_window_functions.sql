-- ============================================
-- Étape 14 : Window Functions
-- ============================================
USE ecommerce_analysis;

-- 1. Classement des clients (RANK, DENSE_RANK, ROW_NUMBER)
SELECT
    customer_id,
    first_name,
    last_name,
    revenue,
    RANK()       OVER (ORDER BY revenue DESC) AS rang,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS rang_dense,
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS numero_ligne
FROM vw_customer_revenue
ORDER BY revenue DESC;

-- 2. CA cumulé par produit (courbe de Pareto)
SELECT
    product_name,
    revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC) AS ca_cumule,
    ROUND(100 * SUM(revenue) OVER (ORDER BY revenue DESC)
              / SUM(revenue) OVER (), 2)      AS pct_cumule
FROM vw_product_performance;

-- 3. Évolution mensuelle : LAG / LEAD
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS mois,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS ca
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    mois,
    ca,
    LAG(ca)  OVER (ORDER BY mois) AS ca_mois_precedent,
    LEAD(ca) OVER (ORDER BY mois) AS ca_mois_suivant,
    ROUND(100 * (ca - LAG(ca) OVER (ORDER BY mois))
              / LAG(ca) OVER (ORDER BY mois), 2) AS evolution_pct
FROM monthly
ORDER BY mois;

-- 4. Moyenne mobile sur 3 mois
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS mois,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS ca
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    mois,
    ca,
    ROUND(AVG(ca) OVER (
        ORDER BY mois
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moyenne_mobile_3_mois
FROM monthly
ORDER BY mois;

-- 5. Segmentation des clients en quartiles (NTILE)
SELECT
    customer_id,
    first_name,
    last_name,
    revenue,
    NTILE(4) OVER (ORDER BY revenue DESC) AS segment
FROM vw_customer_revenue
ORDER BY revenue DESC;

-- 6. Premier achat de chaque client (PARTITION BY)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_date,
    FIRST_VALUE(o.order_date) OVER (
        PARTITION BY c.customer_id ORDER BY o.order_date
    ) AS date_premier_achat
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_date;
