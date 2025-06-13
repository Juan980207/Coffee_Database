USE ROLE ACCOUNTADMIN;

USE DATABASE COFFEE;

USE SCHEMA COFFEE_SHOP;

CREATE WAREHOUSE mi_warehouse_xsmall
  WITH
  WAREHOUSE_SIZE = XSMALL
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE DYNAMIC TABLE customer_ranking (
    ranking INTEGER,
    customer_id INTEGER,
    name STRING,
    email VARCHAR,
    total INTEGER
)
TARGET_LAG='5 MINUTE'
REFRESH_MODE=INCREMENTAL
INITIALIZE=ON_CREATE
WAREHOUSE=mi_warehouse_xsmall
AS
WITH customers_total AS(
    SELECT rank() OVER (ORDER BY sum(td.quantity) DESC) AS ranking,c.id,c.name,c.email,SUM(td.quantity) AS total
    FROM
    CLIENTS AS c JOIN
    TRANSACTIONS AS t
    ON c.id=t.client_id
    JOIN TRANSACTIONS_DETAILS AS td 
    ON t.id=td.purchase_id
    GROUP BY c.id,c.name,c.email
)
SELECT ranking,id,name,email,total
FROM customers_total;

SHOW DYNAMIC TABLES;

