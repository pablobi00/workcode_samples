SHOW databases;

-- DB1 ============================================================================================================================

CREATE database db01;
CREATE table db01.table01 (id INTEGER, name string);
CREATE table db01.table02 (id INTEGER, name string) stored as parquet;
CREATE table db01.table03 (id INTEGER, name string) row format delimited fields terminated by ',' stored as TEXTFILE;

describe database db01;
describe formatted db01.table01;
describe formatted db01.table02;
describe formatted db01.table03;

select * from db01.table01;
select * from db01.table02;
select * from db01.table03;

-- Insert 1 ----------------------------------------------------------------

insert into db01.table01 values (1, "Pablo");
insert into db01.table02 values (1, "Pablo");
insert into db01.table03 values (1, "Pablo");

-- Insert 2 -10 ----------------------------------------------------------------


insert into db01.table01 values 
  (2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

insert into db01.table02 values 
  (2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

insert into db01.table03 values 
  (2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

-- Insert 11 - 20 ----------------------------------------------------------------

insert into db01.table01 values
  (12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi"),
  (11,"Suzanne");
    
 insert into db01.table02 values
  (12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi"),
  (11,"Suzanne");
  

insert into db01.table03 values
  (12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi"),
  (11,"Suzanne");

-- Dreop DB/Tables ----------------------------------------------------------------


-- DROP DATABASE db01 CASCADE;
-- DROP table db01.table01;
-- DROP table db01.table02;
-- DROP table db01.table03;



-- -------------------------------------------------------------------------------------------------

