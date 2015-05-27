-- create a unique set of npi's fro 2012-2013 data, 2013-2014 data and add to New table Npi_Unique
INSERT INTO Npi_Unique
(NPI)
SELECT DISTINCT a.npi
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
LIMIT 5

-- find out if there are any duplicate values in the Npi_unique table
SELECT NPI
FROM Npi_Unique
GROUP BY NPI
HAVING count(*) > 1;
