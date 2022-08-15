-- DELIVERABLE 1: The number of retiring employees by title

-- 1. Retrieve the emp_no, first_name, and last_name columns from the Employees table
-- 2. Retrieve the title, from_date, and to_date columns from the Titles table.
-- Join Employee and title together. and Create "retirement_title" table
-- First Create tables for employees and titles

-- Create tables for employees
CREATE TABLE employees(
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
); 
SELECT * FROM employees

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);
SELECT * FROM titles

SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
    t.title, 
	t.from_date, 
	t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t 
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;
-- Preview retirement_titles
SELECT * FROM retirement_titles

-- Remove duplicate entries for some employees who have switched titles over the years.
-- Create "unique_titles" table
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no)
		rt.emp_no,
		rt.first_name,
		rt.last_name,
		rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY emp_no, to_date DESC;

-- Preview unique_titles
SELECT * FROM unique_titles

-- Retrieve the number of employees by their most recent job title who are about to retire
-- Create "retiring_titles" table
SELECT COUNT (ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT DESC; 

-- Preview retiring_titles table
SELECT * FROM retiring_titles;

-- Deliverable 2: The Employees Eligible for the Mentorship Program table that holds current employees who were born between January 1, 1965 and December 31, 1965.
-- Retrieve columns from Employees and Department employee tables. Join tables.

-- First create Dept_emp table
CREATE TABLE dept_emp (
emp_no INT NOT NULL,
  dept_no VARCHAR(4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, dept_no)
);
SELECT * FROM dept_emp

-- Create "mentorship_eligiibility" table
SELECT DISTINCT ON (e.emp_no) 
	e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title
INTO mentorship_eligibility
FROM employees as e
LEFT JOIN dept_emp as de
ON (e.emp_no = de.emp_no)    
LEFT JOIN titles as t
ON (e.emp_no = t.emp_no)  
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no

-- View mentorship_eligibility table
SELECT * FROM mentorship_eligibility;


