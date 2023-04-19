select * from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--select * from PortfolioProject..CovidVaccinations
--order by 3,4


-- Selecting the data

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2


--Total cases vs  population

select location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2


--Countries with highest infecation rate compared to the population


select location,population, max(total_cases) as HighestInfectionCount ,  max((total_cases/population))*100 as InfectedPercentage
from PortfolioProject..CovidDeaths
--where location like 'India'
where continent is not null
group by location,population
order by  InfectedPercentage desc

--Countries with highest death rate compared to the population

select location, max(cast (total_deaths as int)) as TotaldeathCount
from PortfolioProject..CovidDeaths
where continent is not null
--where location like 'India'
group by location
order by  Totaldeathcount desc

--Same as above but for continent

select continent, max(cast (total_deaths as int)) as TotaldeathCount
from PortfolioProject..CovidDeaths
where continent is not null
--where location like 'India'
group by continent
order by  Totaldeathcount desc

--Global Numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths
, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

--Looking at total population vs covid vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPepopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Using cte

with PopvsVac (Continent, Location,Date,Population,new_vaccinations,RollingPepopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPepopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (RollingPepopleVaccinated/Population)*100
from PopvsVac

--Temp Table


Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPepopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPepopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select*, (RollingPepopleVaccinated/Population)*100
from #PercentPopulationVaccinated

--Creating view for later visualization
Create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date)
as RollingPepopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3