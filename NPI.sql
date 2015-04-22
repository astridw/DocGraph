
-- Query to show the records that are shared by both years for ON Npi
SELECT *
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE a.npi= 1720027436
--151 records


--Query to show new relatiONships that did not exist in the previous year
SELECT *
FROM npi_team_2013_2014_365.undirected a
LEFT JOIN npi_team_2012_2013_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE b.npi is NULL AND b.npi_dest is NULL AND a.npi= 1720027436
--34 records


--same as above without alias for tables
SELECT *
FROM npi_team_2013_2014_365.undirected
LEFT JOIN npi_team_2012_2013_365.undirected
ON npi_team_2013_2014_365.undirected.npi = npi_team_2012_2013_365.undirected.npi
AND npi_team_2013_2014_365.undirected.npi_dest = npi_team_2012_2013_365.undirected.npi_dest
WHERE npi_team_2012_2013_365.undirected.npi is NULL AND npi_team_2012_2013_365.undirected.npi_dest is NULL
AND a.npi= 1720027436


--Query to count current relatiONships
SELECT DISTINCT count(npi_dest) as 'unique count of relatiONships'
FROM npi_team_2013_2014_365.undirected
WHERE npi= 1720027436

--sum of new npi_dest patient count
SELECT sum(patient_count)
FROM npi_team_2013_2014_365.undirected
WHERE npi=1720027436 AND npi_dest in (
  SELECT a.npi_dest
  FROM npi_team_2013_2014_365.undirected a
  LEFT JOIN npi_team_2012_2013_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE b.npi is NULL AND b.npi_dest is NULL AND a.npi= 1720027436)



--count of lost relatiONships AND lost patients
SELECT DISTINCT count(npi_dest) as 'lost npi relatiONship count', sum(patient_count) as 'lost patient count'
FROM npi_team_2012_2013_365.undirected
WHERE npi=1720027436 AND npi_dest in (
  SELECT a.npi_dest
  FROM npi_team_2012_2013_365.undirected a
  LEFT JOIN npi_team_2013_2014_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE b.npi is NULL AND b.npi_dest is NULL AND a.npi= 1720027436)

--count of new relatiONships AND new patients
SELECT DISTINCT count(npi_dest) as 'new npi relatiONship count', sum(patient_count) as 'new patient count'
FROM npi_team_2013_2014_365.undirected
WHERE npi=1720027436 AND npi_dest in (
  SELECT a.npi_dest
  FROM npi_team_2013_2014_365.undirected a
  LEFT JOIN npi_team_2012_2013_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE b.npi is NULL AND b.npi_dest is NULL AND a.npi= 1720027436)


--Patient flow change FROM previous year's data
SELECT (sum(a.patient_count) - sum(b.patient_count)) as 'patient flow change'
FROM npi_team_2013_2014_365.undirected a
INNER JOIN npi_team_2012_2013_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE a.npi = 1720027436

--patient flow change average
SELECT asum / bcount
FROM
(SELECT abs(sum(a.patient_count - b.patient_count)) asum
FROM npi_team_2013_2014_365.undirected a
INNER JOIN npi_team_2012_2013_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE a.npi = 1720027436) a, (SELECT count(a.npi_dest) bcount
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE a.npi= 1720027436) b

--patient flow change percentage
SELECT (asum / bsum)/ ccount
FROM (SELECT (sum(a.patient_count) - sum(b.patient_count)) asum
FROM npi_team_2013_2014_365.undirected a
INNER JOIN npi_team_2012_2013_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE a.npi = 1720027436) a,
( SELECT sum(b.patient_count) bsum
FROM npi_team_2012_2013_365.undirected b
WHERE npi = 1720027436) b,
(SELECT count(a.npi_dest) ccount
FROM npi_team_2012_2013_365.undirected a
INNER JOIN npi_team_2013_2014_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE a.npi= 1720027436) c

--absolute patient flow change query test(2 queries)
-- SELECT abs(sum(a.patient_count - b.patient_count)) as 'difference'
-- FROM npi_team_2013_2014_365.undirected a
-- INNER JOIN npi_team_2012_2013_365.undirected b
-- ON a.npi = b.npi AND a.npi_dest = b.npi_dest
-- WHERE a.npi = 1720027436 AND a.patient_count - b.patient_count < 0;
-- SELECT abs(sum(a.patient_count - b.patient_count)) as 'difference'
-- FROM npi_team_2013_2014_365.undirected a
-- INNER JOIN npi_team_2012_2013_365.undirected b
-- ON a.npi = b.npi AND a.npi_dest = b.npi_dest
-- WHERE a.npi = 1720027436 AND a.patient_count - b.patient_count > 0

--combined query to get total absolute value
SELECT a.asum + b.bsum
FROM
(SELECT abs(sum(a.patient_count - b.patient_count)) asum
FROM npi_team_2013_2014_365.undirected a
INNER JOIN npi_team_2012_2013_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE a.npi = 1720027436 AND a.patient_count - b.patient_count < 0) as a,
(SELECT abs(sum(a.patient_count - b.patient_count)) bsum
FROM npi_team_2013_2014_365.undirected a
INNER JOIN npi_team_2012_2013_365.undirected b
ON a.npi = b.npi AND a.npi_dest = b.npi_dest
WHERE a.npi = 1720027436 AND a.patient_count - b.patient_count > 0) as b


---score

SELECT (a.asum * 5) + (b.bsum * 5) + c.csum
FROM
(SELECT sum(patient_count) asum
FROM npi_team_2012_2013_365.undirected
WHERE npi=1720027436 AND npi_dest in (
  SELECT a.npi_dest
  FROM npi_team_2012_2013_365.undirected a
  LEFT JOIN npi_team_2013_2014_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE b.npi is NULL AND b.npi_dest is NULL AND a.npi= 1720027436)) a,
(SELECT sum(patient_count) bsum
FROM npi_team_2013_2014_365.undirected
WHERE npi=1720027436 AND npi_dest in (
  SELECT a.npi_dest
  FROM npi_team_2013_2014_365.undirected a
  LEFT JOIN npi_team_2012_2013_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE b.npi is NULL AND b.npi_dest is NULL AND a.npi= 1720027436)) b,
  (SELECT (x.asum + y.bsum) csum
  FROM
  (SELECT abs(sum(a.patient_count - b.patient_count)) asum
  FROM npi_team_2013_2014_365.undirected a
  INNER JOIN npi_team_2012_2013_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE a.npi = 1720027436 AND a.patient_count - b.patient_count < 0) as x,
  (SELECT abs(sum(a.patient_count - b.patient_count)) bsum
  FROM npi_team_2013_2014_365.undirected a
  INNER JOIN npi_team_2012_2013_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE a.npi = 1720027436 AND a.patient_count - b.patient_count > 0) as y) c


-- alma's work with fred.
-- rather than doing the calculatiON we are returning the foundatiONal data points alONg with associated npi
-- we removed the WHERE clauses that were restricting the query to a single npi.
-- the resulting query may be different in nature because the npi limitatiON may have been doing more than just restricting the results by npi

-- TO DO:
-- since this is a query based ON sub-queries, we should use LIMIT to ensure that every sub-query is ONly returning 1000 npis for testing purposes
-- using LIMIT, you should be able to ensure that the code would work ON all npis, without tying up the server for hours or days
-- then use EXPLAIN in order to verify that WHEREver possible, your query is leveraging indexes. Add indexes as needed.
-- use the CREATE TABLE syntax with LIMIT removed, in order create a new data table ONce you have proved to yourself that the query is correct
-- then run the query, hours or days taken up is fine.
-- you need a way to make sure sub-queries are working ON the same npi at the same time, now that the WHERE has been removed

-- Fixing this mega query is not necesarily the easiest way (can also use intermediate tables), but having a properly named four-column table with the scores for each npi is the goal


SELECT
	npi,
	a.asum,
	b.bsum,
	c.csum
FROM
(SELECT npi, sum(patient_count) asum
FROM npi_team_2012_2013_365.undirected
WHERE npi_dest in (
  SELECT a.npi_dest
  FROM npi_team_2012_2013_365.undirected a
  LEFT JOIN npi_team_2013_2014_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE b.npi is NULL AND b.npi_dest is NULL)) a ,
(SELECT sum(patient_count) bsum
FROM npi_team_2013_2014_365.undirected
WHERE npi_dest in (
  SELECT a.npi_dest
  FROM npi_team_2013_2014_365.undirected a
  LEFT JOIN npi_team_2012_2013_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE b.npi is NULL AND b.npi_dest is NULL)) b,
  (SELECT (x.asum + y.bsum) csum
  FROM
  (SELECT abs(sum(a.patient_count - b.patient_count)) asum
  FROM npi_team_2013_2014_365.undirected a
  INNER JOIN npi_team_2012_2013_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE a.patient_count - b.patient_count < 0) as x,
  (SELECT abs(sum(a.patient_count - b.patient_count)) bsum
  FROM npi_team_2013_2014_365.undirected a
  INNER JOIN npi_team_2012_2013_365.undirected b
  ON a.npi = b.npi AND a.npi_dest = b.npi_dest
  WHERE a.patient_count - b.patient_count > 0) as y) c




--attempt to join the npi databases with npi table to other tables to have a unique set
--still working on it
--If there is a way for me to connect to this table or to have it available inside the team foler
--it would take care of the problem of having a table that has unique NPIs
  SELECT n.npi, a.npi
  FROM npi n LIMIT 10
  INNER JOIN npi_team_2012_2013_365.undirected a
  ON npi.npi = a.npi
