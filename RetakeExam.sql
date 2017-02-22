--Section 1. DDL								25 pts
--For this section put your queries in judge and use SQL Server run queries and check DB.
CREATE DATABASE TheNerdHerd
GO

USE TheNerdHerd
GO

-- 01. DDL
CREATE TABLE Locations
(
Id INT IDENTITY,
Latitude FLOAT,
Longitude FLOAT,
CONSTRAINT PK_Locations PRIMARY KEY(Id)
)

CREATE TABLE Credentials
(
Id INT IDENTITY,
Email VARCHAR(30),
Password VARCHAR(20),
CONSTRAINT PK_Credentials PRIMARY KEY (Id)
)

CREATE TABLE Users
(
Id INT IDENTITY,
Nickname VARCHAR(25),
Gender CHAR(1),
Age INT,
LocationId INT,
CredentialId INT,
CONSTRAINT PK_Users PRIMARY KEY (Id),
CONSTRAINT FK_Users_Credentials FOREIGN KEY(CredentialId) REFERENCES Credentials(Id),
CONSTRAINT FK_Users_Locations FOREIGN KEY(LocationId) REFERENCES Locations(Id),
CONSTRAINT U_Users_CredentialId UNIQUE(CredentialId)
)

CREATE TABLE Chats
(
Id INT IDENTITY,
Title VARCHAR(32),
StartDate DATE,
IsActive BIT,
CONSTRAINT PK_Chats PRIMARY KEY(Id)
)


CREATE TABLE Messages
(
Id INT IDENTITY,
Content VARCHAR(200),
ChatId INT,
UserId INT,
SentOn DATE,
CONSTRAINT PK_Messages PRIMARY KEY(Id),
CONSTRAINT FK_Messages_Chats FOREIGN KEY (ChatId) REFERENCES Chats(Id),
CONSTRAINT FK_Messages_Users FOREIGN KEY (UserId) REFERENCES Users(Id),
)

CREATE TABLE UsersChats
(
UserId INT,
ChatId INT,
CONSTRAINT PK_UsersChats PRIMARY KEY(ChatId, UserId),
CONSTRAINT FK_UsersChats_Users FOREIGN KEY (UserId) REFERENCES Users(Id),
CONSTRAINT FK_UsersChats_Chats FOREIGN KEY (ChatId) REFERENCES Chats(Id),
)

--Section 2. DML								15 pts
--For this section put your queries in judge and use SQL Server run skeleton, run queries and check DB.
--Before you start you have to import Data.sql. If you have created the structure correctly the data should be successfully inserted.
--In this section you have to do couple of data manipulations:

--2.	Insert
--Do you remember ASL?  It stands for Age, Sex(gender), Location. You have to insert couple of message based on table Users. 
--•	Content – it should be concatenation of age, gender, latitude and longitude split by dash. Use a concatenating function.
--•	SentOn – should be the current date
--•	ChatId – 
--o	If the user is female multiply the age by 2 and then take the square root 
--o	if it is a male divide the age by 18 and take it the power of 3
--o	when you find the id round it up
--•	UserId – take the UserId from the table
--•	You should insert data for users with id between 10 and 20 inclusively
Insert into Messages (Content, SentOn, ChatId, UserId)
select 
CONCAT(Age, '-', Gender, '-', l.Latitude, '-', l.Longitude),
GETDATE(),
case
	when Gender = 'F' then CEILING(SQRT(Age * 2))
	when Gender = 'M' then CEILING(POWER(Age/18, 3))
end,
u.Id
from Users as u
join Locations as l on l.Id = u.LocationId
where u.Id between 10 and 20

--3.	Update
--The back-end developers have slightly failed and let some chats to have messages with a date earlier than the creation date of the chat. You have to fix that. For all chats which have messages before the chat StartDate update the chat StartDate to be equal to the earliest message in that chat.
update Chats
Set StartDate = (select min(m.SentOn) from Chats as c
					join Messages as m on c.Id = m.ChatId
					where c.Id = Chats.Id
				)
where Chats.Id in (select c.Id from Chats as c
					join Messages as m on m.ChatId = c.Id
					group by c.Id, c.StartDate
					having c.StartDate > min(m.SentOn)
                    )

--4.	Delete
--Delete all locations which doesn’t have user located there.
delete from Locations
where Id not in (select LocationId from Users where LocationId is not null)

--Section 3. Querying							40 pts
--For this section put your queries in judge and use SQL Server prepare DB and run queries.
--5.	Age Range
--Select all users that are aged between 22 and 37 inclusively. 
--Required columns:
--•	Nickname
--•	Gender
--•	Age
select Nickname, Gender, Age from Users
where Age between 22 and 37

--6.	Messages
--Select all messages that are sent after 12.05.2014 and contain the word “just”. Sort the results by the message id in descending order.
--Required columns:
--•	Content
--•	SentOn

select m.Content, m.SentOn from Messages as m
where m.SentOn > '2014-05-12'
and m.Content like '%just%'
order by m.Id desc

--7.	Chats
--Select all chats that that are active and their title length is less than 5 or 3rd and 4th letters are equal to “tl”. Sort the results by title in descending order.
--Required columns:
--•	Title
--•	IsActive
select Title,IsActive from Chats
where (IsActive = 0 and len(Title) < 5) or Title like '__tl%'
order by Title desc

--8.	Chat Messages
--Select all chats with messages sent before 26.03.2012 and chat title with last letter equal to “x”. Sort by chat Id and message Id in ascending order.
--Required columns:
--•	Id(Chats)
--•	Tittle
--•	Id(Messages)
select c.Id, c.Title, m.Id from Chats as c
join Messages as m on c.Id = m.ChatId
where m.SentOn < '2012-03-26' and right(Title, 1) = 'x'
order by c.Id, m.Id

--9.	Message Count
--Select all chats and the amount of messages they have. Some messages may not have a chat. Filter messages with id less than 90. Select only the first 5 results sorted by TotalMessages in descending order and chat id in ascending order.
--Required columns:
--•	Id(Chats)
--•	TotalMessages
select top 5  ch.Id, COUNT(m.Id) as TotalMessages from Chats as ch
 right join Messages as m on m.ChatId = ch.Id
where m.Id <90
group by ch.Id
order by TotalMessages desc,ch.Id

--10.	Credentials
--Select all users with emails ending with “co.uk”. Sort by email in ascending order.
--Required columns:
--•	Nickname
--•	Email
--•	Password
select u.Nickname, c.Email, c.Password  from Credentials as c
join Users as u on u.CredentialId = c.Id
where c.Email like '%co.uk'
order by c.Email

--11.	Locations
--Select all users who don’t have a location.
--Required columns:
--•	Id(Users)
--•	Nickname
--•	Age
select Id, Nickname, Age from Users
where LocationId not in (select Id from Locations) or LocationId is null

--12.	Left Users
--Select all messages sent from users who have left the chat (they are not in the chat anymore). Filter data only for chat with id 17. Sort by message Id in descending order.
--Required columns:
--•	Id(Messages)
--•	ChatId
--•	UserId
SELECT m.Id, m.ChatId, m.UserId FROM Messages AS m
WHERE m.ChatId = 17 AND (m.UserId NOT IN (SELECT UserId FROM UsersChats WHERE ChatId = 17) OR m.UserId IS NULL)
ORDER BY m.Id DESC

--13.	Users in Bulgaria
--Select all users that are located in Bulgaria. Consider the latitude is in range [41.14;44.13] and longitude in range [22.21; 28.36]. Sort the results by title in ascending order.
--Required columns:
--•	Nickname
--•	Title
--•	Latitude
--•	Longitude

select u.Nickname, c.Title, l.Latitude, l.Longitude from Users as u
join Locations as l on u.LocationId = l.Id
join UsersChats as uc on uc.UserId = u.Id
join Chats as c on c.Id = uc.ChatId
where (l.Latitude between 41.13999 and 44.12999) and (l.Longitude between 22.20999 and 28.35999)
order by c.Title

--14.	Last Chat
--Select the first message (if there is any) of the last chat.
--Required columns:
--•	Title
--•	Content

select top 1 with ties c.Title, m.Content from chats as c
 left join Messages as m on c.Id = m.ChatId
order by StartDate desc, m.SentOn

--Section 4. Programmability					20 pts
--For this section put your queries in judge and use SQL Server run skeleton, run queries and check DB.

--15.	Radians
--Create a user defined function that transforms degrees to radians. The formula should multiply the degrees by Pi and then split by 180. The return type must be float. Call the function udf_GetRadians.
--Parameters:
--•	Degrees
--Example:

--   SELECT dbo.udf_GetRadians(22.12) AS Radians
go
create function udf_GetRadians (@degrees float)
returns float
as
begin
	declare @result float = (@degrees * PI())/180
	return @result
end
go
SELECT dbo.udf_GetRadians(22.12) AS Radians

--16.	Change Password
--Create a user defined procedure that receives an email and changes the password with the newly provided one. If the email doesn’t exist throw an exception with Severity = 16, State = 1 and message “The email does't exist!”. Call the procedure udp_ChangePassword.
--Parameters:
--•	Email
--•	NewPassword
go
create procedure udp_ChangePassword(@email varchar(30), @newPassword varchar(20))
as
begin
	begin transaction
	if not exists (select Email from Credentials where Email = @email)
	begin
		raiserror('The email does''t exist!', 16, 1)
		rollback
	end
	else
	begin
		update Credentials
		set Password = @newPassword
		where Email = @email
		commit
	end

end

--17.	Send Message
--Create a user defined procedure sends a message with a current date. The procedure should receive UserId, ChatId and the Content of the message. If there is no chat with that user throw an exception with Severity = 16, State = 1 and message “There is no chat with that user!”. Call the procedure udp_SendMessage.
--Parameters:
--•	UserId
--•	ChatId
--•	Content
go
create procedure udp_SendMessage (@UserId int, @ChatId int, @Content varchar(200))
as
begin
	begin transaction
		declare @count int = (select count(*) from UsersChats where UserId = @UserId and ChatId = @ChatId)
		if (@count <> 1)
		begin
			raiserror('There is no chat with that user!', 16, 1)
			rollback
		end
		else 
		begin
			insert into Messages (Content, ChatId, UserId, SentOn)
			values (
			@Content,
			@ChatId,
			@UserId,
			getdate()
			)
			commit
		end
end

--18.	Log Messages
--Create a trigger that logs any deleted message from table messages. Submit only your create trigger statement. The log table should be called MessageLogs and should have exactly the same structure as table Messages. The name of the trigger is not important.
go
CREATE TRIGGER T_Messages_After_Delete ON Messages AFTER DELETE
AS
	INSERT INTO MessageLogs
	SELECT * FROM deleted


DELETE FROM [Messages]
       WHERE [Messages].Id = 1

SELECT * FROM [dbo].[MessagesLogs]


--19.	Delete users
--Create a trigger that will help you to delete a user. Submit the create trigger statement only.
--Example:
CREATE TRIGGER T_Users_InsteadOF_Delete ON Users INSTEAD OF DELETE
AS
	UPDATE Users
	SET CredentialId = NULL
	WHERE Id IN (SELECT Id FROM deleted)
	
	DELETE FROM Credentials
	WHERE Id IN (SELECT CredentialId FROM deleted)

	DELETE FROM UsersChats
	WHERE UserId IN (SELECT Id FROM deleted)

	UPDATE Messages
	SET UserId = NULL
	WHERE UserId IN (SELECT Id FROM deleted)
	
	DELETE FROM Users
WHERE Id IN (SELECT Id FROM deleted)

