CREATE OR REPLACE DATABASE TPCDS;

CREATE OR REPLACE SCHEMA RAW;

CREATE OR REPLACE TABLE TPCDS.RAW.INVENTORY (
	inv_data_sk int NOT NULL,
    inv_item_sk int NOT NULL,
    inv_quantity_on_hand int m
    inv_warehouse_sk int NOT NULL
);

CREATE OR REPLACE USER users
password='user1234';

GRANT ROLE accountadmin to user users;

drop user users;
