use cars;

-- Create 1NF Table
CREATE TABLE Cars_1NF (
    car_name VARCHAR(100),
    mpg DECIMAL(4,2),
    cylinders INT,
    displacement DECIMAL(5,2),
    horsepower DECIMAL(5,2),
    weight DECIMAL(7,2),
    acceleration DECIMAL(4,2),
    model_year INT,
    origin VARCHAR(50)
);

-- Insert Data from carsdetail into Cars_1NF
INSERT INTO Cars_1NF (car_name, mpg, cylinders, displacement, horsepower, weight, acceleration, model_year, origin)
SELECT car, MPG, Cylinder, Displacement, Horsepower, Weight, Acceleration, Model, Origin
FROM carsdetail;


select * from Cars_1NF;


-- Create Cars Table for 2NF
 CREATE TABLE Cars_2NF (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    car_name VARCHAR(100),
    mpg DECIMAL(4,2),
    cylinders INT,
    displacement DECIMAL(5,2),
    horsepower DECIMAL(5,2),
    weight DECIMAL(7,2),
    acceleration DECIMAL(4,2),
    model_id INT,
    origin_id INT
);

-- Create Model Table for 2NF
CREATE TABLE Model_2NF (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    model_year INT
);

-- Create Origin Table for 2NF
CREATE TABLE Origin_2NF (
    origin_id INT AUTO_INCREMENT PRIMARY KEY,
    origin VARCHAR(50)
);

-- Insert Unique Model Years into Model Table
INSERT INTO Model_2NF (model_year)
SELECT DISTINCT Model FROM carsdetail;

-- Insert Unique Origins into Origin Table
INSERT INTO Origin_2NF (origin)
SELECT DISTINCT Origin FROM carsdetail;

-- Insert Data into Cars_2NF, linking to model_id and origin_id
INSERT INTO Cars_2NF (car_name, mpg, cylinders, displacement, horsepower, weight, acceleration, model_id, origin_id)
SELECT car, MPG, Cylinder, Displacement, Horsepower, Weight, Acceleration,
       (SELECT model_id FROM Model_2NF WHERE model_year = carsdetail.Model),
       (SELECT origin_id FROM Origin_2NF WHERE origin = carsdetail.Origin)
FROM carsdetail;


select * from Cars_2NF;


-- Create Cars Table for 3NF
CREATE TABLE Cars_3NF (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    car_name VARCHAR(100),
    model_id INT,
    origin_id INT,
    FOREIGN KEY (model_id) REFERENCES Model_2NF(model_id),
    FOREIGN KEY (origin_id) REFERENCES Origin_2NF(origin_id)
);

-- Create Specifications Table for 3NF
CREATE TABLE Specifications_3NF (
    spec_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    cylinders INT,
    displacement DECIMAL(5,2),
    horsepower DECIMAL(5,2),
    weight DECIMAL(7,2),
    FOREIGN KEY (car_id) REFERENCES Cars_3NF(car_id)
);

-- Create Performance Table for 3NF
CREATE TABLE Performance_3NF (
    performance_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    mpg DECIMAL(4,2),
    acceleration DECIMAL(4,2),
    FOREIGN KEY (car_id) REFERENCES Cars_3NF(car_id)
);

-- Insert Data into Cars_3NF
INSERT INTO Cars_3NF (car_name, model_id, origin_id)
SELECT car,
       (SELECT model_id FROM Model_2NF WHERE model_year = carsdetail.Model),
       (SELECT origin_id FROM Origin_2NF WHERE origin = carsdetail.Origin)
FROM carsdetail;

-- Insert Data into Specifications_3NF
INSERT INTO Specifications_3NF (car_id, cylinders, displacement, horsepower, weight)
SELECT c.car_id, cd.Cylinder, cd.Displacement, cd.Horsepower, cd.Weight
FROM carsdetail cd
JOIN Cars_3NF c ON c.car_name = cd.car;

-- Insert Data into Performance_3NF
INSERT INTO Performance_3NF (car_id, mpg, acceleration)
SELECT c.car_id, cd.MPG, cd.Acceleration
FROM carsdetail cd
JOIN Cars_3NF c ON c.car_name = cd.car;

select * from Cars_3NF;

-- Part2
-- Query 1: List All Cars with Their Specifications and Performance
SELECT 
    c.car_name,            -- Selects the car's name from the Cars_3NF table.
    p.mpg,                 -- Selects the miles per gallon (mpg) from the Performance_3NF table.
    p.acceleration,        -- Selects the acceleration value from the Performance_3NF table.
    m.model_year,          -- Selects the model year from the Model_2NF table.
    o.origin               -- Selects the origin (country/region) from the Origin_2NF table.
FROM 
    Cars_3NF c             -- Main table: Cars_3NF provides basic car details.
JOIN 
    Performance_3NF p ON c.car_id = p.car_id    -- Joins Cars_3NF with Performance_3NF using car_id.
JOIN 
    Model_2NF m ON c.model_id = m.model_id      -- Joins Cars_3NF with Model_2NF using model_id.
JOIN 
    Origin_2NF o ON c.origin_id = o.origin_id;  -- Joins Cars_3NF with Origin_2NF using origin_id.

 -- Query 2: Display performance data (name, mpg, acceleration, model year, origin)   
 SELECT 
    c.car_name,            -- Selects the car's name from the Cars_3NF table.
    p.mpg,                 -- Selects the miles per gallon (mpg) from the Performance_3NF table.
    p.acceleration,        -- Selects the acceleration value from the Performance_3NF table.
    m.model_year,          -- Selects the model year from the Model_2NF table.
    o.origin               -- Selects the origin (country/region) from the Origin_2NF table.
FROM 
    Cars_3NF c             -- Main table: Cars_3NF provides basic car details.
JOIN 
    Performance_3NF p ON c.car_id = p.car_id    -- Joins Cars_3NF with Performance_3NF using car_id.
JOIN 
    Model_2NF m ON c.model_id = m.model_id      -- Joins Cars_3NF with Model_2NF using model_id.
JOIN 
    Origin_2NF o ON c.origin_id = o.origin_id;  -- Joins Cars_3NF with Origin_2NF using origin_id.


-- Query 3: Find cars with the highest horsepower by model year and origin
SELECT 
    c.car_name,            -- Selects the car's name from the Cars_3NF table.
    s.horsepower,          -- Selects the horsepower from the Specifications_3NF table.
    m.model_year,          -- Selects the model year from the Model_2NF table.
    o.origin               -- Selects the origin (country/region) from the Origin_2NF table.
FROM 
    Cars_3NF c             -- Main table: Cars_3NF provides basic car details.
JOIN 
    Specifications_3NF s ON c.car_id = s.car_id  -- Joins Cars_3NF with Specifications_3NF using car_id.
JOIN 
    Model_2NF m ON c.model_id = m.model_id      -- Joins Cars_3NF with Model_2NF using model_id.
JOIN 
    Origin_2NF o ON c.origin_id = o.origin_id   -- Joins Cars_3NF with Origin_2NF using origin_id.
WHERE 
    s.horsepower = (       -- Filters for cars where the horsepower is the maximum for that model year and origin.
        SELECT MAX(s2.horsepower)               -- Subquery to find the maximum horsepower.
        FROM Specifications_3NF s2             -- Inner query selects the maximum horsepower for each model.
        JOIN Cars_3NF c2 ON c2.car_id = s2.car_id
        WHERE c2.model_id = c.model_id          -- Ensures the subquery focuses on the same model year.
        AND c2.origin_id = c.origin_id          -- Ensures the subquery focuses on the same origin.
    );



-- Query 4: Find cars with high fuel efficiency and low weight
SELECT c.car_name, p.mpg, s.weight, m.model_year, o.origin
FROM Cars_3NF c
JOIN Performance_3NF p ON c.car_id = p.car_id
JOIN Specifications_3NF s ON c.car_id = s.car_id
JOIN Model_2NF m ON c.model_id = m.model_id
JOIN Origin_2NF o ON c.origin_id = o.origin_id
WHERE p.mpg > 25 AND s.weight < 3000;

-- Query5: Find Cars with Specific Cylinders and MPG Range
SELECT c.car_name, s.cylinders, p.mpg, m.model_year
FROM Cars_3NF c
JOIN Specifications_3NF s ON c.car_id = s.car_id
JOIN Performance_3NF p ON c.car_id = p.car_id
JOIN Model_2NF m ON c.model_id = m.model_id
WHERE s.cylinders = 8 AND p.mpg BETWEEN 15 AND 20;





