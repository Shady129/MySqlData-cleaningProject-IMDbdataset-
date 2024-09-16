USE project1;

#examine the data in its original form.
SELECT * FROM imdb_data
LIMIT 10;

#Create a temp table where we can manipulate and restructure the data without altering the original.
CREATE TABLE cleaned_imdb_data LIKE imdb_data;

#insert data into temp table from the original table
INSERT INTO cleaned_imdb_data SELECT * FROM imdb_data;

#examine the data in its copy form.
SELECT * FROM cleaned_imdb_data
LIMIT 10;


#Fix column name - Original title column 1
 ALTER TABLE cleaned_imdb_data
 RENAME COLUMN `Original titlï؟½` TO `Original_title`;
 
 
#Fix column name - IMBD title ID
 ALTER TABLE cleaned_imdb_data
 RENAME COLUMN `IMBD title ID` TO  `Title_ID`;



#Fix column name - Release year column
ALTER TABLE cleaned_imdb_data
RENAME COLUMN `Release year` TO `Release_Year`;




#Fix column name - Content Rating Column
ALTER TABLE cleaned_imdb_data
RENAME COLUMN `Content Rating` TO `Content_Rating`;




#Removing empty rows in the table
DELETE FROM  cleaned_imdb_data
WHERE Title_ID IS NULL
  AND Original_title IS NULL
  AND Release_Year IS NULL
  AND Genre IS NULL
  AND Duration IS NULL
  AND Country IS NULL
  AND Content_Rating IS NULL
  AND Director IS NULL
  AND Income IS NULL
  AND Votes IS NULL
  AND Score IS NULL;



-- Removing empty columns

ALTER TABLE cleaned_imdb_data
DROP MyUnknownColumn;



-- Cleaning the Release_Year column

#Step One:
#Droping month and days and keeping just only year

UPDATE cleaned_imdb_data
SET Release_Year = SUBSTRING(release_year FROM 1 FOR 4)
WHERE Release_Year LIKE '____-__-__';



#Step Two:
#Cleaning other formats in Release_Year column because each of these rows has different data format

UPDATE cleaned_imdb_data
SET Release_Year = 1972
WHERE Title_ID = 'tt0068646';

UPDATE cleaned_imdb_data
SET Release_Year = 2008
WHERE Title_ID = 'tt0468569';

UPDATE cleaned_imdb_data
SET Release_Year = 2003
WHERE Title_ID = 'tt0167261';

UPDATE cleaned_imdb_data
SET Release_Year = 1976
WHERE Title_ID= 'tt0073486';

UPDATE cleaned_imdb_data
SET Release_Year = 1946
WHERE Title_ID = 'tt0034583';

UPDATE cleaned_imdb_data
SET Release_Year = 1999
WHERE Title_ID = 'tt0137523';

UPDATE cleaned_imdb_data
SET Release_Year = 2004
WHERE Title_ID = 'tt0167260';

UPDATE cleaned_imdb_data
SET Release_Year = 1966
WHERE Title_ID = 'tt0060196';

UPDATE cleaned_imdb_data
SET Release_Year = 1966
WHERE Title_ID = 'tt0043014';


-- Removing all non numeric values from Duration

UPDATE cleaned_imdb_data
SET Duration =  REGEXP_REPLACE(Duration,'[^0-9]+','');


-- Cleaning the country column

UPDATE cleaned_imdb_data 
SET Country =  
    CASE 
        WHEN country = 'US' THEN 'USA'
        WHEN country = 'US.' THEN 'USA'
        ELSE country
    END;


-- Removing non-alphabetic values from the country column

UPDATE cleaned_imdb_data 
SET Country =  REGEXP_REPLACE(Country,'[^a-zA-Z]','');


-- Correcting spelling errors with New Zealand

UPDATE cleaned_imdb_data 
SET Country = 'New Zealand'
WHERE Country LIKE '%New%';


-- Correcting spelling errors with South Korea
UPDATE cleaned_imdb_data 
SET Country =  'South Korea'
WHERE country like'%South%';


-- Replacing WestGermany with Germany
UPDATE cleaned_imdb_data
SET Country = REPLACE(Country,'WestGermany', 'Germany');



SELECT * FROM cleaned_imdb_data;


-- Cleaning Income column

#Removing $ Symbol

UPDATE cleaned_imdb_data
SET Income = REGEXP_REPLACE(Income, '[$]','');


-- Correcting incorrect values 1

UPDATE cleaned_imdb_data
SET Income = REGEXP_REPLACE(Income, 'o', '0');


-- Correcting incorrect values 2

UPDATE cleaned_imdb_data
SET Income = REPLACE(Income, ',','');


-- Cleaning votes column

UPDATE cleaned_imdb_data
SET Votes = REPLACE(Votes, '.','');


-- Cleaning duration column

-- Part1

UPDATE cleaned_imdb_data
SET Duration = NULL
WHERE Duration = '';

-- Part2

UPDATE cleaned_imdb_data
SET Duration = NULL
WHERE Duration = ' ';


SELECT * FROM cleaned_imdb_data;


-- Cleaning score column

-- Part1
UPDATE cleaned_imdb_data
SET Score = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(score, ',', '.'), '+', ''), 'f', ''), ':', '.'), '..', '.'));

-- Part2
UPDATE cleaned_imdb_data
SET Score = REPLACE (Score, '8.7.', '8.7');

-- Part3
UPDATE cleaned_imdb_data
SET score = REPLACE(Score, '8.7e-0', '8.7');





 
