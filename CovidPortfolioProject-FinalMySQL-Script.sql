SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    portfolioproject.coviddeaths
WHERE
    continent IS NOT NULL
ORDER BY 1

-- Looking at Total Cases vs Total Deaths (Shows likelihood of dying if you contract covid in your country)
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    portfolioproject.coviddeaths
WHERE
    location LIKE '%states%'
        AND continent IS NOT NULL
ORDER BY 1

-- looking at the Total Cases vs Population (% of population who tested positive for covid)
SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS PercentPopulationInfected
FROM
    portfolioproject.coviddeaths
WHERE
    location LIKE '%states%'
        AND continent IS NOT NULL
ORDER BY 1

-- Looking at Countries with highest infection rate relative to Population
SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    portfolioproject.coviddeaths
GROUP BY location , population
ORDER BY 4 DESC

-- Shows Continents with Highest Death Count (below shows the full values of all continents)
SELECT 
    location,
    MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM
    portfolioproject.coviddeaths
WHERE
    (location = 'World' OR location = 'Asia'
        OR location = 'North America'
        OR location = 'South America'
        OR location = 'Africa'
        OR location = 'Europe'
        OR location = 'Oceania')
GROUP BY location
ORDER BY TotalDeathCount DESC

-- shows values for countries max total death count
SELECT 
    location,
    MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM
    portfolioproject.coviddeaths
WHERE
    NOT (location = 'World' OR location = 'Asia'
        OR location = 'North America'
        OR location = 'South America'
        OR location = 'Africa'
        OR location = 'Europe'
        OR location = 'Oceania'
        OR location = 'High Income'
        OR location = 'Upper middle income'
        OR location = 'Lower middle income'
        OR location = 'European Union'
        OR location = 'Low income')
GROUP BY location
ORDER BY TotalDeathCount DESC

-- shows continental death percentage based off total death count divided by total continental cases
     SELECT 
        location,
		MAX(total_cases) AS TotalCases,
        MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount,
		(MAX(CAST(total_deaths AS UNSIGNED)) / MAX(total_cases)) * 100 AS DeathPercentage
    FROM
        portfolioproject.coviddeaths
    WHERE
        (location = 'World' OR location = 'Asia'
            OR location = 'North America'
            OR location = 'South America'
            OR location = 'Africa'
            OR location = 'Europe'
            OR location = 'Oceania'
            and continent is not null)
    GROUP BY location
    ORDER BY DeathPercentage DESC

-- GLOBAL NUMBERS of total deaths relative to total cases ordered by date
SELECT 
    date,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths,
    SUM(CAST(new_deaths AS UNSIGNED)) / SUM(new_cases) * 100 AS DeathPercentage
FROM
    portfolioproject.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY date

-- joining the two tables together
SELECT 
    *
FROM
    portfolioproject.coviddeaths dea
        JOIN
    portfolioproject.covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date

-- looking at total population vs vaccinations with percentage of population vaccinated
SELECT 
    dea.continent,
    dea.location,
    dea.population,
    MAX(CAST(vac.total_vaccinations AS UNSIGNED)) AS total_vaccinations,
    MAX(CAST(vac.total_vaccinations AS UNSIGNED)) / dea.population * 100 AS PercentPopulationVaccinated
FROM
    portfolioproject.coviddeaths dea
        JOIN
    portfolioproject.covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
GROUP BY 2

-- shows percentage of population infected by date (continent/income)
SELECT 
        location,
        date,
        population,
        total_cases,
        (total_cases / population) * 100 AS PercentPopulationInfected
    FROM
        portfolioproject.coviddeaths
    WHERE
		(location = 'World' OR location = 'Asia'
        OR location = 'North America'
        OR location = 'South America'
        OR location = 'Africa'
        OR location = 'Europe'
        OR location = 'Oceania'
        OR location = 'High Income'
        OR location = 'Upper middle income'
        OR location = 'Lower middle income'
        OR location = 'European Union'
        OR location = 'Low income')
    ORDER BY 1

-- creating view of percentage of population infected by date (continent/income)
CREATE VIEW ContinentPercentInfected as
SELECT 
        location,
        date,
        population,
        total_cases,
        (total_cases / population) * 100 AS PercentPopulationInfected
    FROM
        portfolioproject.coviddeaths
    WHERE
		(location = 'World' OR location = 'Asia'
        OR location = 'North America'
        OR location = 'South America'
        OR location = 'Africa'
        OR location = 'Europe'
        OR location = 'Oceania'
        OR location = 'High Income'
        OR location = 'Upper middle income'
        OR location = 'Lower middle income'
        OR location = 'European Union'
        OR location = 'Low income')
    ORDER BY 1
    
-- creating view of percentage of population infected by date (ALL COUNTRIES)
create view PercentPopulationInfected as
SELECT 
        location,
        date,
        population,
        total_cases,
        (total_cases / population) * 100 AS PercentPopulationInfected
    FROM
        portfolioproject.coviddeaths
    WHERE
		NOT (location = 'World' OR location = 'Asia'
        OR location = 'North America'
        OR location = 'South America'
        OR location = 'Africa'
        OR location = 'Europe'
        OR location = 'Oceania'
        OR location = 'High Income'
        OR location = 'Upper middle income'
        OR location = 'Lower middle income'
        OR location = 'European Union'
        OR location = 'Low income')
    ORDER BY 1
    
-- creating view to store data for later visualizations
-- View = likelihood of dying from covid in US
CREATE VIEW USCovidDeathPercentages AS
    SELECT 
        location,
        date,
        total_cases,
        total_deaths,
        (total_deaths / total_cases) * 100 AS DeathPercentage
    FROM
        portfolioproject.coviddeaths
    WHERE
        location LIKE '%states%'
            AND continent IS NOT NULL
    ORDER BY 1

-- creating view of % of population who tested positive for covid
CREATE VIEW PositiveCovidUSPopulation AS
    SELECT 
        location,
        date,
        population,
        total_cases,
        (total_cases / population) * 100 AS PercentPopulationInfected
    FROM
        portfolioproject.coviddeaths
    WHERE
        location LIKE '%states%'
            AND continent IS NOT NULL
    ORDER BY 1

-- creating view for countries with highest infection rates
CREATE VIEW HighestInfectionRate AS
    SELECT 
        location,
        population,
        MAX(total_cases) AS HighestInfectionCount,
        MAX((total_cases / population)) * 100 AS PercentPopulationInfected
    FROM
        portfolioproject.coviddeaths
    GROUP BY location , population
    ORDER BY 4 DESC

-- creating view of total death count in all locations
CREATE OR REPLACE VIEW TotalDeathCountPerLocation AS
    SELECT 
        location,
        MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
    FROM
        portfolioproject.coviddeaths
    WHERE
        NOT (location = 'World' OR location = 'Asia'
            OR location = 'North America'
            OR location = 'South America'
            OR location = 'Africa'
            OR location = 'Europe'
            OR location = 'Oceania'
            OR location = 'High Income'
            OR location = 'Upper middle income'
            OR location = 'Lower middle income'
            OR location = 'European Union'
            OR location = 'Low income')
    GROUP BY location
    ORDER BY TotalDeathCount DESC

-- creating a view for percentpopulationvaccinated based off population and total vaccinations
CREATE VIEW PercentPopulationVaccinated AS
    SELECT 
        dea.continent,
        dea.location,
        dea.population,
        MAX(CAST(vac.total_vaccinations AS UNSIGNED)) AS total_vaccinations,
        MAX(CAST(vac.total_vaccinations AS UNSIGNED)) / dea.population * 100 AS PercentPopulationVaccinated
    FROM
        portfolioproject.coviddeaths dea
            JOIN
        portfolioproject.covidvaccinations vac ON dea.location = vac.location
            AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
    GROUP BY 2
    
    -- creating a view for total death count in all continents
    CREATE VIEW continenttotaldeathcount AS
    SELECT 
        location,
        MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
    FROM
        portfolioproject.coviddeaths
    WHERE
        (location = 'World' OR location = 'Asia'
            OR location = 'North America'
            OR location = 'South America'
            OR location = 'Africa'
            OR location = 'Europe'
            OR location = 'Oceania')
    GROUP BY location
    ORDER BY TotalDeathCount DESC
    
    -- creating a view that shows continental death percentage (shows continental death percentage based off total death count divided by total continental cases)
     create view DeathPercentageByContinent as 
     SELECT 
        location,
		MAX(total_cases) AS TotalCases,
        MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount,
		(MAX(CAST(total_deaths AS UNSIGNED)) / MAX(total_cases)) * 100 AS DeathPercentage
    FROM
        portfolioproject.coviddeaths
    WHERE
        (location = 'World' OR location = 'Asia'
            OR location = 'North America'
            OR location = 'South America'
            OR location = 'Africa'
            OR location = 'Europe'
            OR location = 'Oceania'
            and continent is not null)
    GROUP BY location
    ORDER BY DeathPercentage DESC
