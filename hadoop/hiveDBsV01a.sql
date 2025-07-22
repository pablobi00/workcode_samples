-- hiveDBsV01a.sql
-- Create HIVE DBs
-- Version 2021.07.09.a

-- show columns names & list databases

set hive.cli.print.header=true;
show databases;

-- dba01 - ORC

create database dba01;
use dba01;
create table dba01.t1in1 (c1 int, c2 int)  STORED AS orc ;
insert into dba01.t1in1 values (1,100),(2,200),(3,300),(4,400),(5,500);
insert into dba01.t1in1 values (6,600);

create table dba01.t2in1 (c1 int, c2 int)  STORED AS orc ;
insert into dba01.t2in1 values (21,2100),(22,2200),(23,2300),(24,2400),(25,2500);
insert into dba01.t2in1 values (26,2600);

-- dba02 - default

create database dba02;
use dba02;
create table dba02.t1in2 (c1 int, c2 int);
insert into dba02.t1in2 values (10,1000),(20,2000),(30,3000),(40,4000),(50,5000);

-- dba03t - text

create database dba03t;
use dba03t;
create table dba03t.t1in3 (name string, city string) row format delimited fields terminated by ',' stored as textfile;  
insert into dba03t.t1in3 values ("Pablo", "Kirkland"),("Andrea", "Seattle");
insert into table dba03t.t1in3 values ("Victor", "Redmond");

-- dba04p - parquet

create database dba04p;
use dba04p;
create table dba04p.t1in4 (name string, city string) row format delimited fields terminated by ',' stored as parquet;  
insert into dba04p.t1in4 values ("Pablo", "Kirkland"),("Andrea", "Seattle");
insert into table dba04p.t1in4 values ("Monica", "Seattle");

-- dba05i - insert only change - CDP - teansactional 

create database dba05i;
use dba05i;
CREATE TABLE dba05i.t1in5 (c1 int, c2 int) STORED AS ORC  TBLPROPERTIES ('transactional'='true',  'transactional_properties'='insert_only');
insert into dba05i.t1in5 values (51,510) , (52,520);
select * from dba05i.t1in5;
insert into dba05i.t1in5 values (53,530);

-- dbs01 - insert data from files

create database dbs01;
create table dbs01.t1in1 (name string, province string) row format delimited fields terminated by ',' stored as textfile;  

LOAD DATA INPATH '/forhive/people1.csv' INTO TABLE dbs01.t1in1;
LOAD DATA INPATH '/forhive/people2.csv' INTO TABLE dbs01.t1in1;
LOAD DATA INPATH '/forhive/people3.csv' INTO TABLE dbs01.t1in1;
LOAD DATA INPATH '/forhive/people4.csv' INTO TABLE dbs01.t1in1;
LOAD DATA INPATH '/forhive/people5.csv' INTO TABLE dbs01.t1in1;


-- Update = enabled/ACID - dba01 and dba02

update dba01.t1in1 set c2=600 where c1=5;
update dba01.t1in1 set c1=6 where c2=600;

update dba02.t1in2 set c2=6000 where c1=50;
update dba02.t1in2 set c1=60 where c2=6000;

-- disable transactions at table level/add table

CREATE TABLE dba01.t2in1 (c1 int, c2 int) TBLPROPERTIES ('transactional'='true',  'transactional_properties'='insert_only');
describe formatted dba01.t2in1;

ALTER TABLE dba04p.t1in1 SET TBLPROPERTIES ('transactional'='true',  'transactional_properties'='insert_only');

-- list and describe DBs

show databases;

-- dba01

select * from dba01.t1in1;
describe formatted dba01.t1in1;
select * from dba01.t2in1;
describe formatted dba01.t2in1;

describe database dba01;

--- dba02

select * from dba02.t1in2;
describe database dba02;
describe formatted dba02.t1in2;

-- dba03t

select * from dba03t.t1in3;
describe database dba03t;
describe formatted dba03t.t1in3;

--dba04p

select * from dba04p.t1in4;
describe database dba04p;
describe formatted dba04p.t1in4;

--dba05i

select * from dba05i.t1in5;
describe database dba05i;
describe formatted dba05i.t1in5;

-- dbs01

select * from dbs01.t1in1;
select count(*) from dbs01.t1in1;

-- Clean environment

DROP DATABASE dba01 CASCADE;
DROP DATABASE dba02 CASCADE;
DROP DATABASE dba03t CASCADE;
DROP DATABASE dba04p CASCADE;
DROP DATABASE dba05i CASCADE;

DROP DATABASE dbs01 CASCADE;

-- describe DBs

DESCRIBE DATABASE EXTENDED db_name;
DESCRIBE SCHEMA EXTENDED db_name;