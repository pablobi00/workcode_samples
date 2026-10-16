show databases;

drop database dbnpjoin cascade;

create database if not exists dbnpjoin;

create table dbnpjoin.customer_info (Id int, last_name string, country string , phone string ) row format delimited fields terminated by ',' stored as textfile;
create table dbnpjoin.purchases (Id int, product int, paid string) row format delimited fields terminated by ',' stored as textfile;


LOAD DATA INPATH '/join_test_data/customers_info.csv' INTO TABLE dbnpjoin.customer_info;
LOAD DATA INPATH '/join_test_data/purchases.csv' INTO TABLE dbnpjoin.purchases;

select * from dbnpjoin.customer_info;
select * from dbnpjoin.purchases;


-- join data form two tables 

use dbnpjoin;
select customer_info.id , customer_info.last_name, purchases.product 
from purchases inner join customer_info on customer_info.id=purchases.id 
where purchases.paid = 'Yes'; 

select customer_info.id , customer_info.last_name, purchases.product 
from purchases inner join customer_info on customer_info.id=purchases.id ;

---- create summary table

use dbnpjoin;

drop table best_customers;

create table best_customers (id int, last_name string);
describe formatted best_customers; 

insert into best_customers (id,last_name) 
select 
   customer_info.id , customer_info.last_name 
from 
   purchases inner join customer_info on customer_info.id=purchases.id 
where
   purchases.paid = 'Yes';
   

-- how many customers and simpel list

select count(*) from best_customers;

select 
   *, COUNT(*) 
from 
   best_customers
group by id,last_name;


-- Count and dispaly top customers

select 
    *, COUNT(last_name) as product_orders
from 
    best_customers
group by 
    id,last_name
having 
    product_orders > 2
order by
    product_orders desc limit 10;