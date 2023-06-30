/*

Exploratory Data Analysis

*/


-- Inspecting the data
-- This query allows you to view all the data in the TeslaSupercharger table and understand its structure and contents.
SELECT *
FROM TeslaSupercharger;

--------------------------------------------------------------------------------------------------------------------------

-- Calculate descriptive statistics for "Stalls"
SELECT
  COUNT(*) AS TotalSuperchargers,
  SUM(Stalls) AS Total_Supercharger_Stalls,
  MIN(Stalls) AS MinStalls_per_location,
  MAX(Stalls) AS MaxStalls_per_location,
  AVG(Stalls) AS AvgStalls_per_location
FROM TeslaSupercharger;

--------------------------------------------------------------------------------------------------------------------------

-- Calculate descriptive statistics for "kW"
SELECT
  COUNT(*) AS TotalSuperchargers,
  MIN(kW) AS MinPower,
  MAX(kW) AS MaxPower,
  AVG(kW) AS AvgPower
FROM TeslaSupercharger;

--------------------------------------------------------------------------------------------------------------------------

-- Calculate descriptive statistics for "Elev(m)"
SELECT
  COUNT(*) AS TotalSuperchargers,
  MIN([Elev(m)]) AS MinElevation,
  MAX([Elev(m)]) AS MaxElevation,
  AVG([Elev(m)]) AS AvgElevation
FROM TeslaSupercharger;

--------------------------------------------------------------------------------------------------------------------------

-- Count Supercharger stations in each city and state to identify regions with the highest concentration
SELECT City, State, COUNT(*) AS StationCount
FROM TeslaSupercharger
GROUP BY City, State
ORDER BY StationCount DESC;



--------------------------------------------------------------------------------------------------------------------------

-- Create a histogram to visualize the frequency distribution of Supercharger openings by month or year

-- Histogram of Supercharger openings by month
SELECT MONTH(OpenDateConverted) AS OpenMonth, COUNT(*) AS OpeningCount
FROM TeslaSupercharger
GROUP BY MONTH(OpenDateConverted)
ORDER BY OpenMonth;

-- Histogram of Supercharger openings by year
SELECT YEAR(OpenDateConverted) AS OpenYear, COUNT(*) AS OpeningCount
FROM TeslaSupercharger
GROUP BY YEAR(OpenDateConverted)
ORDER BY OpenYear;

-- Line plot of cumulative Supercharger openings over time
SELECT OpenDateConverted, COUNT(*) OVER (ORDER BY OpenDateConverted) AS CumulativeOpenings
FROM TeslaSupercharger
ORDER BY OpenDateConverted;



