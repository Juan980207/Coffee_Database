USE ROLE ACCOUNTADMIN;

USE DATABASE COFFEE;

USE SCHEMA COFFEE_SHOP;

--Create a table to analyze information
CREATE IF NOT EXISTS TABLE sales_summary(
    date DATE,
    id_store INT,
    id_product INT,
    total_quantity INT,
    total_value FLOAT
);

--Simulate the input of new transactions
--INSERT INTO  transactions VALUES(13099,'01/01/2024','8:00',20,'Good','Cash',2,10);

--Chech the change in the transactions
--SELECT * FROM transactions;
--Input iformation to the example
--INSERT INTO transactions_details VALUES(13099,7,3),(13098,1,2);
--Check the new record
--SELECT * FROM transactions_details;
--Chech that the table
--SELECT * FROM sales_summary;
--Create the stream of the main table
CREATE OR REPLACE STREAM stream_transactions_details ON TABLE transactions_details;
--Check the operations saved
--SELECT * FROM stream_transactions_details;
--

CREATE OR REPLACE TASK update_sales_summary
SCHEDULE='1 MINUTE'
AS
INSERT INTO sales_summary
SELECT t.day,t.store_id,std.product_id,SUM(std.quantity),SUM(t.total)
FROM stream_transactions_details AS std
JOIN transactions AS t
ON std.purchase_id=t.id
GROUP BY t.day,t.store_id,std.product_id;

ALTER TASK update_sales_summary RESUME;

ALTER TASK update_sales_summary SUSPEND;