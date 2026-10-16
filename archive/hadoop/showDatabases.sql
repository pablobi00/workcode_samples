show databases;

-- Clean environment 

drop database dbnpparquet500 cascade;
drop database dbnpcsv500 cascade;

drop table dbnpcsv500.employee;

-- CSV DATABASE

CREATE SCHEMA IF NOT EXISTS dbnpcsv500;
create table dbnpcsv500.employee (id int, name string, company string, province string) row format delimited fields terminated by ',' stored as textfile;



describe database dbnpcsv500;
describe formatted  dbnpcsv500.employee;

-- Add data to CSV, as a pre-requisite copy /name-province/SourceFiles/* to /name-province/
-- Load people1.csv to start with. 
-- Create file and metadata migrations in LDM
-- To add rows to the table and look at migreation sin Databricks, add one file at a time
-- Data is a list of names and Canadian provinces. 

LOAD DATA INPATH '/name-province/data50001.csv' INTO TABLE dbnpcsv500.employee;
LOAD DATA INPATH '/name-province/data50002.csv' INTO TABLE dbnpcsv500.employee;
LOAD DATA INPATH '/name-province/data50003.csv' INTO TABLE dbnpcsv500.employee;


select count(*) from dbnpcsv500.employee;
select * from dbnpcsv500.employee;

-- CSV2 ---------------

CREATE SCHEMA IF NOT EXISTS dbnpcsv5002;
create table dbnpcsv5002.employee (id int, name string, company string, province string) row format delimited fields terminated by ',' stored as textfile;

describe database dbnpcsv5002;
describe formatted  dbnpcsv5002.employee;

-- Insert data into  DB using CSV table above, recommended to start with just people1.cvs

insert OVERWRITE table dbnpcsv5002.employee select * from dbnpcsv500.employee;

select count(*) from dbnpcsv5002.employee;
select * from dbnpcsv5002.employee;


-- PARQUET DATABASE ---------------------------------------------------------------------------------------

create database dbnpparquet500;
create table dbnpparquet500.pemployee (id int, name string, company string, province string) row format delimited fields terminated by ',' stored as parquet;

describe database dbnpparquet500;

-- Insert data into Parquet DB using CSV table, recommended to start with just people1.cvs
-- Create file and metadata migrations in LDM
-- Execute CSV load and then insert into Parquet

insert OVERWRITE table dbnpparquet500.pemployee select * from dbnpcsv500.employee;
-- insert into table dbnpparquet500.pemployee select * from dbtemp01.csv01;

select count(*) from dbnpparquet500.pemployee;
select * from dbnpparquet500.pemployee;

-- JSON --------------------------------------------------------------------------------------------------

create database dbnpjson500;

create table dbnpjson500.jemployee (id int, name string, company string, province string) 
row format SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' 
stored as textfile;

describe database dbnpjson500;
describe formatted dbnpjson500.jemployee;

-- Insert data into JSON/SERDE DB using CSV table, recommended to start with just people1.cvs
-- Create file and metadata migrations in LDM
-- Execute CSV load and then insert into JSON

insert OVERWRITE table dbnpjson500.jemployee select * from dbnpcsv500.employee;

select count(*) from dbnpjson500.jemployee;
select * from dbnpjson500.jemployee;

