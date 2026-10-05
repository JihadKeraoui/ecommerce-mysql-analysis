-- ============================================
-- Étape 15 : Créer des vues (prêtes pour Power BI / Python)
-- ============================================
USE ecommerce_analysis;

-- Vue : résumé par client
CREATE OR REPLACE VIEW vw_customer_revenue AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    c.region,
    COUNT(DISTINCT o.order_id)                  AS nb_commandes,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS revenue,
    MAX(o.order_date)                           AS derniere_commande
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.region;

-- Vue : performance par produit
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.unit_price,
    p.unit_cost,
    SUM(oi.quantity)                            AS unites_vendues,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS revenue,
    ROUND(SUM(oi.quantity * (oi.unit_price - p.unit_cost)), 2) AS marge
FROM products p
JOIN categories c   ON c.category_id  = p.category_id
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, c.category_name, p.unit_price, p.unit_cost;

-- Vue : CA mensuel
CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')          AS mois,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS chiffre_affaires,
    COUNT(DISTINCT o.order_id)                  AS nb_commandes,
    COUNT(DISTINCT o.customer_id)               AS nb_clients
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m');

-- Vue : KPI par région
CREATE OR REPLACE VIEW vw_region_kpi AS
SELECT
    c.region,
    COUNT(DISTINCT c.customer_id)               AS nb_clients,
    COUNT(DISTINCT o.order_id)                  AS nb_commandes,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS chiffre_affaires,
    ROUND(SUM(oi.quantity * oi.unit_price)
          / COUNT(DISTINCT o.order_id), 2)      AS panier_moyen
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY c.region;

-- Test des vues
SELECT * FROM vw_customer_revenue  ORDER BY revenue DESC LIMIT 5;
SELECT * FROM vw_product_performance ORDER BY revenue DESC LIMIT 5;
SELECT * FROM vw_monthly_revenue   ORDER BY mois;
SELECT * FROM vw_region_kpi        ORDER BY chiffre_affaires DESC;
