# Find the number of employes each year grouped by gender
SELECT
	YEAR(hire_date) AS years,
	gender,
	COUNT(d.emp_no) AS num_emp
FROM t_employees e 
	JOIN t_dept_emp d ON e.emp_no = d.emp_no
GROUP BY gender, years
ORDER BY years, gender;


