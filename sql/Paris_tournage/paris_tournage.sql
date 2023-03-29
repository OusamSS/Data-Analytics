

# WHERE ARE MOST OF THE SERIES TAKING PLACES ?
# PLACES BY TYPES OF FILMS ?

#WHAT TYPE OF FILMING IS THERE ?
SELECT
  DISTINCT Type_de_tournage,
FROM `first-data-analytic-project.sql_project.paris_tournage`;

# MOST POPULAR PLACES ?
SELECT
  Code_postal,
  COUNT(Code_postal) AS count_of
FROM `first-data-analytic-project.sql_project.paris_tournage`
GROUP BY code_postal;

# HOW LONG DOES IT USALLY TAKE FOR A TOURNAGE IN PARIS ?
SELECT
  Identifiant_du_lieu,
  Titre,
  Date_de_d__but,
  Date_de_fin,
  DATE_DIFF(Date_de_fin, Date_de_d__but, DAY) AS number_of_days
FROM `first-data-analytic-project.sql_project.paris_tournage`
ORDER BY number_of_days DESC;


#PERCENTAGE OF TYPE OF FILMING IN PARIS ?
SELECT
  Type_de_tournage,
  COUNT(*) AS num,
  ROUND(COUNT(*)/SUM(COUNT(*)) OVER() *100,2) AS percent_movies
FROM `first-data-analytic-project.sql_project.paris_tournage`
GROUP BY Type_de_tournage;

SELECT DISTINCT titre, COUNT(titre) AS num
 FROM `first-data-analytic-project.sql_project.paris_tournage`
GROUP BY titre
ORDER BY num DESC;

SELECT DISTINCT Ann__e_du_tournage
 FROM `first-data-analytic-project.sql_project.paris_tournage`;
