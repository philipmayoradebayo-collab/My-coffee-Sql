/*
POWERBI ANALYSIS CRUDE PROMPT
Role: I am a business data analyst goal: To analyse a world coffee roaster review dataset. 
My analysis is to provide answers to the following business 
questions: 1.	What is the most expensive coffee per 100g, and what features distinguish it?
2.	Which country of origin has the highest average rating for coffee?
3.	Which coffee brand has the best/worst average rating every year?
4.	Which roaster has received the best reviews in terms of average rating?
5.	How many coffees have a rating above 90?
6.	Which coffee has a “light” roast?
7.	Which country contributes the most to the dataset in terms of coffee production?
8.	Is there any relationship between the price of coffee and its rating, considering different origins and roast?
9.	In North America (Roaster location), show a word cloud visual of their coffee’s Aroma.
10.	Top 5 high average rating coffee brands in Asia, do they have a common Mouthfeel? 
Provide any recommendations for future Asian markets. 
task:Take a critical look at the dataset uploaded perform a detailed exploratory data analysis to
uncover key insights in the dataset, identify the required transformations and data cleaning process 
that should be performed on the dataset including all measures and columns to be created. 
provide the DAX functions as necesary to achieve my goal. 
I want you to create a 3-page report such that the first page contains the overview of the data 
exploration providing key insights from the data and the other two pages provides apprproiate 
analysis theme using the dataset. suggest appropriate visuals for my report pages, 
also include appropriate filters, buttons, bookmarks, tooltips, parameters and drillthrough. Constraints: No hardcoding of data, only information from the dataset should be used. I am using powerBI Desktop.  Refine and Optimize my prompt using appropriate prompting framework and wait for my next instruction
*/


/*
prompt to write table schema
write the sql queries to create a database for my dataset, design a table schema create table 
and load the dataset into mysql locally. make sure dataset local load restrictions are handled
*/

/* =========================================================
   MYSQL DATABASE SETUP FOR COFFEE DATASET
   COMPLETE LOCAL IMPORT SCRIPT
   =========================================================

   THIS SCRIPT WILL:
   1. Create a database
   2. Create a clean analytics-ready table schema
   3. Handle LOCAL INFILE restrictions
   4. Load CSV dataset locally into MySQL
   5. Validate imported data
   6. Add performance indexes

   =========================================================
   BEFORE RUNNING THIS SCRIPT
   =========================================================

   STEP 1:
   Save your dataset as CSV:
   Example:
   coffee_dataset.csv

   STEP 2:
   Place the CSV in an accessible folder:
   Example Windows:
   C:/mysql-files/coffee_dataset.csv

   Example Mac/Linux:
   /Users/yourname/mysql-files/coffee_dataset.csv

   ========================================================= */


/* =========================================================
   1. ENABLE LOCAL FILE IMPORT
   ========================================================= */

-- Check if LOCAL INFILE is enabled

SHOW VARIABLES LIKE 'local_infile';


/* =========================================================
   IF local_infile = OFF
   =========================================================

   OPTION A — MYSQL WORKBENCH CONNECTION FIX

   1. Open MySQL Workbench
   2. Go to:
      Database > Manage Connections
   3. Select your connection
   4. Click "Advanced"
   5. Add this to "Others":

      OPT_LOCAL_INFILE=1

   6. Save and reconnect

   ---------------------------------------------------------

   OPTION B — MYSQL SERVER CONFIGURATION

   WINDOWS:
   Edit my.ini

   Add:
   local_infile=1

   Restart MySQL Server

   ---------------------------------------------------------

   MAC/LINUX:
   Edit my.cnf

   Add:
   local_infile=1

   Restart MySQL

   ========================================================= */


/* =========================================================
   2. CREATE DATABASE
   ========================================================= */

DROP DATABASE IF EXISTS coffee_analytics;

CREATE DATABASE coffee_analytics;

USE coffee_analytics;

/* =========================================================
   3. CREATE TABLE SCHEMA
   ========================================================= */

DROP TABLE IF EXISTS coffee_ratings;

-- CREATE TABLE coffee_ratings (

--     coffee_id INT AUTO_INCREMENT PRIMARY KEY,

--     brand_name VARCHAR(255),

--     roasters VARCHAR(255),

--     roast_type VARCHAR(100),

--     roaster_location VARCHAR(255),

--     roaster_latitude DECIMAL(10,6),

--     roaster_longitude DECIMAL(10,6),

--     origin_country VARCHAR(255),

--     origin_latitude DECIMAL(10,6),

--     origin_longitude DECIMAL(10,6),

--     price_per_100g_usd DECIMAL(10,2),

--     rating DECIMAL(5,2),

--     review_date varchar(10),

--     short_product_description TEXT,

--     aroma TEXT,

--     mouthfeel TEXT,

--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

-- );
CREATE TABLE coffee_ratings (

    coffee_id INT AUTO_INCREMENT PRIMARY KEY,

    brand_name VARCHAR(255),

    roasters VARCHAR(255),

    roast_type VARCHAR(100),

    roaster_location VARCHAR(255),

    roaster_latitude DECIMAL(10,6),

    roaster_longitude DECIMAL(10,6),

    origin_country VARCHAR(255),

    origin_latitude DECIMAL(10,6),

    origin_longitude DECIMAL(10,6),

    price_per_100g_usd DECIMAL(10,2),

    rating DECIMAL(5,2),

    review_date DATE,

    short_product_description TEXT,

    aroma TEXT,

    mouthfeel TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

/* =========================================================
   4. LOAD DATA FROM CSV FILE
   =========================================================

   IMPORTANT:
   Replace the file path below with YOUR actual path.

   WINDOWS PATH FORMAT:
   Use forward slashes (/)

   GOOD:
   C:/mysql-files/coffee_dataset.csv

   BAD:
   C:\mysql-files\coffee_dataset.csv

   ========================================================= */
SET GLOBAL local_infile = 1;

-- LOAD DATA LOCAL INFILE "C://ProgramData//MySQL//MySQL Server 8.0//Uploads//coffee.csv"
-- INTO TABLE coffee_ratings
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS

-- (
--     brand_name,
--     roasters,
--     roast_type,
--     roaster_location,
--     roaster_latitude,
--     roaster_longitude,
--     origin_country,
--     origin_latitude,
--     origin_longitude,
--     price_per_100g_usd,
--     rating,
--     @review_date,
--     short_product_description,
--     aroma,
--     mouthfeel
-- )

-- SET review_date =
--     CASE
--         WHEN @review_date = ''
--         THEN NULL
--         ELSE STR_TO_DATE(@review_date, '%d-%m-%Y')
--     END;


-- LOAD DATA INFILE '/path/to/coffee.csv'
set sql_mode ="";
LOAD DATA INFILE "C://ProgramData//MySQL//MySQL Server 8.2//Uploads//cofeecsv.csv"
INTO TABLE coffee_ratings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @brand_name,
    @roasters,
    @roast_type,
    @roaster_location,
    @roaster_latitude,
    @roaster_longitude,
    @origin_country,
    @origin_latitude,
    @origin_longitude,
    @price_per_100g_usd,
    @rating,
    @review_date,
    @short_product_description,
    @aroma,
    @mouthfeel
)
SET
    brand_name = NULLIF(@brand_name, ''),
    roasters = NULLIF(@roasters, ''),
    roast_type = NULLIF(@roast_type, ''),
    roaster_location = NULLIF(@roaster_location, ''),
    roaster_latitude = NULLIF(@roaster_latitude, ''),
    roaster_longitude = NULLIF(@roaster_longitude, ''),
    origin_country = NULLIF(@origin_country, ''),
    origin_latitude = NULLIF(@origin_latitude, ''),
    origin_longitude = NULLIF(@origin_longitude, ''),
    price_per_100g_usd = NULLIF(@price_per_100g_usd, ''),
    rating = NULLIF(@rating, ''),
    review_date = STR_TO_DATE(@review_date, '%Y-%m-%d'),
    short_product_description = NULLIF(@short_product_description, ''),
    aroma = NULLIF(@aroma, ''),
    mouthfeel = NULLIF(@mouthfeel, '');
/* =========================================================
   5. VERIFY IMPORT
   ========================================================= */

-- Total records imported

SELECT COUNT(*) AS total_records
FROM coffee_ratings;


-- Preview imported data

SELECT *
FROM coffee_ratings
LIMIT 10;


/* =========================================================
   6. DATA QUALITY CHECKS
   ========================================================= */

-- Check for NULL ratings

SELECT COUNT(*) AS null_ratings
FROM coffee_ratings
WHERE rating IS NULL;


-- Check invalid prices

SELECT *
FROM coffee_ratings
WHERE price_per_100g_usd < 0;


-- Check invalid coordinates

SELECT *
FROM coffee_ratings
WHERE roaster_latitude NOT BETWEEN -90 AND 90
   OR roaster_longitude NOT BETWEEN -180 AND 180;


-- Check duplicate coffee entries

SELECT
    brand_name,
    roasters,
    COUNT(*) AS duplicate_count
FROM coffee_ratings
GROUP BY brand_name, roasters
HAVING COUNT(*) > 1;


/* =========================================================
   7. CREATE INDEXES FOR FASTER ANALYTICS
   ========================================================= */

CREATE INDEX idx_brand_name
ON coffee_ratings(brand_name);

CREATE INDEX idx_origin_country
ON coffee_ratings(origin_country);

CREATE INDEX idx_roast_type
ON coffee_ratings(roast_type);

CREATE INDEX idx_rating
ON coffee_ratings(rating);

CREATE INDEX idx_price
ON coffee_ratings(price_per_100g_usd);

CREATE INDEX idx_review_date
ON coffee_ratings(review_date);

CREATE INDEX idx_roasters
ON coffee_ratings(roasters);


/* =========================================================
   8. CREATE ANALYTICS VIEW
   ========================================================= */

CREATE OR REPLACE VIEW vw_coffee_summary AS

SELECT

    coffee_id,

    brand_name,

    roasters,

    roast_type,

    origin_country,

    roaster_location,

    price_per_100g_usd,

    rating,

    YEAR(review_date) AS review_year,

    aroma,

    mouthfeel

FROM coffee_ratings;


/* =========================================================
   9. TEST ANALYTICS QUERY
   ========================================================= */

SELECT
    origin_country,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS total_coffees
FROM coffee_ratings
GROUP BY origin_country
ORDER BY avg_rating DESC;


/* =========================================================
   10. SHOW TABLE STRUCTURE
   ========================================================= */

DESCRIBE coffee_ratings;


/* =========================================================
   11. SHOW DATABASE TABLES
   ========================================================= */

SHOW TABLES;


/* =========================================================
   OPTIONAL:
   EXPORT CLEAN DATA
   ========================================================= */

-- Example export

/*
SELECT *
FROM coffee_ratings
INTO OUTFILE 'C:/mysql-files/clean_coffee_export.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
*/


/* =========================================================
   TROUBLESHOOTING GUIDE
   =========================================================

   ERROR:
   "The used command is not allowed with this MySQL version"

   FIX:
   Enable local_infile=1

   ---------------------------------------------------------

   ERROR:
   "File not found"

   FIX:
   Verify CSV path exists exactly.

   ---------------------------------------------------------

   ERROR:
   "Incorrect date value"

   FIX:
   Change STR_TO_DATE format.

   Example:
   '%m/%d/%Y'
   '%d-%m-%Y'
   '%Y-%m-%d'

   ---------------------------------------------------------

   ERROR:
   "Row truncated"

   FIX:
   Increase VARCHAR size or inspect CSV formatting.

   ========================================================= */


/* =========================================================
   END OF MYSQL SETUP SCRIPT
   ========================================================= */

/*
Prompt to generate queries for analysis
These are the column names of my data table, Brand Name	Roasters	
Type of Roast	Roaster Location	Roaster Latitude	Roaster Longitude	Origin	Origin Latitude	
origin longitude	Price per 100g (USD)	Rating	Review Date	Short Product Description	
Aroma	Mouthfeel
 I am a senior level business data analyst, I want to analyse the dataset in mysql workbench. 
 my analysis should answer the following business questions: 1.	What is the most expensive coffee 
 per 100g, and what features distinguish it?
2.	Which country of origin has the highest average rating for coffee?
3.	Which coffee brand has the best/worst average rating every year?
4.	Which roaster has received the best reviews in terms of average rating?
5.	How many coffees have a rating above 90?
6.	Which coffee has a “light” roast?
7.	Which country contributes the most to the dataset in terms of coffee production?
8.	Is there any relationship between the price of coffee and its rating, considering different origins and roast?
9.	In North America (Roaster location), show a word cloud visual of their coffee’s Aroma.
10.	Top 5 high average rating coffee brands in Asia, do they have a common Mouthfeel? Provide any recommendations for future Asian markets.
write a complete and detailed SQL queries that uncover insights in my data and answers my business questions. output an sql script I can use in mysql workbench 

Please write in English language.
*/

/* =========================================================
   COFFEE DATASET BUSINESS ANALYSIS SCRIPT
   DATABASE: MYSQL WORKBENCH
   =========================================================

   ASSUMPTIONS:
   1. Table name = coffee_ratings
   2. Review Date is stored as DATE or VARCHAR
   3. Price per 100g (USD) and Rating are numeric
   4. Origin contains country names
   5. Roaster Location contains continent/country/city text

   =========================================================
   OPTIONAL: CLEANING & PREPARATION
   ========================================================= */

USE coffee_db;

-- Rename columns with spaces for easier querying (OPTIONAL)
-- Recommended for professional analytics workflow

ALTER TABLE coffee_ratings
CHANGE COLUMN `Brand Name` brand_name VARCHAR(255);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Roasters` roasters VARCHAR(255);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Type of Roast` roast_type VARCHAR(100);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Roaster Location` roaster_location VARCHAR(255);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Roaster Latitude` roaster_latitude DECIMAL(10,6);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Roaster Longitude` roaster_longitude DECIMAL(10,6);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Origin` origin_country VARCHAR(255);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Origin Latitude` origin_latitude DECIMAL(10,6);

ALTER TABLE coffee_ratings
CHANGE COLUMN `origin longitude` origin_longitude DECIMAL(10,6);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Price per 100g (USD)` price_per_100g_usd DECIMAL(10,2);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Rating` rating DECIMAL(5,2);

ALTER TABLE coffee_ratings
CHANGE COLUMN `Review Date` review_date DATE;

ALTER TABLE coffee_ratings
CHANGE COLUMN `Short Product Description` short_product_description TEXT;

ALTER TABLE coffee_ratings
CHANGE COLUMN `Aroma` aroma TEXT;

ALTER TABLE coffee_ratings
CHANGE COLUMN `Mouthfeel` mouthfeel TEXT;


/* =========================================================
   1. MOST EXPENSIVE COFFEE PER 100G
   AND FEATURES THAT DISTINGUISH IT
   ========================================================= */

SELECT
    brand_name,
    roasters,
    roast_type,
    origin_country,
    price_per_100g_usd,
    rating,
    aroma,
    mouthfeel,
    short_product_description
FROM coffee_ratings
WHERE price_per_100g_usd = (
    SELECT MAX(price_per_100g_usd)
    FROM coffee_ratings
);

-- INSIGHT:
-- Reveals premium coffee characteristics:
-- roast type, origin, sensory profile, and ratings.


/* =========================================================
   2. COUNTRY OF ORIGIN WITH HIGHEST AVERAGE RATING
   ========================================================= */

SELECT
    origin_country,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS total_coffees
FROM coffee_ratings
GROUP BY origin_country
HAVING COUNT(*) >= 3
ORDER BY avg_rating DESC;

-- INSIGHT:
-- Identifies countries producing the highest-quality coffee.


/* =========================================================
   3. BEST/WORST AVERAGE RATED BRAND EACH YEAR
   ========================================================= */

WITH yearly_brand_rating AS (
    SELECT
        YEAR(review_date) AS review_year,
        brand_name,
        ROUND(AVG(rating), 2) AS avg_rating
    FROM coffee_ratings
    GROUP BY YEAR(review_date), brand_name
),

ranked_brands AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY review_year
            ORDER BY avg_rating DESC
        ) AS best_rank,

        RANK() OVER (
            PARTITION BY review_year
            ORDER BY avg_rating ASC
        ) AS worst_rank
    FROM yearly_brand_rating
)

SELECT
    review_year,
    brand_name,
    avg_rating,
    CASE
        WHEN best_rank = 1 THEN 'BEST BRAND'
        WHEN worst_rank = 1 THEN 'WORST BRAND'
    END AS performance_category
FROM ranked_brands
WHERE best_rank = 1
   OR worst_rank = 1
ORDER BY review_year, avg_rating DESC;

-- INSIGHT:
-- Tracks brand performance over time.


/* =========================================================
   4. ROASTER WITH BEST REVIEWS
   ========================================================= */

SELECT
    roasters,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS total_reviews
FROM coffee_ratings
GROUP BY roasters
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC;

-- INSIGHT:
-- Identifies top-performing roasting companies.


/* =========================================================
   5. HOW MANY COFFEES HAVE RATING ABOVE 90?
   ========================================================= */

SELECT
    COUNT(*) AS coffees_above_90
FROM coffee_ratings
WHERE rating > 90;

-- OPTIONAL DETAILED VIEW

SELECT
    brand_name,
    roasters,
    origin_country,
    rating
FROM coffee_ratings
WHERE rating > 90
ORDER BY rating DESC;


/* =========================================================
   6. COFFEES WITH LIGHT ROAST
   ========================================================= */

SELECT
    brand_name,
    roasters,
    roast_type,
    origin_country,
    rating,
    price_per_100g_usd
FROM coffee_ratings
WHERE LOWER(roast_type) LIKE '%light%';

-- INSIGHT:
-- Useful for market segmentation analysis.


/* =========================================================
   7. COUNTRY CONTRIBUTING MOST TO DATASET
   ========================================================= */

SELECT
    origin_country,
    COUNT(*) AS total_coffees,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM coffee_ratings),
        2
    ) AS percentage_contribution
FROM coffee_ratings
GROUP BY origin_country
ORDER BY total_coffees DESC;

-- INSIGHT:
-- Identifies dominant coffee-producing countries
-- represented in the dataset.


/* =========================================================
   8. RELATIONSHIP BETWEEN PRICE & RATING
   BY ORIGIN AND ROAST TYPE
   ========================================================= */

SELECT
    origin_country,
    roast_type,

    ROUND(AVG(price_per_100g_usd), 2) AS avg_price,
    ROUND(AVG(rating), 2) AS avg_rating,

    ROUND(
        CORR(price_per_100g_usd, rating),
        3
    ) AS price_rating_correlation,

    COUNT(*) AS total_records
FROM coffee_ratings
GROUP BY origin_country, roast_type
HAVING COUNT(*) >= 3
ORDER BY price_rating_correlation DESC;

-- NOTE:
-- CORR() works in MySQL 8+.
-- Positive correlation:
-- expensive coffees tend to have higher ratings.


/* =========================================================
   ALTERNATIVE CORRELATION QUERY
   IF CORR() IS NOT SUPPORTED
   ========================================================= */

SELECT
    origin_country,
    roast_type,

    ROUND(
        (
            AVG(price_per_100g_usd * rating)
            - AVG(price_per_100g_usd)
            * AVG(rating)
        ) /
        (
            STDDEV(price_per_100g_usd)
            * STDDEV(rating)
        ),
        3
    ) AS correlation_value
FROM coffee_ratings
GROUP BY origin_country, roast_type;

-- INSIGHT:
-- Statistical relationship between pricing and quality.


/* =========================================================
   9. NORTH AMERICA AROMA WORD CLOUD DATA
   ========================================================= */

-- MYSQL does not directly generate word clouds.
-- This query prepares frequency data for Tableau,
-- Power BI, Python, or Excel word cloud visuals.

SELECT
    aroma,
    COUNT(*) AS frequency
FROM coffee_ratings
WHERE LOWER(roaster_location) REGEXP
      'usa|canada|mexico|north america'
GROUP BY aroma
ORDER BY frequency DESC;

-- ADVANCED TOKENIZATION VERSION

WITH RECURSIVE split_words AS (
    SELECT
        SUBSTRING_INDEX(aroma, ' ', 1) AS word,
        SUBSTRING(
            aroma,
            LENGTH(SUBSTRING_INDEX(aroma, ' ', 1)) + 2
        ) AS remaining
    FROM coffee_ratings
    WHERE LOWER(roaster_location)
          REGEXP 'usa|canada|mexico|north america'

    UNION ALL

    SELECT
        SUBSTRING_INDEX(remaining, ' ', 1),
        SUBSTRING(
            remaining,
            LENGTH(SUBSTRING_INDEX(remaining, ' ', 1)) + 2
        )
    FROM split_words
    WHERE remaining <> ''
)

SELECT
    LOWER(word) AS aroma_word,
    COUNT(*) AS frequency
FROM split_words
WHERE LENGTH(word) > 3
GROUP BY LOWER(word)
ORDER BY frequency DESC
LIMIT 100;

-- Export this result into Power BI/Tableau
-- to create a Word Cloud visual.


/* =========================================================
   10. TOP 5 HIGH AVERAGE RATING BRANDS IN ASIA
   COMMON MOUTHFEEL & RECOMMENDATIONS
   ========================================================= */

-- STEP 1: TOP 5 ASIAN BRANDS

WITH asia_brands AS (
    SELECT
        brand_name,
        mouthfeel,
        ROUND(AVG(rating), 2) AS avg_rating,
        COUNT(*) AS total_reviews
    FROM coffee_ratings
    WHERE LOWER(origin_country) REGEXP
          'china|japan|india|indonesia|vietnam|thailand|philippines|laos|nepal|yemen|myanmar|malaysia'
    GROUP BY brand_name, mouthfeel
)

SELECT
    brand_name,
    mouthfeel,
    avg_rating,
    total_reviews
FROM asia_brands
ORDER BY avg_rating DESC
LIMIT 5;

-- STEP 2: COMMON MOUTHFEEL ANALYSIS

SELECT
    mouthfeel,
    COUNT(*) AS frequency,
    ROUND(AVG(rating), 2) AS avg_rating
FROM coffee_ratings
WHERE LOWER(origin_country) REGEXP
      'china|japan|india|indonesia|vietnam|thailand|philippines|laos|nepal|yemen|myanmar|malaysia'
GROUP BY mouthfeel
ORDER BY avg_rating DESC, frequency DESC;

-- BUSINESS RECOMMENDATIONS:
--
-- 1. Focus future Asian market products around
--    dominant high-rated mouthfeel characteristics.
--
-- 2. If silky/tea-like/creamy mouthfeel dominates,
--    product development should prioritize these textures.
--
-- 3. Premium Asian specialty coffee markets respond
--    strongly to sensory differentiation.
--
-- 4. Brands should market mouthfeel descriptors
--    alongside aroma and roast profiles.
--
-- 5. High-rated Asian coffees can support premium pricing
--    if sensory consistency is maintained.


/* =========================================================
   BONUS EXECUTIVE DASHBOARD QUERIES
   ========================================================= */

-- TOP 10 HIGHEST RATED COFFEES

SELECT
    brand_name,
    roasters,
    origin_country,
    roast_type,
    rating,
    price_per_100g_usd
FROM coffee_ratings
ORDER BY rating DESC
LIMIT 10;


-- AVERAGE RATING BY ROAST TYPE

SELECT
    roast_type,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS total_coffees
FROM coffee_ratings
GROUP BY roast_type
ORDER BY avg_rating DESC;


-- PRICE DISTRIBUTION BY ROAST TYPE

SELECT
    roast_type,
    ROUND(MIN(price_per_100g_usd), 2) AS min_price,
    ROUND(MAX(price_per_100g_usd), 2) AS max_price,
    ROUND(AVG(price_per_100g_usd), 2) AS avg_price
FROM coffee_ratings
GROUP BY roast_type;


-- YEARLY RATING TREND

SELECT
    YEAR(review_date) AS review_year,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS total_reviews
FROM coffee_ratings
GROUP BY YEAR(review_date)
ORDER BY review_year;


-- GEOGRAPHIC QUALITY ANALYSIS

SELECT
    origin_country,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(price_per_100g_usd), 2) AS avg_price,
    COUNT(*) AS total_coffees
FROM coffee_ratings
GROUP BY origin_country
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC;


/* =========================================================
   END OF SCRIPT
   ========================================================= */
