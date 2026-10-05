-- ============================================
-- Étape 2 : Créer les tables (PK, FK, NOT NULL, CHECK)
-- ============================================
USE ecommerce_analysis;

CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE customers (
    customer_id       INT AUTO_INCREMENT PRIMARY KEY,
    first_name        VARCHAR(50)  NOT NULL,
    last_name         VARCHAR(50)  NOT NULL,
    email             VARCHAR(120) NULL,
    city              VARCHAR(80)  NOT NULL,
    region            VARCHAR(50)  NOT NULL,
    registration_date DATE         NOT NULL
);

CREATE TABLE products (
    product_id   INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(120)   NOT NULL,
    category_id  INT            NOT NULL,
    unit_price   DECIMAL(10, 2) NOT NULL,
    unit_cost    DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES categories (category_id),
    CONSTRAINT chk_price_positive CHECK (unit_price > 0),
    CONSTRAINT chk_cost_positive  CHECK (unit_cost > 0),
    CONSTRAINT chk_margin         CHECK (unit_cost <= unit_price)
);

CREATE TABLE orders (
    order_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT          NOT NULL,
    order_date   DATE         NOT NULL,
    order_status VARCHAR(20)  NOT NULL DEFAULT 'completed',
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT            NOT NULL,
    product_id    INT            NOT NULL,
    quantity      INT            NOT NULL,
    unit_price    DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_items_order   FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id)
        REFERENCES products (product_id),
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_item_price CHECK (unit_price > 0)
);

CREATE TABLE payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT            NOT NULL,
    payment_date   DATE           NOT NULL,
    payment_method VARCHAR(30)    NOT NULL,
    payment_status VARCHAR(20)    NOT NULL DEFAULT 'paid',
    amount         DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT chk_amount CHECK (amount >= 0)
);
