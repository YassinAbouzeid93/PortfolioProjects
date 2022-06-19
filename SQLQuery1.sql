select * from [SQL Portfolio]..covidDeath
where continent is not null

select Location,date,total_cases,new_cases,total_deaths, population from [SQL Portfolio]..covidDeath
order by 1,2

-- looking at total cases vs total deaths


select Location,date,total_cases,population, (total_cases/population)*100 as DeathPercentage

from [SQL Portfolio]..covidDeath
--where location like '%states%'
order by 1,2

-- looking at countries with highest infection rate to population

select Location,max(total_cases) as HighestinfectionCount,population, max((total_cases/population))*100 as PrecentPopulationInfected

from [SQL Portfolio]..covidDeath
--where location like '%states%'
Group by location, population
order by PrecentPopulationInfected desc

-- showing coutries with highest Deat count 

select location,max(cast(total_deaths as int)) as totalDeathCount

from [SQL Portfolio]..covidDeath
--where location like '%states%'
where location is not null

group by location

order by 2 desc


-- this is showing the continent with highest death count
select continent,max(cast(total_deaths as int)) as totalDeathCount

from [SQL Portfolio]..covidDeath
--where location like '%states%'
where continent is not null

group by continent

order by totalDeathCount desc




-- Global Numbers

select date,sum(new_cases) as Totalcases,sum(cast(new_deaths as int)) as totaldeath, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [SQL Portfolio]..covidDeath
where continent is not null
Group by date
order by 1,2

-- Looking at total population vs vaccination

-- USE CTE

with POPvsVAC ( continent,location,date,population,new_vaccinations,rollingpepopleVaccinated)
as
(
select coviddeath.continent, coviddeath.location,coviddeath.date,coviddeath.population, covidvaccination.new_vaccinations,

sum(convert(int,covidvaccination.new_vaccinations )) over ( partition by coviddeath.location order by coviddeath.location,coviddeath.date ) as RollingpepopleVaccinated



from Covidvaccination
join  coviddeath
	on coviddeath.location = covidvaccination.location
	and coviddeath.date = covidvaccination.date

	where coviddeath.continent is not null
	
	)
	select *, (rollingpepopleVaccinated/population)*100 from POPvsVAC

	
-- create view to store data for later visulatization

	Create view Percentpopulationvaccinated as 
	select coviddeath.continent, coviddeath.location,coviddeath.date,coviddeath.population, covidvaccination.new_vaccinations,

sum(convert(int,covidvaccination.new_vaccinations )) over ( partition by coviddeath.location order by coviddeath.location,coviddeath.date ) as RollingpepopleVaccinated

from Covidvaccination
join  coviddeath
	on coviddeath.location = covidvaccination.location
	and coviddeath.date = covidvaccination.date

	where coviddeath.continent is not null