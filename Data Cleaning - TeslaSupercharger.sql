/*

Teslasupercharger Data Cleaning

*/


-- Select all rows from the TeslaSupercharger table to inspect the data
SELECT *
FROM TeslaSupercharger;

--------------------------------------------------------------------------------------------------------------------------

-- Populates null values in the OpenDate column with the latest date in the column
-- Assumes that null values indicate newly built Superchargers
UPDATE TeslaSupercharger
SET OpenDate = (
  SELECT MAX(OpenDate)
  FROM TeslaSupercharger
)
WHERE OpenDate IS NULL;


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

-- Display the original OpenDate column and its conversion to DATE data type
SELECT opendate, CONVERT(DATE, opendate)
FROM teslasupercharger;

-- Update the OpenDate column to the standardized DATE format
UPDATE teslasupercharger
SET opendate = CONVERT(DATE, opendate);


-- If the update doesn't work properly, create an additional column OpenDateConverted to store the converted dates
ALTER TABLE teslasupercharger
ADD OpenDateConverted DATE;

-- Update the OpenDateConverted column with the converted dates
UPDATE teslasupercharger
SET OpenDateConverted = CONVERT(DATE, opendate);


--------------------------------------------------------------------------------------------------------------------------

-- Filter the Supercharger locations in the USA
SELECT *
FROM TeslaSupercharger
WHERE Country = 'usa'

-- Convert the USA state abbreviations in table to their corresponding full names
-- Create a lookup table:
CREATE TABLE StateLookup (
  StateCode VARCHAR(2),
  StateName VARCHAR(50)
);

-- Populate the lookup table with the state abbreviations and their corresponding full names:
INSERT INTO StateLookup (StateCode, StateName)
VALUES 
    ('AL', 'Alabama'),
    ('AK', 'Alaska'),
    ('AZ', 'Arizona'),
    ('AR', 'Arkansas'),
    ('CA', 'California'),
    ('CO', 'Colorado'),
    ('CT', 'Connecticut'),
    ('DE', 'Delaware'),
    ('FL', 'Florida'),
    ('GA', 'Georgia'),
    ('HI', 'Hawaii'),
    ('ID', 'Idaho'),
    ('IL', 'Illinois'),
    ('IN', 'Indiana'),
    ('IA', 'Iowa'),
    ('KS', 'Kansas'),
    ('KY', 'Kentucky'),
    ('LA', 'Louisiana'),
    ('ME', 'Maine'),
    ('MD', 'Maryland'),
    ('MA', 'Massachusetts'),
    ('MI', 'Michigan'),
    ('MN', 'Minnesota'),
    ('MS', 'Mississippi'),
    ('MO', 'Missouri'),
    ('MT', 'Montana'),
    ('NE', 'Nebraska'),
    ('NV', 'Nevada'),
    ('NH', 'New Hampshire'),
    ('NJ', 'New Jersey'),
    ('NM', 'New Mexico'),
    ('NY', 'New York'),
    ('NC', 'North Carolina'),
    ('ND', 'North Dakota'),
    ('OH', 'Ohio'),
    ('OK', 'Oklahoma'),
    ('OR', 'Oregon'),
    ('PA', 'Pennsylvania'),
    ('RI', 'Rhode Island'),
    ('SC', 'South Carolina'),
    ('SD', 'South Dakota'),
    ('TN', 'Tennessee'),
    ('TX', 'Texas'),
    ('UT', 'Utah'),
    ('VT', 'Vermont'),
    ('VA', 'Virginia'),
    ('WA', 'Washington'),
    ('WV', 'West Virginia'),
    ('WI', 'Wisconsin'),
    ('WY', 'Wyoming');

-- Join the TeslaSupercharger table with the StateLookup table to retrieve Supercharger locations with actual state names
SELECT ts.state, sl.StateCode, sl.StateName
FROM TeslaSupercharger ts
JOIN StateLookup sl
ON ts.State = sl.StateCode;

-- Update the TeslaSupercharger table to replace state codes with their corresponding full names
UPDATE TeslaSupercharger
SET State = sl.StateName
FROM TeslaSupercharger ts
JOIN StateLookup sl 
ON ts.State = sl.StateCode;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

-- Select all columns from the TeslaSupercharger table to review the data
SELECT *
FROM TeslaSupercharger;

-- Drop the OpenDate column as it has been standardized to the DATE format
ALTER TABLE TeslaSupercharger
DROP COLUMN OpenDate;


