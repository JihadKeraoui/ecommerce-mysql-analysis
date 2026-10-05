# E-commerce Sales & Customer Analysis — MySQL & Docker

## 📌 Présentation

Ce projet consiste à réaliser une analyse complète des ventes et des clients d'une plateforme e-commerce à l'aide de **MySQL**, **SQL**, **Python** et **Docker**.

L'objectif est de construire une base de données relationnelle, d'intégrer un jeu de données réaliste, puis d'utiliser SQL pour analyser les performances commerciales, les produits, les clients, les régions et l'évolution des ventes dans le temps.

Le projet met également en œuvre des fonctionnalités SQL avancées telles que :

- les jointures ;
- les sous-requêtes ;
- les CTE ;
- les fonctions fenêtre ;
- les vues SQL ;
- les agrégations ;
- les calculs de KPI ;
- l'analyse de la marge ;
- le contrôle de la qualité des données.

Les visualisations et le dashboard seront réalisés dans une étape ultérieure.

---

# 🎯 Objectifs du projet

Les principaux objectifs sont :

1. Concevoir une base de données relationnelle e-commerce.
2. Créer les différentes tables et leurs relations.
3. Générer et intégrer un jeu de données réaliste.
4. Contrôler la qualité et la cohérence des données.
5. Analyser le chiffre d'affaires et les ventes.
6. Identifier les produits et catégories les plus performants.
7. Analyser les clients et leur comportement d'achat.
8. Comparer les performances des différentes régions.
9. Étudier l'évolution des ventes dans le temps.
10. Calculer des indicateurs clés de performance (KPI).
11. Utiliser des fonctionnalités SQL avancées.
12. Préparer les résultats pour les futures visualisations et le dashboard.

---

# 🛠️ Technologies utilisées

| Technologie | Utilisation |
|---|---|
| MySQL | Base de données relationnelle |
| SQL | Analyse et manipulation des données |
| Docker | Conteneurisation de MySQL |
| Python | Génération des données |
| Visual Studio Code | Développement et organisation du projet |
| MySQL Workbench | Connexion et exécution des requêtes |
| Git | Gestion de versions |
| GitHub | Publication future du projet |

---

# 🗂️ Structure du projet

```text
ecommerce-mysql-analysis/
│
├── python/
│   └── generate_data.py
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_insert_data.sql
│   ├── 04_data_quality.sql
│   ├── 05_basic_analysis.sql
│   ├── 06_join_analysis.sql
│   ├── 07_kpi.sql
│   ├── 08_product_analysis.sql
│   ├── 09_region_analysis.sql
│   ├── 10_time_analysis.sql
│   ├── 11_customer_analysis.sql
│   ├── 12_subqueries.sql
│   ├── 13_cte_analysis.sql
│   ├── 14_window_functions.sql
│   └── 15_views.sql
│
├── .env
├── .gitignore
├── docker-compose.yml
└── README.md
```

> Le fichier `.env` est utilisé uniquement localement pour les informations sensibles et est exclu du dépôt Git grâce au fichier `.gitignore`.

---

# 🗄️ Modèle de données

La base de données utilisée dans le projet s'appelle :

```text
ecommerce_analysis
```

Elle contient les tables principales suivantes :

```text
categories
     │
     └── products
             │
             └── order_items
                     │
                     └── orders
                             │
                             ├── customers
                             │
                             └── payments
```

## Tables principales

### `categories`

Contient les catégories de produits.

Principales informations :

- `category_id`
- `category_name`

### `products`

Contient les produits disponibles.

Principales informations :

- `product_id`
- `category_id`
- `product_name`
- `unit_price`
- `unit_cost`

### `customers`

Contient les informations relatives aux clients.

Principales informations :

- `customer_id`
- `first_name`
- `last_name`
- `email`
- `city`
- `region`

### `orders`

Contient les commandes.

Principales informations :

- `order_id`
- `customer_id`
- `order_date`
- `order_status`

### `order_items`

Contient le détail des produits présents dans les commandes.

Principales informations :

- `order_item_id`
- `order_id`
- `product_id`
- `quantity`
- `unit_price`

### `payments`

Contient les informations relatives aux paiements.

Principales informations :

- `payment_id`
- `order_id`
- `payment_date`
- `amount`
- `payment_status`

---

# 📊 Volume des données

Le jeu de données contient actuellement :

| Élément | Nombre |
|---|---:|
| Catégories | 8 |
| Produits | 40 |
| Clients | 750 |
| Commandes | 1 000 |
| Lignes de commande | 2 510 |
| Paiements | 910 |

Les données ont été générées avec Python afin de disposer d'un jeu de données suffisamment réaliste pour réaliser différentes analyses SQL.

Le dataset contient également volontairement certaines situations permettant de tester la qualité des données :

- clients sans adresse e-mail ;
- adresses e-mail dupliquées ;
- différents statuts de paiement ;
- commandes sans paiement associé.

---

# 🐳 Environnement Docker

Le projet utilise **MySQL exécuté dans un conteneur Docker**.

## Configuration actuelle

```text
Container : mysql-ecommerce
Image     : mysql:latest
MySQL     : 26.7.0
Host      : 127.0.0.1
Port      : 3306
Database  : ecommerce_analysis
```

## Démarrer MySQL

Depuis le répertoire du projet :

```bash
docker compose up -d
```

## Vérifier le conteneur

```bash
docker ps
```

## Vérifier la version du serveur MySQL

```bash
docker exec mysql-ecommerce mysql -uroot -p -e "SELECT VERSION();"
```

## Arrêter le conteneur

```bash
docker compose down
```

Les données MySQL sont conservées dans le volume Docker :

```text
mysql_data
```

> La version actuelle du serveur MySQL utilisée dans l'environnement de développement est 26.7.0.

---

# 🔐 Configuration et sécurité

Les informations sensibles sont stockées localement dans le fichier `.env`.

Exemple :

```env
MYSQL_ROOT_PASSWORD=YOUR_MYSQL_PASSWORD
```

Le fichier `.env` est exclu du dépôt Git grâce au fichier `.gitignore`.

> ⚠️ Le mot de passe réel utilisé en local ne doit jamais être publié sur GitHub.

---

# 🔌 Connexion à MySQL

Les paramètres de connexion utilisés localement sont :

```text
Host     : 127.0.0.1
Port     : 3306
User     : root
Database : ecommerce_analysis
Password : défini dans .env
```

La connexion peut être effectuée avec MySQL Workbench ou tout autre client MySQL compatible.

---

# ▶️ Exécution du projet

Les scripts SQL doivent être exécutés dans l'ordre suivant :

```text
01_create_database.sql
02_create_tables.sql
03_insert_data.sql
04_data_quality.sql
05_basic_analysis.sql
06_join_analysis.sql
07_kpi.sql
08_product_analysis.sql
09_region_analysis.sql
10_time_analysis.sql
11_customer_analysis.sql
12_subqueries.sql
13_cte_analysis.sql
14_window_functions.sql
15_views.sql
```

---

# 📋 Description des scripts SQL

## 01 — Création de la base de données

```text
01_create_database.sql
```

Ce script :

- supprime l'ancienne base si elle existe ;
- crée la base `ecommerce_analysis` ;
- configure l'encodage `utf8mb4`.

---

## 02 — Création des tables

```text
02_create_tables.sql
```

Création des tables :

- `categories`
- `customers`
- `products`
- `orders`
- `order_items`
- `payments`

Les clés primaires, clés étrangères et contraintes d'intégrité sont également définies.

---

## 03 — Insertion des données

```text
03_insert_data.sql
```

Insertion du jeu de données généré avec Python.

---

## 04 — Data Quality

```text
04_data_quality.sql
```

Contrôles réalisés :

- clients sans email ;
- emails dupliqués ;
- prix invalides ;
- quantités invalides ;
- commandes orphelines ;
- lignes de commande orphelines ;
- incohérences entre commandes et paiements.

---

## 05 — Analyse de base

```text
05_basic_analysis.sql
```

Calcul de plusieurs indicateurs de base :

- nombre de clients ;
- nombre de commandes ;
- nombre de produits ;
- chiffre d'affaires ;
- unités vendues ;
- panier moyen ;
- nombre moyen d'articles par commande.

---

## 06 — Analyse avec JOIN

```text
06_join_analysis.sql
```

Analyse :

- des meilleurs clients ;
- du chiffre d'affaires par catégorie ;
- des produits les plus performants ;
- du chiffre d'affaires par région.

---

## 07 — KPI

```text
07_kpi.sql
```

Calcul de plusieurs indicateurs de performance :

- chiffre d'affaires ;
- nombre de commandes ;
- nombre de clients ;
- unités vendues ;
- panier moyen ;
- marge brute ;
- taux de marge.

---

## 08 — Analyse des produits

```text
08_product_analysis.sql
```

Analyse :

- du chiffre d'affaires par produit ;
- des produits les plus vendus ;
- des produits les moins performants ;
- de la marge par catégorie ;
- du taux de marge par catégorie.

---

## 09 — Analyse régionale

```text
09_region_analysis.sql
```

Comparaison des régions selon :

- chiffre d'affaires ;
- nombre de clients ;
- nombre de commandes ;
- unités vendues ;
- panier moyen ;
- marge ;
- taux de marge ;
- classement ;
- part du chiffre d'affaires.

---

## 10 — Analyse temporelle

```text
10_time_analysis.sql
```

Analyse :

- du chiffre d'affaires annuel ;
- du chiffre d'affaires trimestriel ;
- du chiffre d'affaires mensuel ;
- du nombre de commandes ;
- du classement des périodes ;
- du panier moyen ;
- de l'évolution des ventes.

---

## 11 — Analyse des clients

```text
11_customer_analysis.sql
```

Analyse :

- des meilleurs clients ;
- du nombre de commandes par client ;
- du chiffre d'affaires par client ;
- du panier moyen ;
- des clients actifs ;
- des clients n'ayant jamais commandé.

---

## 12 — Sous-requêtes

```text
12_subqueries.sql
```

Utilisation de sous-requêtes pour réaliser différentes analyses comparatives.

Exemples :

- clients ayant un chiffre d'affaires supérieur à la moyenne ;
- produits dont les performances sont supérieures à la moyenne ;
- recherche d'entités sans activité.

---

## 13 — CTE

```text
13_cte_analysis.sql
```

Utilisation des **Common Table Expressions (`WITH`)** pour construire des analyses complexes en plusieurs étapes.

Exemples :

- chiffre d'affaires des clients supérieur à la moyenne ;
- évolution mensuelle ;
- comparaison avec les périodes précédentes ;
- part des catégories dans le chiffre d'affaires.

---

## 14 — Window Functions

```text
14_window_functions.sql
```

Utilisation notamment de :

- `RANK()`
- `DENSE_RANK()`
- `ROW_NUMBER()`
- `LAG()`
- `LEAD()`
- `NTILE()`
- `FIRST_VALUE()`

ainsi que :

- sommes cumulées ;
- analyses Pareto ;
- moyennes mobiles ;
- comparaison entre périodes.

---

## 15 — Views

```text
15_views.sql
```

Création de plusieurs vues analytiques réutilisables :

```text
vw_customer_revenue
vw_product_performance
vw_monthly_revenue
vw_region_kpi
```

Ces vues permettent de simplifier les analyses futures et de préparer les données pour les visualisations.

---

# 📈 Principaux résultats

Les principaux indicateurs obtenus à partir des analyses SQL sont :

| KPI | Valeur |
|---|---:|
| Catégories | 8 |
| Produits | 40 |
| Clients | 750 |
| Commandes | 1 000 |
| Lignes de commande | 2 510 |
| Paiements | 910 |
| Unités vendues | 5 064 |
| Chiffre d'affaires | 2 220 022,87 |
| Panier moyen | ≈ 2 220 |

---

# 💡 Business Insights

## Performance des catégories

La catégorie **Laptops** génère le chiffre d'affaires le plus élevé :

```text
812 048,35
```

## Rentabilité

La catégorie **Keyboards** présente le meilleur taux de marge :

```text
44,01 %
```

La catégorie **Monitors** présente le taux de marge le plus faible :

```text
21,09 %
```

## Performance régionale

La **Bretagne** génère le chiffre d'affaires régional le plus élevé :

```text
343 639,41
```

Les **Hauts-de-France** présentent le panier moyen régional le plus élevé :

```text
2 485,37
```

## Évolution annuelle

| Année | Chiffre d'affaires |
|---|---:|
| 2023 | 760 050,77 |
| 2024 | 692 697,79 |
| 2025 | 767 274,31 |

Le chiffre d'affaires diminue en 2024 par rapport à 2023, puis progresse de nouveau en 2025.

Le chiffre d'affaires de 2025 est légèrement supérieur à celui de 2023.

---

# 💰 Analyse de la marge

Le projet permet de calculer :

- la marge brute ;
- le taux de marge ;
- la marge par catégorie ;
- la comparaison entre chiffre d'affaires et coût produit.

Les calculs sont réalisés principalement dans :

```text
sql/07_kpi.sql
sql/08_product_analysis.sql
```

> La valeur totale de la marge brute n'est pas encore affichée dans ce README, car le résultat numérique du KPI doit encore être validé.

---

# 🐍 Génération des données avec Python

Le fichier :

```text
python/generate_data.py
```

est utilisé pour générer le jeu de données du projet.

Python permet de préparer un jeu de données suffisamment volumineux et réaliste pour réaliser les différentes analyses SQL.

Le fichier `03_insert_data.sql` contient ensuite les données destinées à être insérées dans MySQL.

---

# 📊 Visualisations — prochaine étape

Les visualisations ne sont pas encore intégrées au projet.

Elles seront réalisées dans une prochaine étape à partir des résultats SQL.

Les graphiques prévus comprennent notamment :

- chiffre d'affaires par catégorie ;
- chiffre d'affaires par région ;
- évolution du chiffre d'affaires dans le temps ;
- Top 10 des produits ;
- Top 10 des clients ;
- marge par catégorie.

Les visualisations seront réalisées avec Python, Pandas et Matplotlib.

---

# 📊 Dashboard — évolution prévue

Une étape ultérieure consistera à construire un dashboard permettant de présenter :

- les KPI principaux ;
- l'évolution du chiffre d'affaires ;
- les performances par catégorie ;
- les performances régionales ;
- les produits les plus performants ;
- les indicateurs de marge.

Le dashboard sera développé après la finalisation des visualisations.

---

# 🧠 Compétences développées

## SQL

- `SELECT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `JOIN`
- sous-requêtes
- `EXISTS`
- `NOT EXISTS`
- CTE
- Window Functions
- Views
- fonctions d'agrégation
- fonctions temporelles

## Data Analysis

- analyse des ventes ;
- analyse des clients ;
- analyse des produits ;
- analyse géographique ;
- analyse temporelle ;
- calcul de KPI ;
- analyse de marge ;
- contrôle de la qualité des données.

## Technologies

- Python
- MySQL
- SQL
- Docker
- Visual Studio Code
- MySQL Workbench
- Git
- GitHub

---

# 🚀 Évolutions prévues

Les prochaines étapes du projet sont :

1. Créer les visualisations avec Python.
2. Calculer et valider les KPI complémentaires.
3. Ajouter l'analyse graphique de la marge.
4. Créer un dashboard.
5. Approfondir les business insights.
6. Nettoyer et finaliser le projet.
7. Initialiser Git.
8. Publier le projet sur GitHub.

---

# 🔐 Sécurité

Les informations sensibles ne doivent pas être publiées dans le dépôt GitHub.

Le projet utilise un fichier `.env` pour les variables sensibles.

Le fichier `.gitignore` exclut notamment :

```text
.env
.env.*
__pycache__/
.venv/
*.log
```

> Le mot de passe MySQL réel reste uniquement dans l'environnement local.

---

# 👨‍💻 Auteur

Projet réalisé dans le cadre d'un portfolio personnel en **Data Analysis**.

### Technologies principales

```text
Python
SQL
MySQL
Docker
Git
GitHub
Data Analysis
```

---

## ⭐ À propos du projet

Ce projet a pour objectif de démontrer la capacité à :

- concevoir une base de données relationnelle ;
- manipuler et analyser des données avec SQL ;
- utiliser des fonctionnalités SQL avancées ;
- contrôler la qualité des données ;
- calculer des KPI ;
- analyser les performances commerciales ;
- transformer des données brutes en informations exploitables ;
- préparer les résultats pour une future visualisation et un dashboard.