--Problem 1.	One-To-One Relationship
--Create two tables as follows. Use appropriate data types.

CREATE TABLE Passports(
PassportID INT NOT NULL,
PassportNumber NVARCHAR(10) NOT NULL
)

CREATE TABLE Persons(
PersonID INT NOT NULL,
FirstName NVARCHAR(20) NOT NULL,
Salary DECIMAL(10,2),
PassportID INT NOT NULL)

INSERT INTO Passports (PassportID, PassportNumber)
VALUES
	(101, 'N34FG21B'),
	(102, 'K65LO4R7'),
	(103, 'ZE657QP2')

INSERT INTO Persons (PersonID, FirstName, Salary, PassportID)
VALUES
	(1, 'Roberto', 43300.00, 102),
	(2, 'Tom', 56100.00, 103),
	(3, 'Yana', 60200.00, 101)

ALTER TABLE Persons
ADD PRIMARY KEY (PersonID)

ALTER TABLE Passports
ADD PRIMARY KEY (PassportID)

ALTER TABLE Persons
ADD CONSTRAINT FK_Persons_Passports
FOREIGN KEY (PassportID)
REFERENCES Passports(PassportID)

--Problem 2.	One-To-Many Relationship
--Create two tables as follows. Use appropriate data types.
create table Models (
ModelID int not null,
Name nvarchar(30) not null,
ManufacturerID int not null
)

create table Manufacturers (
ManufacturerID int not null,
Name nvarchar(30) not null,
EstablishedOn date
)

insert into Models (ModelID, Name, ManufacturerID) values 
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3)

insert into Manufacturers (ManufacturerID, Name, EstablishedOn) values
(1, 'BMW', '1916-03-07'),
(2, 'Tesla', '2003-01-01'),
(3, 'Lada', '1966-05-01')

alter table Models
add primary key(ModelID)

alter table Manufacturers
add primary key(ManufacturerID)

alter table Models
add constraint FK_Models_Manufacturers foreign key(ManufacturerID) references Manufacturers(ManufacturerID)

--Problem 3. Many-To- Many Relationship
create table Students (
StudentID int not null primary key,
Name nvarchar(30) not null
)

create table Exams (
ExamID int not null primary key,
Name nvarchar(30) not null
)
create table StudentsExams(
StudentID int not null,
ExamID int not null,
constraint PK_StudentsExams primary key(StudentID, ExamID),
constraint FK_StudentsExams_Students foreign key(StudentID) references Students(StudentID),
constraint FK_StudentsExams_Exams foreign key(ExamID) references Exams(ExamID)
)
insert into Students (StudentID, Name) values
(1, 'Mila'),
(2, 'Toni'),
(3, 'Ron')

insert into Exams(ExamID, Name) values 
(101,'SpringMVC'),
(102,'Neo4j'),
(103,'Oracle 11g')

insert into StudentsExams (StudentID, ExamID) values
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

--Problem 4.	Self-Referencing 
--Create a single table as follows. Use appropriate data types.
create table Teachers (
TeacherID int not null,
Name nvarchar(30) not null,
ManagerID int
)

insert into Teachers (TeacherID, Name, ManagerID) values (101, 'John', NULL),
(102, 'Maya',106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101)

alter table Teachers
add primary key(TeacherID)

alter table teachers
add constraint FK_Teachers_Teachers foreign key(ManagerID) references Teachers(TeacherID)

--Problem 5.	Online Store Database
--Create a new database and design the following structure:
create table Cities (
CityID int Primary key,
Name varchar(50) not null
)

create table Customers (
CustomerID int primary key,
Name varchar(50) not null,
Birthday date,
CityID int not null,
constraint FK_Customers_Cities foreign key(CityID) references Cities(CityID)
)

create table Orders (
OrderID int primary key,
CustomerID int,
constraint FK_Orders_Customers foreign key(CustomerID) references Customers(CustomerID)
)

create table ItemTypes (
ItemTypeID int primary key,
Name varchar(50) not null
)

create table Items (
ItemID int primary key,
Name varchar(50) not null,
ItemTypeID int,
constraint FK_Items_ItemTypes foreign key(ItemTypeID) references ItemTypes(ItemTypeID)
)

create table OrderItems (
OrderID int not null,
ItemID int not null,
constraint PK_OrderItems primary key(OrderID, ItemID),
constraint FK_OrderItems_Orders foreign key(OrderID) references Orders(OrderID),
constraint FK_OrderItems_Items foreign key(ItemID) references Items(ItemID)
)

--Problem 6. University Database
--Create a new database and design the following structure:
create table Majors (
MajorID int primary key,
Namve nvarchar(50)
)

create table Students (
StudentID int primary key,
StudentNumber int not null,
StudentName nvarchar(50),
MajorID int not null,
constraint FK_Students_Majors foreign key(MajorID) references Majors(MajorID)
)

create table Subjects(
SubjectID int primary key,
SubjectName nvarchar(50) not null
)

create table Agenda (
StudentID int not null,
SubjectID int not null,
constraint PK_Agenda_Students_Subjects primary key(StudentID, SubjectID),
constraint FK_Agenda_Students foreign key(StudentID) references Students(StudentID),
constraint FK_Agenda_Subjects foreign key(SubjectID) references Subjects(SubjectID)
)

create table Payments(
PaymentID int not null primary key,
PaymentDate date,
PaymentAmount money,
StudentID int not null,
constraint FK_Payments_Students foreign key(StudentID) references Students(StudentID)
)

--Problem 9. *Peaks in Rila

--Display all peaks for &quot;Rila&quot; mountain. Include:

-- MountainRange

-- PeakName

-- PeakElevation

--Peaks should be sorted by elevation descending.
select m.MountainRange,p.PeakName, p.Elevation from Mountains m right join Peaks p on m.Id = p.MountainId where m.Id = 17 order by p.Elevation desc
