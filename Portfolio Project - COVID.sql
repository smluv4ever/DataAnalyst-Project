--SELECT * 
--FROM CovidDeaths
--ORDER BY location, date

-- Select Data that I will use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent is not null
ORDER BY location, date

-- Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
ORDER BY location, date

-- % of population got COVID
SELECT location, date, total_cases, population, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
WHERE continent is not null
--WHERE location like '%States'
ORDER BY location, date

-- Countries with Highest Infection rate per Population
SELECT location, MAX(total_cases) AS HighestCovidCount, population, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS PercentPopulationInfected
FROM CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Countries with Highest Death Count per Population
SELECT location, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount, population, MAX((CONVERT(float, total_deaths) / NULLIF(CONVERT(float, population), 0))) * 100 AS PercentPopulationDeaths
FROM CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationDeaths DESC

-- Continents with Highest Death Count per Population
SELECT continent, MAX(CONVERT(float, total_deaths)) AS TotalDeathsCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathsCount DESC

-- Global Numbers by Date
SELECT date, SUM(new_deaths) AS NewDeaths, SUM(new_cases) AS NewCases, SUM(new_deaths)/SUM(new_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY date


-- Total Population vs Vaccination
SELECT death.continent, death.location, death.date, death.population, vaccine.new_vaccinations,
	SUM(CAST(vaccine.new_vaccinations AS INT)) OVER (PARTITION BY death.location ORDER BY death.location, death.date)
FROM CovidDeaths AS death
JOIN CovidVaccinations AS vaccine
ON death.location = vaccine.location AND death.date = vaccine.date
WHERE death.continent is not null
ORDER BY location, date

