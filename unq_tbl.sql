-- creates a unique set of npi's from 2012-2013 data, 2013-2014 data and add to New table Npi_Unique
INSERT INTO Npi_Unique
(NPI)
SELECT DISTINCT a.npi
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
-- LIMIT 5

-- find out if there are any duplicate values in the Npi_unique table
SELECT NPI
FROM Npi_Unique
GROUP BY NPI
HAVING count(*) > 1;


--create a table to represent npi relationships for 2012-2013
INSERT INTO Npi_Relationship
(NPI, NPI_Dest)
SELECT DISTINCT a.npi,a.npi_dest
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
-- LIMIT 10

--update the table year column with the correct year for the represented relationship
UPDATE Npi_Relationship
SET Table_Year = "2012-2013"



--check to see if all the records were entered into the table(since the screen froze)

SELECT *
FROM npi_team_2012_2013_365.undirected a
INNER JOIN Npi_Relationship c
ON a.npi = c.npi AND a.npi_dest = c.npi_dest
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest


--create a table to represent npi relationships for 2013-2014
INSERT INTO Npi_Relationship
(NPI, NPI_Dest)
SELECT DISTINCT a.npi,a.npi_dest
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
INNER JOIN acountee.npi_relationship c
ON a.npi = c.npi AND a.npi_dest = c.npi_dest
WHERE c.npi is null

--update the table year column with the correct year for the represented relationship
UPDATE Npi_Relationship
SET Table_Year = "2013-2014"


--a check to see if there are any npi's missing
SELECT DISTINCT b.npi, *
FROM npi_team_2013_2014_365.undirected b
INNER JOIN acountee.npi
ON b.npi = npi.npi
WHERE b.npi NOT IN acountee.npi

--a preliminary script to creating an insert script for npi's from 2013-2014

SELECT DISTINCT b.npi,b.npi_dest
FROM npi_team_2013_2014_365.undirected b
INNER JOIN acountee.npi_relationship a
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE b.npi NOT IN acountee.npi_relationship
