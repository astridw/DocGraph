
-- Query to show the records that are shared by both years for on Npi
select *
from npi_team_2012_2013_365.undirected a
inner join npi_team_2013_2014_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where a.npi= 1720027436
--151 records


--Query to show new relationships that did not exist in the previous year
select *
from npi_team_2013_2014_365.undirected a
left join npi_team_2012_2013_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where b.npi is null and b.npi_dest is null and a.npi= 1720027436
--34 records


--same as above without alias for tables
select *
from npi_team_2013_2014_365.undirected
left join npi_team_2012_2013_365.undirected
on npi_team_2013_2014_365.undirected.npi = npi_team_2012_2013_365.undirected.npi
and npi_team_2013_2014_365.undirected.npi_dest = npi_team_2012_2013_365.undirected.npi_dest
where npi_team_2012_2013_365.undirected.npi is null and npi_team_2012_2013_365.undirected.npi_dest is null
and a.npi= 1720027436


--Query to count current relationships
select distinct count(npi_dest) as 'unique count of relationships'
from npi_team_2013_2014_365.undirected
where npi= 1720027436

--sum of new npi_dest patient count
select sum(patient_count)
from npi_team_2013_2014_365.undirected
where npi=1720027436 and npi_dest in (
  select a.npi_dest
  from npi_team_2013_2014_365.undirected a
  left join npi_team_2012_2013_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where b.npi is null and b.npi_dest is null and a.npi= 1720027436)



--count of lost relationships and lost patients
select distinct count(npi_dest) as 'lost npi relationship count', sum(patient_count) as 'lost patient count'
from npi_team_2012_2013_365.undirected
where npi=1720027436 and npi_dest in (
  select a.npi_dest
  from npi_team_2012_2013_365.undirected a
  left join npi_team_2013_2014_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where b.npi is null and b.npi_dest is null and a.npi= 1720027436)

--count of new relationships and new patients
select distinct count(npi_dest) as 'new npi relationship count', sum(patient_count) as 'new patient count'
from npi_team_2013_2014_365.undirected
where npi=1720027436 and npi_dest in (
  select a.npi_dest
  from npi_team_2013_2014_365.undirected a
  left join npi_team_2012_2013_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where b.npi is null and b.npi_dest is null and a.npi= 1720027436)


--Patient flow change from previous year's data
select (sum(a.patient_count) - sum(b.patient_count)) as 'patient flow change'
from npi_team_2013_2014_365.undirected a
inner join npi_team_2012_2013_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where a.npi = 1720027436

--patient flow change average
select asum / bcount
from
(select abs(sum(a.patient_count - b.patient_count)) asum
from npi_team_2013_2014_365.undirected a
inner join npi_team_2012_2013_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where a.npi = 1720027436) a, (select count(a.npi_dest) bcount
from npi_team_2012_2013_365.undirected a
inner join npi_team_2013_2014_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where a.npi= 1720027436) b

--patient flow change percentage
select (asum / bsum)/ ccount
from (select (sum(a.patient_count) - sum(b.patient_count)) asum
from npi_team_2013_2014_365.undirected a
inner join npi_team_2012_2013_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where a.npi = 1720027436) a,
( select sum(b.patient_count) bsum
from npi_team_2012_2013_365.undirected b
where npi = 1720027436) b,
(select count(a.npi_dest) ccount
from npi_team_2012_2013_365.undirected a
inner join npi_team_2013_2014_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where a.npi= 1720027436) c

--absolute patient flow change query test(2 queries)
-- select abs(sum(a.patient_count - b.patient_count)) as 'difference'
-- from npi_team_2013_2014_365.undirected a
-- inner join npi_team_2012_2013_365.undirected b
-- on a.npi = b.npi and a.npi_dest = b.npi_dest
-- where a.npi = 1720027436 and a.patient_count - b.patient_count < 0;
-- select abs(sum(a.patient_count - b.patient_count)) as 'difference'
-- from npi_team_2013_2014_365.undirected a
-- inner join npi_team_2012_2013_365.undirected b
-- on a.npi = b.npi and a.npi_dest = b.npi_dest
-- where a.npi = 1720027436 and a.patient_count - b.patient_count > 0

--combined query to get total absolute value
select a.asum + b.bsum
from
(select abs(sum(a.patient_count - b.patient_count)) asum
from npi_team_2013_2014_365.undirected a
inner join npi_team_2012_2013_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where a.npi = 1720027436 and a.patient_count - b.patient_count < 0) as a,
(select abs(sum(a.patient_count - b.patient_count)) bsum
from npi_team_2013_2014_365.undirected a
inner join npi_team_2012_2013_365.undirected b
on a.npi = b.npi and a.npi_dest = b.npi_dest
where a.npi = 1720027436 and a.patient_count - b.patient_count > 0) as b


---score

select (a.asum * 5) + (b.bsum * 5) + c.csum
from
(select sum(patient_count) asum
from npi_team_2012_2013_365.undirected
where npi=1720027436 and npi_dest in (
  select a.npi_dest
  from npi_team_2012_2013_365.undirected a
  left join npi_team_2013_2014_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where b.npi is null and b.npi_dest is null and a.npi= 1720027436)) a,
(select sum(patient_count) bsum
from npi_team_2013_2014_365.undirected
where npi=1720027436 and npi_dest in (
  select a.npi_dest
  from npi_team_2013_2014_365.undirected a
  left join npi_team_2012_2013_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where b.npi is null and b.npi_dest is null and a.npi= 1720027436)) b,
  (select (x.asum + y.bsum) csum
  from
  (select abs(sum(a.patient_count - b.patient_count)) asum
  from npi_team_2013_2014_365.undirected a
  inner join npi_team_2012_2013_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where a.npi = 1720027436 and a.patient_count - b.patient_count < 0) as x,
  (select abs(sum(a.patient_count - b.patient_count)) bsum
  from npi_team_2013_2014_365.undirected a
  inner join npi_team_2012_2013_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where a.npi = 1720027436 and a.patient_count - b.patient_count > 0) as y) c


-- alma's work with fred. 
-- rather than doing the calculation we are returning the foundational data points along with associated npi
-- we removed the WHERE clauses that were restricting the query to a single npi.
-- the resulting query may be different in nature because the npi limitation may have been doing more than just restricting the results by npi

-- TO DO: 
-- since this is a query based on sub-queries, we should use LIMIT to ensure that every sub-query is only returning 1000 npis for testing purposes
-- using LIMIT, you should be able to ensure that the code would work on all npis, without tying up the server for hours or days
-- then use EXPLAIN in order to verify that wherever possible, your query is leveraging indexes. Add indexes as needed.
-- use the CREATE TABLE syntax with LIMIT removed, in order create a new data table once you have proved to yourself that the query is correct
-- then run the query, hours or days taken up is fine.
-- you need a way to make sure sub-queries are working on the same npi at the same time, now that the WHERE has been removed


SELECT
	npi, 
	a.asum, 
	b.bsum,
	c.csum
from
(select npi, sum(patient_count) asum
from npi_team_2012_2013_365.undirected
where npi_dest in (
  select a.npi_dest
  from npi_team_2012_2013_365.undirected a
  left join npi_team_2013_2014_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where b.npi is null and b.npi_dest is null)) a,
(select sum(patient_count) bsum
from npi_team_2013_2014_365.undirected
where npi_dest in (
  select a.npi_dest
  from npi_team_2013_2014_365.undirected a
  left join npi_team_2012_2013_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where b.npi is null and b.npi_dest is null)) b,
  (select (x.asum + y.bsum) csum
  from
  (select abs(sum(a.patient_count - b.patient_count)) asum
  from npi_team_2013_2014_365.undirected a
  inner join npi_team_2012_2013_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where a.patient_count - b.patient_count < 0) as x,
  (select abs(sum(a.patient_count - b.patient_count)) bsum
  from npi_team_2013_2014_365.undirected a
  inner join npi_team_2012_2013_365.undirected b
  on a.npi = b.npi and a.npi_dest = b.npi_dest
  where a.patient_count - b.patient_count > 0) as y) c
