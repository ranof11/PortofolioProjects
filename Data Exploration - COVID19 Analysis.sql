SELECT *
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE continent IS NOT NULL;


-- SELECT DATA WE'RE GOING TO USE
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Looking at Total Cases VS Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE location IN ('INDONESIA') 
AND continent IS NOT NULL
ORDER BY 1, 2;


-- Looking at Total Cases VS Total Population
-- Shows what percentage of population got covid19
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionRate
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE location IN ('INDONESIA')
AND continent IS NOT NULL
ORDER BY 1, 2;


-- Looking at Countries with highest infection rate
SELECT location, population, MAX(total_cases) AS InfectionCount, MAX((total_cases/population)*100) AS InfectionRate
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY InfectionRate DESC;


-- Showing Countris with Highest Death Count per Population
SELECT location, MAX(total_deaths) AS DeathCount, MAX((total_deaths/population)*100) AS DeathRatePerPopulation
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY DeathCount DESC;


-- BREAKS THINGS BY CONTINENT
SELECT location, MAX(total_deaths) AS DeathCount
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE continent IS NULL 
GROUP BY location
ORDER BY DeathCount DESC;

SELECT continent, MAX(total_deaths) AS DeathCount
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathCount DESC;


--Global Numbers
SELECT	date,
		SUM(new_cases) AS cases,
		SUM(new_deaths) AS deaths,
		-- Avoid a divide by 0 error
		CASE 
          WHEN SUM(new_cases) = 0 THEN NULL 
          ELSE (SUM(new_deaths) / NULLIF(SUM(new_cases), 0)) * 100 
       END AS DeathPercentage
FROM PortofolioProject_COVID19_2023..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;


-- Looking at Total Population VS Vaccination
SELECT	dea.continent, dea.location, dea.date, dea.population, 
		vac.new_vaccinations,
		-- Looking at Accumulative Sum Using Windows Function 
		SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CummulativePeopleVaccinated
			-- This expression calculates the sum of new_vaccinations, ensuring that the sum can handle larger values
			-- The window function is used to calculate the cumulative sum within each partition
			-- The rows within each partition are ordered by location and date, determining the order for the cumulative sum calculation
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;


-- USE CTE
WITH PopvsVac AS
(
	SELECT	dea.continent, dea.location, dea.date, dea.population, 
			vac.new_vaccinations,
			SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CummulativePeopleVaccinated
	FROM CovidDeaths dea
	JOIN CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
)
SELECT *, (CummulativePeopleVaccinated/PopvsVac.population)*100 AS VaccinatedPeoplePercentage
FROM PopvsVac
ORDER BY 2, 3;



-- USE TEMP TABLE
DROP TABLE #Temp_PopvsVac;

CREATE TABLE #Temp_PopvsVac
(	continent VARCHAR(255),
	location VARCHAR(255),
	date DATETIME,
	population numeric,
	new_vaccinations numeric,
	CummulativePeopleVaccinated numeric )

INSERT INTO #Temp_PopvsVac
	SELECT	dea.continent, dea.location, dea.date, dea.population, 
			vac.new_vaccinations,
			SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CummulativePeopleVaccinated
	FROM CovidDeaths dea
	JOIN CovidVaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL

SELECT *, (CummulativePeopleVaccinated/population)*100 AS VaccinatedPeoplePercentage
FROM #Temp_PopvsVac
ORDER BY 2, 3;


-- CREATE VIEW TO STORE DATA FOR LATER VISUALIZATIONS
CREATE VIEW VaccinatedPeoplePercentage AS
SELECT	dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS CummulativePeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *
FROM VaccinatedPeoplePercentage