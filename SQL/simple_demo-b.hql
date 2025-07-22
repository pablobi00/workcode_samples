show databases;

drop database db01 cascade;
drop table db01.t01text;

CREATE database db01;

CREATE table db01.t01text
    (id INTEGER, name string, company string, province string)
    row format delimited fields terminated by ',' 
    stored as TEXTFILE
    -- TBLPROPERTIES ('transactional'='false')
    ;

USE db01;
show tables;
describe database db01;
describe formatted db01.t01text;

CREATE TEMPORARY TABLE default.DataSource 
    (id INTEGER, name string, company string, province string)
    row format delimited fields terminated by ',' 
    stored as TEXTFILE
    -- TBLPROPERTIES ('transactional'='false')
    ;


LOAD DATA INPATH '/data/source/data50001.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50002.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50003.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50004.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50005.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50006.csv' OVERWRITE INTO TABLE Default.DataSource;



DROP TABLE Default.DataSource;

FROM default.DataSource insert into db01.t01text;
SELECT count(*) FROM db01.t01text;
SELECT * FROM db01.t01text ORDER BY id DESC;

-- COPY DATA FILES INTO LOCAL FILESYSTEM

LOAD DATA INPATH '/data/source/data50001.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50002.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50003.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50004.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50005.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/source/data50006.csv' OVERWRITE INTO TABLE Default.DataSource;

select * from default.datasource;

DROP TABLE Default.DataSource;

FROM default.datasource insert into db01.t01text;

SELECT count(*) FROM db01.t01text;