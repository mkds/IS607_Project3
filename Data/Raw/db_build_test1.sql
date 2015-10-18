CREATE DATABASE Proj3_test;

USE Proj3_test;

DROP TABLE if EXISTS Awards;

CREATE TABLE Awards
(
    Year varchar(50) NOT NULL,
    Category varchar(50) NOT NULL,
    Nominee varchar(50) NOT NULL,
    Additional_Info varchar(50) NOT NULL,
    Won varchar(50) NOT NULL
);


-- To build database locally change file path -- boot mysql with flag --local-infile 
LOAD DATA LOCAL INFILE '/home/bsnacks/Documents/CUNY/DataAq/Proj3/academy_awards.csv'
INTO TABLE Awards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Relevant project data?

SELECT Year, Category, Nominee, Won 
FROM Awards
WHERE   (Category = "Best Picture") OR
        (Category = "Film Editing")
LIMIT 100;
