# US HOUSEHOLD INCOME DATA CLEANING

SELECT * FROM us_project.us_household_income;

#Correcting Mispelled Column Names
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` to `id`;

#Replacing Blank values to NULL
UPDATE us_project.us_household_income
SET place = NULL
WHERE PLACE = '';

#Checking to see if updates were made
SELECT *
FROM us_project.us_household_income_statistics;


#identify ID duplicates in the us_household_income table
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

#identify row_ids / ROW duplicates that have more than one row.
SELECT *
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID) row_num
FROM us_project.us_household_income
) AS temp
WHERE row_num > 1
;

# delete the duplicates 
DELETE FROM us_project.us_household_income 
WHERE row_id in ( 
	SELECT row_id
	FROM (
		select row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID) row_num
		FROM us_project.us_household_income
) AS temp 
WHERE row_num > 1
);

#Retrieves Unique states and ordered by alphabetically
SELECT DISTINCT state_name
FROM us_project.us_household_income
ORDER BY 1
;

#UPDATE MISSPELLED GEORGIA
UPDATE us_project.us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia'
;
SELECT state_name 
FROM us_project.us_household_income
WHERE state_name = 'georia'
;
#identified uncapitalized state name
SELECT state_name 
FROM us_project.us_household_income
WHERE state_name = 'alabama'
;
#updates uncapitalized state name to capitalized.
UPDATE us_project.us_household_income
SET state_name = 'Alabama'
WHERE state_name = 'alabama'
;

#Identifies data errors by retrieves entire row data where the `place` column has a NULL value
SELECT *
FROM us_project.us_household_income
WHERE place IS NULL
ORDER BY 1
;

#populate/replace the data where its null based off of the majority of the data in that county
UPDATE us_household_income
SET PLACE = 'Autaugaville'
WHERE county = 'Autauga County'
AND City = 'Vinemont'
;

#find duplicates/errors in `type` column
SELECT type, COUNT(type)
FROM us_project.us_household_income
GROUP by type
; 			# FOUND a MISSPELLED data 'Boroughs' count(1) that should be 'Borough'
            
#update 'Boroughs' to 'Borough'
UPDATE us_project.us_household_income
SET TYPE = 'Borough'
WHERE type = 'Boroughs'
;

# IDENTIFYING invalid zipcodes that have less than 5 numbers
SELECT zip_code, count(zip_code)
FROM us_project.us_household_income
WHERE length(zip_code) < 5
GROUP by zip_code
ORDER by zip_code
;

#Now I view cleaned data
SELECT *
FROM us_project.us_household_income
;









#US HOUSEHOLD INCOME EXPLORATORY DATA ANALYSIS

SELECT *
from us_household_income
;

SELECT *
from us_project.us_household_income_statistics
;

#retrieves the top 10 largest sums of land. 
SELECT state_name, sum(ALand), sum(AWater)
FROM us_household_income
GROUP by state_name
ORDER by 2 desc
LIMIT 10
;

#view both tables in one SELECT
SELECT *
FROM us_project.us_household_income u 
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
;

#Retrieves data from both tables where the `mean` column does NOT have "0" value.
SELECT *
FROM us_project.us_household_income u 
join us_project.us_household_income_statistics us
	on u.id = us.id
where mean <> 0
;

# This retrieves the average household income (both mean and median) for each U.S. state from two joined tables, excluding entries with a mean of zero. The results are rounded to one decimal place, grouped by state, and ordered by the average mean income in ascending order. Showcasing the states that have the lowest average mean household income.
SELECT u.state_name, ROUND(avg(mean),1), ROUND(avg(median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY u.state_name
ORDER BY 2 ASC
;

# This retrieves the same thing as above but instead shows 5 of the lowest avg mean household income.
SELECT u.state_name, ROUND(avg(mean),1), ROUND(avg(median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP by u.state_name
ORDER BY 2 ASC
LIMIT 5
;

## SELECTS THE TOP 10 STATES THAT HAVE THE HIGHEST AVG MEAN HOUSEHOLD INCOME
SELECT u.state_name, ROUND(avg(mean),1), ROUND(avg(median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP by u.state_name
ORDER BY 2 DESC
LIMIT 10
;
# SELECTS THE TOP 10 STATES WITH THE HIGHEST AVG MEDIAN HOUSEHOLD INCOME
SELECT u.state_name, ROUND(avg(mean),1), ROUND(avg(median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY u.state_name
ORDER BY 3 DESC
LIMIT 10
;

# COUNTS THE TYPE OF EACH AREA IE. CITY, VILLAGE, COUNTY, ORDER DESCENDING BY LARGEST AVG(MEAN) TO LOWEST.
SELECT `Type`, COUNT(`Type`), ROUND(avg(mean),1), ROUND(avg(median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP by `Type`
ORDER BY 3 DESC
;

# COUNTS THE TYPE OF EACH AREA IE. CITY, VILLAGE, COUNTY, ORDERS BY DESCENDING LARGEST AVG(MEDIAN) HOUSEHOLD INCOME TO LOWEST.
SELECT `Type`, COUNT(`Type`), ROUND(avg(mean),1), ROUND(avg(median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY `Type`
ORDER BY 4 DESC
; # TYPE 'COMMUNITY' WAS AT THE LOWEST AVG MEDIAN INCOME 

#PUERTO RICO WAS THE STATE WITH THE LOWEST AVG MEDIAN HOUSEHOLD INCOME
SELECT *
FROM us_household_income
WHERE type = 'Community' 
;
# FILTERING OUTLIERS, LOOKING AT THE HIGHER VOLUME TYPES FOR THE DIFFERENT AREAS.
SELECT `Type`, COUNT(`Type`), ROUND(avg(mean),1), ROUND(avg(median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP by `Type`
HAVING COUNT(TYPE) > 100
ORDER BY 4 DESC
; 

#IDENTIFYING THE CITIES THAT HAVE THE HIGHEST AVG MEAN HOUSEHOLD INCOMES
SELECT u.state_name, city, round(avg(mean),1)
FROM us_project.us_household_income u 
INNER join us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP by u.state_name, city
ORDER by 3 DESC
;




























































