/* Undirected */

-- creates a unique set of npi's from 2012-2013 data, 2013-2014 data and add to New table Npi_Unique
INSERT INTO Npi_Unique
(NPI)
SELECT DISTINCT a.npi
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
-- LIMIT 5
--done

-- find out if there are any duplicate values in the Npi_unique table
SELECT NPI
FROM Npi_Unique
GROUP BY NPI
HAVING count(*) > 1
--check done


--create a table to represent npi relationships for 2012-2013
INSERT INTO Npi_Relationship
(NPI, NPI_Dest)
SELECT DISTINCT a.npi,a.npi_dest
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
-- LIMIT 10
--done

--update the table year column with the correct year for the represented relationship
UPDATE Npi_Relationship
SET Table_Year = "2012-2013"

---updated the table year from the unique npi table(MYSQL WOULD NOT ALLOW SUBQUERIES)
UPDATE Npi_Relationship
SET Table_Year = "2012-2013"
WHERE npi in
	(SELECT  Npi
FROM Npi_Unique
ORDER BY NPI ASC LIMIT 10 )


--check to see if all npi relationships were added to the npi relationship table
SELECT COUNT(*)
FROM Npi_Unique
INNER JOIN Npi_Relationship ON Npi_Unique.NPI = Npi_Relationship.NPI


--check to see if all the records were entered into the table(since the screen froze)
--this turns out to be a bad query

-- SELECT *
-- FROM npi_team_2012_2013_365.undirected a
-- INNER JOIN acountee.Npi_Relationship c
-- ON a.npi = c.npi AND a.npi_dest = c.npi_dest
-- INNER JOIN npi_team_2013_2014_365.undirected b
-- ON a.npi = b.npi AND a.npi_dest = b.npi_dest


--create a table to represent npi relationships for 2013-2014
INSERT INTO Npi_Relationship
(NPI, NPI_Dest)
SELECT DISTINCT a.npi,a.npi_dest
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
INNER JOIN Npi_Relationship c
ON a.npi = c.npi AND a.npi_dest = c.npi_dest
WHERE c.npi is null AND c.npi_dest is null

--update the table year column with the correct year for the represented relationship
UPDATE Npi_Relationship
SET Table_Year = "2013-2014"




--check to see if there are any records missing after the first load
SELECT *
FROM npi_team_2012_2013_365.undirected b
INNER JOIN acountee.Npi_Relationship a WHERE b.npi = a.npi and b.npi_dest = a.npi_dest
--shows missing records 134975148, not sure if this query is correct
--after checking this query is incorrect


--check to see if records are missing, check 2
SELECT *
FROM npi_team_2012_2013_365.undirected b
INNER JOIN acountee.Npi_Relationship a
ON b.npi = a.npi and b.npi_dest = a.npi_dest
WHERE a.npi = null  and a.npi_dest = null
AND a.npi = 1000000004
--no records returned

--try again, missing records check---this one worked
SELECT *
FROM npi_team_2012_2013_365.undirected a
LEFT JOIN acountee.Npi_Relationship b ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE b.npi is NULL  and b.npi_dest is NULL
--45972658 total missing
--38912658 total
--36112658 total


--insert statement to add missing records
INSERT INTO Npi_Relationship
(NPI, NPI_Dest)
SELECT a.npi, a.npi_dest
FROM npi_team_2012_2013_365.undirected a
LEFT JOIN acountee.Npi_Relationship b ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE b.npi is NULL  and b.npi_dest is NULL
LIMIT 100000
--this query is correct, but cannot be completed because of error message The total number of locks exceeds the lock table size
--in order to insert, I had to keep running by limiting by 1000

/*
--check to see if records missing query above is correct by comparing to 2013-2014
SELECT *
FROM npi_team_2013_2014_365.undirected b
INNER JOIN acountee.Npi_Relationship a
ON b.npi = a.npi and b.npi_dest = a.npi_dest
WHERE b.npi = null  and b.npi_dest = null
--still no records returned

--query to check and see if 2013-2014 is different from 2012-2013
SELECT *
FROM npi_team_2013_2014_365.undirected b
LEFT JOIN npi_team_2012_2013_365.undirected a
ON b.npi = a.npi
WHERE a.npi = null

--a check to see if there are any npi's missing for 2012-2013
SELECT DISTINCT b.npi, b.npi_dest
FROM npi_team_2012_2013_365.undirected b
INNER JOIN acountee.Npi_relationship
ON b.npi = npi.Npi_relationship
WHERE b.npi NOT IN acountee.Npi_relationship

--a check to see if there are any npi's missing for 2013-2014
SELECT DISTINCT b.npi, *
FROM npi_team_2013_2014_365.undirected b
INNER JOIN acountee.npi
ON b.npi = npi.npi
WHERE b.npi NOT IN acountee.npi
*/

--a preliminary script to creating an insert script for npi's from 2013-2014

SELECT DISTINCT b.npi,b.npi_dest
FROM npi_team_2013_2014_365.undirected b
INNER JOIN acountee.npi_relationship a
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE b.npi NOT IN acountee.npi_relationship


/* Directed */
