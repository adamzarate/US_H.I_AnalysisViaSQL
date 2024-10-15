# US_H.I_AnalysisViaSQL
SQL project showcasing data cleaning and analysis on U.S. household income data. Tasks include fixing errors, handling duplicates, managing missing values, and standardizing data. It also explores income trends by state and area types, identifying outliers and top-performing regions!


US Household Income Data Cleaning and Exploratory Data Analysis (EDA) Project
Overview
This SQL project demonstrates data cleaning and exploratory data analysis (EDA) on U.S. household income data. It covers essential database operations such as identifying and fixing data inconsistencies, handling duplicates, and performing insightful analyses on household income trends across different states and areas.



Key Concepts and SQL Operations Used
Data Cleaning:
Correcting Misspelled Column Names:

Used ALTER TABLE to fix incorrectly encoded columns.
Handling Missing Values:

Converted blank entries in place to NULL using UPDATE.
Identifying and Removing Duplicates:

Applied ROW_NUMBER() and DELETE queries to find and remove duplicate rows by ID.
Standardizing Data:

Corrected inconsistent spellings (e.g., "georia" to "Georgia", lowercase to uppercase state names) with UPDATE.
Validating Data Integrity:

Used queries to identify invalid zip codes and data errors, like entries with fewer than five digits.



Exploratory Data Analysis (EDA):
Aggregating Income Statistics:

Joined us_household_income and us_household_income_statistics to retrieve mean and median income by state and area types.
Identifying Top and Bottom Performers:

Found states with the highest and lowest average incomes.
Ranked city-level income performance.
Analyzing Income Distribution by Area Type:

Counted and averaged income data by types like city, village, county, and community.
Filtering Outliers:

Filtered out area types with fewer than 100 entries to focus on significant patterns.
Land and Water Area Analysis:

Retrieved states with the largest land and water areas to explore geographical impacts on income.



Functions and SQL Concepts Demonstrated:
ALTER TABLE: Rename columns.
UPDATE: Modify entries to fix errors and handle missing values.
ROW_NUMBER(): Identify duplicate rows.
DELETE: Remove duplicate data.
GROUP BY and ORDER BY: Aggregate and rank income data.
JOIN: Combine data across multiple tables.
HAVING: Filter aggregated results for deeper insights.
