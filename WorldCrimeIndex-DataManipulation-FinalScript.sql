SELECT 
    *
FROM
    portfolioproject.`world crime index`;

-- TOP 20 CITIES WITH HIGHEST CRIME INDEX --

SELECT 
    City, `world crime index`.`Crime Index`
FROM
    portfolioproject.`world crime index`
ORDER BY `world crime index`.`Crime Index` DESC
LIMIT 20

--  TOP 20 CITIES WITH HIGHEST SAFETY INDEX -- 
SELECT 
    City, `world crime index`.`Safety Index`
FROM
    portfolioproject.`world crime index`
ORDER BY 2 DESC
LIMIT 20

-- SEPARATING CITIES FROM COUNTRIES AND ADDING THEM INTO SEPARATE COLUMNS -- 
SELECT 
    SUBSTRING_INDEX(city, ',', 1) AS SeparatedCity,
    SUBSTRING_INDEX(city, ',', - 1) AS SeparatedCountry
FROM
    portfolioproject.`world crime index`
    
ALTER TABLE portfolioproject.`world crime index`
ADD SeparatedCity Varchar(255)

UPDATE portfolioproject.`world crime index` 
SET 
    SeparatedCity = SUBSTRING_INDEX(city, ',', 1)

ALTER TABLE portfolioproject.`world crime index`
ADD SeparatedCountry Varchar(255)

UPDATE portfolioproject.`world crime index`
SET 
    SeparatedCountry = SUBSTRING_INDEX(city, ',', - 1)

SELECT 
    *
FROM
    portfolioproject.`world crime index`;

-- LOOKING AT COUNTRIES WITH MOST CITIES ON THE LIST --
SELECT 
    separatedcountry, COUNT((separatedcountry))
FROM
    portfolioproject.`world crime index`
GROUP BY separatedcountry
ORDER BY 2 DESC

-- LOOKING AT COUNTRIES WITH MOST CITIES ABOVE THE AVERAGE CRIME INDEX --
SELECT 
    AVG(`world crime index`.`Crime Index`) 'Average Crime Index'
FROM
    portfolioproject.`world crime index`;

SELECT 
    separatedcountry, COUNT((separatedcountry))
FROM
    portfolioproject.`world crime index`
WHERE
    `world crime index`.`Crime Index` > '44.89821192052978'
GROUP BY separatedcountry
ORDER BY 2 DESC

-- LOOKING AT COUNTRIES WITH THE MOST CITIES BELOW AVERAGE CRIME INDEX -- 
SELECT 
    AVG(`world crime index`.`Crime Index`) 'Average Crime Index'
FROM
    portfolioproject.`world crime index`;

SELECT 
    separatedcountry, COUNT((separatedcountry))
FROM
    portfolioproject.`world crime index`
WHERE
    `world crime index`.`Crime Index` < '44.89821192052978'
GROUP BY separatedcountry
ORDER BY 2 DESC

