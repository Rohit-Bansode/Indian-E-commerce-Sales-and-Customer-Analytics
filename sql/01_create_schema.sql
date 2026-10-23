-- Active: 1792738017810@@127.0.0.1@5432@indian_ecommerce

--- ------------------------------------
-- 1. Create Database as indian_ecommerce
-- -------------------------------------
Create DATABASE indian_ecommerce;

-- --------------------------------------
-- 2. Create Schema as ecommerce (That stores datasets)
-- --------------------------------------

DROP SCHEMA public CASCADE;
Create SCHEMA IF NOT EXISTS ecommerce;
SET search_path TO ecommerce,public;

-- ---------------------------------------------------------
--3. Drop Tables if they already exists (for clean re-runs)
-- ---------------------------------------------------------

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
Drop Table IF EXISTS customers CASCADE;

-- ------------------------------------------------------
-- 4. Create Tables
-- ------------------------------------------------------

----------------------- 1.Customers ----------------------

Create table customers (
    customer_id                 VARCHAR(50) PRIMARY KEY,
    customer_signup_date        DATE NOT NULL,
    gender                      VARCHAR(50) NOT NULL,
    age                         INTEGER,
    age_group                   VARCHAR(50) NOT NULL,
    state                       VARCHAR (50) NOT NULL,
    city                        VARCHAR (50) NOT NULL,
    pincode_prefix              INTEGER NOT NULL,
    customer_segment            VARCHAR(20) NOT NULL,
    preferred_device            VARCHAR(30),
    preferred_payment_method    VARCHAR(30) NOT NULL,
    total_orders                INTEGER NOT NULL DEFAULT 0,
    total_spend                 NUMERIC(12,2) NOT NULL DEFAULT 0,
    average_order_value         INTEGER NOT NULL DEFAULT 0,
    last_order_date             DATE,
    customer_status             VARCHAR(50) NOT NULL,
    loyalty_tier                VARCHAR(50) NOT NULL
);

----------------------- 2. Products ----------------------

CREATE TABLE products (
    product_id                  VARCHAR(20) PRIMARY KEY,
    product_name                VARCHAR(250) NOT NULL,
    category                    VARCHAR(50) NOT NULL,
    subcategory                 VARCHAR(50) NOT NULL,
    brand                       VARCHAR(50) NOT NULL,
    price                       NUMERIC(12,2) NOT NULL,
    cost_price                  NUMERIC(12,2) NOT NULL,
    discount_range              VARCHAR(20),
    rating_average              NUMERIC(3,2),
    rating_count                INTEGER NOT NULL DEFAULT 0,
    stock_quantity              INTEGER NOT NULL DEFAULT 0,
    product_launch_date         DATE NOT NULL,
    product_type                VARCHAR(20) NOT NULL,
    return_rate_baseline        NUMERIC(5,3) NOT NULL
)

----------------------- 3. Orders ----------------------

CREATE TABLE orders(
    order_id            VARCHAR(50) PRIMARY KEY,
    customer_id         VARCHAR(50) NOT NULL REFERENCES customers(customer_id),
    order_date          DATE NOT NULL,
    order_time          TIME NOT NULL,
    order_status        VARCHAR(30) NOT NULL,
    shipping_method     VARCHAR(30) NOT NULL,
    delivery_city       VARCHAR(30) NOT NULL,
    delivery_state      VARCHAR(30) NOT NULL,
    coupon_code         VARCHAR(30),
    discount_percentage NUMERIC(5,2) NOT NULL DEFAULT 0,
    subtotal            NUMERIC(12,2) NOT NULL,
    shipping_fee        NUMERIC(12,2) NOT NULL DEFAULT 0,
    tax_amount          NUMERIC(12,2) NOT NULL DEFAULT 0,
    final_amount        NUMERIC(12,2) NOT NULL
    
)

----------------------- 4. Order Items ----------------------
CREATE TABLE order_items (
    order_item_id               VARCHAR(20) PRIMARY KEY,
    order_id                    VARCHAR(20) NOT NULL REFERENCES orders(order_id),
    product_id                  VARCHAR(20) NOT NULL REFERENCES products(product_id),
    quantity                    INTEGER NOT NULL,
    unit_price                  NUMERIC(12,2) NOT NULL,
    discount_percentage         NUMERIC(5,2) NOT NULL DEFAULT 0,
    item_revenue                NUMERIC(12,2) NOT NULL,
    item_cost                   NUMERIC(12,2) NOT NULL,
    profit                      NUMERIC(12,2) NOT NULL
);

----------------------- 5. Payments ----------------------
CREATE TABLE payments (
    payment_id                  VARCHAR(20) PRIMARY KEY,
    order_id                    VARCHAR(20) NOT NULL REFERENCES orders(order_id),
    payment_date                DATE NOT NULL,
    payment_method              VARCHAR(30) NOT NULL,
    payment_status              VARCHAR(30) NOT NULL,
    amount_paid                 NUMERIC(12,2) NOT NULL,
    transaction_fee             NUMERIC(12,2) NOT NULL DEFAULT 0,
    refund_amount               NUMERIC(12,2) NOT NULL DEFAULT 0
);

----------------------- 6. Shipments ----------------------
CREATE TABLE shipments (
    shipment_id                 VARCHAR(20) PRIMARY KEY,
    order_id                    VARCHAR(20) NOT NULL REFERENCES orders(order_id),
    warehouse_city              VARCHAR(50) NOT NULL,
    delivery_city               VARCHAR(50) NOT NULL,
    shipping_method             VARCHAR(30) NOT NULL,
    dispatch_date               DATE NOT NULL,
    expected_delivery_date      DATE NOT NULL,
    actual_delivery_date        DATE,
    delivery_days               NUMERIC(6,2),
    delivery_status             VARCHAR(50) NOT NULL,
    delayed_flag                SMALLINT NOT NULL DEFAULT 0       -- 0 or 1
);

----------------------- 7. Returns ----------------------
CREATE TABLE returns (
    return_id                   VARCHAR(20) PRIMARY KEY,
    order_id                    VARCHAR(20) NOT NULL REFERENCES orders(order_id),
    customer_id                 VARCHAR(20) NOT NULL REFERENCES customers(customer_id),
    product_id                  VARCHAR(20) NOT NULL REFERENCES products(product_id),
    return_date                 DATE NOT NULL,
    return_reason               VARCHAR(100) NOT NULL,
    refund_amount               NUMERIC(12,2) NOT NULL,
    return_status               VARCHAR(30) NOT NULL
);

----------------------- 8. Customer Reviews ----------------------

CREATE TABLE customer_reviews (
    review_id                   VARCHAR(20) PRIMARY KEY,
    order_id                    VARCHAR(20) NOT NULL REFERENCES orders(order_id),
    customer_id                 VARCHAR(20) NOT NULL REFERENCES customers(customer_id),
    product_id                  VARCHAR(20) NOT NULL REFERENCES products(product_id),
    review_date                 DATE NOT NULL,
    rating                      SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_sentiment            VARCHAR(20),
    verified_purchase           BOOLEAN NOT NULL
);


-- ------------------------------------------------------------
-- 5. Create Indexes (for better query performance)
-- ------------------------------------------------------------

CREATE INDEX idx_customers_state            ON customers(state);
CREATE INDEX idx_customers_segment          ON customers(customer_segment);
CREATE INDEX idx_customers_status           ON customers(customer_status);

CREATE INDEX idx_products_category          ON products(category);
CREATE INDEX idx_products_brand             ON products(brand);

CREATE INDEX idx_orders_customer_id         ON orders(customer_id);
CREATE INDEX idx_orders_order_date          ON orders(order_date);
CREATE INDEX idx_orders_status              ON orders(order_status);
CREATE INDEX idx_orders_delivery_state      ON orders(delivery_state);

CREATE INDEX idx_order_items_order_id       ON order_items(order_id);
CREATE INDEX idx_order_items_product_id     ON order_items(product_id);

CREATE INDEX idx_payments_order_id          ON payments(order_id);
CREATE INDEX idx_payments_method            ON payments(payment_method);

CREATE INDEX idx_shipments_order_id         ON shipments(order_id);
CREATE INDEX idx_shipments_delayed_flag     ON shipments(delayed_flag);

CREATE INDEX idx_returns_order_id           ON returns(order_id);
CREATE INDEX idx_returns_reason             ON returns(return_reason);

CREATE INDEX idx_reviews_product_id         ON customer_reviews(product_id);
CREATE INDEX idx_reviews_rating             ON customer_reviews(rating);


SELECT 'Schema created successfully in database: indian_ecommerce' AS status;


SELECT current_database(), current_user;

SHOW search_path;