/* 
Queries  for Tableau Project are numbered.
*/


SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4



---Select data that we are going to be usng
SELECT location, date, total_cases, new_cases, total_deaths,  population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

---looking at Total Cases vs Total Deaths

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%States%' AND continent IS NOT NULL
ORDER BY 1,2]

---looking at the Total Cases vs Population
SELECT location, date, total_cases, population, (total_deaths/population) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL AND location = 'Ghana'
ORDER BY 1,2


---what countries have the Highest Infection Rate compared to their Population.
SELECT location, population, MAX(total_cases) as HighestInfectionCount,
MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


---Countries with Highest Death Count per Population
SELECT location, MAX(CAST(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeathCount DESC


---Breaking things down by Continent
SELECT continent, MAX(CAST(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount DESC



---Global Numbers
SELECT SUM(new_cases) as Total_cases, SUM(CAST(new_deaths as int)) as Total_deaths,
SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1,2

---(1)
SELECT SUM(new_cases) as Total_cases, SUM(CAST(new_deaths as int)) as Total_deaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

---(2)
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income',
'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc


---(3)
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


---(4)
SELECT Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC


SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
  ON Dea.location = Vac.location
  AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 1,2,3


SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(int, Vac.new_vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.location, Dea.date)
as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
  ON Dea.location = Vac.location
  AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3



---Using CTE
WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS(
SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(CONVERT(int, Vac.new_vaccinations)) OVER (PARTITION BY Dea.Location ORDER BY Dea.location, Dea.date)
as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
   ON Dea.location = Vac.location
   AND Dea.date = Vac.date
WHERE Dea.continent IS NOT NULL
ORDER BY 2,3
)