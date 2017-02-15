--Problem 1.	Employees with Salary Above 35000
--Create stored procedure usp_GetEmployeesSalaryAbove35000 that returns all employees’ first and last names for whose salary is above 35000. Submit your query statement as Run skeleton, run queries & check DB in Judge.
create procedure usp_GetEmployeesSalaryAbove35000
as
select e.FirstName, e.LastName from Employees as e
where e.Salary>35000

exec usp_GetEmployeesSalaryAbove35000

--Problem 2.	Employees with Salary Above Number
--Create stored procedure usp_GetEmployeesSalaryAboveNumber that accept a number (of type MONEY) as parameter and return all employees’ first and last names whose salary is above or equal to the given number. Submit your query statement as Run skeleton, run queries & check DB in Judge.

create proc usp_GetEmployeesSalaryAboveNumber @Number money
as
select e.FirstName, e.LastName from Employees as e 
where e.Salary >= @Number

exec usp_GetEmployeesSalaryAboveNumber 48100

--Problem 3.	Town Names Starting With
--Write a stored procedure usp_GetTownsStartingWith that accept string as parameter and returns all town names starting with that string. Submit your query statement as Run skeleton, run queries & check DB in Judge.
create proc usp_GetTownsStartingWith @string nvarchar(max)
as
select t.Name from Towns as t
where left(t.Name, len(@string)) = @string

exec usp_GetTownsStartingWith 'b'

--Problem 4.	Employees from Town
--Write a stored procedure usp_GetEmployeesFromTown that accepts town name as parameter and return the employees’ first and last name that live in the given town. Submit your query statement as Run skeleton, run queries & check DB in Judge.
create proc usp_GetEmployeesFromTown  @town nvarchar(max)
as
select e.FirstName, e.LastName  from Employees as e
join Addresses as a on a.AddressID = e.AddressID
join Towns as t on a.TownID = t.TownID
where t.Name = @town

exec usp_GetEmployeesFromTown 'Sofia'

--Problem 5.	Salary Level Function
--Write a function ufn_GetSalaryLevel(@salary MONEY) that receives salary of an employee and returns the level of the salary.
--•	If salary is < 30000 return “Low”
--•	If salary is between 30000 and 50000 (inclusive) return “Average”
--•	If salary is > 50000 return “High”
--Submit your query statement as Run skeleton, run queries & check DB in Judge.
create function ufn_GetSalaryLevel (@salary money)
returns varchar(7)
as
begin
declare @result varchar(7);
if (@salary < 30000)
begin
set @result = 'Low';
end
else if(@salary >50000)
begin 
set @result = 'High';
end
else
begin
set @result = 'Average'
end
return @result;
end;

select dbo.ufn_GetSalaryLevel(13500.00) from Employees

--Problem 6.	Employees by Salary Level
--Write a stored procedure usp_EmployeesBySalaryLevel that receive as parameter level of salary (low, average or high) and print the names of all employees that have given level of salary. You can use the function - “dbo.ufn_GetSalaryLevel(@Salary)”, which was part of the previous task, inside your “CREATE PROCEDURE …” query.
create proc usp_EmployeesBySalaryLevel @levelSalary varchar(7)
as
select e.FirstName,e.LastName  from Employees as e
where dbo.ufn_GetSalaryLevel(e.Salary) = @levelSalary

exec usp_EmployeesBySalaryLevel 'High'

--Problem 7.	Define Function
--Define a function ufn_IsWordComprised(@setOfLetters, @word) that returns true or false depending on that if the word is a comprised of the given set of letters. Submit your query statement as Run skeleton, run queries & check DB in Judge.
create function ufn_IsWordComprised (@setOfLetters nvarchar(20), @word nvarchar(20))
returns bit
as
begin
	declare @comprised bit = 1
	declare @index int =1
	while(@comprised = 1) and (@index <= len(@word))
	begin
		if (CHARINDEX(lower(SUBSTRING(@word, @index, 1)),lower (@setOfLetters)) not between 1 and len(@setOfLetters))
		begin
			set @comprised = 0
		end
		else set @index +=1
	end
	return @comprised
end

select dbo.ufn_IsWordComprised ('pppp', 'Gey')

--Problem 8.	* Delete Employees and Departments
--Write a SQL query to delete all Employees from the Production and Production Control departments. Delete these departments from the Departments table too. Submit your query as Run skeleton, run queries and check DB. After that exercise restore your database to revert those changes.
--Hint:
--You may set ManagerID column in Departments table to nullable (using query "ALTER TABLE …").
alter table Departments
alter column ManagerID int null

delete from EmployeesProjects
where EmployeeID in (
						select e.EmployeeID from  Employees as e
						join Departments as d on e.DepartmentID = d.DepartmentID
						where d.Name in ('Production', 'Production Control')
					)

update Employees
set ManagerID = NULL
where ManagerID	in (
						select e.EmployeeID from  Employees as e
						join Departments as d on e.DepartmentID = d.DepartmentID
						where d.Name in ('Production', 'Production Control')
					)

update Departments
set ManagerID = NULL
where ManagerID	in (
						select e.EmployeeID from  Employees as e
						join Departments as d on e.DepartmentID = d.DepartmentID
						where d.Name in ('Production', 'Production Control')
					)

delete from Employees
where EmployeeID in (
						select e.EmployeeID from  Employees as e
						join Departments as d on e.DepartmentID = d.DepartmentID
						where d.Name in ('Production', 'Production Control')
					)

delete from Departments
where Name in ('Production', 'Production Control')

--Problem 9.	Employees with Three Projects
--Create a procedure usp_AssignProject(@emloyeeId, @projectID) that assigns projects to employee. If the employee has more than 3 project throw exception and rollback the changes. The exception message must be: "The employee has too many projects!" with Severity = 16, State = 1.
create procedure usp_AssignProject (@employeeId int, @projectID int)
as
begin
	begin transaction
	insert into EmployeesProjects (EmployeeID, ProjectID) values (@employeeId, @projectID)

	if (select count(ep.EmployeeID) from EmployeesProjects as ep where @employeeId = ep.EmployeeID) > 3
	begin
	  RAISERROR ('The employee has too many projects!', 16, 1)
	  rollback
	end
	commit
end

--PART II – Queries for Bank Database

--Problem 10.	Find Full Name
--You are given a database schema with tables AccountHolders(Id (PK), FirstName, LastName, SSN) and Accounts(Id (PK), AccountHolderId (FK), Balance).  Write a stored procedure usp_GetHoldersFullName that selects the full names of all people. Submit your query statement as Run skeleton, run queries & check DB in Judge.
create procedure usp_GetHoldersFullName
as
begin
	select a.FirstName + ' ' + a.LastName as 'Full Name'  from AccountHolders as a
end

exec usp_GetHoldersFullName

--Problem 11.	People with Balance Higher Than
--Your task is to create a stored procedure usp_GetHoldersWithBalanceHigherThan that accepts a number as a parameter and returns all people who have more money in total of all their accounts than the supplied number. Submit your query statement as Run skeleton, run queries & check DB in Judge. 
create procedure usp_GetHoldersWithBalanceHigherThan (@number money) 
as
begin
select FirstName as 'First Name', LastName as 'Last Name' from 
              (
					select a.FirstName, a.LastName, sum(ac.Balance) as Total from AccountHolders as a
					join Accounts as ac on ac.AccountHolderId = a.Id
					group by a.FirstName, a.LastName
				)as tb
				where tb.Total>@number
end

exec usp_GetHoldersWithBalanceHigherThan 10000



--Problem 17.	Create Table Logs
--Create another table – Logs (LogId, AccountId, OldSum, NewSum). Add a trigger to the Accounts table that enters a new entry into the Logs table every time the sum on an account changes.
--Submit your query only for the trigger action as Run skeleton, run queries and check DB.

create table Logs (
LogId int not null primary key identity,
AccountId int foreign key references Accounts(Id),
OldSum money,
NewSum money
)
go
create trigger T_Accounts_After_Update on Accounts for Update
as
begin
	insert  into Logs (AccountId, OldSum, NewSum)
	select i.Id, d.Balance, i.Balance  from inserted as i 
	join deleted as d on i.Id = d.Id

end

--	12. Future Value Function
--Your task is to create a function ufn_CalculateFutureValue that accepts as parameters – sum (money), yearly interest rate (float) and number of years(int). It should calculate and return the future value of the initial sum. Using the following formula:
--FV=I×(〖(1+R)〗^T)
go
create function ufn_CalculateFutureValue (@sum money, @yearlyInterestRate float, @numberYears int)
returns money
as
begin
	declare @result money = 0.0
	declare @pow float = power(1+@yearlyInterestRate, @numberYears)
	set @result = @sum * @pow
	return @result

end

go
select dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

--Problem 13.	Calculating Interest
--Your task is to create a stored procedure usp_CalculateFutureValueForAccount that uses the function from the previous problem to give an interest to a person's account for 5 years, along with information about his/her account id, first name, last name and current balance as it is shown in the example below. It should take the AccountId and the interest rate as parameters. Again you are provided with “dbo.ufn_CalculateFutureValue” function which was part of the previous task.
go
create proc usp_CalculateFutureValueForAccount (@account int, @interest float)
as
begin
		select acc.Id as [Account ID], ah.FirstName as [First Name], ah.LastName as [Last Name], acc.Balance as [Current Balance], 
		dbo.ufn_CalculateFutureValue(acc.Balance, @interest, 5) as [Balance in 5 years]
		  from Accounts as acc
		join AccountHolders as ah on ah.Id = acc.AccountHolderId
		where acc.Id = @account
end

exec usp_CalculateFutureValueForAccount 1, 0.1

--Problem 14.	Deposit Money
--Add stored procedure usp_DepositMoney (AccountId, moneyAmount) that operate in transactions. Submit your query statement as Run skeleton, run queries & check DB in Judge.
go
create procedure usp_DepositMoney (@accountId int, @moneyAmount money)
as
begin
		begin transaction
		update Accounts
		set Balance = Balance + @moneyAmount
		where Id = @accountId
		commit
end

--Problem 15.	Withdraw Money
--Add stored procedures usp_WithdrawMoney (AccountId, moneyAmount) that operate in transactions. Submit your query statement as Run skeleton, run queries & check DB in Judge.
go
create proc usp_WithdrawMoney (@accountId int, @moneyAmount money)
as
begin
	begin transaction
		update Accounts
		set Balance = Balance - @moneyAmount
		where Id = @accountId
		commit
end

--Problem 16.	Money Transfer
--Write stored procedure usp_TransferMoney(senderId, receiverId, amount) that transfers money from one account to another. Consider cases when the amount of money is negative number. Make sure that the whole procedure passes without errors and if error occurs make no change in the database. You can use both: “usp_DepositMoney”, “usp_WithdrawMoney” (look at previous two problems about those procedures).

go
create proc usp_TransferMoney (@senderId int, @receiverId int, @amount money)
as
begin
	begin transaction
	update Accounts 
	set Balance = Balance - @amount
	where Id = @senderId
	update Accounts
	set Balance = Balance + @amount
	where Id = @receiverId
	if (select Balance from Accounts where Id = @senderId) < 0
	begin
		rollback
	end
	else
	begin
		commit
	end
end

--Problem 18.	Create Table Emails
--Create another table – NotificationEmails(Id, Recipient, Subject, Body). Add a trigger to logs table and create new email whenever new record is inserted in logs table. The following data is required to be filled for each email:
--•	Recipient – AccountId
--•	Subject – “Balance change for account: {AccountId}”
--•	Body - “On {date} your balance was changed from {old} to {new}.”
--Submit your query only for the trigger action as Run skeleton, run queries and check DB.
go
create table NotificationEmails(
Id int not null primary key identity,
Recipient int not null,
Subject nvarchar(150),
Body nvarchar(max)
)

go
create trigger T_Logs_After_Insert on Logs for insert
as
begin
	insert into NotificationEmails(Recipient, Subject, Body)
	select l.AccountId, 'Balance change for account: ' 
		+ CONVERT(varchar(10), AccountId),
		'On ' + CONVERT(varchar(30), GETDATE()) + ' your balance was changed from '
		+ CONVERT(varchar(30), OldSum) + ' to ' 
+ CONVERT(varchar(30), NewSum) 
	 from Logs as l
end

UPDATE Accounts
SET Balance += 10
WHERE Id = 1

select * from NotificationEmails