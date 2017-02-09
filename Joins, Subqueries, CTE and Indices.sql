--Problem 1.	Employee Address
--Write a query that selects:
--•	EmployeeId
--•	JobTitle
--•	AddressId
--•	AddressText
--Return the first 5 rows sorted by AddressId in ascending order.
select top 5 e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText  from Employees as e
join Addresses as a
on e.AddressID = a.AddressID
order by e.AddressID asc

--Problem 2.	Addresses with Towns
--Write a query that selects:
--•	FirstName
--•	LastName
--•	Town
--•	AddressText
--Sorted by FirstName in ascending order then by LastName. Select first 50 employees.
select top 50 e.FirstName,e.LastName, t.Name, a.AddressText from Employees as e
join Addresses as a
on e.AddressID = a.AddressID
join Towns as t
on t.TownID = a.TownID
order by e.FirstName, e.LastName

--Problem 3.	Sales Employee
--Write a query that selects:
--•	EmployeeID
--•	FirstName
--•	LastName
--•	DepartmentName
--Sorted by EmployeeID in ascending order. Select only employees from “Sales” department.
select e.EmployeeID, e.FirstName, e.LastName, d.Name as 'DepartmentName' from Employees as e
join Departments as d 
on e.DepartmentID = d.DepartmentID
where d.Name = 'Sales'
order by e.EmployeeID asc

--Problem 4.	Employee Departments
--Write a query that selects:
--•	EmployeeID
--•	FirstName
--•	Salary
--•	DepartmentName
--Filter only employees with salary higher than 15000. Return the first 5 rows sorted by DepartmentID in ascending order.
select top 5 e.EmployeeID, e.FirstName, e.Salary, d.Name as 'DepartmentName'  from Employees as e
join Departments as d on d.DepartmentID = e.DepartmentID
where e.Salary > 15000
order by e.DepartmentID

--Problem 5.	Employees Without Project
--Write a query that selects:
--•	EmployeeID
--•	FirstName
--Filter only employees without a project. Return the first 3 rows sorted by EmployeeID in ascending order.
select top 3 e.EmployeeID, e.FirstName from Employees as e
left join EmployeesProjects as epr on e.EmployeeID = epr.EmployeeID
where epr.EmployeeID is null
order by EmployeeID

--Problem 6.	Employees Hired After
--Write a query that selects:
--•	FirstName
--•	LastName
--•	HireDate
--•	DeptName
--Filter only employees with hired after 1/1/1999 and are from either "Sales" or "Finance" departments. Sorted by HireDate (ascending).
select e.FirstName, e.LastName, e.HireDate, d.Name as 'DeptName' from Employees as e
join Departments as d on e.DepartmentID = d.DepartmentID
where e.HireDate>'1999-1-1' and d.Name in ('Sales', 'Finance')
order by e.HireDate

--Problem 7.	Employees with Project
--Write a query that selects:
--•	EmployeeID
--•	FirstName
--•	ProjectName
--Filter only employees with a project which has started after 13.08.2002 and it is still ongoing (no end date). Return the first 5 rows sorted by EmployeeID in ascending order.
select top 5 e.EmployeeID, e.FirstName,p.Name as 'ProjectName'  from Employees as e
join EmployeesProjects as epr on e.EmployeeID = epr.EmployeeID
join Projects as p on p.ProjectID = epr.ProjectID
where p.EndDate is null and p.StartDate > '2002-08-13'
order by e.EmployeeID

--Problem 8.	Employee 24
--Write a query that selects:
--•	EmployeeID
--•	FirstName
--•	ProjectName
--Filter all the projects of employee with Id 24. If the project has started after 2005 the return value should be NULL.
select e.EmployeeID, e.FirstName,
case
	when p.StartDate>'2005' then NULL
	else p.Name
end as ProjectName
from Employees as e
join EmployeesProjects as epr on e.EmployeeID = epr.EmployeeID
 join Projects as p on p.ProjectID = epr.ProjectID
where e.EmployeeID = 24

--Problem 9.	Employee Manager
--Write a query that selects:
--•	EmployeeID
--•	FirstName
--•	MangerID
--•	ManagerName
--Filter all employees with a manager who has ID equals to 3 or 7. Return the all rows sorted by EmployeeID in ascending order.

select e.EmployeeID, e.FirstName, e.ManagerID, e2.FirstName as ManagerName  from Employees as e
join Employees as e2 on e.ManagerID = e2.EmployeeID
where e.ManagerID in (3,7)
order by e.EmployeeID

--Problem 10.	Employee Summary
--Write a query that selects:
--•	EmployeeID
--•	EmployeeName
--•	ManagerName
--•	DepartmentName
--Show first 50 employees with their managers and the departments which they are in (show the departments of the employees). Order by EmployeeID.
select top 50 e.EmployeeID, e.FirstName + ' ' + e.LastName as EmployeeName, e2.FirstName + ' ' + e2.LastName as ManagerName,d.Name as DepartmentName  from Employees as e
join Employees as e2 on e.ManagerID = e2.EmployeeID
join Departments as d on d.DepartmentID = e.DepartmentID
order by e.EmployeeID

--Problem 11.	Min Average Salary
--Write a query that return the value of the lowest average salary of all departments.
select min(query.Sal) from
(select avg(Salary) as Sal from Employees
group by DepartmentID) as query

use Geography

--Problem 12.	Highest Peaks in Bulgaria
--Write a query that selects:
--•	CountryCode
--•	MountainRange
--•	PeakName
--•	Elevation
--Filter all peaks in Bulgaria with elevation over 2835. Return the all rows sorted by elevation in descending order.
select mc.CountryCode,m.MountainRange,p.PeakName, p.Elevation from  Mountains as m
join MountainsCountries as mc on m.Id = mc.MountainId
join Peaks as p on p.MountainId = m.Id
where mc.CountryCode = 'BG' and p.Elevation>2835
order by p.Elevation desc

--Problem 13.	Count Mountain Ranges
--Write a query that selects:
--•	CountryCode
--•	MountainRanges
--Filter the count of the mountain ranges in the United States, Russia and Bulgaria.
select m.CountryCode, count(m.MountainId)  from MountainsCountries as m
group by m.CountryCode
having m.CountryCode in ('US', 'RU', 'BG')