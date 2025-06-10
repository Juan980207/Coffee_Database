--Create a view to share
CREATE VIEW IF NOT EXISTS sales_store
AS SELECT s.id AS store_id,td.quantity AS total,t.day AS date
FROM COFFEE.COFFEE_SHOP.stores AS s
JOIN COFFEE.COFFEE_SHOP.transactions AS t
ON s.id=t.store_id
JOIN COFFEE.COFFEE_SHOP.transactions_details AS td 
ON t.id=td.purchase_id;

SELECT * FROM sales_store;

--Create a view to share with analysis without sensitive information
CREATE SECURE VIEW IF NOT EXISTS sales_clients
AS SELECT c.id AS client_id,SUM(td.quantity) AS total
FROM COFFEE.COFFEE_SHOP.clients AS c
JOIN COFFEE.COFFEE_SHOP.transactions AS t
ON c.id=t.client_id
JOIN COFFEE.COFFEE_SHOP.transactions_details AS td 
ON t.id=td.purchase_id
GROUP BY c.id
ORDER BY SUM(td.quantity) DESC;

SELECT * FROM sales_clients;