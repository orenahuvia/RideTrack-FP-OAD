USE [RideTrack-FP-OAD];
GO
------------------------------------------------------------
-- הכנסת נתונים
------------------------------------------------------------
--	Riders
INSERT INTO dbo.Riders (RiderName, RanchName, Phone, Email)
VALUES
(N'Danielle Kaneti',       N'Double K Ranch',              N'050-1111111', N'danielle@example.com'),
(N'Amit Gani-Levin',       N'70 stables',				   N'050-2222222', N'amit@example.com'),
(N'Noa Cohen',             N'RY Ranch',					   N'050-3333333', N'noa@example.com'),
(N'Yehonatan Hof',         N'Galilee Performance Horses',  N'050-4444444', N'yehonatan@example.com');
GO

--	Horses
INSERT INTO dbo.Horses (HorseName, YearOfBirth, RanchName)
VALUES
(N'A Final Smoke',    2019, N'70 stables'),
(N'PF Golden Voodoo', 2020, N'Galilee Performance Horses'),
(N'DK Shiny Spark',   2015, N'Double K Ranch'),
(N'Sharona Surprise', 2016, N'RY Ranch');
GO

--	Payers
INSERT INTO dbo.Payers (PayerName, Phone, Email)
VALUES
(N'Danielle Kaneti',             N'050-1111111', N'danielle@example.com'),
(N'70 stables',              N'050-5555555', N'office@70stables.example.com'),
(N'Noa Cohen',               N'050-6666666', N'office@Noa.example.com'),
(N'Galilee Performance Horses',  N'050-7777777', N'office@gph.example.com');
GO

--	Competitions
INSERT INTO dbo.Competitions (CompetitionName, Location, StartDate, EndDate, Season)
VALUES
(N'DKR Spring Slide 2025',  N'Double K Ranch', '2025-03-20', '2025-03-22', N'2025 Season'),
(N'Galilee Summer Reining', N'Double K Ranch', '2025-07-10', '2025-07-12', N'2025 Season'),
(N'Autumn Classic 2025',    N'Double K Ranch', '2025-10-01', '2025-10-03', N'2025 Season');
GO

--	Classes (מקצים)
INSERT INTO dbo.Classes (CompetitionId, ClassDay, ClassName, ClassPrice)
VALUES
(1, '2025-03-21', N'Non Pro Level 4', 250.00), 
(1, '2025-03-21', N'Non Pro Level 3', 230.00),  
(1, '2025-03-21', N'Open Level 1',    220.00), 
(2, '2025-07-11', N'Green Reiner 1',  180.00),  
(3, '2025-10-02', N'Non Pro Level 1', 200.00);  
GO

--	Stalls
INSERT INTO dbo.Stalls
(CompetitionId, HorseId, PayerId, StallNumber, ArrivalDate,  DepartureDate, DailyRate, TotalPrice)
VALUES
(1, 1, 4,  1, '2025-03-19', '2025-03-23', 150.00, 600.00), 
(1, 2, 4,  2, '2025-03-19', '2025-03-23', 150.00, 600.00), 
(1, 3, 1,  3, '2025-03-19', '2025-03-22', 150.00, 450.00), 
(2, 4, 2, 10, '2025-07-09', '2025-07-13', 130.00, 520.00), 
(3, 3, 3, 20, '2025-09-30', '2025-10-03', 140.00, 420.00); 

GO

--	Entries (הרשמות למקצים)
INSERT INTO dbo.Entries
(RiderId, HorseId, PayerId, ClassId)
VALUES
(4, 1, 4, 1), 
(4, 2, 4, 2), 
(1, 3, 1, 3), 
(3, 4, 2, 4),
(1, 3, 3, 5); 
GO

--	ShavingsOrders (לפי StallId)
INSERT INTO dbo.ShavingsOrders
(StallId, OrderDate,       BagsQuantity, PricePerBag, TotalPrice)
VALUES
(1, '2025-03-19T10:00:00', 6, 40.00, 240.00), 
(2, '2025-03-19T11:30:00', 5, 40.00, 200.00), 
(3, '2025-03-20T08:30:00', 4, 40.00, 160.00), 
(4, '2025-07-09T17:00:00', 3, 40.00, 120.00),
(5, '2025-09-30T19:15:00', 5, 40.00, 200.00);
GO

-- PaidTimes
INSERT INTO dbo.PaidTimes
(CompetitionId, RiderId, HorseId, PayerId, ArenaName, Day,        SlotType, Price)
VALUES
(1, 4, 1, 4, N'DK Arena', '2025-03-19', N'Long',  240.00), 
(1, 1, 3, 1, N'DK Arena', '2025-03-19', N'Short', 170.00),
(2, 3, 4, 2, N'B2W Arena', '2025-07-09', N'Short', 170.00), 
(3, 1, 3, 3, N'B2W Arena', '2025-09-30', N'Long',  240.00); 
GO
