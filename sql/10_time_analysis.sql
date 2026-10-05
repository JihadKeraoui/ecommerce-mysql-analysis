-- ============================================
-- Étape 10 : Analyse temporelle
-- ============================================
USE ecommerce_analysis;

-- 1. CA par année
SELECT
    YEAR(o.order_date) AS annee,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires,
    COUNT(DISTINCT o.order_id) AS nb_commandes
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY YEAR(o.order_date)
ORDER BY annee;


-- 2. CA par trimestre
SELECT
    CONCAT(YEAR(o.order_date), '-T', QUARTER(o.order_date)) AS trimestre,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY CONCAT(YEAR(o.order_date), '-T', QUARTER(o.order_date))
ORDER BY trimestre;


-- 3. CA par mois
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS mois,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires,
    COUNT(DISTINCT o.order_id) AS nb_commandes
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY mois;


-- 4. Nombre de commandes par mois
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS mois,
    COUNT(*) AS nb_commandes
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY mois;


-- 5. Meilleurs mois par chiffre d'affaires
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS mois,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY chiffre_affaires DESC
LIMIT 10;


-- 6. Évolution mensuelle avec classement
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS mois,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS chiffre_affaires,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    ) AS rang_ca
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY mois;


-- 7. CA moyen par commande chaque mois
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS mois,
    ROUND(
        SUM(oi.quantity * oi.unit_price)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS panier_moyen
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY mois;