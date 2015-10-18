DROP TABLE if EXISTS Master;

CREATE TABLE Master
(
    Year varchar(50) NOT NULL,
    Category varchar(50) NOT NULL,
    Nominee varchar(50) NOT NULL,
    Additional_Info varchar(50) NOT NULL,
    Won varchar(50) NOT NULL
);


-- To build database locally change file path -- boot mysql with flag --local-infile 
LOAD DATA LOCAL INFILE '/home/bsnacks/Documents/CUNY/DataAq/Proj3/Data_All_MASTER_edit.csv'
INTO TABLE Awards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE VIEW project AS 
SELECT Year, Category, Nominee, Won
FROM Master
WHERE   (Category = "ACTOR") OR
        (Category = "ACTRESS") OR
        (Category = "ACTOR IN A LEADING ROLE") OR
        (Category = "ACTOR IN A SUPPORTING ROLE") OR
        (Category = "ACTRESS IN A LEADING ROLE") OR
        (Category = "ACTRESS IN A SUPPORTING ROLE") OR
        (Category = "CINEMATOGRAPHY") OR
        (Category = "DIRECTING") OR
        (Category = "FILM EDITING") OR
        (Category = "SOUND EDITING") OR
        (Category = "SOUND MIXING") OR
        (Category = "COSTUME DESIGN");

SELECT * FROM project;
