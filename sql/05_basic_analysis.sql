-- ============================================
-- Étape 5 : Analyse SQL de base
-- ============================================
USE ecommerce_analysis;

-- Nombre de clients
SELECT COUNT(*) AS total_customers FROM customers;

-- Nombre de commandes
SELECT COUNT(*) AS total_orders FROM orders;

-- Nombre de produits
SELECT COUNT(*) AS total_products FROM products;

-- Chiffre d'affaires
SELECT ROUND(SUM(quantity * unit_price), 2) AS chiffre_affaires
FROM order_items;

-- Quantités vendues
SELECT SUM(quantity) AS unites_vendues
FROM order_items;
