# 📊 E-commerce Sales & Customer Analysis — MySQL, Docker & Python

Analyse complète des ventes et des clients d'une plateforme e-commerce à l'aide de **MySQL**, **SQL**, **Docker**, **Python**, **Pandas** et **Matplotlib**.

Le projet couvre l'ensemble du processus d'analyse de données :

**Génération des données → Modélisation MySQL → Qualité des données → Analyse SQL → KPI → Analyses avancées → Visualisations Python → GitHub**

---

## 🎯 Objectifs du projet

Ce projet a pour objectif de construire une analyse complète d'une base de données e-commerce afin de répondre à plusieurs questions métier :

- Quel est le chiffre d'affaires total ?
- Quelles sont les catégories les plus performantes ?
- Quels sont les produits qui génèrent le plus de chiffre d'affaires ?
- Quels sont les meilleurs clients ?
- Quelles régions génèrent le plus de revenus ?
- Comment évoluent les ventes dans le temps ?
- Quelle est la marge brute par catégorie ?
- Quels clients n'ont jamais effectué de commande ?
- Quels produits n'ont jamais été vendus ?
- Comment identifier les tendances et performances commerciales ?

Le projet permet également de mettre en pratique des techniques SQL avancées telles que :

- `JOIN`
- `GROUP BY`
- `HAVING`
- sous-requêtes
- `CTE`
- fonctions de fenêtre
- `RANK`
- `DENSE_RANK`
- `ROW_NUMBER`
- `LAG`
- `LEAD`
- agrégations
- création de `VIEW`

---

# 🛠️ Technologies utilisées

### Base de données

- MySQL 8.4
- SQL
- MySQL Workbench
- MySQL Connector/Python

### Conteneurisation

- Docker
- Docker Compose

### Analyse et visualisation

- Python 3.13
- Pandas
- Matplotlib
- SQLAlchemy
- python-dotenv

### Développement

- Visual Studio Code
- Git
- GitHub

---

# 🗂️ Structure du projet

```text
ecommerce-mysql-analysis/
│
├── python/
│   ├── generate_data.py
│   └── visualize_data.py
│
├── results/
│   ├── margin_by_category.png
│   ├── revenue_by_category.png
│   ├── revenue_by_month.png
│   ├── revenue_by_region.png
│   ├── revenue_by_year.png
│   ├── top_10_customers.png
│   └── top_10_products.png
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
├── .env.example
├── .gitignore
├── docker-compose.yml
└── README.md

Le fichier .env contenant les informations de connexion locales n'est pas publié sur GitHub.

🐳 Docker & MySQL
La base de données MySQL est exécutée dans un conteneur Docker.
Le fichier docker-compose.yml permet de démarrer automatiquement le serveur MySQL avec :
- MySQL 8.4
- port 3306
- base de données ecommerce_analysis
- volume persistant pour les données
Exemple de configuration :
services:
  mysql:
    image: mysql:8.4
    container_name: ecommerce_mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ecommerce_analysis
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:

🔐 Configuration des variables d'environnement
Les informations sensibles sont stockées dans un fichier .env local.
Exemple de fichier .env :
MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=YOUR_PASSWORD
MYSQL_DATABASE=ecommerce_analysis

Un fichier .env.example est fourni dans le repository afin d'indiquer les variables nécessaires sans exposer le véritable mot de passe.
Le fichier .env est exclu de Git grâce au .gitignore.
🚀 Installation et exécution
1. Cloner le repository
git clone https://github.com/JihadKeraoui/ecommerce-mysql-analysis.git

Puis :
cd ecommerce-mysql-analysis

2. Créer le fichier .env
Copier .env.example vers .env :
copy .env.example .env

Sous Linux/macOS :
cp .env.example .env

Puis renseigner les paramètres MySQL.
3. Démarrer MySQL avec Docker
docker compose up -d

Vérifier que le conteneur fonctionne :
docker ps

🗄️ Création et alimentation de la base
Les scripts SQL doivent être exécutés dans l'ordre.
01 — Création de la base
sql/01_create_database.sql

Création de :
ecommerce_analysis

avec l'encodage utf8mb4.
02 — Création des tables
sql/02_create_tables.sql

Création des principales tables :
- categories
- customers
- products
- orders
- order_items
- payments
Les relations entre les tables sont définies avec des clés primaires et étrangères.
03 — Insertion des données
sql/03_insert_data.sql

Le script contient les données générées pour alimenter la base.
📦 Volume des données
La base contient actuellement :
Table	Nombre de lignes
Categories	8
Products	40
Customers	750
Orders	1 000
Order items	2 510
Payments	910


Les données permettent notamment de travailler sur :
- les ventes ;
- les clients ;
- les produits ;
- les catégories ;
- les régions ;
- les paiements ;
- les performances commerciales.
🔎 Analyse de la qualité des données
Le script :
sql/04_data_quality.sql

permet de contrôler plusieurs problèmes potentiels :
- clients sans adresse e-mail ;
- doublons d'e-mails ;
- prix invalides ;
- quantités invalides ;
- commandes orphelines ;
- lignes de commandes orphelines ;
- incohérences entre les montants des commandes et des paiements.
Quelques anomalies volontairement présentes dans le jeu de données permettent de tester les contrôles de qualité.
📈 Analyses SQL
05 — Analyse de base
sql/05_basic_analysis.sql

Principaux résultats :
Indicateur	Résultat
Clients	750
Commandes	1 000
Produits	40
Chiffre d'affaires	2 220 022,87 MAD
Unités vendues	5 064


Le panier moyen est d'environ :
2 220,02 MAD

06 — Analyses avec JOIN
sql/06_join_analysis.sql

Cette étape analyse :
- les meilleurs clients ;
- le chiffre d'affaires par catégorie ;
- les meilleurs produits ;
- le chiffre d'affaires par région.
CA par catégorie
Catégorie	CA
Laptops	812 048,35 MAD
Smartphones	592 291,27 MAD
Tablets	291 668,16 MAD
Monitors	223 062,89 MAD
Printers	120 062,39 MAD
Headphones	92 088,74 MAD
Keyboards	59 036,69 MAD
Accessories	29 764,38 MAD


Les Laptops représentent la catégorie avec le chiffre d'affaires le plus élevé.
📊 KPI commerciaux
Le fichier :
sql/07_kpi.sql

regroupe les principaux indicateurs de performance :
- chiffre d'affaires ;
- nombre de commandes ;
- nombre d'unités vendues ;
- panier moyen ;
- nombre de clients ;
- performance commerciale ;
- marge brute ;
- taux de marge.
Le chiffre d'affaires total est de :
2 220 022,87 MAD

La marge brute totale calculée à partir des coûts produits est d'environ :
740 252,27 MAD

soit un taux de marge global d'environ :
33,34 %

🏆 Analyse des produits
Le script :
sql/08_product_analysis.sql

permet d'identifier :
- les produits ayant le plus gros chiffre d'affaires ;
- les produits les plus vendus en volume ;
- les produits ayant les plus faibles performances ;
- la marge par catégorie ;
- le taux de marge par catégorie.
Exemples de produits les plus performants en CA
- Phone Max
- Laptop Pro 16
- Laptop Ultra 15
- Phone X Pro
- Laptop Air 13
Le produit générant le plus de chiffre d'affaires est :
Phone Max
≈ 230 650,92 MAD

🌍 Analyse régionale
Le script :
sql/09_region_analysis.sql

analyse :
- le chiffre d'affaires par région ;
- le nombre de clients ;
- le nombre de commandes ;
- les unités vendues ;
- le panier moyen ;
- la marge ;
- le taux de marge ;
- le classement des régions ;
- la contribution de chaque région au CA total.
Classement par chiffre d'affaires
Région	CA
Bretagne	343 639,41 MAD
Occitanie	321 350,48 MAD
Hauts-de-France	320 612,75 MAD
Nouvelle-Aquitaine	286 914,33 MAD
Grand Est	283 141,69 MAD
Auvergne-Rhône-Alpes	232 926,88 MAD
Île-de-France	219 310,17 MAD
Provence-Alpes-Côte d’Azur	212 127,16 MAD


La Bretagne est la région générant le chiffre d'affaires le plus élevé.
📅 Analyse temporelle
Le fichier :
sql/10_time_analysis.sql

permet d'analyser les ventes :
- par année ;
- par trimestre ;
- par mois ;
- avec classement des périodes ;
- avec panier moyen mensuel ;
- avec comparaison entre périodes.
CA annuel
Année	CA
2023	760 050,77 MAD
2024	692 697,79 MAD
2025	767 274,31 MAD


L'année 2024 présente une baisse par rapport à 2023, tandis que 2025 montre un rebond et dépasse légèrement le niveau de 2023.
👥 Analyse des clients
Le fichier :
sql/11_customer_analysis.sql

permet d'analyser :
- les meilleurs clients ;
- le nombre de commandes par client ;
- le chiffre d'affaires par client ;
- le panier moyen ;
- les clients actifs ;
- les clients inactifs.
🔍 Sous-requêtes
Le fichier :
sql/12_subqueries.sql

met en pratique les sous-requêtes SQL pour répondre à différentes questions analytiques.
Exemples :
- clients ayant un CA supérieur à la moyenne ;
- produits dépassant certaines performances ;
- comparaison avec des valeurs globales ;
- identification de produits ou clients sans activité.
🧩 Common Table Expressions — CTE
Le fichier :
sql/13_cte_analysis.sql

utilise les CTE (WITH) pour construire des analyses SQL plus lisibles et plus faciles à maintenir.
Les analyses comprennent notamment :
- CA client comparé à la moyenne ;
- évolution mensuelle ;
- comparaison avec le mois précédent ;
- contribution des catégories au CA.
📊 Window Functions
Le fichier :
sql/14_window_functions.sql

met en pratique plusieurs fonctions analytiques :
- RANK()
- DENSE_RANK()
- ROW_NUMBER()
- LAG()
- LEAD()
- NTILE()
- FIRST_VALUE()
- sommes cumulées ;
- moyenne mobile.
Ces fonctions permettent d'aller au-delà des simples agrégations SQL.
👁️ Views
Le fichier :
sql/15_views.sql

crée plusieurs vues analytiques réutilisables :
vw_customer_revenue
vw_product_performance
vw_monthly_revenue
vw_region_kpi

Ces vues facilitent la réutilisation des résultats analytiques et constituent une base pour de futures analyses ou dashboards.
🐍 Analyse et visualisation avec Python
Les résultats SQL sont complétés par une analyse Python.
Le script principal est :
python/visualize_data.py

Il utilise :
- Python ;
- Pandas ;
- SQLAlchemy ;
- MySQL Connector ;
- Matplotlib ;
- python-dotenv.
La connexion à MySQL utilise les variables définies dans .env.
📊 Visualisations
Sept visualisations sont actuellement disponibles dans le dossier results/.
1. Chiffre d'affaires par catégorie
results/revenue_by_category.png

Permet de comparer la contribution des différentes catégories au chiffre d'affaires.
2. Chiffre d'affaires par région
results/revenue_by_region.png

Permet d'identifier les régions les plus performantes.
3. Évolution annuelle du chiffre d'affaires
results/revenue_by_year.png

Permet de comparer les performances entre 2023, 2024 et 2025.
4. Évolution mensuelle du chiffre d'affaires
results/revenue_by_month.png

Permet d'observer les variations mensuelles et les périodes de forte ou faible activité.
5. Top 10 des produits
results/top_10_products.png

Classe les dix produits générant le plus de chiffre d'affaires.
6. Top 10 des clients
results/top_10_customers.png

Identifie les dix clients générant le plus de chiffre d'affaires.
7. Marge brute par catégorie
results/margin_by_category.png

Compare la marge brute générée par chaque catégorie.
💡 Principaux insights
L'analyse permet notamment de constater que :
- les Laptops génèrent le chiffre d'affaires le plus élevé ;
- les Smartphones constituent également une catégorie majeure ;
- la Bretagne est la première région en chiffre d'affaires ;
- le chiffre d'affaires annuel baisse en 2024 avant de rebondir en 2025 ;
- le chiffre d'affaires mensuel présente une forte variabilité ;
- Phone Max est le produit générant le plus de CA ;
- les Laptops génèrent la marge brute totale la plus importante ;
- les Keyboards présentent le meilleur taux de marge parmi les catégories analysées ;
- la marge brute totale est d'environ 740 252 MAD ;
- le taux de marge global est d'environ 33,34 %.
📊 Dashboard
Les analyses et visualisations actuelles sont produites avec Python, Pandas et Matplotlib.
Une évolution possible du projet consiste à créer un dashboard interactif avec Power BI afin de centraliser :
- les KPI principaux ;
- le chiffre d'affaires ;
- l'évolution temporelle ;
- les performances par catégorie ;
- les performances par région ;
- les produits les plus performants ;
- les meilleurs clients ;
- les indicateurs de marge.
Le dashboard n'est pas encore intégré au projet actuel.
🧠 Compétences développées
SQL
- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- JOIN
- LEFT JOIN
- sous-requêtes
- NOT EXISTS
- fonctions d'agrégation
- CTE
- Window Functions
- RANK
- DENSE_RANK
- ROW_NUMBER
- LAG
- LEAD
- NTILE
- FIRST_VALUE
- Views
- Data Quality
- KPI
Data Analysis
- analyse des ventes ;
- analyse des clients ;
- analyse des produits ;
- analyse géographique ;
- analyse temporelle ;
- analyse de la marge ;
- calcul des KPI ;
- contrôle de la qualité des données ;
- interprétation des résultats.
Python
- connexion à MySQL ;
- Pandas ;
- DataFrame ;
- SQLAlchemy ;
- gestion des variables d'environnement ;
- Matplotlib ;
- génération automatisée de graphiques.
Data Visualization
- graphiques en barres ;
- graphiques horizontaux ;
- courbes temporelles ;
- classement Top 10 ;
- visualisation de la marge.
Technologies
- MySQL
- Docker
- Docker Compose
- Python
- Pandas
- Matplotlib
- SQLAlchemy
- Visual Studio Code
- Git
- GitHub
🔐 Sécurité
Les informations sensibles ne doivent jamais être publiées dans le repository.
Le projet utilise :
.env

pour les informations de connexion locales.
Le fichier .env est ignoré par Git.
Un fichier :
.env.example

est fourni avec des valeurs génériques afin d'indiquer la configuration nécessaire.
Aucun mot de passe réel ne doit être présent dans le repository.
🚀 Évolutions possibles
Le projet actuel couvre l'ensemble du processus d'analyse, de la préparation des données jusqu'aux visualisations.
Des améliorations peuvent être ajoutées ultérieurement :
1. Créer un dashboard interactif avec Power BI.
2. Ajouter des KPI commerciaux supplémentaires.
3. Approfondir l'analyse de la marge par produit et par région.
4. Ajouter une segmentation des clients.
5. Ajouter une analyse RFM.
6. Ajouter une analyse prédictive des ventes.
7. Automatiser l'actualisation des données.
8. Ajouter des tests automatisés de qualité des données.
9. Mettre en place une pipeline ETL complète.
📌 Résumé du projet
                  DONNÉES E-COMMERCE
                         │
                         ▼
                  Génération Python
                         │
                         ▼
                    MySQL / Docker
                         │
                         ▼
                  Data Quality
                         │
                         ▼
                   Analyse SQL
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
         KPI            CTE       Window Functions
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                       Views
                         │
                         ▼
                  Python / Pandas
                         │
                         ▼
                     Matplotlib
                         │
                         ▼
                  7 Visualisations
                         │
                         ▼
                       GitHub

👤 Auteur
Jihad Keraoui
Projet réalisé dans le cadre de la constitution d'un portfolio personnel en Data Analysis / Data Engineering.
🔗 GitHub :
https://github.com/JihadKeraoui
