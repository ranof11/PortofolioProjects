/*

Case Study: How Does a Bike-Share Navigate Speedy Success?

DATA PREPARATION AND DATA CLEANING WITH BIGQUERY
*/


-- Create a new table called 'all_months' to consolidate trip data for the entire year
-- This table will contain data from all twelve months' trip data tables
-- Combine data from each month's trip data table using UNION ALL
-- Create 'all_months' table in the same project and dataset
CREATE TABLE gdap-01.Cyclistic.all_months AS
SELECT * FROM `gdap-01.Cyclistic.202201_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202202_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202203_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202204_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202205_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202206_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202207_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202208_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202209_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202210_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202211_divvy_tripdata`
UNION ALL
SELECT * FROM `gdap-01.Cyclistic.202212_divvy_tripdata`;


----------------------------------------------------------------------------------------------------------------------------------
-- Handle missing values
-- Count all missing values in the table
SELECT
  COUNTIF(ride_id IS NULL) AS missing_ride_id,
  COUNTIF(rideable_type IS NULL) AS missing_rideable_type,
  COUNTIF(started_at IS NULL) AS missing_started_at,
  COUNTIF(ended_at IS NULL) AS missing_ended_at,
  COUNTIF(start_station_name IS NULL) AS missing_start_station_name,
  COUNTIF(start_station_id IS NULL) AS missing_start_station_id,
  COUNTIF(end_station_name IS NULL) AS missing_end_station_name,
  COUNTIF(end_station_id IS NULL) AS missing_end_station_id,
  COUNTIF(start_lat IS NULL) AS missing_start_lat,
  COUNTIF(start_lng IS NULL) AS missing_start_lng,
  COUNTIF(end_lat IS NULL) AS missing_end_lat,
  COUNTIF(end_lng IS NULL) AS missing_end_lng,
  COUNTIF(member_casual IS NULL) AS missing_member_casual
FROM `gdap-01.Cyclistic.all_months`;


-- Create a new table with selected columns for analysis
-- This query creates a new table for analysis, including only the columns needed for the task.
CREATE TABLE `gdap-01.Cyclistic.all_months_selected_columns`
AS
SELECT
  ride_id,              -- Unique identifier for each ride
  rideable_type,        -- Type of bike used for the ride
  started_at,           -- Timestamp when the ride started
  ended_at,             -- Timestamp when the ride ended
  member_casual         -- Indicates rider's membership type
FROM `gdap-01.Cyclistic.all_months`;

----------------------------------------------------------------------------------------------------------------------------------
-- Query rows with duplicate ride_id values
-- Duplicates are expected and valid in the context of a bike-sharing program, as they represent instances where individuals use bikes multiple times within a given time frame (e.g., a year or a month).
-- By retaining these duplicates, the analysis maintains the integrity of user interactions.
SELECT
  t.*
FROM `gdap-01.Cyclistic.all_months_selected_columns` AS t
WHERE t.ride_id IN (
  SELECT ride_id
  FROM `gdap-01.Cyclistic.all_months_selected_columns`
  GROUP BY ride_id
  HAVING COUNT(ride_id) > 1
);


----------------------------------------------------------------------------------------------------------------------------------
/* Create a new column ride_length and calculate ride duration in HH:MM:SS format */
/* This query calculates the duration of each ride in the Cyclistic bike-sharing program
   and formats it as HH:MM:SS. It uses the TIMESTAMP_DIFF function to calculate the
   duration in seconds and then converts it to the desired format using FORMAT_TIMESTAMP.
   The durations are calculated based on the started_at and ended_at timestamps in the
   original dataset. */

/* Since BigQuery doesn't permit direct modification of tables without billing,
   we create a new table to store the result of this analysis. The new table will
   include the original columns along with the calculated ride lengths. */
   -- name the table "selected_columns_update1"

WITH durations AS (
  SELECT
    ride_id,
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS duration_seconds
  FROM `gdap-01.Cyclistic.all_months_selected_columns`
)
SELECT
  a.*,
  FORMAT_TIMESTAMP('%H:%M:%S', TIMESTAMP_SECONDS(d.duration_seconds)) AS ride_length
FROM `gdap-01.Cyclistic.all_months_selected_columns` AS a
JOIN durations AS d
ON a.ride_id = d.ride_id;


----------------------------------------------------------------------------------------------------------------------------------
-- Create a new column day_of_week and calculate the day of the week that each ride started
/* This query adds a new column 'day_of_week' to the dataset to indicate the day of the week when each ride started.
   This additional column can help analyze ride patterns and trends based on the
   day of the week. */
/* Create a new table called "selected_columns_update2" */

SELECT
  *,
  CASE
    WHEN EXTRACT(DAYOFWEEK FROM started_at) = 1 THEN 'Sunday'
    WHEN EXTRACT(DAYOFWEEK FROM started_at) = 2 THEN 'Monday'
    WHEN EXTRACT(DAYOFWEEK FROM started_at) = 3 THEN 'Tuesday'
    WHEN EXTRACT(DAYOFWEEK FROM started_at) = 4 THEN 'Wednesday'
    WHEN EXTRACT(DAYOFWEEK FROM started_at) = 5 THEN 'Thursday'
    WHEN EXTRACT(DAYOFWEEK FROM started_at) = 6 THEN 'Friday'
    WHEN EXTRACT(DAYOFWEEK FROM started_at) = 7 THEN 'Saturday'
  END AS day_of_week
FROM `gdap-01.Cyclistic.selected_columns_update1`;


----------------------------------------------------------------------------------------------------------------------------------
