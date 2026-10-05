-- ============================================
-- Étape 9 : Analyse par région
-- ============================================
USE ecommerce_analysis;

-- 1. CA par région
SELECT
    c.region,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY chiffre_affaires DESC;


-- 2. Nombre de clients par région
SELECT
    region,
    COUNT(*) AS nb_clients
FROM customers
GROUP BY region
ORDER BY nb_clients DESC;


-- 3. Nombre de commandes par région
SELECT
    c.region,
    COUNT(DISTINCT o.order_id) AS nb_commandes
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY nb_commandes DESC;


-- 4. Unités vendues par région
SELECT
    c.region,
    SUM(oi.quantity) AS unites_vendues
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY unites_vendues DESC;


-- 5. Panier moyen par région
SELECT
    c.region,
    ROUND(
        SUM(oi.quantity * oi.unit_price)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS panier_moyen
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY panier_moyen DESC;


-- 6. CA et marge par région
SELECT
    c.region,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires,
    ROUND(
        SUM(oi.quantity * (oi.unit_price - p.unit_cost)),
        2
    ) AS marge,
    ROUND(
        100 * SUM(oi.quantity * (oi.unit_price - p.unit_cost))
        / SUM(oi.quantity * oi.unit_price),
        2
    ) AS taux_marge
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN products p
    ON p.product_id = oi.product_id
GROUP BY c.region
ORDER BY chiffre_affaires DESC;


-- 7. Classement des régions par chiffre d'affaires
SELECT
    c.region,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    ) AS rang_ca
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY rang_ca;


-- 8. Classement des régions par panier moyen
SELECT
    c.region,
    ROUND(
        SUM(oi.quantity * oi.unit_price)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS panier_moyen,
    RANK() OVER (
        ORDER BY
            SUM(oi.quantity * oi.unit_price)
            / COUNT(DISTINCT o.order_id) DESC
    ) AS rang_panier_moyen
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY rang_panier_moyen;
-- 9. Classement régional synthétique
-- CA, poids dans le CA total et classement

SELECT
    c.region,

    ROUND(SUM(oi.quantity * oi.unit_price), 2)
        AS chiffre_affaires,

    ROUND(
        100 * SUM(oi.quantity * oi.unit_price)
        / (SELECT SUM(quantity * unit_price)
           FROM order_items),
        2
    ) AS pct_du_ca_total,

    RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    ) AS rang_ca

FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id

GROUP BY c.region

ORDER BY rang_ca;