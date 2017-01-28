--Problem 1.	Find Names of All Employees by First Name
--Write a SQL query to find first and last names of all employees whose first name starts with “SA”. Submit your query statements as Prepare DB & run queries.
select FirstName, LastName from Employees where FirstName like 'sa%'

--Problem 2.	  Find Names of All employees by Last Name 
--Write a SQL query to find first and last names of all employees whose last name contains “ei”. Submit your query statements as Prepare DB & run queries.
select FirstName, LastName from Employees where LastName like '%ei%'

--Problem 3.	Find First Names of All Employees
--Write a SQL query to find the first names of all employees in the departments with ID 3 or 10 and whose hire year is between 1995 and 2005 inclusive. Submit your query statements as Prepare DB & run queries.
select FirstName from Employees where DepartmentID in (3, 10) and year(HireDate)  between 1995 and 2005

--Problem 4.	Find All Employees Except Engineers
--Write a SQL query to find the first and last names of all employees whose job titles does not contain “engineer”. Submit your query statements as Prepare DB & run queries.
select FirstName, LastName from Employees where JobTitle not like '%engineer%'

--Problem 5.	Find Towns with Name Length
--Write a SQL query to find town names that are 5 or 6 symbols long and order them alphabetically by town name. Submit your query statements as Prepare DB & 
select Name from Towns where LEN(Name) in (5,6) order by Name

--Problem 6.	 Find Towns Starting With
--Write a SQL query to find all towns that start with letters M, K, B or E. Order them alphabetically by town name. Submit your query statements as Prepare DB & run queries.
select * from Towns where LEFT(Name, 1) in ('M','K','B', 'E') order by Name

--Problem 7.	 Find Towns Not Starting With
--Write a SQL query to find all towns that does not start with letters R, B or D. Order them alphabetically by name. Submit your query statements as Prepare DB & run queries.
select * from Towns where LEFT(Name, 1) not in ('R', 'B', 'D') order by Name

--Problem 8.	Create View Employees Hired After 2000 Year
--Write a SQL query to create view V_EmployeesHiredAfter2000 with first and last name to all employees hired after 2000 year. Submit your query statements as Run skeleton, run queries & check DB.
create view V_EmployeesHiredAfter2000
as
select FirstName, LastName from Employees where YEAR(HireDate)>2000

--Problem 9.	Length of Last Name
--Write a SQL query to find the names of all employees whose last name is exactly 5 characters long
select FirstName, LastName from Employees where len(LastName) = 5


--Problem 10.	Countries Holding ‘A’ 3 or More Times
--Find all countries that holds the letter 'A' in their name at least 3 times (case insensitively), sorted by ISO code. Display the country name and ISO code. Submit your query statements as Prepare DB & run queries.
select CountryName, IsoCode from Countries where CountryName like '%a%a%a%' order by IsoCode

--Problem 11.	 Mix of Peak and River Names
--Combine all peak names with all river names, so that the last letter of each peak name is the same like the first letter of its corresponding river name. Display the peak names, river names, and the obtained mix (mix should be in lowercase). Sort the results by the obtained mix. Submit your query statements as Prepare DB & run queries.
select  p.PeakName, r.RiverName, lower(p.PeakName + SUBSTRING(r.RiverName, 2,len(r.RiverName)-1)) as Mix   from Peaks p 
join Rivers r
on RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
order by Mix

--Problem 12.	Games from 2011 and 2012 year
--Find the top 50 games ordered by start date, then by name of the game. Display only games from 2011 and 2012 year. Display start date in the format “yyyy-MM-dd”. Submit your query statements as Prepare DB & run queries
select top(50) Name,format(Start,'yyyy-MM-dd') as [Started] from Games where YEAR(Start) between 2011 and 2012 order by Start, Name

--Problem 13.	 User Email Providers
--Find all users along with information about their email providers. Display the username and email provider. Sort the results by email provider alphabetically, then by username. Submit your query statements as Prepare DB & run queries
select u.Username,SUBSTRING(u.Email,(CHARINDEX('@',u.Email)+1),LEN(u.Email)-(CHARINDEX('@',u.Email))) as [Email Provider]  from Users u order by [Email Provider], u.Username

--Problem 14.	 Get Users with IPAdress Like Pattern
--Find all users along with their IP addresses sorted by username alphabetically. Display only rows that IP address matches the pattern: “***.1^.^.***”. Submit your query statements as Prepare DB & run queries.
--Legend: * - one symbol, ^ - one or more symbols
select u.Username,u.IpAddress  from Users u where IpAddress like '___.1_%._%.___' order by u.Username

--Problem 15.	 Show All Games with Duration and Part of the Day
--Find all games with part of the day and duration sorted by game name alphabetically then by duration and part of the day (all ascending). Parts of the day should be Morning (time is >= 0 and < 12), Afternoon (time is >= 12 and < 18), Evening (time is >= 18 and < 24). Duration should be Extra Short (smaller or equal to 3), Short (between 4 and 6 including), Long (greater than 6) and Extra Long (without duration). Submit your query statements as Prepare DB & run queries.
select g.Name as Game,'Part of the Day' = 
	case
		when (DATEPART(HOUR,g.Start)) between 0 and 11 then 'Morning'
		when (DATEPART(HOUR,g.Start)) between 12 and 17 then 'Afternoon'
		when (DATEPART(HOUR,g.Start)) between 18 and 23 then 'Evening'
	end,
	'Duration' = 
	case
		when g.Duration <= 3 then 'Extra Short'
		when g.Duration between 4 and 6 then 'Short'
		when g.Duration > 6 then 'Long'
		when g.Duration is null then 'Extra Long'
	end
   from Games g
   order by g.Name, Duration, [Part of the Day]

--   Problem 16.	 Orders Table
--You are given a table Orders(Id, ProductName, OrderDate) filled with data. Consider that the payment for that order must be accomplished within 3 days after the order date. Also the delivery date is up to 1 month. Write a query to show each product’s name, order date, pay and deliver due dates. Submit your query statements as Prepare DB & run queries.
SELECT ProductName, OrderDate, 
DATEADD(Day, 3, OrderDate) AS 'Pay Due',
DATEADD(Month, 1, OrderDate) AS 'Deliver Due'
FROM Orders













