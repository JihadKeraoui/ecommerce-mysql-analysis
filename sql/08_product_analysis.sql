-- ============================================
-- Étape 8 : Analyse par produit
-- ============================================
USE ecommerce_analysis;

-- Top 10 des produits par chiffre d'affaires
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
    SUM(oi.quantity)                           AS unites_vendues
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- Produits qui vendent le plus d'unités
SELECT
    p.product_name,
    SUM(oi.quantity) AS unites_vendues
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY unites_vendues DESC
LIMIT 10;

-- Produits qui génèrent le moins de CA
SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue ASC
LIMIT 10;

-- CA, marge et taux de marge par catégorie
SELECT
    c.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires,
    ROUND(
        SUM(oi.quantity * (oi.unit_price - p.unit_cost)),
        2
    ) AS marge,
    ROUND(
        100 * SUM(oi.quantity * oi.unit_price)
        / (SELECT SUM(quantity * unit_price) FROM order_items),
        2
    ) AS pct_du_ca,
    ROUND(
        100 * SUM(oi.quantity * (oi.unit_price - p.unit_cost))
        / SUM(oi.quantity * oi.unit_price),
        2
    ) AS taux_marge
FROM categories c
JOIN products p
    ON p.category_id = c.category_id
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY chiffre_affaires DESC;
