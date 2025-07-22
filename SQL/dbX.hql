SHOW databases;

drop table db01.t01;
drop table db01.t02;
drop table db01.t03;
drop table db01.t04;

drop database db01 cascade;



CREATE database db01;


CREATE table db01.t01 (id INTEGER, name string) TBLPROPERTIES ( 'transactional'='false');
CREATE table db02.t02 (id INTEGER, name string) stored as parquet;
CREATE table db03.t03 (id INTEGER, name string) row format delimited fields terminated by ',' stored as TEXTFILE;
CREATE table db04.t04 (id INTEGER, name string);


describe database db01;
describe formatted db01.t01;
describe formatted db02.t02;
describe formatted db03.t03;
describe formatted db04.t04;

insert into db01.t01 values (1, "Pablo");
insert into db02.t02 values (1, "Pablo");
insert into db03.t03 values (1, "Pablo");
insert into db04.t04 values (1, "Pablo");


select * from db01.t01;
select * from db02.t02;
select * from db03.t03;
select * from db04.t04;

-- ----------------------------------------------------------------
insert into db01.t01 values 
  (2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

insert into db02.t02 values 
  (2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

insert into db03.t03 values 
  (2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

insert into db04.t04 values 
  (2, "Dinnesh"), (3, "Clayton"), 
  (4, "Scott"), (5, "Ax"), 
  (6, "Lo"), (7, "Mariana"), 
  (8, "Andrea"), (9, "Krystyna"), 
  (10, "Nacho");

-- ----------------------------------------------------
insert into db01.t01 values
  (12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi"),
  (21,"Suzanne");
    
 insert into db02.t02 values
  (12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi"),
  (21,"Suzanne");
  

insert into db03.t03 values
  (12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi"),
  (21,"Suzanne");
  
insert into db04.t04 values
  (12,"Terri"),(13,"Agnes"),
  (14,"Nicolas"),(15,"Silvana"),
  (16,"Nora"),(17,"Filiberto"),
  (18,"Marcela"),
  (19,"Sandra"),(20,"Angi"),
  (21,"Suzanne");
