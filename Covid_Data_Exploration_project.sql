-- ==========================================================================================

--  ######################     Covid-19 Data exploration project #######################

-- ==========================================================================================

-->   Showing all data 
select * from CovidDeaths
-->   Shoing Total number of Rows
select COUNT(*) as TotalRows
from CovidDeaths 
-->   Showing total number of Columns
SELECT count (column_name) as TotalColumn 
FROM information_schema.columns 
WHERE table_name='CovidDeaths'

--     Total Cases , Total deaths  and Death rate in each Country 
select Location,Sum(total_cases) as Total_cases,sum(cast(total_deaths as int))  as Total_deaths,
ROUND((sum(cast(total_deaths as int))/Sum(total_cases))*100 ,2) AS Deathrate
from CovidDeaths
group by Location
order by 1

-->    What percent is effected by covid in each country every day
select Location,date,Population ,total_cases ,(total_cases/population )*100 as Total_Population_effected
FROM CovidDeaths
order by 1
-->    Countries by Higest death count per day 
select location,Max(total_deaths) as Maximum_deaths
from CovidDeaths
where continent is not null
--we can also choose specfic location like i have done:
--where location like '%pakistan%' and continent is not null
group by location
order by 1

-->   Showing total deaths in each continent 
 select continent , sum(cast(total_deaths as int)) as TotalDeaths
 from CovidDeaths
 where continent is  not null
 group by continent
 order by 2 desc

 -->  Showing the total Cases, total deaths and death percentage from World
select sum(new_cases) as TotalCases, sum(cast(total_deaths as int)) as TotalDeaths
,Round(sum(new_cases)/sum(cast(total_deaths as int))*100,2) As DeathPercentage
from CovidDeaths
where continent is not null


-->   Total vaccinaton and total prople vaccinated in each country

select location, sum(cast(total_vaccinations as bigint )) AS TotalVccination,
sum(cast(people_vaccinated as bigint))  as PropleVaccinated
from CovidDeaths
where continent is not null
group by location
order by 1

select location,date,reproduction_rate 
from CovidDeaths
where continent is not null
order by 1


--         Classfying each day's transmission level based on the ratio 
--                 of new cases to the previous day's cases
SELECT
    location,
    date,
    CASE
        WHEN new_cases / NULLIF(LAG(new_cases) OVER (PARTITION BY location ORDER BY date), 0) > 1.5 THEN 'High Transmission'
        WHEN new_cases / NULLIF(LAG(new_cases) OVER (PARTITION BY location ORDER BY date), 0) < 0.5 THEN 'Low Transmission'
        ELSE 'Moderate Transmission'
    END AS transmission_category
FROM
    CovidDeaths
ORDER BY
    location, date;

--   creating a view table for pervious query ..
create view TransmissionRate as 
SELECT
    location,
    date,
    CASE
        WHEN new_cases / NULLIF(LAG(new_cases) OVER (PARTITION BY location ORDER BY date), 0) > 1.5 THEN 'High Transmission'
        WHEN new_cases / NULLIF(LAG(new_cases) OVER (PARTITION BY location ORDER BY date), 0) < 0.5 THEN 'Low Transmission'
        ELSE 'Moderate Transmission'
    END AS transmission_category
FROM
    CovidDeaths


select * from TransmissionRate








  




