-- ============================================
-- Étape 4 : Vérifier la qualité des données
-- ============================================
USE ecommerce_analysis;

-- 1. Valeurs NULL (emails manquants)
SELECT COUNT(*) AS clients_sans_email
FROM customers
WHERE email IS NULL;

-- 2. Doublons (emails en double)
SELECT email, COUNT(*) AS nb_occurrences
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY nb_occurrences DESC;

-- 3. Prix invalides (négatifs ou coût > prix)
SELECT product_id, product_name, unit_price, unit_cost
FROM products
WHERE unit_price <= 0 OR unit_cost <= 0 OR unit_cost > unit_price;

-- 4. Quantités invalides
SELECT order_item_id, order_id, product_id, quantity
FROM order_items
WHERE quantity <= 0;

-- 5. Commandes sans client
SELECT o.*
FROM orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- 6. Lignes de commande orphelines (sans commande)
SELECT oi.*
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_id IS NULL;

-- 7. Paiements incohérents (montant différent du total de la commande)
SELECT p.payment_id, p.order_id, p.amount,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_commande
FROM payments p
JOIN orders o      ON o.order_id = p.order_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY p.payment_id, p.order_id, p.amount
HAVING p.amount <> ROUND(SUM(oi.quantity * oi.unit_price), 2);
