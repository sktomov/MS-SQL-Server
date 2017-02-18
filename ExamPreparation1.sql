--Databases MSSQL Server Exam - 16 October 2016
create database AMS
CREATE TABLE Towns (
	TownID INT,
	TownName VARCHAR(30) NOT NULL,
	CONSTRAINT PK_Towns PRIMARY KEY(TownID)
)

CREATE TABLE Airports (
	AirportID INT,
	AirportName VARCHAR(50) NOT NULL,
	TownID INT NOT NULL,
	CONSTRAINT PK_Airports PRIMARY KEY(AirportID),
	CONSTRAINT FK_Airports_Towns FOREIGN KEY(TownID) REFERENCES Towns(TownID)
)

CREATE TABLE Airlines (
	AirlineID INT,
	AirlineName VARCHAR(30) NOT NULL,
	Nationality VARCHAR(30) NOT NULL,
	Rating INT DEFAULT(0),
	CONSTRAINT PK_Airlines PRIMARY KEY(AirlineID)
)

CREATE TABLE Customers (
	CustomerID INT,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Gender VARCHAR(1) NOT NULL CHECK (Gender='M' OR Gender='F'),
	HomeTownID INT NOT NULL,
	CONSTRAINT PK_Customers PRIMARY KEY(CustomerID),
	CONSTRAINT FK_Customers_Towns FOREIGN KEY(HomeTownID) REFERENCES Towns(TownID)
)

INSERT INTO Towns(TownID, TownName)
VALUES
(1, 'Sofia'),
(2, 'Moscow'),
(3, 'Los Angeles'),
(4, 'Athene'),
(5, 'New York')

INSERT INTO Airports(AirportID, AirportName, TownID)
VALUES
(1, 'Sofia International Airport', 1),
(2, 'New York Airport', 5),
(3, 'Royals Airport', 1),
(4, 'Moscow Central Airport', 2)

INSERT INTO Airlines(AirlineID, AirlineName, Nationality, Rating)
VALUES
(1, 'Royal Airline', 'Bulgarian', 200),
(2, 'Russia Airlines', 'Russian', 150),
(3, 'USA Airlines', 'American', 100),
(4, 'Dubai Airlines', 'Arabian', 149),
(5, 'South African Airlines', 'African', 50),
(6, 'Sofia Air', 'Bulgarian', 199),
(7, 'Bad Airlines', 'Bad', 10)

INSERT INTO Customers(CustomerID, FirstName, LastName, DateOfBirth, Gender, HomeTownID)
VALUES
(1, 'Cassidy', 'Isacc', '19971020', 'F', 1),
(2, 'Jonathan', 'Half', '19830322', 'M', 2),
(3, 'Zack', 'Cody', '19890808', 'M', 4),
(4, 'Joseph', 'Priboi', '19500101', 'M', 5),
(5, 'Ivy', 'Indigo', '19931231', 'F', 1)


-- 1 . You will be given 4 of the tables. You need to create tables for Flights and Tickets. Follow the instructions and constraints about the columns, below, and create the Tables exactly as specified.
--Submit your queries in judge, using the “Run Skeleton, Run Queries and Check DB” execution strategy.
use AMS

create table Flights (
FlightID int not null,
DepartureTime datetime not null,
ArrivalTime datetime not null,
Status varchar(9),
OriginAirportID int not null,
DestinationAirportID int not null,
AirlineID int not null,
constraint PK_FlightID primary key(FlightID),
constraint CH_Status check (Status in ('Departing', 'Delayed', 'Arrived', 'Cancelled')),
constraint FK_Flights_Airports foreign key(OriginAirportID) references Airports(AirportID),
constraint FK_Flights_Airports_Destination foreign key(DestinationAirportID) references Airports(AirportID),
constraint FK_Flights_Airlines foreign key(AirlineID) references Airlines(AirlineID)
)

create table Tickets (
TicketID int not null,
Price decimal(8,2) not null,
Class varchar(6),
Seat varchar(5) not null, 
CustomerID int not null,
FlightID int not null,
constraint PK_TicketID primary key(TicketID),
constraint CH_Class check (Class in ('First', 'Second', 'Third')),
constraint FK_Tickets_Customers foreign key(CustomerID) references Customers(CustomerID),
constraint FK_Tickets_Flights foreign key (FlightID) references Flights(FlightID)
)

--Section 2: Database Manipulations
--Here we need to do several manipulations in the database, like changing data, adding data, adding tables etc.
--Submit your queries in judge, using the “Run Skeleton, Run Queries and Check DB” execution strategy.
--Task 1: Data Insertion
--For us to be able to do any manipulations we need some test data first. Insert the following rows of data into their corresponding tables:
insert into Flights values
(1,'2016-10-13 06:00 AM','2016-10-13 10:00 AM','Delayed',1,4,1),
(2,'2016-10-12 12:00 PM','2016-10-12 12:01 PM','Departing',1,3,2),
(3,'2016-10-14 03:00 PM','2016-10-20 04:00 AM','Delayed',4,2,4),
(4,'2016-10-12 01:24 PM','2016-10-12 4:31 PM','Departing',3,1,3),
(5,'2016-10-12 08:11 AM','2016-10-12 11:22 PM','Departing',4,1,1),
(6,'1995-06-21 12:30 PM','1995-06-22 08:30 PM','Arrived',2,3,5),
(7,'2016-10-12 11:34 PM','2016-10-13 03:00 AM','Departing',2,4,2),
(8,'2016-11-11 01:00 PM','2016-11-12 10:00 PM','Delayed',4,3,1),
(9,'2015-10-01 12:00 PM','2015-12-01 01:00 AM','Arrived',1,2,1),
(10,'2016-10-12 07:30 PM','2016-10-13 12:30 PM','Departing',2,1,7)

insert into Tickets values
(1,3000.00,'First','233-A',3,8),
(2,1799.90,'Second','123-D',1,1),
(3,1200.50,'Second','12-Z',2,5),
(4,410.68,'Third','45-Q',2,8),
(5,560.00,'Third','201-R',4,6),
(6,2100.00,'Second','13-T',1,9),
(7,5500.00,'First','98-O',2,7)


--Task 2: Update Arrived Flights
--Update all flights with status-‘Arrived’ Airline ID, to 1.
update Flights
set AirlineID = 1
where Status = 'Arrived'

--Task 3: Update Tickets
--Find the highest-rated Airline, and increase all of its Flights’ Tickets’ prices with 50%.
update Tickets
set Price = Price*0.5
where FlightID in
(select f.FlightID from Tickets as t
join Flights as f on t.FlightID = f.FlightID
join Airlines as a on a.AirlineID = f.AirlineID
where a.Rating = 200)

--Task 4: Table Creation
--Now we’ve reached the point where your real assignment comes, and it is to extend the AMS database. The Customers would like to write reviews about certain Airlines.  Add to the database a table called CustomerReviews. Here is what you need to have in it:
create table CustomerReviews(
ReviewID int not null,
ReviewContent varchar(255) not null,
ReviewGrade int,
AirlineID int not null,
CustomerID int not null,
constraint PK_CustomerReviews primary key(ReviewID),
constraint CH_ReviewGrade check(ReviewGrade between 0 and 10),
constraint FK_CustomerReviews_Airlines foreign key(AirlineID) references Airlines(AirlineID),
constraint FK_CustomerReviews_Customers foreign key(CustomerID) references Customers(CustomerID)
)

create table CustomerBankAccounts (
AccountID int not null,
AccountNumber varchar(10) unique not null,
Balance decimal(10,2) not null,
CustomerID int not null,
constraint PK_CustomerBankAccounts primary key(AccountID),
constraint FK_CustomerBankAccounts_Customers foreign key(CustomerID) references Customers(CustomerID)
)

--Task 5: Fill the new Tables with Data	
--Insert the following data into the newly created table – CustomerReviews.

insert into CustomerReviews values
(1,'Me is very happy. Me likey this airline. Me good.',10,1,1),
(2,'Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!',10,1,4),
(3,'Meh...',5,4,3),
(4,'Well Ive seen better, but Ive certainly seen a lot worse...',7,3,5)

insert into CustomerBankAccounts values
(1,'123456790',2569.23,1),
(2,'18ABC23672',14004568.23,2),
(3,'F0RG0100N3',19345.20,5)

--Section 3: Querying
--And now we need to do some data extraction. For this section, submit your queries in judge, using the “Prepare DB and Run Queries” execution strategy. Note that the example results from this section use a fresh database.
--Task 1: Extract All Tickets
--Extract from the database, all of the Tickets, taking only the Ticket’s ID, Price, Class and Seat. Sort the results ascending by TicketID.
select TicketID, Price, Class, Seat from Tickets
order by TicketID

--Task 2: Extract All Customers 
--Extract from the database, all of the Customers, taking only the Customer’s ID, Full Name (First name + Last name separated by a single space) and Gender. Sort the results by alphabetical order of the full name, and as second criteria, sort them ascending by CustomerID.
select CustomerID, FirstName + ' '+LastName as FullName, Gender from Customers 
order by FullName, CustomerID

--Task 3: Extract Delayed Flights 
--Extract from the database, all of the Flights, which have Status-‘Delayed’, taking only the Flight’s ID, DepartureTime and ArrivalTime. Sort the results ascending by FlightID.
select FlightID, DepartureTime, ArrivalTime from Flights 
where Status = 'Delayed'
order by FlightID

--Task 4: Extract Top 5 Most Highly Rated Airlines which have any Flights
--Extract from the database, the top 5 airlines, in terms of highest rating, which have any flights, taking only the Airlines’ IDs and Airlines’ Names, Airlines’ Nationalities and Airlines’ Ratings. If two airlines have the same rating order them, ascending, by AIrlineID.
select distinct top 5  a.AirlineID, a.AirlineName, a.Nationality, a.Rating from Airlines as a
join Flights as f on a.AirlineID = f.AirlineID
order by Rating	desc, AirlineName

--Task 5: Extract all Tickets with price below 5000, for First Class
--Extract from the database, all tickets, which have price below 5000, and have class – ‘First´, taking the Tickets’ IDs, Flights’ Destination Airport Name, and Owning Customers’ Full Names (First name + Last name separated by a single space). Order the results, ascending, by TicketID.
select t.TicketID, a.AirportName as [Destination], c.FirstName + ' ' +c.LastName as CustomerName from Tickets as t
join Flights as f on f.FlightID = t.FlightID
join Airports as a on a.AirportID = f.DestinationAirportID
join Customers as c on c.CustomerID = t.CustomerID
where t.Price < 5000 and Class = 'First'
order by TicketID

--Task 6: Extract all Customers which are departing from their Home Town
--Extract from the database, all of the Customers, which are departing from their Home Town, taking only the Customer’s ID, Full Name (First name + Last name separated by a single space) and Home Town Name. Order the results, ascending, by CustomerID.
SELECT c.CustomerID, 
	c.FirstName + ' ' + c.LastName AS FulName, 
	tn.TownName AS HomeTown
FROM Customers c
JOIN Tickets t
ON t.CustomerID = c.CustomerID
JOIN Flights f
ON f.FlightID = t.FlightID
JOIN Airports a
ON a.AirportID = f.OriginAirportID
JOIN Towns tn
ON tn.TownID = a.TownID
WHERE a.TownID = c.HomeTownID
AND f.Status = 'Departing'

--Task 7: Extract all Customers which will fly
--Extract from the database all customers, which have bought tickets and the flights to their tickets have Status-‘Departing’, taking only the Customer’s ID, Full Name (First name + Last name separated by a single space) and Age. Order them Ascending by their Age. Assume that the current year is 2016. If two people have the same age, order them by CustomerID, ascending. 

select distinct c.CustomerID, concat(c.FirstName, ' ', c.LastName), 2016 -year(c.DateOfBirth) as Age from Tickets as t
join Customers as c on c.CustomerID = t.CustomerID
join Flights as f on f.FlightID = t.FlightID
where f.Status = 'Departing'
order by Age

--Task 8: Extract Top 3 Customers which have Delayed Flights
--Extract from the database, the top 3 Customers, in terms of most expensive Ticket, which’s flights have Status- ‘Delayed’. Take the Customers’ IDs, Full Name (First name + Last name separated by a single space), Ticket Price and Flight Destination Airport Name.  If two tickets have the same price, order them, ascending, by CustomerID.
select top 3 c.CustomerID,concat(c.FirstName, ' ', c.LastName) as FullName, t.Price as TicketPrice, a.AirportName as Destination  from Tickets as t
join Flights as f on f.FlightID = t.FlightID
join Customers as c on c.CustomerID = t.CustomerID
join Airports as a on a.AirportID = f.DestinationAirportID
where f.Status = 'Delayed'
order by TicketPrice desc

--Task 9: Extract the Last 5 Flights, which are departing.
--Extract from the database, the last 5 Flights, in terms of departure time, which have a status of ‘Departing’, taking only the Flights’ IDs, Departure Time, Arrival Time, Origin and Destination Airport Names. 
--You have to take the last 5 flights in terms of departure time, which means they must be ordered ascending by departure time in the first place. If two flights have the same departure time, order them by FlightID, ascending.
select * from
(select top 5 f.FlightID, f.DepartureTime, f.ArrivalTime, a.AirportName as Origin, a2.AirportName as Destination from Flights as f
join Airports as a on a.AirportID = f.OriginAirportID
join Airports as a2 on a2.AirportID = f.DestinationAirportID
where Status = 'Departing'
order by f.DepartureTime desc, f.FlightID) as frd
order by DepartureTime asc


--Task 10: Extract all Customers below 21 years, which have already flew at least once
--Extract from the database, all customers which are below 21 years aged, and own a ticket to a flight, which has status – ‘Arrived’, taking their Customer’s ID, Full Name (First name + Last name separated by a single space), and Age. Order them by their Age in descending order.  Assume that the current year is 2016. If two persons have the same age, order them by CustomerID, ascending.
select distinct c.CustomerID, concat(c.FirstName, ' ', c.LastName) as FullName, 2016 -year(c.DateOfBirth) as Age from Customers as c
join Tickets as t on t.CustomerID = c.CustomerID
join Flights as f on f.FlightID = t.FlightID
where f.Status = 'Arrived' and 2016 -year(c.DateOfBirth) < 21
order by Age desc, c.CustomerID

--Task 11: Extract all Airports and the Count of People departing from them
--Extract from the database, all airports that have any flights with Status-‘Departing’, and extract the count of people that have tickets for those flights. Take the Airports’ IDs, Airports’ Names, and Count of People as Passengers. Order the results by AirportID, ascending. The flights must have some people in them.
select a.AirportID, a.AirportName, count(t.TicketID) as Passengers from Airports as a
join Flights as f on a.AirportID = f.OriginAirportID
and f.Status = 'Departing'
join Tickets as t on t.FlightID = f.FlightID
group by a.AirportID, a.AirportName
order by a.AirportID

--Section 4: Programmability
--Our employers are satisfied with our remarkable skills. They have decided to let us write several stored procedures for the AMS database. For this section, submit your queries in judge, using the “Run Skeleton, Run Queries and Check DB” execution strategy.
--Task 1: Review Registering Procedure
--Write a procedure – “usp_SubmitReview”, which registers a review in the CustomerReviews table. The procedure should accept the following parameters as input:
--•	CustomerID
--•	ReviewContent
--•	ReviewGrade
--•	AirlineName
--You can assume that the CustomerID , will always be valid, and existent in the database.
--If there is no airline with the given name, raise an error – ‘Airline does not exist.’
--If no error has been raised, insert the review into the table, with the Airline’s ID.
go 
create procedure usp_SubmitReview (@customerId int, @ReviewContent varchar(255), @ReviewGrade int, @AirlineName varchar(30))
as
begin
	begin transaction

	if not exists(select AirlineName  from Airlines where AirlineName = @AirlineName)
	begin
		RAISERROR('Airline does not exist.', 16, 1)
		rollback

	end
	else 
	begin
			declare @index int
			if (select count(*) from CustomerReviews) = 0
			begin
			set @index = 1
			end
			else
			set @index = (select max(ReviewID) from CustomerReviews) + 1
	
			declare @AirlineID int  = (select AirlineID from Airlines where AirlineName = @AirlineName)
			insert into CustomerReviews Values
			(@index, @ReviewContent, @ReviewGrade,@AirlineID, @customerId)
	commit
	end

end

exec usp_SubmitReview 1, 'kur', 6, 'Royal Airline'

--Task 2: Ticket Purchase Procedure
--Write a procedure – “usp_PurchaseTicket”, which registers a ticket in the Tickets table, to a customer that has purchased it, taking from his balance in the CustomerBankAccounts table, the provided ticket price. The procedure should accept the following parameters as input:
--•	CustomerID
--•	FlightID
--•	TicketPrice
--•	Class
--•	Seat
--You can assume that the CustomerID , FlightID, Class and Seat will always be valid, and existent in the database.
--If the ticket price is greater than the customer’s bank account balance, raise an error ‘Insufficient bank account balance for ticket purchase.’
--If no error has been raised, insert the ticket into the table Tickets, and reduce the customer’s bank account balance with the ticket price’s value.
--All input parameters will be given in a valid format. Numeric data will be given as numbers, text as text etc.

go
create procedure usp_PurchaseTicket(@CustomerID int, @FlightID int, @TicketPrice decimal(8,2), @Class varchar(6), @Seat varchar(5))
as
begin
	begin transaction 
	declare @customerBalance decimal (10,2) = (select Balance from CustomerBankAccounts where @CustomerID = CustomerID);
	if (@TicketPrice > @customerBalance or @customerBalance is null)
	begin
	RAISERROR('Insufficient bank account balance for ticket purchase.', 16, 2)
	rollback
	end
	else
	begin
		declare @tickedID int = isnull((select max(TicketID) from Tickets),0) + 1
		insert into Tickets values
		(@tickedID, @TicketPrice, @Class, @Seat, @CustomerID, @FlightID)
		update CustomerBankAccounts
		set Balance = Balance - @TicketPrice
		where @CustomerID = CustomerID
		commit
	end

end

--Section 5 (BONUS): Update Trigger
--AMS has given you one final task because you are really good. They have already given you full control over their database. You have been tasked to create a table ArrivedFlights, and a trigger, which comes in action every time a flight’s status, is updated to ‘Arrived’, and only in that case… In all other cases the update should function normally.
--The table should hold basic data about the flight, but also the amount of passengers.
--The table should have the following columns:

CREATE TABLE ArrivedFlights(
FlightID INT PRIMARY KEY,
ArrivalTime DATETIME NOT NULL,
Origin VARCHAR(50) NOT NULL,
Destination VARCHAR(50) NOT NULL,
Passengers INT NOT NULL
)
go
create trigger TR_ArrivedFlights_After_Update on Flights for UPDATE
as
insert into ArrivedFlights ([FlightID], [ArrivalTime], [Origin], [Destination], [Passengers])
select FlightID, 
ArrivalTime,
a.AirportName as Origin, 
a2.AirportName as Destination
, (select count(*) from Tickets where FlightID = i.FlightID) as Passengers
  from inserted as i
join Airports as a on i.OriginAirportID = a.AirportID
join Airports as a2 on i.DestinationAirportID = a2.AirportID
where Status = 'Arrived'



UPDATE Flights
SET Status='Arrived'
WHERE FlightID = 5;

SELECT * FROM ArrivedFlights;