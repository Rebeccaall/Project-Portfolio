SELECT * FROM PortfolioProject..CovidDeath ORDER BY 3,4

SELECT * FROM PortfolioProject..CovidVaccination ORDER BY 3,4

-- All the important data we'd like to analyze
SELECT location,date,total_cases, new_cases,total_deaths, population
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
ORDER BY 3,4

-- Calculate the death percentage in the United States
-- Insight: On 9/20/2021 the death percentage was 1.6%, which is much lower than the 
-- death percentage rate back in September, 2021 (3%).
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE location LIKE '%states%'
AND Continent IS NOT NULL
ORDER BY 1,2 DESC

-- Look at total cases vs population to see the infection rate in China
SELECT location, date, total_cases, population, (total_cases/population) *100 as DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE location LIKE 'China'
AND Continent IS NOT NULL
ORDER BY 1,2 DESC

-- Find out which country has the highest infection rate: Andorra (9.2%)
SELECT location, AVG(total_cases/population) *100 as InfectionPercentage
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
Group by location
ORDER BY 2 DESC

-- Showing Country with Highest Death count per population
SELECT location, MAX(cast(total_deaths as int)) as DeathCount
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
Group By location
ORDER BY 2 DESC

-- Let's break things down by continent
-- Insights: realize that some countries'data is not included in either of the continent.
-- (e.g.Canada's deathcount is not included in the North America continent.)
SELECT continent, MAX(cast(total_deaths as int)) as DeathCount
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
Group By continent
ORDER BY 2 DESC

-- Showing the continent with the highest Deathcount
SELECT continent, MAX(cast(total_deaths as int)) as DeathCount
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
Group By continent
ORDER BY 2 DESC

-- Global numbers
-- *given the datatype of the total_deaths is nvarchar,we need to cast it before AGG it.
SELECT date, SUM(new_cases)  as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, SUM(Cast(new_deaths as int))/SUM(new_cases) *100 as DeathPercenage
FROM PortfolioProject..CovidDeath
-- WHERE location LIKE '%states%'
WHERE Continent IS NOT NULL
GROUP BY date 
ORDER BY 1


-- Looking at Total Population vs Vaccinations, accumulated total new_vaccinations every date,
-- and what percentage of the population is vaccinated per location.
-- Use CTE
with PopvsVac (Continennt, Location, Date, populatoin, New_vaccination,RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM PortfolioProject..CovidVaccination vac
JOIN PortfolioProject..CovidDeath dea
	ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, RollingPeopleVaccinated/populatoin *100  FROM PopvsVac


-- With Temp table
DROP TABLE IF exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM PortfolioProject..CovidVaccination vac
JOIN PortfolioProject..CovidDeath dea
	ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, RollingPeopleVaccinated/Populatoin *100  FROM #PercentPopulationVaccinated

-- Create a view to store data for later visualization
Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM PortfolioProject..CovidVaccination vac
JOIN PortfolioProject..CovidDeath dea
	ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT * FROM PercentPopulationVaccinated