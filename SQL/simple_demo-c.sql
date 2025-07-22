SHOW databases;

-- bda1 =============================================================

CREATE database bda1;
CREATE table bda1.table01 (id INT, name string, company string, province string) STORED AS ORC;

describe database bda1;
describe formatted bda1.table01;

select * from bda1.table01;

-- Insert 1-5 --------------------------------------------------

insert into bda1.table01 values 
    (1,"Shannon Gill","Vitae Velit Limited","Manitoba"),
    (2,"Chaim Hanson","Aliquam Vulputate Incorporated","Northwest Territories"),
    (3,"Rose Sosa","Mauris Vestibulum LLP","Prince Edward Island"),
    (4,"Dean White","Curabitur Egestas Corp.","Quebec"),
    (5,"Yasir Gray","Malesuada Fames Inc.","Alberta");

-- Insert 5-10 -------------------------------------------------

insert into bda1.table01 values 
    (6,"Phoebe Hogan","Et Magnis Institute","Nova Scotia"),
    (7,"Imogene Hebert","Nec Ltd","Quebec"),
    (8,"Yoko Goodwin","Odio Industries","Northwest Territories"),
    (9,"Tara Clarke","Eget Tincidunt LLP","Quebec"),
    (10,"Aspen Hardin","Donec Consectetuer Limited","New Brunswick");
    
-- Drop DB/Tables -----------------------------------------------

DROP DATABASE bda1 CASCADE;

-- Target --------------------------------------------------------

SHOW databases;
USE bda1;
SHOW TABLES;

describe database bda1;
describe formatted bda1.table01;

SELECT count(*) FROM bda1.table01;
SELECT * FROM bda1.table01;

-- 
