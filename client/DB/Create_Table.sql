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
-- ניקוי טבלאות קיימות (כדי לאפשר הרצה חוזרת של הסקריפט)
------------------------------------------------------------
IF OBJECT_ID('dbo.PaidTimes', 'U') IS NOT NULL
    DROP TABLE dbo.PaidTimes;

IF OBJECT_ID('dbo.ShavingsOrders', 'U') IS NOT NULL
    DROP TABLE dbo.ShavingsOrders;

IF OBJECT_ID('dbo.Stalls', 'U') IS NOT NULL
    DROP TABLE dbo.Stalls;

IF OBJECT_ID('dbo.Entries', 'U') IS NOT NULL
    DROP TABLE dbo.Entries;
GO

------------------------------------------------------------
-- טבלת Entries – הרשמות למקצים
-- מנקודת מבט אדמין: לכל שורה יש כל מה שצריך על המקצה
------------------------------------------------------------
CREATE TABLE dbo.Entries (
    EntryId         INT IDENTITY(1,1) PRIMARY KEY,

    CompetitionName NVARCHAR(100) NOT NULL,   
    DayName         NVARCHAR(20)  NULL,       

    ClassName       NVARCHAR(100) NOT NULL,  
    RiderName       NVARCHAR(100) NOT NULL,   
    HorseName       NVARCHAR(100) NOT NULL,   
    TrainerName     NVARCHAR(100) NULL,       
    PayerName       NVARCHAR(100) NOT NULL,  
    PrizeReceiver   NVARCHAR(100) NULL,       

    Fee             DECIMAL(10,2) NOT NULL,  
    IsPaid          BIT NOT NULL DEFAULT(0)  -- 0 = לא שולם, 1 = שולם
);
GO

------------------------------------------------------------
-- טבלת Stalls – תאים לסוסים / ציוד
-- כל שורה מייצגת תא אחד בהזמנה
------------------------------------------------------------
CREATE TABLE dbo.Stalls (
    StallId       INT IDENTITY(1,1) PRIMARY KEY,

    CompetitionName NVARCHAR(100) NOT NULL,   
    HorseName       NVARCHAR(100) NOT NULL,  
    PayerName       NVARCHAR(100) NOT NULL,   
    TrainerName     NVARCHAR(100) NULL,       
    StableName      NVARCHAR(100) NULL,      

    StartDay        NVARCHAR(20)  NOT NULL,   
    EndDay          NVARCHAR(20)  NOT NULL,   
    Days            INT           NOT NULL,   

    PricePerDay     DECIMAL(10,2) NOT NULL,   
    Total           DECIMAL(10,2) NOT NULL  
);
GO

------------------------------------------------------------
-- טבלת ShavingsOrders – הזמנות נסורת
-- כל שורה היא הזמנת נסורת לסוס ספציפי
------------------------------------------------------------
CREATE TABLE dbo.ShavingsOrders (
    ShavingsId      INT IDENTITY(1,1) PRIMARY KEY,

    CompetitionName NVARCHAR(100) NOT NULL, 
    HorseName       NVARCHAR(100) NOT NULL,  
    PayerName       NVARCHAR(100) NOT NULL,  
    TrainerName     NVARCHAR(100) NULL,      
    StableName      NVARCHAR(100) NULL,       

    Bags            INT           NOT NULL,   
    PricePerBag     DECIMAL(10,2) NOT NULL,   
    Total           DECIMAL(10,2) NOT NULL   
);
GO

------------------------------------------------------------
-- טבלת PaidTimes – פייד טיים / זמן אימון בתשלום
-- בקשה לזמן בתשלום: יום, טווח שעות, סוג (קצר/ארוך) ופרטי רוכב/סוס/מאמן
------------------------------------------------------------
CREATE TABLE dbo.PaidTimes (
    PaidTimeId      INT IDENTITY(1,1) PRIMARY KEY,

    CompetitionName NVARCHAR(100) NOT NULL, 
    PayerName       NVARCHAR(100) NOT NULL,  

    RiderName       NVARCHAR(100) NOT NULL,  
    HorseName       NVARCHAR(100) NOT NULL,   
    TrainerName     NVARCHAR(100) NOT NULL,   
    StableName      NVARCHAR(100) NOT NULL, 

    DayName         NVARCHAR(20)  NOT NULL,   
    RequestedTime   NVARCHAR(20)  NOT NULL,   

    Type            NVARCHAR(10)  NOT NULL,   
    Price           DECIMAL(10,2) NOT NULL,   -- 170 (קצר) או 240 (ארוך)

    Comments        NVARCHAR(255) NULL   
);
GO
