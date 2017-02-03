
--Problem 1.	Records’ Count
--Import the database and send the total count of records to Mr. Bodrog. Make sure nothing got lost.
select COUNT(Id) from WizzardDeposits

--Problem 2.	Longest Magic Wand
--Select the size of the longest magic wand. Rename the new column appropriately.
select max(MagicWandSize) as LongestMagicWand from WizzardDeposits

--Problem 3.	Longest Magic Wand per Deposit Groups
--For wizards in each deposit group show the longest magic wand. Rename the new column appropriately.
select w.DepositGroup, max(w.MagicWandSize) as LongestMagicWand  from WizzardDeposits w group by w.DepositGroup

--Problem 4.	* Smallest Deposit Group per Magic Wand Size
--Select the deposit group with the lowest average wand size.
select w.DepositGroup from WizzardDeposits w  group by w.DepositGroup having avg(w.MagicWandSize)<
(
select avg(MagicWandSize) from WizzardDeposits
)

--Problem 5.	Deposits Sum
--Select all deposit groups and its total deposit sum.
select w.DepositGroup, sum(w.DepositAmount)  from WizzardDeposits w group by w.DepositGroup

--Problem 6.	Deposits Sum for Ollivander Family
--Select all deposit groups and its total deposit sum but only for the wizards who has their magic wand crafted by Ollivander family.
select w.DepositGroup, sum(w.DepositAmount) as TotalSum from WizzardDeposits w where w.MagicWandCreator = 'Ollivander family' group by w.DepositGroup

--Problem 7.	Deposits Filter
--Select all deposit groups and its total deposit sum but only for the wizards who has their magic wand crafted by Ollivander family. After this filter total deposit amounts lower than 150000. Order by total deposit amount in descending order.
select w.DepositGroup, sum(w.DepositAmount) as TotalSum from WizzardDeposits w where w.MagicWandCreator = 'Ollivander family' group by w.DepositGroup having sum(w.DepositAmount)<150000 order by TotalSum desc

--Problem 8.	 Deposit Charge
--Create a query that selects:
--•	Deposit group 
--•	Magic wand creator
--•	Minimum deposit charge for each group 
--Select the data in ascending order by MagicWandCreator and DepositGroup.
select w.DepositGroup, w.MagicWandCreator, min(w.DepositCharge)  from WizzardDeposits w group by w.DepositGroup, w.MagicWandCreator order by w.MagicWandCreator, w.DepositGroup

--Problem 9.	Age Groups
--Write down a query that creates 7 different groups based on their age.
--Age groups should be as follows:
--•	[0-10]
--•	[11-20]
--•	[21-30]
--•	[31-40]
--•	[41-50]
--•	[51-60]
--•	[61+]
--The query should return
--•	Age groups
--•	Count of wizards in it
select a.AgeGroup, Count(a.Age)
from
( select
case
	when Age >0 and Age <=10 then '[0-10]'
	when Age >10 and Age <=20 then '[11-20]'
	when Age >20 and Age <=30 then '[21-30]'
	when Age >30 and Age <=40 then '[31-40]'
	when Age >40 and Age <=50 then '[41-50]'
	when Age >50 and Age <=60 then '[51-60]'
	else '[61+]'
end AgeGroup, Age from WizzardDeposits
) a group by a.AgeGroup

--Problem 10.	First Letter
--Write a query that returns all unique wizard first letters of their first names only if they have deposit of type Troll Chest. Order them alphabetically. Use GROUP BY for uniqueness.
select left(w.FirstName, 1) as FirstLetter from WizzardDeposits w where w.DepositGroup = 'Troll Chest' group by left(w.FirstName, 1) order by FirstLetter

--Problem 11.	Average Interest 
--Mr. Bodrog is highly interested in profitability. He wants to know the average interest of all deposits groups split by whether the deposit has expired or not. But that’s not all. He wants you to select deposits with start date after 01/01/1985. Order the data descending by Deposit Group and ascending by Expiration Flag.
--The output should consist of the following columns:
select w.DepositGroup, w.IsDepositExpired, avg(w.DepositInterest) as AverageInterest  from WizzardDeposits w where w.DepositStartDate > '1985-01-01' group by w.DepositGroup, w.IsDepositExpired order by w.DepositGroup desc, IsDepositExpired

--Problem 12.	* Rich Wizard, Poor Wizard
--Mr. Bodrog definitely likes his werewolves more than you. This is your last chance to survive! Give him some data to play his favorite game Rich Wizard, Poor Wizard. The rules are simple: You compare the deposits of every wizard with the wizard after him. If a wizard is the last one in the database, simply ignore it. In the end you have to sum the difference between the deposits.
select sum(SumDiff.SumDifference) from 
(select w.DepositAmount - (select DepositAmount from WizzardDeposits where Id = w.Id+1) as SumDifference  from WizzardDeposits w) as SumDiff
declare @sumDif decimal(18,2)
set @sumDif = (
select sum(w.DepositAmount - w2.DepositAmount) from WizzardDeposits w join WizzardDeposits w2 on  w2.Id = w.Id+1)
select @sumDif

--Problem 13.	Departments Total Salaries
--That’s it! You no longer work for Mr. Bodrog. You have decided to find a proper job as an analyst in SoftUni. 
--It’s not a surprise that you will use the SoftUni database. Things get more exciting here!
--Create a query which shows the total sum of salaries for each department. Order by DepartmentID.
--Your query should return:	
--•	DepartmentID
select e.DepartmentID, sum(e.Salary) as TotalSalary from Employees e group by e.DepartmentID order by e.DepartmentID

--Problem 14.	Employees Minimum Salaries
--Select the minimum salary from the employees for departments with ID (2,5,7) but only for those who are hired after 01/01/2000.
--Your query should return:	
--•	DepartmentID
select e.DepartmentID, min(e.Salary) as MinimumSalary from Employees e where e.DepartmentID in (2,5,7) and e.HireDate > '2000-01-01'  group by e.DepartmentID 

--Problem 15.	Employees Average Salaries
--Select all employees who earn more than 30000 into a new table. Then delete all employees who has ManagerID = 42 (in the new table); Then increase the salaries of all employees with DepartmentID=1 with 5000. Finally, select the average salaries in each department.
select * into G from Employees where Salary > 30000

delete from G where G.ManagerID = 42

update G set Salary = Salary+5000 where DepartmentID = 1

select G.DepartmentID, avg(Salary) as AverageSalary  from G group by DepartmentID

--Problem 16.	Employees Maximum Salaries
--Find the max salary for each department. Filter those which have max salaries not in the range 30000 and 70000;
select e.DepartmentID, max(Salary) as MaxSalary  from Employees e group by e.DepartmentID having max(Salary) not between 30000 and 70000

--Problem 17.	Employees Count Salaries
--Count the salaries of all employees who don’t have a manager.
select count(e.Salary) from Employees e where ManagerID  is null

--Problem 18. *3rd Highest Salary
--Find the third highest salary in each department if there is such.
select Salaries.DepartmentID,Salaries.ThirdSalary from
(
select e.DepartmentID, max(e.Salary) as ThirdSalary, DENSE_RANK() over (partition by e.DepartmentId order by salary desc) as Rank  from Employees e group by DepartmentID, Salary) as Salaries
where Rank = 3

--Problem 19. **Salary Challenge
--Write a query that returns:

-- FirstName

-- LastName

-- DepartmentID

--Select all employees who have salary higher than the average salary of their respective departments. Select only the
--first 10 rows. Order by DepartmentID.
select top(10) e.FirstName, e.LastName, e.DepartmentID  from Employees e
where e.Salary > (
					select avg(e2.Salary) from Employees e2
					where e.DepartmentID = e2.DepartmentID
					group by DepartmentID
				 )
order by DepartmentID







