------------------------------------------------------------
-- יצירת הדאטאבייס (אם לא קיים) ומעבר אליו
------------------------------------------------------------
IF DB_ID('RideTrack-FP-OAD') IS NULL
BEGIN
    CREATE DATABASE [RideTrack-FP-OAD];
END;
GO

USE [RideTrack-FP-OAD];
GO

------------------------------------------------------------
-- יצירת טבלאות
------------------------------------------------------------
-- Riders: רוכבים
CREATE TABLE dbo.Riders
(
    RiderId    INT IDENTITY(1,1) PRIMARY KEY,
    RiderName  NVARCHAR(100) NOT NULL,
    RanchName  NVARCHAR(100) NOT NULL,
    Phone      NVARCHAR(20)  NOT NULL,
    Email      NVARCHAR(100) NOT NULL
);
GO

-- Horses: סוסים
CREATE TABLE dbo.Horses
(
    HorseId     INT IDENTITY(1,1) PRIMARY KEY,
    HorseName   NVARCHAR(100) NOT NULL,
    YearOfBirth INT           NOT NULL,
    RanchName   NVARCHAR(100) NOT NULL
);
GO

-- Payers: משלמים
CREATE TABLE dbo.Payers
(
    PayerId   INT IDENTITY(1,1) PRIMARY KEY,
    PayerName NVARCHAR(100) NOT NULL,
    Phone     NVARCHAR(20)  NOT NULL,
    Email     NVARCHAR(100) NOT NULL
);
GO

-- Competitions: תחרויות
CREATE TABLE dbo.Competitions
(
    CompetitionId   INT IDENTITY(1,1) PRIMARY KEY,
    CompetitionName NVARCHAR(100) NOT NULL,
    Location        NVARCHAR(100) NOT NULL,
    StartDate       DATE          NOT NULL,
    EndDate         DATE          NOT NULL,
    Season          NVARCHAR(20)  NOT NULL
);
GO

-- Classes: טבלת מקצים (עזר)
CREATE TABLE dbo.Classes
(
    ClassId       INT IDENTITY(1,1) PRIMARY KEY,
    CompetitionId INT           NOT NULL,
    ClassDay      DATE          NOT NULL,
    ClassName     NVARCHAR(100) NOT NULL,
    ClassPrice    DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Classes_Competitions
        FOREIGN KEY (CompetitionId) REFERENCES dbo.Competitions(CompetitionId)
);
GO

/* -------------------------
   Service Tables
   ------------------------- */

-- Stalls: הזמנת תאים
CREATE TABLE dbo.Stalls
(
    StallId       INT IDENTITY(1,1) PRIMARY KEY,
    CompetitionId INT           NOT NULL,
    HorseId       INT           NOT NULL,
    PayerId       INT           NOT NULL,
    StallNumber   INT           NOT NULL,
    ArrivalDate   DATE          NOT NULL,
    DepartureDate DATE          NOT NULL,
    DailyRate     DECIMAL(10,2) NOT NULL,
    TotalPrice    DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_Stalls_Competitions
        FOREIGN KEY (CompetitionId) REFERENCES dbo.Competitions(CompetitionId),
    CONSTRAINT FK_Stalls_Horses
        FOREIGN KEY (HorseId) REFERENCES dbo.Horses(HorseId),
    CONSTRAINT FK_Stalls_Payers
        FOREIGN KEY (PayerId) REFERENCES dbo.Payers(PayerId),
    CONSTRAINT CK_Stalls_Dates CHECK (DepartureDate >= ArrivalDate)
);
GO

-- Entries: הרשמות למקצים (משתמשת בטבלת Classes)
CREATE TABLE dbo.Entries
(
    EntryId  INT IDENTITY(1,1) PRIMARY KEY,
    RiderId  INT NOT NULL,
    HorseId  INT NOT NULL,
    PayerId  INT NOT NULL,
    ClassId  INT NOT NULL,

    CONSTRAINT FK_Entries_Riders
        FOREIGN KEY (RiderId) REFERENCES dbo.Riders(RiderId),
    CONSTRAINT FK_Entries_Horses
        FOREIGN KEY (HorseId) REFERENCES dbo.Horses(HorseId),
    CONSTRAINT FK_Entries_Payers
        FOREIGN KEY (PayerId) REFERENCES dbo.Payers(PayerId),
    CONSTRAINT FK_Entries_Classes
        FOREIGN KEY (ClassId) REFERENCES dbo.Classes(ClassId)
);
GO

-- ShavingsOrders: הזמנות נסורת (מקושרת רק ל-Stall)
CREATE TABLE dbo.ShavingsOrders
(
    ShavingsOrderId INT IDENTITY(1,1) PRIMARY KEY,
    StallId         INT           NOT NULL,
    OrderDate       DATETIME      NOT NULL,
    BagsQuantity    INT           NOT NULL,
    PricePerBag     DECIMAL(10,2) NOT NULL,
    TotalPrice      DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_ShavingsOrders_Stalls
        FOREIGN KEY (StallId) REFERENCES dbo.Stalls(StallId)
);
GO

-- PaidTimes: פייד־טיים
CREATE TABLE dbo.PaidTimes
(
    PaidTimeId   INT IDENTITY(1,1) PRIMARY KEY,
    CompetitionId INT           NOT NULL,
    RiderId       INT           NOT NULL,
    HorseId       INT           NOT NULL,
    PayerId       INT           NOT NULL,
    ArenaName     NVARCHAR(50)  NOT NULL,
    Day           DATE          NOT NULL,
    SlotType      NVARCHAR(20)  NOT NULL,  -- Short / Long
    Price         DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_PaidTimes_Competitions
        FOREIGN KEY (CompetitionId) REFERENCES dbo.Competitions(CompetitionId),
    CONSTRAINT FK_PaidTimes_Riders
        FOREIGN KEY (RiderId) REFERENCES dbo.Riders(RiderId),
    CONSTRAINT FK_PaidTimes_Horses
        FOREIGN KEY (HorseId) REFERENCES dbo.Horses(HorseId),
    CONSTRAINT FK_PaidTimes_Payers
        FOREIGN KEY (PayerId) REFERENCES dbo.Payers(PayerId)
);
GO