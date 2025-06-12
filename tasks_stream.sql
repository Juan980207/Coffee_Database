USE ROLE ACCOUNTADMIN;

USE DATABASE COFFEE;

USE SCHEMA COFFEE_SHOP;


CREATE OR REPLACE TABLE sales_summary(
    date DATE,
    id_store INT,
    id_product INT,
    total_quantity INT,
    total_value FLOAT
);

CREATE OR REPLACE STREAM stream_transactions_details
ON TABLE transactions_details;

SELECT * FROM stream_transactions_details;

CREATE OR REPLACE TASK update_sales_summary
SCHEDULE='5 MINUTE'
AS
INSERT INTO sales_summary
SELECT t.date,t.store_id AS id_store,p.product_id AS id_product,SUM(a.quantity) AS total_quantity,SUM(t.total) AS total_quantity
FROM (SELECT a.date,
FROM 
(SELECT * FROM stream_transactions_details
WHERE METADATA$ACTION IN ('INSERT','UPDATE')) AS a 
JOIN PRODUCTS AS p
ON stream_transactions_details.product_id=product.id 
JOIN transactions AS t
ON t.id=a.purchase_id
JOIN STORES AS s
ON s.id=t.store_id)

ALTER TASK update_sales_summary RESUME

----------------------
INSERT INTO  transactions VALUES(13093,'01/01/2024','8:00',20,'Good','Cash',2,10);


SELECT * FROM transactions;

INSERT INTO transactions_details VALUES(13093,7,3),(13092,1,2);

SELECT * FROM transactions_details;


ALTER TASK update_sales_summary SUSPEND;
