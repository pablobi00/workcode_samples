SHOW databases;

DROP DATABASE db01int CASCADE;

CREATE database db01int;
USE db01int;
SHOW tables;

CREATE table db01int.orc_nt (id INTEGER, aNumber INTEGER) STORED AS ORC TBLPROPERTIES ( 'transactional'='false');
CREATE table db01int.text_nt  (id INTEGER, aNumber INTEGER) row format delimited fields terminated by ',' stored as TEXTFILE TBLPROPERTIES ( 'transactional'='false');
CREATE table db01int.parquet_nt  (id INTEGER, aNumber INTEGER) stored as parquet TBLPROPERTIES ( 'transactional'='false');
CREATE table db01int.parquet_t (id INTEGER, aNumber INTEGER) stored as parquet;
CREATE table db01int.text_t (id INTEGER, aNumber INTEGER) row format delimited fields terminated by ',' stored as TEXTFILE;
CREATE table db01int.orc_t (id INTEGER, aNumber INTEGER) stored as ORC;

DESCRIBE formatted db01int.orc_nt;
DESCRIBE formatted db01int.text_nt;
DESCRIBE formatted db01int.parquet_nt;
DESCRIBE formatted db01int.parquet_t;
DESCRIBE formatted db01int.text_t;
DESCRIBE formatted db01int.orc_t;

-- create temporary table to hold calculated values

CREATE TEMPORARY TABLE default.temp_table (id INTEGER, aNumber INTEGER);

insert into default.temp_table values (1,10),(2,20),(3,30);
insert into default.temp_table values (4,40),(5,50),(6,60);

-- Insert temporary table values into db01int tables

FROM default.temp_table
    insert into db01int.orc_nt  SELECT *
    insert into db01int.text_nt  SELECT *
    insert into db01int.parquet_nt  SELECT *
    insert into db01int.parquet_t  SELECT *
    insert into db01int.text_t  SELECT *
    insert into db01int.orc_t  SELECT *;

-- Drop table before doing inseret with next values set
DROP TABLE default.temp_table;

-- Select from tables

SELECT * FROM db01int.orc_nt;
SELECT * FROM db01int.text_nt;
SELECT * FROM db01int.parquet_nt;
SELECT * FROM db01int.parquet_t;
SELECT * FROM db01int.text_t;
SELECT * FROM db01int.orc_t;
