import os

import matplotlib.pyplot as plt
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL


# ============================================================
# 1. CONFIGURATION
# ============================================================

load_dotenv()

DB_CONFIG = {
    "host": os.getenv("MYSQL_HOST"),
    "port": int(os.getenv("MYSQL_PORT", 3306)),
    "user": os.getenv("MYSQL_USER"),
    "password": os.getenv("MYSQL_PASSWORD"),
    "database": os.getenv("MYSQL_DATABASE"),
}


# Créer le dossier results s'il n'existe pas
os.makedirs("results", exist_ok=True)


# ============================================================
# 2. CONNEXION MYSQL
# ============================================================

connection_url = URL.create(
    drivername="mysql+mysqlconnector",
    username=DB_CONFIG["user"],
    password=DB_CONFIG["password"],
    host=DB_CONFIG["host"],
    port=DB_CONFIG["port"],
    database=DB_CONFIG["database"],
)

engine = create_engine(connection_url)


# ============================================================
# 3. FONCTION POUR EXECUTER UNE REQUETE
# ============================================================

def execute_query(query):
    """
    Exécute une requête SQL et retourne un DataFrame Pandas.
    """
    with engine.connect() as connection:
        return pd.read_sql(text(query), connection)


# ============================================================
# 4. GRAPHIQUE 1 — CA PAR CATEGORIE
# ============================================================

query_category = """
SELECT
    c.category_name AS category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM categories c
JOIN products p
    ON p.category_id = c.category_id
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC;
"""

df_category = execute_query(query_category)

print("\n=== CA PAR CATEGORIE ===")
print(df_category)


plt.figure(figsize=(10, 6))

bars = plt.barh(
    df_category["category"],
    df_category["revenue"]
)

plt.xlabel("Chiffre d'affaires (MAD)")
plt.ylabel("Catégorie")
plt.title("Chiffre d'affaires par catégorie")

plt.gca().invert_yaxis()

for bar, value in zip(bars, df_category["revenue"]):
    plt.text(
        bar.get_width() + 5000,
        bar.get_y() + bar.get_height() / 2,
        f"{value:,.0f} MAD",
        va="center"
    )

plt.tight_layout()

plt.savefig(
    "results/revenue_by_category.png",
    dpi=300,
    bbox_inches="tight"
)

plt.close()


# ============================================================
# 5. GRAPHIQUE 2 — CA PAR REGION
# ============================================================

query_region = """
SELECT
    c.region,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY revenue DESC;
"""

df_region = execute_query(query_region)

print("\n=== CA PAR REGION ===")
print(df_region)


plt.figure(figsize=(10, 6))

bars = plt.barh(
    df_region["region"],
    df_region["revenue"]
)

plt.xlabel("Chiffre d'affaires (MAD)")
plt.ylabel("Région")
plt.title("Chiffre d'affaires par région")

plt.gca().invert_yaxis()

for bar, value in zip(bars, df_region["revenue"]):
    plt.text(
        bar.get_width() + 5000,
        bar.get_y() + bar.get_height() / 2,
        f"{value:,.0f} MAD",
        va="center"
    )

plt.tight_layout()

plt.savefig(
    "results/revenue_by_region.png",
    dpi=300,
    bbox_inches="tight"
)

plt.close()


# ============================================================
# 6. GRAPHIQUE 3 — CA PAR ANNEE
# ============================================================

query_year = """
SELECT
    YEAR(o.order_date) AS year,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY YEAR(o.order_date)
ORDER BY year;
"""

df_year = execute_query(query_year)

print("\n=== CA PAR ANNEE ===")
print(df_year)


plt.figure(figsize=(9, 6))

bars = plt.bar(
    df_year["year"].astype(str),
    df_year["revenue"]
)

plt.xlabel("Année")
plt.ylabel("Chiffre d'affaires (MAD)")
plt.title("Évolution du chiffre d'affaires par année")

for bar, value in zip(bars, df_year["revenue"]):
    plt.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + 10000,
        f"{value:,.0f} MAD",
        ha="center",
        va="bottom"
    )

plt.tight_layout()

plt.savefig(
    "results/revenue_by_year.png",
    dpi=300,
    bbox_inches="tight"
)

plt.close()


# ============================================================
# 7. GRAPHIQUE 4 — CA PAR MOIS
# ============================================================

query_month = """
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;
"""

df_month = execute_query(query_month)

print("\n=== CA PAR MOIS ===")
print(df_month)


plt.figure(figsize=(12, 6))

plt.plot(
    df_month["month"],
    df_month["revenue"],
    marker="o"
)

plt.xlabel("Mois")
plt.ylabel("Chiffre d'affaires (MAD)")
plt.title("Évolution mensuelle du chiffre d'affaires")

plt.xticks(rotation=45)

plt.tight_layout()

plt.savefig(
    "results/revenue_by_month.png",
    dpi=300,
    bbox_inches="tight"
)

plt.close()


# ============================================================
# 8. GRAPHIQUE 5 — TOP 10 PRODUITS
# ============================================================

query_products = """
SELECT
    p.product_name AS product,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 10;
"""

df_products = execute_query(query_products)

print("\n=== TOP 10 PRODUITS ===")
print(df_products)


plt.figure(figsize=(10, 6))

bars = plt.barh(
    df_products["product"],
    df_products["revenue"]
)

plt.xlabel("Chiffre d'affaires (MAD)")
plt.ylabel("Produit")
plt.title("Top 10 des produits par chiffre d'affaires")

plt.gca().invert_yaxis()

for bar, value in zip(bars, df_products["revenue"]):
    plt.text(
        bar.get_width() + 3000,
        bar.get_y() + bar.get_height() / 2,
        f"{value:,.0f} MAD",
        va="center"
    )

plt.tight_layout()

plt.savefig(
    "results/top_10_products.png",
    dpi=300,
    bbox_inches="tight"
)

plt.close()


# ============================================================
# 9. GRAPHIQUE 6 — TOP 10 CLIENTS
# ============================================================

query_customers = """
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY revenue DESC
LIMIT 10;
"""

df_customers = execute_query(query_customers)

print("\n=== TOP 10 CLIENTS ===")
print(df_customers)


plt.figure(figsize=(10, 6))

bars = plt.barh(
    df_customers["customer"],
    df_customers["revenue"]
)

plt.xlabel("Chiffre d'affaires (MAD)")
plt.ylabel("Client")
plt.title("Top 10 des clients par chiffre d'affaires")

plt.gca().invert_yaxis()

for bar, value in zip(bars, df_customers["revenue"]):
    plt.text(
        bar.get_width() + 500,
        bar.get_y() + bar.get_height() / 2,
        f"{value:,.0f} MAD",
        va="center"
    )

plt.tight_layout()

plt.savefig(
    "results/top_10_customers.png",
    dpi=300,
    bbox_inches="tight"
)

plt.close()


# ============================================================
# 10. GRAPHIQUE 7 — MARGE PAR CATEGORIE
# ============================================================

query_margin = """
SELECT
    c.category_name AS category,
    ROUND(
        SUM(oi.quantity * (oi.unit_price - p.unit_cost)),
        2
    ) AS gross_margin
FROM categories c
JOIN products p
    ON p.category_id = c.category_id
JOIN order_items oi
    ON oi.product_id = p.product_id
GROUP BY c.category_id, c.category_name
ORDER BY gross_margin DESC;
"""

df_margin = execute_query(query_margin)

print("\n=== MARGE BRUTE PAR CATEGORIE ===")
print(df_margin)


plt.figure(figsize=(10, 6))

bars = plt.barh(
    df_margin["category"],
    df_margin["gross_margin"]
)

plt.xlabel("Marge brute (MAD)")
plt.ylabel("Catégorie")
plt.title("Marge brute par catégorie")

plt.gca().invert_yaxis()

for bar, value in zip(bars, df_margin["gross_margin"]):
    plt.text(
        bar.get_width() + 3000,
        bar.get_y() + bar.get_height() / 2,
        f"{value:,.0f} MAD",
        va="center"
    )

plt.tight_layout()

plt.savefig(
    "results/margin_by_category.png",
    dpi=300,
    bbox_inches="tight"
)

plt.close()


# ============================================================
# 11. FIN
# ============================================================

print("\n========================================")
print("Toutes les visualisations ont été créées.")
print("========================================")

print("\nFichiers générés :")

print("✓ results/revenue_by_category.png")
print("✓ results/revenue_by_region.png")
print("✓ results/revenue_by_year.png")
print("✓ results/revenue_by_month.png")
print("✓ results/top_10_products.png")
print("✓ results/top_10_customers.png")
print("✓ results/margin_by_category.png")