SELECT
  location,
  SAFE_DIVIDE(SUM(total_cases),SUM(population))*100 AS ratiosi
FROM `first-data-analytic-project.sql_training.covid`
GROUP BY location
ORDER BY ratiosi DESC
LIMIT 500;

---------------

SELECT
  location,
  MAX(total_cases) AS max_cases,
  population,
  SAFE_DIVIDE(MAX(total_cases),population)*100 AS percentInfect
FROM `first-data-analytic-project.sql_training.covid`
GROUP BY location,population
LIMIT 500;

------------------

SELECT
  continent,
  AVG(population_density) AS avg_density,
  (SUM(aged_65_older) + SUM(aged_70_older))/AVG(population)*100 AS percent_of_old,
  MAX(total_cases) AS max_cases,
FROM `first-data-analytic-project.sql_training.covid`
WHERE continent != '0'
GROUP BY continent
LIMIT 500;

-----------------------



SELECT
  continent,
  AVG(population_density) as dst,
  AVG(population) as pop,
  AVG(total_cases)as cas,
  AVG(total_deaths) as dead
FROM `first-data-analytic-project.sql_training.covid`
WHERE continent != '0'
GROUP BY continent

--------------
#Finding months with the most deaths ranked

SELECT
  SUM(new_deaths) AS death_sum,
  FORMAT_DATE('%Y-%m', date) AS year_month  
FROM `first-data-analytic-project.sql_training.covid`
GROUP BY year_month
ORDER BY death_sum DESC
----------------------


