USE portfolioproj;
--============================================================================================================================
-- Select first 100 rowa from all columns
SELECT TOP 100 * FROM CovidDeaths;
SELECT COUNT(*) AS nums_of_cov_death
FROM CovidDeaths;

--============================================================================================================================
SELECT TOP 100 * FROM CovidVaccinations;
SELECT COUNT(*) AS nums_of_cov_vac
FROM CovidDeaths;

--============================================================================================================================
-- Key columns
SELECT Location, date, total_cases, new_cases, total_deaths,population
FROM CovidDeaths
ORDER BY Location, date;

--============================================================================================================================
-- Percentage of deaths
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM CovidDeaths
ORDER BY location, date;

--============================================================================================================================
-- Total Cases vs Population
-- Shows what percentage of population infected with Covid from Africa using 'LIKE'
SELECT Location, date, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM CovidDeaths
WHERE Location LIKE '%ca'
ORDER BY Location, date;

--============================================================================================================================
-- Countries with Highest Infection Rate compared to Population
SELECT Location, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY Location
ORDER BY PercentPopulationInfected DESC;

--============================================================================================================================
-- Countries with Highest Death Count per Population
SELECT Location, max(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

--============================================================================================================================
-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

SELECT continent,SUM(population) AS population, MAX(CAST(total_deaths AS INT)) AS total_deaths
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY total_deaths DESC;

--============================================================================================================================
 --Total Population vs Vaccinations
 --Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT TOP 100 * FROM CovidVaccinations;

SELECT  CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidVaccinations.new_vaccinations, 
		SUM(CONVERT(BIGINT,CovidVaccinations.new_vaccinations)) OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location,CovidDeaths.date) 
		AS RollingPeopleVaccinated
		FROM CovidDeaths 
		JOIN CovidVaccinations
		ON CovidDeaths.location = CovidVaccinations.location AND CovidDeaths.date = CovidDeaths.date
		WHERE CovidDeaths.continent IS NOT NULL;
		--ORDER BY CovidDeaths.continent, CovidDeaths.location;


WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS 
(
SELECT TOP 100 CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations, 
		SUM(CONVERT(BIGINT,CovidVaccinations.new_vaccinations)) OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location,CovidDeaths.date)  
		AS RollingPeopleVaccinated
		FROM CovidDeaths 
		JOIN CovidVaccinations
		ON CovidDeaths.location = CovidVaccinations.location AND CovidDeaths.date = CovidDeaths.date
		WHERE CovidDeaths.continent IS NOT NULL
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;

--============================================================================================================================
 --Using Temp Table to perform Calculation on Partition By in previous query
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT  CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations, 
		SUM(CONVERT(BIGINT,CovidVaccinations.new_vaccinations)) OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location,CovidDeaths.date)  
		AS RollingPeopleVaccinated
		FROM CovidDeaths 
		JOIN CovidVaccinations
		ON CovidDeaths.location = CovidVaccinations.location AND CovidDeaths.date = CovidDeaths.date
		WHERE CovidDeaths.continent IS NOT NULL

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated;

--============================================================================================================================
-- Creating View to store data for later visualizations

CREATE VIEW ViewPercentPopulationVaccinated AS
SELECT  CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations, 
		SUM(CONVERT(BIGINT,CovidVaccinations.new_vaccinations)) OVER (PARTITION BY CovidDeaths.location ORDER BY CovidDeaths.location,CovidDeaths.date)  
		AS RollingPeopleVaccinated
		FROM CovidDeaths 
		JOIN CovidVaccinations
		ON CovidDeaths.location = CovidVaccinations.location AND CovidDeaths.date = CovidDeaths.date
		WHERE CovidDeaths.continent IS NOT NULL;

SELECT * FROM ViewPercentPopulationVaccinated






































