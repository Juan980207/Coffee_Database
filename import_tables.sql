
USE ROLE ACCOUNTADMIN;

USE DATABASE COFFEE;

USE SCHEMA COFFEE_SHOP;

LIST @external_s3_stage;

CREATE OR REPLACE STAGE external_s3_stage
URL='s3://'
CREDENTIALS=(AWS_KEY_ID='',AWS_SECRET_KEY='')
FILE_FORMAT=(TYPE='CSV',FIELD_DELIMITER=',',SKIP_HEADER=1);

COPY INTO clients
FROM @external_s3_stage/Clients.csv
PURGE=TRUE;

COPY INTO stores
FROM @external_s3_stage/Stores.csv
PURGE=TRUE;

COPY INTO products
FROM @external_s3_stage/Products.csv
PURGE=TRUE;

COPY INTO transactions
FROM @external_s3_stage/Transactions.csv
PURGE=TRUE;

COPY INTO transactions_details
FROM @external_s3_stage/Transactions_details.csv
PURGE=TRUE;