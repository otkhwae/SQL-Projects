
USE techtfq;

-- select all columns
SELECT * FROM athlete_events;

-- count all rows and check if they match rows count in excel file
SELECT COUNT(*) AS 'Num_all rows'
FROM athlete_events;

-- How many olympics games have been held?
 SELECT COUNT(DISTINCT Games) AS tot_games 
 FROM athlete_events;

-- List down all Olympics games held so far
SELECT DISTINCT Year, Season, City
FROM athlete_events
ORDER BY  Year;
--==========================================================================================
-- Mention the total no of nations who participated in each olympics game?

SELECT Games, NOC
FROM athlete_events;

WITH T1 AS
(SELECT  Games, NOC
FROM athlete_events
GROUP BY Games,NOC)

SELECT Games, count(NOC) AS tot_countries
FROM T1
GROUP BY Games
ORDER BY Games;

--=============================================================================================

--Which YEAR saw the highest and lowest NO OF COUNTRIES participating in olympics
--Problem Statement: Write a SQL query to return the Olympic Games which had the highest participating 
--countries and the lowest participating countries.

SELECT Games, NOC, Year
FROM athlete_events
ORDER BY Games,NOC;

WITH T1 AS
(SELECT Games, NOC, Year
FROM athlete_events
GROUP BY Games, NOC, Year),

T2 AS
(SELECT Games,Year, COUNT(NOC) AS tot_teams
FROM T1
GROUP BY Games,Year)

SELECT MIN(tot_teams) AS minn, MAX(tot_teams)
FROM T2;

--==========================================================================================
--Which nation has participated in all of the olympic games

--Problem Statement: SQL query to return the list of countries who have been part of every Olympics games.

WITH T1 AS
(SELECT Games,NOC 
FROM athlete_events
GROUP BY Games, NOC)

SELECT NOC, COUNT(NOC) AS cnt
FROM T1
GROUP BY NOC 
HAVING COUNT(NOC) = (SELECT COUNT(DISTINCT Games) AS tot_games FROM athlete_events)
ORDER BY NOC DESC

--=========================================================================================================
--Fetch the top 5 athletes who have won the most gold medals.
--Problem Statement: SQL query to fetch the top 5 athletes who have won the most gold medals.

WITH T1 AS
(SELECT NAME, count(*) AS tot_medals
FROM athlete_events
WHERE Medal = 'Gold'
GROUP BY NAME),

T2 AS
(SELECT *, DENSE_RANK () OVER(ORDER BY tot_medals DESC) AS rnk 
FROM T1)

SELECT *
FROM T2
WHERE rnk <= 5