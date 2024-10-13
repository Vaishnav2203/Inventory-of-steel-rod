USE steel_rod;
SELECT * FROM dataset;

#----- Duplicate Values -----#

# Duplicate rows
SELECT date, FY, Customer_Name, Dia, Dia_group, Grade, Type, Length, Quantity, Rate, COUNT(*) AS count
FROM dataset
GROUP BY date, FY, Customer_Name, Dia, Dia_group, Grade, Type, Length, Quantity, Rate
HAVING COUNT(*) > 1 ;

# Number of Total Duplicate Rows 
SELECT COUNT(*) AS total_duplicate 
FROM (
	SELECT date, FY, Customer_Name, Dia, Dia_group, Grade, Type, Length, Quantity, Rate, COUNT(*) AS count
	FROM dataset
	GROUP BY date, FY, Customer_Name, Dia, Dia_group, Grade, Type, Length, Quantity, Rate
	HAVING COUNT(*) > 1
) AS duplicates;

# Removing Duplicates
SELECT DISTINCT (date, FY, Customer_Name, Dia, Dia_group, Grade, Type, Length, Quantity, Rate)
INTO new_dataset
FROM dataset;

CREATE TABLE temp_table  AS SELECT DISTINCT * FROM dataset;
TRUNCATE  dataset;
INSERT INTO dataset SELECT * FROM temp_table;
DROP TABLE temp_table;

# ------Determining Missing Values------

SELECT COUNT(*) AS missing_value_FY FROM dataset
WHERE FY IS NULL; # NO MISSING VALUES 

SELECT COUNT(*) AS missing_value_Customer_Name FROM dataset
WHERE Customer_Name IS NULL; # NO MISSING VALUES

SELECT COUNT(*) AS missing_value_Dia FROM dataset
WHERE Dia IS NULL; # NO MISSING VALUES

SELECT COUNT(*) AS missing_value_Dia_group FROM dataset
WHERE Dia_group IS NULL; # NO MISSING VALUES

SELECT COUNT(*) AS missing_value_Grade FROM dataset 
WHERE Grade IS NULL; # NO MISSING VALUES

SELECT COUNT(*) AS missing_value_Type FROM dataset
WHERE Type IS NULL; # NO MISSING VALUES

SELECT COUNT(*) AS missin_value_Length FROM dataset
WHERE Length IS NULL; # NO MISSING VALUES

SELECT COUNT(*) AS missing_value_Quantity FROM dataset
WHERE Quantity IS NULL; # 14 MISSING VALUES

SELECT COUNT(*) AS missing_value_Rate FROM dataset
WHERE Rate IS NULL; # 16 MISSING VALUES

# ------IMPUTATION OF MISSING VALUE------

# QUANTITY - MEDIAN IMPUTATION (The mean of Quantity is influence by extreame values)

SELECT Quantity AS median_value 
FROM (
	SELECT Quantity, ROW_NUMBER() OVER (ORDER BY Quantity) AS row_num,
        COUNT(*) OVER () AS total_count
	FROM dataset
    ) AS Subquery
WHERE row_num = (total_count + 1)/2 OR row_num = (total_count + 2)/2;

UPDATE dataset
SET Quantity = 3.9
WHERE Quantity IS NULL;


SELECT COUNT(*) AS missing_value_Quantity FROM dataset
WHERE Quantity IS NULL; # MISSING VALUES IS 0

# Rate - MEAN IMPUTATION (The values is not affected by extrem value)

SELECT AVG(Rate) AS mean_rate FROM dataset;

UPDATE dataset
SET Rate = 48524.77
WHERE Rate IS NULL;

update dataset
set rate = (select avg(Quantity) )
where rate is null;

SELECT COUNT(*) AS missing_value_rate FROM dataset
WHERE Rate IS NULL; # MISSING VALUE IS 0

# ------Determing Outlier------

# Q1 , Q3, IQR
SELECT MAX(Quantity) AS Q1
FROM (
	SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
    FROM dataset
    ) AS Subquery
WHERE Quatile = 1;

SELECT Max(Quantity) AS Q3
FROM (
	SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
    FROM dataset
    ) AS subquery
WHERE Quatile = 3;

SELECT Q3 - Q1 AS IQR
FROM (
	SELECT MAX(Quantity) AS Q1 
    FROM (
		SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
        FROM dataset
        ) AS Subquery1
	WHERE Quatile = 1
    ) AS Subquery2
CROSS JOIN 
(
SELECT MAX(Quantity) AS Q3
FROM (
	SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
	FROM dataset
	) AS Subquery3
    WHERE Quatile = 3
) AS Subquery4
;

# Lower limit , Upper limit 
SELECT 1.99 - (1.5 * 5.02) AS Lower_limit , 7.01 + (1.5 * 5.02) AS Upper_limit;

# OUTLIER
SELECT COUNT(Quantity) FROM dataset
WHERE Quantity < -5.540 OR Quantity > 14.540;

# ------Treatment of Outlier------

# ------Determing Outlier------

# ---Quantity - Quantity coloum have approx 10% of outlier so we are retain the outliers---

# ---Rate---
# Q1 ,Q3 , IQR
SELECT MAX(Rate) AS Q1
FROM (
	SELECT Rate , NTILE(4) OVER (ORDER BY Rate) Quatile
    FROM dataset
    ) AS Subquery
WHERE Quatile = 1;

SELECT MAX(Rate) AS Q3
FROM (
	SELECT Rate , NTILE(4) OVER (ORDER BY Rate) Quatile
    FROM dataset
    ) AS Subuery
WHERE Quatile = 3;

SELECT Q3 - Q1 AS IQR
FROM (
	SELECT MAX(Rate) AS Q1
    FROM (
		SELECT Rate , NTILE(4) OVER (ORDER BY Rate) Quatile
        FROM dataset
        ) AS Subquery1
	WHERE Quatile = 1
    ) AS Subquery2
CROSS JOIN (
	SELECT MAX(Rate) AS Q3
    FROM (
		SELECT Rate , NTILE(4) OVER (ORDER BY Rate) Quatile
        FROM dataset
        ) AS Subquery3
	WHERE Quatile = 3
    ) AS Subquery4;

# LOWER LIMIT AND UPPER LIMIT
SELECT 41750 - (1.5 * 14250) AS Lower_limit , 56000 + (1.5 * 14250) AS Upper_limit;

# ------DETERMING OUTLER------
SELECT COUNT(Rate) FROM dataset
WHERE Rate < 20375.0 OR Rate > 77375.0 ;

# ------TREATMENT OF OUTLIER------
UPDATE dataset
SET Rate = LEAST( GREATEST( Rate , 41750 ) , 56000 )
WHERE Rate < 20375.0 OR Rate > 77375.0;

# ------TRANSFORMATION------

# QUANTITY - There is no build in function in sql of yeo johson transformation
            #I would prefer yeo johson as compare to log tansformation, yeo johson give more normal distribution as comapre to 
            #log transformation, after yeo johson transformation data is still non normally distributed

# Rate - I would prefer not to do any transformation because after doing log transformation and boxcox transformation 
#        Q-Q plot are appox. same and data distribution have skewed more towards the right side as compare to non-transform data

# ------Normalization / Standardization------

# Quantity - Robust scaling (It has extrem outlier)

# Median 
SELECT Quantity AS median_value
FROM (
	SELECT Quantity , ROW_NUMBER() OVER (ORDER BY Quantity) AS row_num,
     COUNT(*) OVER () AS total_count
	FROM dataset
    ) AS Subquery
WHERE row_num = (total_count + 1)/2 OR row_num = (total_count + 2)/2;
    			
# IQR
SELECT Q3 - Q1 AS IQR 
FROM (
	SELECT MAX(Quantity) AS Q3
    FROM (
		SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
        FROM dataset
        ) AS Subquery1
	WHERE Quatile = 3
    ) AS Subquery2
CROSS JOIN (
	SELECT MAX(Quantity) AS Q1
    FROM (
		SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
        FROM dataset
        ) AS Subquery3
	WHERE Quatile = 1
    ) AS Subquery4;

ALTER TABLE dataset
ADD Robust_Quantity_Value FLOAT;

UPDATE dataset
SET Robust_Quantity_Value = (Quantity - 3.9) / 5.02;

# Rate - Standatdization (It has 0 outier)

ALTER TABLE dataset
ADD Standardize_Rate FLOAT;

SELECT AVG(Rate) , STDDEV(Rate) FROM DATASET;
UPDATE dataset
SET Standardize_Rate = ( Rate - 48400.708009210015) / 9387.290780269986;

SELECT * FROM dataset;