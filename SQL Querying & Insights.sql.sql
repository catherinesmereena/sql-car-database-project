-- Create a new database named 'cars'
CREATE DATABASE cars;

-- Switch to the 'cars' database
USE cars;

-- Create the 'carsdetail' table with the specified columns and data types
CREATE TABLE carsdetail (
    car VARCHAR(255),           
    MPG INT,                    
    Cylinder INT,              
    Displacement INT,           
    Horsepower INT,            
    Weight INT,                
    Acceleration INT,           
    Model INT,                  
    Origin VARCHAR(255)         
);

-- Verify the structure of the 'carsdetail' table
SELECT * FROM carsdetail;

-- Display the columns in the 'carsdetail' table
SHOW COLUMNS FROM cars.carsdetail;

-- Business Questions and Queries --

-- 1. The total number of cars and the average MPG for each country of origin
SELECT Origin, COUNT(*) AS Total_Cars, AVG(MPG) AS Avg_MPG
FROM carsdetail
GROUP BY Origin
ORDER BY Avg_MPG DESC;

-- 2. The average horsepower for cars grouped by decade of production
SELECT 
    (Model DIV 10) * 10 AS Decade, 
    AVG(Horsepower) AS Avg_Horsepower
FROM carsdetail
GROUP BY Decade
ORDER BY Decade;

-- 3. The count of cars produced by country of origin, but only those with more than 10 cars
SELECT Origin, COUNT(*) AS Car_Count
FROM carsdetail
GROUP BY Origin
HAVING COUNT(*) > 10;

-- 4 Get the total number of cars, average weight, and maximum horsepower for each country
SELECT 
    Origin, 
    COUNT(*) AS Total_Cars, 
    AVG(Weight) AS Avg_Weight, 
    MAX(Horsepower) AS Max_Horsepower
FROM carsdetail
GROUP BY Origin
HAVING COUNT(*) > 5
ORDER BY Total_Cars DESC;

-- 5 Get the maximum and minimum acceleration for cars with more than 6 cylinders
SELECT 
    MAX(Acceleration) AS Max_Acceleration, 
    MIN(Acceleration) AS Min_Acceleration
FROM carsdetail
WHERE Cylinder > 6;