-- 1. PRIMARY KEY

ALTER TABLE olist_customers_dataset
ADD CONSTRAINT pk_customers
PRIMARY KEY (customer_id);


ALTER TABLE olist_products_dataset
ADD CONSTRAINT pk_products
PRIMARY KEY (product_id);


ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT pk_order_items
PRIMARY KEY (order_id, order_item_id);


-- 2. FOREIGN KEY

ALTER TABLE olist_orders_dataset
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES olist_customers_dataset(customer_id);

ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);

ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id)
REFERENCES olist_products_dataset(product_id);

-- Melihat semua data di tiap kolom
SELECT 
    -- Kolom dari tabel Customers
    c.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    
    -- Kolom dari tabel Orders
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    
    -- Kolom dari tabel Order Items
    oi.order_item_id,
    oi.price,
    oi.freight_value,
    
    -- Kolom dari tabel Products
    p.product_id,
    p.product_category_name

FROM olist_orders_dataset o
-- 1. Gabungkan Orders ke Customers
JOIN olist_customers_dataset c 
    ON o.customer_id = c.customer_id

-- 2. Gabungkan Orders ke Order Items
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id

-- 3. Gabungkan Order Items ke Products
JOIN olist_products_dataset p 
    ON oi.product_id = p.product_id

LIMIT 100;

-- Melihat struktur dan tipe data semua kolom
SELECT 
    table_name, 
    column_name, 
    data_type, 
    character_maximum_length
FROM information_schema.columns
WHERE table_name IN (
    'olist_customers_dataset', 
    'olist_products_dataset', 
    'olist_orders_dataset', 
    'olist_order_items_dataset'
)
ORDER BY table_name, ordinal_position;

-- Mengecek duplikasi primary key pada setiap table
SELECT 'olist_customers_dataset' AS nama_tabel, 'customer_id' AS kolom_pk, COUNT(*) AS jumlah_duplikat
FROM (
    SELECT customer_id 
    FROM olist_customers_dataset 
    GROUP BY customer_id 
    HAVING COUNT(*) > 1
) AS dup_customers

UNION ALL

SELECT 'olist_products_dataset', 'product_id', COUNT(*)
FROM (
    SELECT product_id 
    FROM olist_products_dataset 
    GROUP BY product_id 
    HAVING COUNT(*) > 1
) AS dup_products

UNION ALL

SELECT 'olist_orders_dataset', 'order_id', COUNT(*)
FROM (
    SELECT order_id 
    FROM olist_orders_dataset 
    GROUP BY order_id 
    HAVING COUNT(*) > 1
) AS dup_orders

UNION ALL

SELECT 'olist_order_items_dataset', 'order_id + order_item_id', COUNT(*)
FROM (
    SELECT order_id, order_item_id 
    FROM olist_order_items_dataset 
    GROUP BY order_id, order_item_id 
    HAVING COUNT(*) > 1
) AS dup_order_items;

-- Cek kolom kosong di tabel olist_customers_dataset
SELECT 
    'olist_customers_dataset' AS nama_tabel,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_customer_unique_id,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip_code,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM olist_customers_dataset;

-- Cek kolom kosong di tabel olist_products_dataset
SELECT 
    'olist_products_dataset' AS nama_tabel,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category_name,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS null_name_length,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS null_desc_length,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS null_photos_qty,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS null_weight,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS null_length,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS null_height,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS null_width
FROM olist_products_dataset;

-- Cek kolom kosong di tabel olist_orders_dataset
SELECT 
    'olist_orders_dataset' AS nama_tabel,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_purchase_time,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_approved_at,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_carrier_date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivered_date,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS null_estimated_date
FROM olist_orders_dataset;

-- Cek kolom kosong di tabel olist_order_items_dataset
SELECT 
    'olist_order_items_dataset' AS nama_tabel,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS null_item_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS null_shipping_limit,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS null_freight
FROM olist_order_items_dataset;

-- Mengecek ukuran dan volume data
SELECT 
    (SELECT COUNT(*) FROM olist_customers_dataset) AS total_customers,
    (SELECT COUNT(*) FROM olist_products_dataset) AS total_products,
    (SELECT COUNT(*) FROM olist_orders_dataset) AS total_orders,
    (SELECT COUNT(*) FROM olist_order_items_dataset) AS total_order_items;

-- Menangani NULL pada kolom product_category_name
UPDATE olist_products_dataset
SET product_category_name = 'Unassigned'
WHERE product_category_name IS NULL;

-- Menangani NULL pada kolom product_name_lenght, product_description_lenght, product_photos_qty
UPDATE olist_products_dataset
SET 
    product_name_lenght = COALESCE(product_name_lenght, 0),
    product_description_lenght = COALESCE(product_description_lenght, 0),
    product_photos_qty = COALESCE(product_photos_qty, 0)
WHERE 
    product_name_lenght IS NULL 
    OR product_description_lenght IS NULL 
    OR product_photos_qty IS NULL;

SELECT view_definition 
FROM information_schema.views 
WHERE table_name = 'vw_monthly_order_status';
DROP VIEW vw_monthly_order_status;
DROP VIEW IF EXISTS vw_monthly_order_status CASCADE;
DROP VIEW IF EXISTS vw_order_delivery_performance CASCADE;

-- Mengubah tipe data berakhiran 'date' ke format waktu
ALTER TABLE olist_orders_dataset
  ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP 
    USING NULLIF(order_purchase_timestamp, '')::TIMESTAMP,
    
  ALTER COLUMN order_approved_at TYPE TIMESTAMP 
    USING NULLIF(order_approved_at, '')::TIMESTAMP,
    
  ALTER COLUMN order_delivered_carrier_date TYPE TIMESTAMP 
    USING NULLIF(order_delivered_carrier_date, '')::TIMESTAMP,
    
  ALTER COLUMN order_delivered_customer_date TYPE TIMESTAMP 
    USING NULLIF(order_delivered_customer_date, '')::TIMESTAMP,
    
  ALTER COLUMN order_estimated_delivery_date TYPE TIMESTAMP 
    USING NULLIF(order_estimated_delivery_date, '')::TIMESTAMP;
  
  -- Mengubah data di kolom customer_zip_code_prefix dari tabel customers menjadi varchar
  ALTER TABLE olist_customers_dataset
  ALTER COLUMN customer_zip_code_prefix TYPE VARCHAR(5) 
  USING LPAD(customer_zip_code_prefix::TEXT, 5, '0');
  
  -- Mengubah tipe data float ke int
  ALTER TABLE olist_products_dataset
  ALTER COLUMN product_name_lenght TYPE INT USING product_name_lenght::INT,
  ALTER COLUMN product_description_lenght TYPE INT USING product_description_lenght::INT,
  ALTER COLUMN product_photos_qty TYPE INT USING product_photos_qty::INT;
  
  -- Mengecek Outlier
  SELECT 
    'price' AS kolom,
    MIN(price) AS min_val,
    ROUND(AVG(price)::numeric, 2) AS avg_val,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS median_val,
    MAX(price) AS max_val,
    ROUND(STDDEV(price)::numeric, 2) AS std_dev
FROM olist_order_items_dataset

UNION ALL

SELECT 
    'freight_value' AS kolom,
    MIN(freight_value) AS min_val,
    ROUND(AVG(freight_value)::numeric, 2) AS avg_val,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY freight_value) AS median_val,
    MAX(freight_value) AS max_val,
    ROUND(STDDEV(freight_value)::numeric, 2) AS std_dev
FROM olist_order_items_dataset;

-- ADVANCED ANALYSIS

-- Top 5 Kategori Produk Berdasarkan Pendapatan
SELECT 
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Sebaran Pelanggan Berdasarkan Wilayah (State)
SELECT 
    customer_state,
    COUNT(customer_id) AS total_customers
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 5;

-- Tren Pendapatan Bulanan (Monthly Revenue Trend)
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(oi.price)::numeric, 2) AS monthly_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY monthly_revenue DESC;

-- Status Pengiriman Pesanan (Order Status Breakdown)
SELECT 
    order_status,
    COUNT(order_id) AS total_orders,
    ROUND(100.0 * COUNT(order_id) / (SELECT COUNT(*) FROM olist_orders_dataset), 2) AS percentage
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-- Mencari produk terlaris berdasarkan wilayah
WITH regional_product_sales AS (
    SELECT 
        c.customer_state,
        COALESCE(p.product_category_name, 'Unassigned') AS product_category,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price)::numeric, 2) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_state 
            ORDER BY SUM(oi.price) DESC
        ) AS rank_by_revenue
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_products_dataset p ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state, p.product_category_name
)
SELECT 
    customer_state,
    product_category,
    total_orders,
    total_revenue
FROM regional_product_sales
WHERE rank_by_revenue = 1
ORDER BY total_revenue desc
limit 5;