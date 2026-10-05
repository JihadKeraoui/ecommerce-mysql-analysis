-- ============================================
-- Étape 7 : KPI commerciaux
-- ============================================
USE ecommerce_analysis;

-- KPI 1 : Chiffre d'affaires total
SELECT ROUND(SUM(quantity * unit_price), 2) AS kpi_ca_total
FROM order_items;

-- KPI 2 : Nombre de commandes
SELECT COUNT(*) AS kpi_total_orders FROM orders;

-- KPI 3 : Nombre de clients
SELECT COUNT(*) AS kpi_total_customers FROM customers;

-- KPI 4 : Nombre de produits
SELECT COUNT(*) AS kpi_total_products FROM products;

-- KPI 5 : Unités vendues
SELECT SUM(quantity) AS kpi_unites_vendues FROM order_items;

-- KPI 6 : Panier moyen
SELECT ROUND(SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT oi.order_id), 2) AS kpi_panier_moyen
FROM order_items oi;

-- KPI 7 : CA moyen par client
SELECT ROUND(
    (SELECT SUM(quantity * unit_price) FROM order_items)
    / (SELECT COUNT(*) FROM customers), 2
) AS kpi_ca_moyen_par_client;


-- KPI 8 : Marge brute
SELECT
    ROUND(SUM(oi.quantity * (oi.unit_price - p.unit_cost)), 2) AS kpi_marge_brute
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id;


-- KPI 9 : Taux de marge
SELECT
    ROUND(
        SUM(oi.quantity * (oi.unit_price - p.unit_cost))
        / SUM(oi.quantity * oi.unit_price) * 100,
        2
    ) AS kpi_taux_marge
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id;