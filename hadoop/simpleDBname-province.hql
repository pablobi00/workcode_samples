show databases;

drop database dbnpparquet cascade;
drop database dbnpcsv cascade;
drop database dbnameprovincecsv cascade;

create database dbnpparquet;
create table dbnpparquet.t1in1 (name string, province string) row format delimited fields terminated by ',' stored as parquet;

CREATE SCHEMA IF NOT EXISTS dbnpcsv;
create table dbnpcsv.csv01 (name string, province string) row format delimited fields terminated by ',' stored as textfile;

LOAD DATA INPATH '/name-province/people1.csv' INTO TABLE dbnpcsv.csv01;
LOAD DATA INPATH '/name-province/people2.csv' INTO TABLE dbnpcsv.csv01;
LOAD DATA INPATH '/name-province/people3.csv' INTO TABLE dbnpcsv.csv01;
LOAD DATA INPATH '/name-province/people4.csv' INTO TABLE dbnpcsv.csv01;
LOAD DATA INPATH '/name-province/people5.csv' INTO TABLE dbnpcsv.csv01;

select count(*) from dbnpcsv.csv01;
select * from dbnpcsv.csv01;

insert OVERWRITE table dbnpparquet.t1in1 select * from dbnpcsv.csv01;
-- insert into table dbnpparquet.t1in1 select * from dbtemp01.csv01;

select count(*) from dbnpparquet.t1in1;
select * from dbnpparquet.t1in1;

show databases;
describe database dbnpparquet;
describe database dbnpcsv;