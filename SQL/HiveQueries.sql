SHOW databases;

-- DB1 ============================================================================================================================

CREATE database db_mix_a;
CREATE table db_mix_a.orc_a (id INTEGER, name string) stored as ORC;
CREATE table db_mix_a.orc_b (id INTEGER, name string) stored as ORC TBLPROPERTIES ('transactional'='false');
CREATE table db_mix_a.parquet_a (id INTEGER, name string) stored as PARQUET TBLPROPERTIES ('transactional'='false');
CREATE table db_mix_a.text_a (id INTEGER, name string) row format delimited fields terminated by ',' stored as TEXTFILE TBLPROPERTIES ('transactional'='false');

describe database db_mix_a;
describe formatted db_mix_a.orc_a;
describe formatted db_mix_a.orc_b;
describe formatted db_mix_a.parquet_a;
describe formatted db_mix_a.text_a;

select * from db_mix_a.orc_a;
select * from db_mix_a.orc_b;
select * from db_mix_a.parquet_a;
select * from db_mix_a.text_a;

-- Insert 1-10 ----------------------------------------------------------------


insert into db_mix_a.orc_a values 
  (1, "Pablo"),(2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

insert into db_mix_a.orc_b values 
  (1, "Pablo"),(2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

insert into db_mix_a.parquet_a values 
  (1, "Pablo"),(2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

insert into db_mix_a.text_a values 
  (1, "Pablo"),(2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

-- Insert 1-20 ----------------------------------------------------------------

insert into db_mix_a.orc_a values
  (11,"Suzanne"),(12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi");
    
insert into db_mix_a.orc_b values 
  (11,"Suzanne"),(12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi");

 insert into db_mix_a.parquet_a values
  (11,"Suzanne"),(12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi");
  
insert into db_mix_a.text_a values
  (11,"Suzanne"),(12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi");

-- Drop DB/Tables ----------------------------------------------------------------

-- DROP DATABASE db_mix_a CASCADE;
-- DROP table db_mix_a.orc_a;
-- DROP table db_mix_a.orc_b;
-- DROP table db_mix_a.parquet_a;
-- DROP table db_mix_a.text_a;

-- Target UNITY ---------------------------------------------------------------- 
%sql
use catalog unity_a;
show databases;

%sql
describe database unity_a.db_mix_a;
-- describe formatted unity_a.db_mix_a.orc_a;
-- describe formatted unity_a.db_mix_a.orc_b;
-- describe formatted unity_a.db_mix_a.parquet_a;
-- describe formatted unity_a.db_mix_a.text_a;

%sql
select * from unity_a.db_mix_a.orc_a;
-- select * from unity_a.db_mix_a.orc_b order by (id) asc;
-- select * from unity_a.db_mix_a.parquet_a order by (id) asc;
-- select * from unity_a.db_mix_a.text_a order by (id) asc;

-- [EOF] -------------------------------------------------------------------------------------------------

