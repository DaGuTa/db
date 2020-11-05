USE geodata;

-- Задание 1 Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
SELECT 
    c.id AS Индекс,
    c.title AS Город,
    co.title AS Страна,
    r.title AS Регион
FROM
    _cities AS c,
    _countries AS co,
    _regions AS r
WHERE
    c.title = 'Омск'
        AND c.country_id = co.id
        AND c.region_id = r.id;

-- Задание 2 Выбрать все города из Московской области.
SELECT 
    r.title AS Область, c.title AS Город
FROM
    _regions AS r
        JOIN
    _cities AS c ON r.id = c.region_id
        AND r.title = 'Московская область';

-- Задание 3 Выбрать среднюю зарплату по отделам.
USE employees;
SELECT 
    dept_name, AVG(salary)
FROM
    dept_manager
        JOIN
    departments USING (dept_no)
        JOIN
    salaries USING (emp_no)
GROUP BY dept_no
ORDER BY dept_name;

-- Задание 4 Выбрать максимальную зарплату у сотрудника.
-- select employees.emp_no, first_name, last_name, max(salary) as "Максимальная ЗП" from employees join salaries using(emp_no);
-- Самая большая ЗП
SELECT 
    MAX(salary) AS 'Максимальная ЗП'
FROM
    employees
        JOIN
    salaries USING (emp_no);
-- Сотрудник с самой большой ЗП
SELECT 
    employees.emp_no, first_name, last_name, salary
FROM
    employees
        JOIN
    salaries
WHERE
    employees.emp_no = salaries.emp_no
        AND salary = (SELECT 
            MAX(salary) AS 'Максимальная ЗП'
        FROM
            salaries);
-- Самые большие ЗП сотрудников
SELECT 
    emp_no,
    first_name,
    last_name,
    MAX(salary) AS 'Максимальная ЗП'
FROM
    employees
        JOIN
    salaries USING (emp_no)
GROUP BY emp_no;

-- Задание 5 Удалить одного сотрудника, у которого максимальная зарплата.
-- Находим id сотрудника с самой большой ЗП
SELECT 
    emp_no
FROM
    salaries
WHERE
    salary = (SELECT 
            MAX(salary) AS 'Максимальная ЗП'
        FROM
            salaries);

-- А теперь удаляем сотрудника.
            
DELETE FROM employees 
WHERE
    emp_no = (SELECT 
        emp_no
    FROM
        salaries
    
    WHERE
        salary = (SELECT 
            MAX(salary) AS 'Максимальная ЗП'
        FROM
            salaries));

-- Задание 6 Посчитать количество сотрудников во всех отделах.
SELECT 
    COUNT(emp_no)
FROM
    dept_manager
        JOIN
    employees USING (emp_no);

-- Задание 7 Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
SELECT 
    dept_name, count, sum
FROM
    (SELECT 
        dept_no, dept_name, COUNT(emp_no) AS count
    FROM
        dept_manager
    JOIN employees USING (emp_no)
    JOIN departments USING (dept_no)
    GROUP BY dept_no
    ORDER BY dept_name) AS t1
        JOIN
    (SELECT 
        dept_no, SUM(salary) AS sum
    FROM
        dept_manager
    JOIN salaries USING (emp_no)
    GROUP BY dept_no) AS t2
WHERE
    t1.dept_no = t2.dept_no;