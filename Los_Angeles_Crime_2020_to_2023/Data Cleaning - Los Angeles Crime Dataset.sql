/*

Data Cleaning
Los Angeles Crime Data From 2020 to 2023 

*/


SELECT TOP 1000 *
FROM Crime_Data_from_2020_to_Present;
--------------------------------------------------------------------------------------------------------------------------
-- Change Column Names to be more descriptive

-- Rename column DR_NO to Report_Number
EXEC sp_rename 'Crime_Data_from_2020_to_Present.DR_NO', 'Report_Number', 'COLUMN';

-- Rename column Date Rptd to Date_Reported
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Date Rptd]', 'Date_Reported', 'COLUMN';

-- Rename column DATE OCC to Date_Occurred
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[DATE OCC]', 'Date_Occurred', 'COLUMN';

-- Rename column TIME OCC to Time_Occurred
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[TIME OCC]', 'Time_Occurred', 'COLUMN';

-- Rename column AREA to Area_Code
EXEC sp_rename 'Crime_Data_from_2020_to_Present.AREA', 'Area_Code', 'COLUMN';

-- Rename column AREA NAME to Area_Name
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[AREA NAME]', 'Area_Name', 'COLUMN';

-- Rename column Rpt Dist No to Reporting_District_Number
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Rpt Dist No]', 'Reporting_District_Number', 'COLUMN';

-- Rename column Part 1-2 to Crime_Type
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Crime_Type]', 'Part_1-2', 'COLUMN';

-- Rename column Crm Cd to Crime_Code
EXEC sp_rename 'Crime_Data_from_2020_to_Present.Crm Cd', 'Crime_Code', 'COLUMN';

-- Rename column Crm Cd Desc to Crime_Description
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Crm Cd Desc]', 'Crime_Description', 'COLUMN';

-- Rename column Mocodes to Modus_Operandi_Codes
EXEC sp_rename 'Crime_Data_from_2020_to_Present.Mocodes', 'Modus_Operandi_Codes', 'COLUMN';

-- Rename column Vict Age to Victim_Age
EXEC sp_rename 'Crime_Data_from_2020_to_Present.Vict Age', 'Victim_Age', 'COLUMN';

-- Rename column Vict Sex to Victim_Sex
EXEC sp_rename 'Crime_Data_from_2020_to_Present.Vict Sex', 'Victim_Sex', 'COLUMN';

-- Rename column Vict Descent to Victim_Descent
EXEC sp_rename 'Crime_Data_from_2020_to_Present.Vict Descent', 'Victim_Descent', 'COLUMN';

-- Rename column Premis Cd to Premises_Code
EXEC sp_rename 'Crime_Data_from_2020_to_Present.Premis Cd', 'Premises_Code', 'COLUMN';

-- Rename column Premis Desc to Premises_Description
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Premis Desc]', 'Premises_Description', 'COLUMN';

-- Rename column Weapon Used Cd to Weapon_Used_Code
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Weapon Used Cd]', 'Weapon_Used_Code', 'COLUMN';

-- Rename column Weapon Desc to Weapon_Description
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Weapon Desc]', 'Weapon_Description', 'COLUMN';

-- Rename column Status to Status
EXEC sp_rename 'Crime_Data_from_2020_to_Present.Status', 'Status', 'COLUMN';

-- Rename column Status Desc to Status_Description
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Status Desc]', 'Status_Description', 'COLUMN';

-- Rename column Crm Cd 1 to Additional_Crime_Code_1
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Crm Cd 1]', 'Crime_Code_1', 'COLUMN';

-- Rename column Crm Cd 2 to Additional_Crime_Code_2
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Crm Cd 2]', 'Crime_Code_2', 'COLUMN';

-- Rename column Crm Cd 3 to Additional_Crime_Code_3
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Crm Cd 3]', 'Crime_Code_3', 'COLUMN';

-- Rename column Crm Cd 4 to Additional_Crime_Code_4
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Crm Cd 4]', 'Crime_Code_4', 'COLUMN';

-- Rename column LOCATION to Location
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[LOCATION]', 'Location', 'COLUMN';

-- Rename column Cross Street to Cross_Street
EXEC sp_rename 'Crime_Data_from_2020_to_Present.[Cross Street]', 'Cross_Street', 'COLUMN';

-- Rename column LAT to Latitude
EXEC sp_rename 'Crime_Data_from_2020_to_Present.LAT', 'Latitude', 'COLUMN';

-- Rename column LON to Longitude
EXEC sp_rename 'Crime_Data_from_2020_to_Present.LON', 'Longitude', 'COLUMN';


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
SELECT Date_Reported, CONVERT(DATE, Date_Reported)
FROM Crime_Data_from_2020_to_Present;

UPDATE Crime_Data_from_2020_to_Present
SET Date_Reported = CONVERT(DATE, Date_Reported);



-- If it doesn't Update properly
-- Update Date_Reported 
-- #1
ALTER TABLE Crime_Data_from_2020_to_Present  -- You can do the update this way
ADD Date_Reported_Converted DATE;

UPDATE Crime_Data_from_2020_to_Present
SET Date_Reported_Converted = CONVERT(DATE, Date_Reported);

-- #2
ALTER TABLE Crime_Data_from_2020_to_Present		-- Simpler way to do the update
ADD Date_Reported_Converted AS CONVERT(DATE, Date_Reported);


-- Update Date_Occured
-- #1
ALTER TABLE Crime_Data_from_2020_to_Present
ADD Date_Occurred_Converted DATE;

UPDATE Crime_Data_from_2020_to_Present
SET Date_Occurred_Converted = CONVERT(DATE, Date_Occurred);

-- #2
ALTER TABLE Crime_Data_from_2020_to_Present		-- Simpler way to do the update
ADD Date_Occurred_Converted AS CONVERT(DATE, Date_Occurred);

--------------------------------------------------------------------------------------------------------------------------
-- Add a new column "Hour_Occurred" to the table "Crime_Data_from_2020_to_Present"
-- The new column will contain only the hour values extracted from the "Time_Occurred" column without decimal points

ALTER TABLE Crime_Data_from_2020_to_Present
ADD Hour_Occurred AS FLOOR(Time_Occurred / 100);


--------------------------------------------------------------------------------------------------------------------------
-- Update the "Victim_Sex" column with more descriptive values
UPDATE Crime_Data_from_2020_to_Present
SET Victim_Sex = 
    CASE
        WHEN Victim_Sex = 'M' THEN 'Male'
        WHEN Victim_Sex = 'F' THEN 'Female'
        ELSE 'Unknown'
    END;

--------------------------------------------------------------------------------------------------------------------------
-- Update the "Victim_Descent" column with more descriptive values
UPDATE Crime_Data_from_2020_to_Present
SET Victim_Descent = 
    CASE
        WHEN Victim_Descent = 'A' THEN 'Asian'
        WHEN Victim_Descent = 'B' THEN 'Black or African American'
        WHEN Victim_Descent = 'C' THEN 'Chinese'
        WHEN Victim_Descent = 'D' THEN 'Cambodian'
        WHEN Victim_Descent = 'F' THEN 'Filipino'
        WHEN Victim_Descent = 'G' THEN 'Guamanian'
        WHEN Victim_Descent = 'H' THEN 'Hispanic or Latino'
        WHEN Victim_Descent = 'I' THEN 'American Indian or Alaska Native'
        WHEN Victim_Descent = 'J' THEN 'Japanese'
        WHEN Victim_Descent = 'K' THEN 'Korean'
        WHEN Victim_Descent = 'L' THEN 'Laotian'
        WHEN Victim_Descent = 'O' THEN 'Other'
        WHEN Victim_Descent = 'P' THEN 'Pacific Islander'
        WHEN Victim_Descent = 'S' THEN 'Samoan'
        WHEN Victim_Descent = 'U' THEN 'Hawaiian'
        WHEN Victim_Descent = 'V' THEN 'Vietnamese'
        WHEN Victim_Descent = 'W' THEN 'White'
        WHEN Victim_Descent = 'X' THEN 'Unknown'
        WHEN Victim_Descent = 'Z' THEN 'Other Asian'
		ELSE 'Unknown'
    END;