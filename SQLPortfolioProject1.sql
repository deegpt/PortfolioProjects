select * from  PortfolioProject.dbo.CovidDeaths 
where continent is not null
order by 3,4
select * from  PortfolioProject.dbo.CovidVaccinations


Select Location, DATE, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Shows the death percentage

Select Location, DATE, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location = 'India'
order by 1,2

-- shows what percentage of population got covid

select Location,date, Population, total_cases, (total_cases/population)*100 as Pop_percentage_got_COVID
from PortfolioProject..CovidDeaths
where location = 'India'
order by 1,2


-- Looking at Countries with Highest number of infections compared to Populations

select Location, Population, MAX (total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as Pop_percentage_got_COVID
from PortfolioProject..CovidDeaths
-- where location = 'India'
group by Location, population
order by Pop_percentage_got_COVID desc


-- shwoing countries with Highest Death count per population

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
-- where location = 'India'
where continent is not null
group by Location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT



-- Showing continents with the highest number of death count per population


select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
-- where location = 'India'
where continent is not null
group by continent
order by TotalDeathCount desc

-- GLOBAL numbers

Select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
from PortfolioProject..CovidDeaths
-- where location = 'India'
where continent is not null
-- group by date
order by 1,2

select * from PortfolioProject..CovidVaccinations

-- LOOKING AT TOTAL POPULATION VS VACCINATIONS (JOIN BOTH TABLES)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



-- Use CTE 

with PopsvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 2,3

)
select *
from PopsvsVac


-- TEMP TABLE
DROP table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
-- order by 2,3

select *
from #PercentPopulationVaccinated


-- Creating VIEW to store data for later visualizations

create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 2,3