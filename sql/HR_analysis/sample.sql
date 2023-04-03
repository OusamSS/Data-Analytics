# Find the number of employes each year grouped by gender
SELECT
	YEAR(hire_date) AS years,
	gender,
	COUNT(d.emp_no) AS num_emp
FROM t_employees e 
	JOIN t_dept_emp d ON e.emp_no = d.emp_no
GROUP BY gender, years
ORDER BY years, gender;

# Whats is salary range of the comapnies ?
SELECT MIN(column_name), MAX(column_name) FROM table_name;

# Whats is salary range of the comapnies ?
SELECT
    salary,
    COUNT(emp_no) num_emp
FROM t_salaries
GROUP BY salary
ORDER BY num_emp DESC;

