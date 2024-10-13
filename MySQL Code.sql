CREATE DATABASE Steel_Rod;
USE Steel_Rod;

SELECT * FROM dataset;

# MODE OF FY
SELECT FY AS mode_value , COUNT(FY) AS frequency 
FROM dataset 
GROUP BY FY
ORDER BY frequency DESC
LIMIT 1;

# TOP 10 CUSTOMER NAME
SELECT Customer_Name AS mode_value , COUNT(Customer_Name) AS frequency FROM dataset
GROUP BY Customer_Name
ORDER BY frequency DESC
LIMIT 10;

# MODE OF DIA
SELECT Dia AS mode_value , COUNT(Dia) AS frequency FROM dataset
GROUP BY Dia
ORDER BY frequency DESC
LIMIT 1;

# MODE OF DIA GROUP
SELECT Dia_group AS mode_value , COUNT(Dia_group) AS frequency FROM dataset
GROUP BY Dia_group
ORDER BY frequency DESC
LIMIT 1;

# MODE OF GRADE
SELECT Grade AS mode_value , COUNT(Grade) AS frequency FROM dataset
GROUP BY Grade
ORDER BY frequency DESC
LIMIT 1;

# MODE OF TYPE
SELECT Type AS mode_value , COUNT(Type) AS frequency FROM dataset
GROUP BY Type
ORDER BY frequency DESC
LIMIT 1;

# MODE OF LENGTH
SELECT Length AS mode_value , COUNT(Length) AS frequency FROM dataset
GROUP BY Length
ORDER BY frequency DESC
LIMIT 1;

#''' DESCRIPTIVE STATISTIC OF QUANTITY '''

### 1ST MOVEMENT BUSINESS DECISION - MEASURE OF CENTRAL TENDENCY

# MEAN
SELECT AVG(Quantity) AS mean_value FROM dataset;

# MEDIAN 
SELECT Quantity AS median_value 
FROM (
	SELECT Quantity, ROW_NUMBER() OVER (ORDER BY Quantity) AS row_num,
        COUNT(*) OVER () AS total_count
	FROM dataset
    ) AS Subquery
WHERE row_num = (total_count + 1)/2 OR row_num = (total_count + 2)/2;

# MODE
SELECT Quantity AS mode_value , COUNT(Quantity) AS frequency FROM dataset
GROUP BY Quantity 
ORDER BY frequency DESC
LIMIT 1 ;

### 2ND MOVEMENT BUSINESS DECISION - MEASURE OF DISPERSION

# VARIANCE
SELECT VARIANCE(Quantity) AS variance FROM dataset;

# STANDATD DEVIATION
SELECT STDDEV(Quantity) AS standard_deviation FROM dataset;

# RANGE
SELECT MAX(Quantity) - MIN(Quantity) AS rrange FROM dataset;

### 3RD MOVEMENT BUSINESS DECISION - SKEWNESS
SELECT (
		SUM(POWER( Quantity - (SELECT AVG(Quantity) FROM dataset),3)) /
        (COUNT(*) * POWER((SELECT STDDEV(Quantity) FROM dataset),3))
       ) AS Skewness
FROM dataset;

### 4TH MOVEMENT BUSINESS DECISION - KURTOSIS
SELECT (
		(SUM(POWER( Quantity - (SELECT AVG(Quantity) FROM dataset),4))/
        (COUNT(*) * POWER((SELECT STDDEV(Quantity) FROM dataset),4))) - 3
        ) AS Kurtosis
FROM dataset;

#''' DESCRIPTIVE STATISTIC OF RATE '''

## 1ST MOVEMENT BUSINESS DECISION - MEASURE OF CENTRAL TENDENCY

# MEAN
SELECT AVG(Rate) AS mean_rate FROM dataset;

# MEDIAN
SELECT Rate AS median_rate 
FROM (
		SELECT Rate , ROW_NUMBER() OVER (ORDER BY Rate) AS row_num,
			COUNT(*) OVER() AS total_count
		FROM dataset
	) AS Subquery
WHERE row_num = (total_count + 1)/2 OR row_num = (total_count + 2)/2;

# MODE
SELECT Rate AS mode_rate , COUNT(Rate) AS frequency FROM dataset
GROUP BY Rate
ORDER BY frequency DESC 
LIMIT 1;

## 2ND MOVEMENT BUSINESS DESCISION - MEASURE OF DISPERSION

# VARIANCE
SELECT VARIANCE(Rate) AS variance FROM dataset;

# STANDARD DEVIATION
SELECT STDDEV(Rate) AS standard_deviation FROM dataset;

# RANGE
SELECT MAX(Rate) - MIN(Rate) AS rrange FROM dataset;

## 3RD MOVEMENT BUSINESS DECISION - SKEWNESS

SELECT(
		SUM(POWER(Rate - (SELECT AVG(Rate) FROM dataset),3))/
        (COUNT(*) * POWER((SELECT STDDEV(Rate) FROM dataset),3))
	) AS Skewness
FROM dataset;

# 4TH MOVEMENT BUSINESS DECISION - KURTOSIS 

SELECT (
		(SUM(POWER(Rate - (SELECT AVG(Rate) FROM dataset),4))/
        (COUNT(*) * POWER((SELECT STDDEV(Rate) FROM dataset),4)))-3
        ) AS Kurtosis
FROM dataset;

# ''' Missing value detection '''

SELECT COUNT(*) FROM dataset
WHERE FY IS NULL;

SELECT COUNT(*) FROM dataset
WHERE Customer_Name IS NULL;

SELECT COUNT(*) FROM dataset
WHERE Dia IS NULL;

SELECT COUNT(*) FROM dataset
WHERE Dia_group IS NULL;

SELECT COUNT(*) FROM dataset
WHERE Grade IS NULL;

SELECT COUNT(*) FROM dataset
WHERE Type IS NULL;

SELECT COUNT(*) FROM dataset
WHERE Length IS NULL;

SELECT COUNT(*) FROM dataset 
WHERE Quantity IS NULL;

SELECT COUNT(*) FROM dataset
WHERE Rate IS NULL; 

# --- Determine Q1, Q3, IQR ---

SELECT MAX(Quantity) AS Q1
FROM (
	SELECT Quantity , NTILE(4) OVER(ORDER BY Quantity) AS Quatile 
    FROM dataset
    ) AS Subquery
WHERE Quatile = 1;

SELECT MAX(Quantity) AS Q3
FROM (
	SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
    FROM dataset
	) AS Subquery
WHERE Quatile = 3;

SELECT Q3 - Q1 AS IQR 
FROM (
	SELECT MAX(Quantity) AS Q3
    FROM (
	SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
    FROM dataset 
		  ) AS Subquery1
	WHERE Quatile = 3
	) AS Subquery2
CROSS JOIN 
	(
	SELECT MAX(Quantity) AS Q1 
    FROM (
		SELECT Quantity , NTILE(4) OVER (ORDER BY Quantity) AS Quatile
        FROM dataset
		  ) AS Subquery3
	WHERE Quatile = 1
    ) AS Subquery4;
    
# LOWER LIMIT AND UPPER LIMIT
SELECT 1.99 - (1.5 * 5.02) AS Lower_limit , 7.01 + (1.5 * 5.02) AS Upper_limit;

# --- Determine Outlier --- 
SELECT COUNT(Quantity)
FROM dataset
WHERE Quantity < -5.540 OR Quantity > 14.54;

# -------Determining of Q1, Q3, IQR--------

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

# DETERMING OUTLER
SELECT COUNT(Rate) FROM dataset
WHERE Rate < 20375.0 OR Rate > 77375.0 ;