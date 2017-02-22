--Exam 19.02.2017
create database Bakery

use Bakery
--1

create table Countries (
Id int primary key identity,
Name nvarchar(50) unique
)

create table Distributors (
Id int primary key identity,
Name nvarchar(25) unique,
AddressText nvarchar(30),
Summary nvarchar(200),
CountryId int foreign key references Countries(Id)
)

create table Ingredients (
Id int primary key identity,
Name nvarchar(30),
Description nvarchar(200),
OriginCountryId int foreign key references Countries(Id),
DistributorId int foreign key references Distributors(Id)
)

create table Products (
Id int primary key identity,
Name nvarchar(25) unique,
Description nvarchar(250),
Recipe nvarchar(max),
Price money,
constraint CH_Price check (Price>0)
)

create table ProductsIngredients (
ProductId int,
IngredientId int,
constraint PK_ProductsIngredients primary key (ProductId, IngredientId),
constraint FK_ProductsIngredients_Products foreign key(ProductId) references Products(Id),
constraint FK_ProductsIngredients_Ingredients foreign key(IngredientId) references Ingredients(Id)
)

create table Customers (
Id int primary key identity,
FirstName nvarchar(25),
LastName nvarchar(25),
Gender char(1),
Age int,
PhoneNumber char(10),
CountryId int foreign key references Countries(Id),
constraint CH_Gender check (Gender in('F', 'M')),
constraint CH_PhoneNumber check (PhoneNumber like replicate ('[0-9]', 10))
)

create table Feedbacks (
Id int primary key identity,
Description nvarchar(255),
Rate decimal(8,2),
ProductId int foreign key references Products(Id),
CustomerId int foreign key references Customers(Id),
constraint CH_Rate check (Rate between 0 and 10)
)

--2

insert into Distributors  (Name,CountryId, AddressText, Summary) values 
('Deloitte & Touche',2,'6 Arch St #9757','Customizable neutral traveling'),
('Congress Title',13,'58 Hancock St','Customer loyalty'),
('Kitchen People',1,'3 E 31st St #77','Triple-buffered stable delivery'),
('General Color Co Inc',21,'6185 Bohn St #72','Focus group'),
('Beck Corporation',23,'21 E 64th Ave','Quality-focused 4th generation hardware')

insert into Customers (FirstName, LastName, Age, Gender, PhoneNumber, CountryId) values
('Francoise','Rautenstrauch',15,'M','0195698399',5),
('Kendra','Loud',22,'F','0063631526',11),
('Lourdes','Bauswell',50,'M','0139037043',8),
('Hannah','Edmison',18,'F','0043343686',1),
('Tom','Loeza',31,'M','0144876096',23),
('Queenie','Kramarczyk',30,'F','0064215793',29),
('Hiu','Portaro',25,'M','0068277755',16),
('Josefa','Opitz',43,'F','0197887645',17)


--3
Update Ingredients
Set DistributorId = 35
Where Name in ('Bay Leaf', 'Paprika', 'Poppy')

update Ingredients
set OriginCountryId = 14
where OriginCountryId = 8

--4

delete from Feedbacks
where CustomerId = 14 or ProductId = 5

--Section 3. Querying (40 pts)
--For this section put your queries in judge and use SQL Server prepare DB and run queries. You need to start with a fresh dataset, so recreate your DB and import the sample data again.

--5
select Name, Price, Description from Products
order by Price desc, Name


--6
select Name, Description, OriginCountryId from Ingredients
where OriginCountryId in (1,10,20)
order by Id

--7
select top 15 i.Name, i.Description, c.Name as CountryName from Ingredients as i
join Countries as c on c.Id = i.OriginCountryId
where c.Name in ('Bulgaria', 'Greece')
order by Name, CountryName

--8
select top 10 p.Name, p.Description,avg(f.Rate) as AverageRate, count(f.CustomerId) as FeedbacksAmount from Products as p
join Feedbacks as f on f.ProductId = p.Id
group by p.Name, p.Description
order by AverageRate desc, FeedbacksAmount desc

--9
select f.ProductId,f.Rate, f.Description, f.CustomerId, c.Age, c.Gender from Feedbacks as f
join Customers as c on c.Id = f.CustomerId
where f.Rate < 5.00
order by f.ProductId desc, f.Rate asc

--10
select concat(FirstName, ' ', LastName) as CustomerName,PhoneNumber, Gender  from Customers
where Id not in (select CustomerId from Feedbacks)
order by Id

--11
select f.ProductId, concat(FirstName, ' ', LastName) as CustomerName, Description as FeedbackDescription from Feedbacks as f
join Customers as c on c.Id = f.CustomerId
where c.Id in (select CustomerId  from Feedbacks
group by CustomerId
having count(CustomerId) >= 3)
order by f.ProductId, CustomerName, f.Id

--12
select cr.FirstName, Age, PhoneNumber from Customers as cr
join Countries as c on c.Id = cr.CountryId
where (cr.Age >=21 and cr.FirstName like '%an%') or (RIGHT(cr.PhoneNumber, 2) = '38' and c.Name != 'Greece')
order by cr.FirstName, cr.Age desc

--13
select d.Name as DistributorName, i.Name as IngredientName, p.Name as ProductName, f.AverageRate
   from Ingredients as i
join Distributors as d on d.Id = i.Id
join ProductsIngredients as pri on pri.IngredientId = i.Id
join Products as p on p.Id = pri.ProductId
join (select ProductId, avg(Rate) as AverageRate from Feedbacks 
group by ProductId
having avg(Rate) between 5.00 and 8.00) as f on f.ProductId = p.Id
where p.Id in  (select ProductId from Feedbacks 
group by ProductId
having avg(Rate) between 5.00 and 8.00)
order by DistributorName, IngredientName, ProductName

-- 2/4 da se opravi

--14
select top 1 with ties cnt.Name as CountryName, j.FeedbackRate from Countries cnt
right join(
	select CountryId, avg(Rate) as FeedbackRate from Customers as c
	join Feedbacks as f on f.CustomerId = c.Id
	group by CountryId
	) as j on j.CountryId = cnt.Id
order by j.FeedbackRate desc

--15
select * from Ingredients
select DistributorId, count(DistributorId) from Ingredients
group by DistributorId

--16
go
create view v_UserWithCountries as
select concat(c.FirstName, ' ', c.LastName) as CustomerName, c.Age, c.Gender, cnt.Name as CountryName from  Customers as c
join Countries as cnt on cnt.Id = c.CountryId

--17
go
create function udf_GetRating (@name nvarchar(25))
returns varchar(9)
as
begin
	declare @result varchar(9)
	declare @rating decimal(8,2)
	set @rating = (select f2.Average from Products as p
	 left join 
	 (select f.ProductId, avg(f.Rate) as Average from Feedbacks as f
	 group by f.ProductId) as f2 on f2.ProductId = p.Id
	where p.Name = @name)

	if @rating < 5
	begin
		set @result = 'Bad'
	end
	else if @rating between 5 and 8 
	begin 
		set @result = 'Average'
	end
	else if @result > 9
	begin
		set @result = 'Good'
	end
	else
	begin
		set @result = 'No rating'
	end
	return @result
end

--18
go
create procedure usp_SendFeedback(@customerId int, @productId int,@rate decimal(8,2), @description nvarchar(255))
as
begin

	begin transaction
	declare @userFeedBacks int = 0
	set @userFeedBacks = (select c.Counts from (select CustomerId, count(CustomerId) as Counts from Feedbacks group by CustomerId) as c where c.CustomerId = @customerId)
	if @userFeedBacks > 3
		begin
			raiserror('You are limited to only 3 feedbacks per product!', 16, 1)
			rollback
		end
	else 
		begin
			insert into Feedbacks (Description, Rate, ProductId, CustomerId) values
			(@description, @rate, @productId, @customerId)
			commit
		end
end

--19.	Delete Products
--Create a trigger that deletes all of the relations of a product upon its deletion. 
--Example usage:
--Query
--DELETE FROM Products WHERE Id = 7
go
create trigger T_Delete_Products  on Products for delete
as
	DELETE FROM ProductsIngredients WHERE ProductId in (select Id from deleted)

	delete from Feedbacks where ProductId in (select Id from deleted) 


	


	DELETE FROM ProductsIngredients WHERE ProductId = 7


--20
select * from Products as p
join ProductsIngredients as pri on pri.ProductId =p.Id
join Ingredients as i on i.Id = pri.ProductId



select p.IngredientId from ProductsIngredients as p
group by IngredientId