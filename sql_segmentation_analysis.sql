USE sql_projects;
SELECT * FROM featured_dataset;

-- Who are genuinely loyal customers vs those who only buy when there is a discount?

SELECT
    Value_Tier,
    Promo_Dependency,
    AVG(`Previous Purchases`) AS avg_previous_purchases,
    COUNT(*) AS customers
FROM featured_dataset
GROUP BY Value_Tier, Promo_Dependency
ORDER BY Value_Tier;

-- What behavioral patterns today predict high customer value over time?

SELECT
    Value_Tier,
    AVG(`Previous Purchases`),
    AVG(`Review Rating`),
    AVG(`Subscription Status`),
    AVG(Purchase_Freq_Score)
FROM featured_dataset
GROUP BY Value_Tier;

-- Which geographies and demographics are commercially underleveraged?

-- Geographics
SELECT
    Location,
    COUNT(*) AS customers,
    AVG(Estimated_Annual_Spend) AS avg_spend
FROM featured_dataset
GROUP BY Location
ORDER BY avg_spend DESC;

-- Demographics
SELECT
    Gender,
    Age,
    AVG(Estimated_Annual_Spend)
FROM featured_dataset
GROUP BY Gender, Age;

-- How should the brand restructure its promotional strategy?

SELECT
    Promo_Dependency,
    AVG(Estimated_Annual_Spend) AS avg_spend,
    AVG(`Review Rating`) AS avg_rating,
    COUNT(*) AS customers
FROM featured_dataset
GROUP BY Promo_Dependency;

-- What does the ideal customer profile look like?

SELECT
    Gender,
    Category,
    Location,
    AVG(Age) AS 'avg_age',
    AVG(Estimated_Annual_Spend) AS 'avg_annual_spend',
    AVG(`Previous Purchases`) AS 'avg_purchases',
    AVG(`Review Rating`) AS 'avg_rating'
FROM featured_dataset
WHERE Value_Tier='Premium Value'
GROUP BY gender, category, location;

-- ADDITIONAL QUESTION FROM SCOPE OF ANALYSIS

-- What separates high-value customers from low-value ones, and which profiles show the strongest repeat purchase behavior?

-- Compare High vs Low Value Customers
SELECT
    Value_Tier,
    COUNT(*) AS customers,
    ROUND(AVG(age),2) AS avg_age,
    ROUND(AVG(`Previous Purchases`),2) AS avg_previous_purchases,
    ROUND(AVG(`review rating`),2) AS avg_rating,
    ROUND(AVG(`subscription status`),2) AS subscription_rate,
    ROUND(AVG(Promo_Dependency),2) AS avg_dependency_score
FROM featured_dataset
GROUP BY Value_Tier
ORDER BY
CASE
    WHEN Value_Tier='Low Value' THEN 1
    WHEN Value_Tier='Medium Value' THEN 2
    WHEN Value_Tier='High Value' THEN 3
    WHEN Value_Tier='Premium Value' THEN 4
END;

-- Strongest Repeat Purchase Profiles
SELECT
    Gender,
    Category,
    Season,
    ROUND(AVG(`previous purchases`),2) AS avg_repeat_purchases,
    COUNT(*) AS customers
FROM featured_dataset
GROUP BY Gender, Category, Season
HAVING COUNT(*) > 20
ORDER BY avg_repeat_purchases DESC
LIMIT 15;

-- Which seasons and categories are associated with lower-tenure customers versus those with high previous purchase counts?
-- Season Analysis

SELECT
    season,
    COUNT(*) AS customers,
    ROUND(AVG(`previous purchases`),2) AS avg_previous_purchases
FROM featured_dataset
GROUP BY season
ORDER BY avg_previous_purchases DESC;

-- Category Analysis
SELECT
    category,
    COUNT(*) AS customers,
    ROUND(AVG(`previous purchases`),2) AS avg_previous_purchases
FROM featured_dataset
GROUP BY category
ORDER BY avg_previous_purchases DESC;

-- Season × Category
SELECT
    season,
    category,
    ROUND(AVG(`previous purchases`),2) AS avg_previous_purchases,
    COUNT(*) AS customers
FROM featured_dataset
GROUP BY season, category
ORDER BY avg_previous_purchases DESC;

--  Which geographies signal organic demand versus discount-driven volume?
SELECT
    location,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`),2) AS avg_spend,
    ROUND(AVG(Promo_Dependency),2) AS avg_dependency,
    ROUND(AVG(`previous purchases`),2) AS avg_previous_purchases
FROM featured_dataset
GROUP BY location
ORDER BY avg_spend DESC;