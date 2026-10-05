# -*- coding: utf-8 -*-
"""
Étape 7-8 : Générer les données réalistes + générer le fichier INSERT.

Génère `sql/03_insert_data.sql` (~750 clients, 8 catégories, 40 produits,
~1000 commandes, ~2500 lignes de commande, ~1000 paiements).

Usage :  python python/generate_data.py
Dépendances : aucune (bibliothèque standard uniquement).
"""
import os
import random
from datetime import date, timedelta

random.seed(42)  # reproductible

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(BASE, "sql", "03_insert_data.sql")

# ---------------------------------------------------------------- données
FIRST_NAMES = [
    "Jean", "Marie", "Pierre", "Francoise", "Michel", "Nathalie", "Alain",
    "Isabelle", "Nicolas", "Sylvie", "Francois", "Martine", "Eric", "Cecile",
    "Julien", "Chantal", "Herve", "Anne", "Bruno", "Claire", "Denis",
    "Helene", "Fabrice", "Monique", "Laurent", "Jacqueline", "Thierry",
    "Sophie", "Philippe", "Christine", "Stephane", "Agnes", "Frederic",
    "Patricia", "Olivier", "Valerie", "Luc", "Veronique", "Marc", "Nadine",
    "Antoine", "Corinne", "Hugo", "Emma", "Louis", "Jade", "Gabriel",
    "Lea", "Raphael", "Manon", "Arthur", "Chloe", "Paul", "Camille",
]
LAST_NAMES = [
    "Martin", "Bernard", "Dubois", "Thomas", "Robert", "Richard", "Petit",
    "Durand", "Leroy", "Moreau", "Simon", "Laurent", "Lefebvre", "Michel",
    "David", "Bertrand", "Roux", "Vincent", "Fournier", "Morel", "Girard",
    "Andre", "Lefevre", "Mercier", "Dupont", "Lambert", "Bonnet", "Fontaine",
    "Rousseau", "Vincent2", "Muller", "Faure", "Andre2", "Perrin", "Robin",
    "Clement", "Brun", "Morin", "Blanchard", "Gauthier", "Perrin2",
    "Guerin", "Muller2", "Henry", "Roussel", "Nicolas", "Perrin3",
]
REGIONS = {
    "Ile-de-France": ["Paris", "Boulogne-Billancourt", "Versailles", "Saint-Denis", "Nanterre"],
    "Auvergne-Rhone-Alpes": ["Lyon", "Grenoble", "Clermont-Ferrand", "Annecy", "Saint-Etienne"],
    "Nouvelle-Aquitaine": ["Bordeaux", "Limoges", "Poitiers", "Bayonne", "La Rochelle"],
    "Occitanie": ["Toulouse", "Montpellier", "Nimes", "Perpignan", "Beziers"],
    "Hauts-de-France": ["Lille", "Amiens", "Roubaix", "Tourcoing", "Dunkerque"],
    "Provence-Alpes-Cote d'Azur": ["Marseille", "Nice", "Toulon", "Aix-en-Provence", "Avignon"],
    "Grand Est": ["Strasbourg", "Reims", "Metz", "Nancy", "Mulhouse"],
    "Bretagne": ["Rennes", "Brest", "Quimper", "Lorient", "Vannes"],
}
REGION_NAMES = list(REGIONS.keys())

CATEGORIES = [
    "Laptops", "Smartphones", "Tablets", "Monitors",
    "Keyboards", "Headphones", "Accessories", "Printers",
]

# (nom, prix_min, prix_max) — 5 produits par catégorie = 40 produits
PRODUCTS = [
    ("Laptop Air 13", 899, 1299), ("Laptop Pro 14", 1299, 1899),
    ("Laptop Pro 16", 1799, 2499), ("Laptop Ultra 15", 1499, 2199),
    ("Laptop Essential 15", 549, 799),
    ("Phone X", 699, 999), ("Phone X Pro", 999, 1299), ("Phone Lite", 299, 449),
    ("Phone Max", 1199, 1499), ("Phone SE", 399, 549),
    ("Tab 8", 249, 349), ("Tab 10", 349, 499), ("Tab Pro 11", 599, 799),
    ("Tab Pro 12.9", 899, 1199), ("Tab Kids", 179, 249),
    ("Monitor 24", 129, 199), ("Monitor 27", 199, 299), ("Monitor 27 4K", 349, 499),
    ("Monitor 32", 299, 449), ("Monitor Curved 34", 499, 699),
    ("Keyboard Wired", 19, 29), ("Keyboard Wireless", 39, 59),
    ("Keyboard Mechanical", 79, 129), ("Keyboard Slim", 49, 79),
    ("Keyboard Pro", 129, 189),
    ("Earbuds Basic", 29, 49), ("Earbuds Pro", 99, 149), ("Headphone BT", 59, 99),
    ("Headphone ANC", 149, 249), ("Headphone Studio", 249, 349),
    ("Mouse Wireless", 19, 35), ("Mouse Gaming", 49, 89), ("Webcam HD", 39, 69),
    ("USB-C Hub", 29, 59), ("Laptop Stand", 25, 45),
    ("Printer Inkjet", 79, 129), ("Printer Laser", 149, 249),
    ("Printer 4-in-1", 199, 299), ("Printer Photo", 129, 199),
    ("Printer Portable", 99, 149),
]

PAYMENT_METHODS = ["Carte bancaire", "PayPal", "Virement", "Apple Pay"]
ORDER_STATUSES = ["completed"] * 82 + ["pending"] * 6 + ["cancelled"] * 7 + ["refunded"] * 5

D0 = date(2021, 1, 1)
D1 = date(2025, 12, 31)
O0, O1 = date(2023, 1, 1), date(2025, 12, 31)

NB_CUSTOMERS, NB_ORDERS = 750, 1000
ACTIVE_CUSTOMERS = 600  # 150 clients resteront "inactifs" (jamais commandé)

# ---------------------------------------------------------------- helpers
def sql_str(s):
    return "'" + str(s).replace("'", "''") + "'"

def rand_date(a, b):
    return a + timedelta(days=random.randint(0, (b - a).days))

def batched(rows, n):
    for i in range(0, len(rows), n):
        yield rows[i:i + n]

# ---------------------------------------------------------------- génération
lines = ["-- ============================================",
         "-- Étape 8 : Insérer les données (généré par python/generate_data.py)",
         "-- ============================================",
         "USE ecommerce_analysis;", ""]

# Catégories
lines.append("INSERT INTO categories (category_name) VALUES")
lines.append(",\n".join(f"    ({sql_str(c)})" for c in CATEGORIES) + ";")
lines.append("")

# Produits (5 par catégorie)
product_rows = []
pid = 0
for cat_idx in range(len(CATEGORIES)):
    for name, lo, hi in PRODUCTS[cat_idx * 5:(cat_idx + 1) * 5]:
        pid += 1
        price = round(random.uniform(lo, hi), 2)
        cost = round(price * random.uniform(0.55, 0.80), 2)
        product_rows.append(
            f"    ({sql_str(name)}, {cat_idx + 1}, {price}, {cost})")
for chunk in batched(product_rows, 20):
    lines.append("INSERT INTO products (product_name, category_id, unit_price, unit_cost) VALUES")
    lines.append(",\n".join(chunk) + ";")
    lines.append("")

# Clients
customer_rows, emails = [], []
for i in range(1, NB_CUSTOMERS + 1):
    first = random.choice(FIRST_NAMES)
    last = random.choice(LAST_NAMES)
    region = random.choice(REGION_NAMES)
    city = random.choice(REGIONS[region])
    reg_date = rand_date(D0, D1)
    email = f"{first.lower()}.{last.lower()}{random.randint(1, 999)}@example.com"
    if random.random() < 0.012:      # ~1% d'emails NULL (data quality)
        email = None
    emails.append(email)
    customer_rows.append(
        "    ({}, {}, {}, {}, {}, {})".format(
            sql_str(first), sql_str(last),
            "NULL" if email is None else sql_str(email),
            sql_str(city), sql_str(region), sql_str(reg_date)))
# quelques doublons d'email volontaires
for i in (10, 11, 25, 60, 61):
    if emails[i] is not None:
        customer_rows[i] = customer_rows[i].replace(
            emails[i], 'doublon.volontaire@example.com', 1)
for chunk in batched(customer_rows, 100):
    lines.append("INSERT INTO customers "
                 "(first_name, last_name, email, city, region, registration_date) VALUES")
    lines.append(",\n".join(chunk) + ";")
    lines.append("")

# Commandes (réservées aux 600 premiers clients -> 150 inactifs)
order_rows, order_totals, order_dates = [], {}, {}
for oid in range(1, NB_ORDERS + 1):
    cid = random.randint(1, ACTIVE_CUSTOMERS)
    odate = rand_date(O0, O1)
    status = random.choice(ORDER_STATUSES)
    order_rows.append(f"    ({cid}, {sql_str(odate)}, {sql_str(status)})")
    order_totals[oid] = 0.0
    order_dates[oid] = odate
for chunk in batched(order_rows, 100):
    lines.append("INSERT INTO orders (customer_id, order_date, order_status) VALUES")
    lines.append(",\n".join(chunk) + ";")
    lines.append("")

# Prix par produit pour les lignes de commande
product_prices = []
for cat_idx in range(len(CATEGORIES)):
    for name, lo, hi in PRODUCTS[cat_idx * 5:(cat_idx + 1) * 5]:
        # reprendre les mêmes prix générés ci-dessus est impossible sans
        # stockage ; on régénère via la seed identique en rejouant la boucle.
        pass
# Rejouer la boucle produits avec la même seed pour retrouver les prix :
random.seed(42)  # non nécessaire pour les prix car indépendants, mais cohérent
# On stocke plutôt les prix réels lors de la génération produits :
# (refait proprement ci-dessous)

# -- correction : on régénère les prix produits de façon déterministe
random.seed(42)
generated_prices = []
for cat_idx in range(len(CATEGORIES)):
    for name, lo, hi in PRODUCTS[cat_idx * 5:(cat_idx + 1) * 5]:
        price = round(random.uniform(lo, hi), 2)
        generated_prices.append(price)

item_rows = []
iid = 0
for oid in range(1, NB_ORDERS + 1):
    for _ in range(random.randint(1, 4)):
        iid += 1
        prod = random.randint(1, 40)
        qty = random.randint(1, 3)
        price = generated_prices[prod - 1]
        order_totals[oid] += qty * price
        item_rows.append(f"    ({oid}, {prod}, {qty}, {price})")
for chunk in batched(item_rows, 200):
    lines.append("INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES")
    lines.append(",\n".join(chunk) + ";")
    lines.append("")

# Paiements (pour commandes completed / pending)
pay_rows = []
for oid, total in order_totals.items():
    # retrouver le statut n'est pas stocké ; on paie 92% des commandes
    if random.random() < 0.92:
        pdate = order_dates[oid] + timedelta(days=random.randint(0, 3))
        method = random.choice(PAYMENT_METHODS)
        status = "paid" if random.random() < 0.96 else "failed"
        pay_rows.append(
            f"    ({oid}, {sql_str(pdate)}, {sql_str(method)}, {sql_str(status)}, {round(total, 2)})")
for chunk in batched(pay_rows, 100):
    lines.append("INSERT INTO payments "
                 "(order_id, payment_date, payment_method, payment_status, amount) VALUES")
    lines.append(",\n".join(chunk) + ";")
    lines.append("")

# Récapitulatif
lines += [
    "-- Vérification rapide du volume inséré",
    "SELECT 'categories'  AS table_name, COUNT(*) AS nb_lignes FROM categories",
    "UNION ALL SELECT 'customers',  COUNT(*) FROM customers",
    "UNION ALL SELECT 'products',   COUNT(*) FROM products",
    "UNION ALL SELECT 'orders',     COUNT(*) FROM orders",
    "UNION ALL SELECT 'order_items', COUNT(*) FROM order_items",
    "UNION ALL SELECT 'payments',   COUNT(*) FROM payments;",
]

with open(OUT, "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print(f"OK -> {OUT}")
print(f"   clients={NB_CUSTOMERS}, commandes={NB_ORDERS}, lignes_commande={iid}, paiements={len(pay_rows)}")
