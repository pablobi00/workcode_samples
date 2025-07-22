SHOW databases;

drop database db01 cascade;

drop table db01.t01text;
drop table db01.t02parquet;
drop table db01.t03orc;

drop database db01 cascade;

CREATE database db01;

USE db01;
SHOW TABLES;


CREATE table db01.t01text  (id INTEGER, name string, company string, province string) row format delimited fields terminated by ',' stored as TEXTFILE TBLPROPERTIES ('transactional'='false');
CREATE table db01.t02parquet  (id INTEGER, name string, company string, province string) stored as parquet TBLPROPERTIES ('transactional'='false');
CREATE table db01.t03orc (id INT, name string, company string, province string) STORED AS ORC TBLPROPERTIES ('transactional'='false');

USE db01;
SHOW TABLES;

describe database db01;
describe formatted db01.t01text;
describe formatted db01.t02parquet;
describe formatted db01.t03orc;


CREATE TEMPORARY TABLE IF NOT EXISTS Default.DataSource (id INTEGER, name string, company string, province string) row format delimited fields terminated by ',' stored as TEXTFILE TBLPROPERTIES ('transactional'='false');

-- COPY DATA FILES INTO LOCAL FILESYSTEM

LOAD DATA INPATH '/data/data50001.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/data50002.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/data50003.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/data50004.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/data50005.csv' OVERWRITE INTO TABLE Default.DataSource;
LOAD DATA INPATH '/data/data50006.csv' OVERWRITE INTO TABLE Default.DataSource;

DROP TABLE Default.DataSource;

FROM default.datasource
    insert into db01.t01text 
    SELECT * 
    insert into db01.t02parquet 
    SELECT * 
    insert into table db01.t03orc
    SELECT * ;

SELECT count(*) FROM db01.t01text;
SELECT count(*) FROM db01.t02parquet;
SELECT count(*) FROM db01.t03orc;
