select * from Project2.dbo.Data1

select * from Project2.dbo.Data2

-- number of rows in our dataset

select count(*) from Project2..Data1
select count(*) from Project2..Data2

-- We will only use the data for 2 states, Jharkhand and Bihar

SELECT * from Project2..Data1 WHERE State IN ('Jharkhand', 'Bihar')

-- Now let's explore some numerical values in the dataset, starting from total population of states across India

SELECT State, Population FROM Project2..Data2

-- Total population of India
SELECT SUM(Population) as TotalPopulation FROM Project2..Data2

-- Average Growth of population(in %) across India
SELECT AVG(growth)*100 AvgGrowth FROM Project2..Data1

-- Average Growth of population(in %) across states in India
SELECT State, AVG(growth)*100 AvgGrowth FROM Project2..Data1 GROUP BY State

-- Highest Average Sex ratio across all the states in India
SELECT State, ROUND(AVG(sex_ratio), 0) AvgSexRatio FROM Project2..Data1 GROUP BY State ORDER BY AvgSexRatio Desc

-- Highest Literacy rate across all the states in India
SELECT State, ROUND(AVG(Literacy), 0) LiteracyRate FROM Project2..Data1 
GROUP BY State 
HAVING ROUND(AVG(Literacy), 0) > 90
ORDER BY LiteracyRate Desc

-- Top 3 states showing highest growth percent ratio
SELECT TOP 3 State, AVG(growth)*100 AvgGrowth FROM Project2..Data1 
GROUP BY State
ORDER BY AvgGrowth DESC

-- top and bottom 3 states in literacy rate
-- we can solve this by creating temporary tables

drop table if exists #topstates
CREATE table #topstates
( state nvarchar(255),
  topstate float ) 
INSERT INTO #topstates
SELECT State, ROUND(AVG(Literacy), 0) AvgLiteracyRate FROM Project2..Data1 
GROUP BY State 
ORDER BY AvgLiteracyRate Desc

SELECT * FROM #topstates ORDER BY #topstates.topstate DESC

drop table if exists #bottomstates
CREATE table #bottomstates
( State nvarchar(255),
  Bottomstate float ) 
INSERT INTO #bottomstates
 SELECT State, ROUND(AVG(Literacy), 0) AvgLiteracyRate FROM Project2..Data1 
GROUP BY State 
ORDER BY AvgLiteracyRate Desc

SELECT * FROM #bottomstates ORDER BY #bottomstates.Bottomstate ASC

-- Combine both the tables using UNION Operator

select * from (
SELECT Top 3 state FROM #topstates ORDER BY #topstates.topstate DESC) a

UNION

select * from(
SELECT TOp 3 State FROM #bottomstates ORDER BY #bottomstates.Bottomstate ASC)b 

-- States starting with letter a
SELECT DISTINCT State FROM Project2..Data1 where State LIKE 'a%'

-- States starting with letter a and ending with letter m 
SELECT DISTINCT State FROM Project2..Data1 where lower(State) LIKE 'a%' and lower(State) LIKE '%m'

--total males and females

select d.State,SUM(d.males) total_males,SUM(d.females) total_females from
(select c.District,c.State, ROUND(c.Population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from Project2..Data1 a inner join Project2..Data2 b on a.District=b.District ) c) d
group by d.state;

-- Total Literacy Rate

Select * from Data1
Select * from Data2

Select d.State, SUM(LiteratePeople) Total_LiteratePeople, SUM(IlliteratePeople) Total_IlliteratePeople FROM(
Select c.District, c.State, ROUND(literacy_ratio*c.Population, 0) LiteratePeople, ROUND((1- literacy_ratio)*c.Population, 0) IlliteratePeople
FROM (SELECT a.District, a.State, a.Literacy/100 literacy_ratio, b.Population from Project2..Data1 a
	 INNER JOIN 
	 Project2..Data2 b
	 ON a.district = b.district)c)d
GROUP BY d.State

-- population in previous census
select sum(e.PrevCensusPop) PrevCensusPop, sum(CurrCensusPop) CurrCensusPop from
(select d.state, sum(d.PrevCensusPop) PrevCensusPop, sum(d.CurrCensusPop) CurrCensusPop from
(Select c.district, c.state,round(c.population/(1+c.growth), 0) PrevCensusPop,round(c.population, 0) CurrCensusPop from
(select a.District, a.State, a.growth Growth, b.Population from Project2..Data1 a 
INNER JOIN Project2..Data2 b ON a.District = b.District)c)d
group by d.State)e


--window output top 3 districts from each state with highest literacy rate

select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from Project2..data1) a

where a.rnk in (1,2,3) order by state