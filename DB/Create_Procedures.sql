USE [RideTrack-FP-OAD];
GO

/* ======================================
   DROP כל הפרוצדורות אם קיימות
   ====================================== */
IF OBJECT_ID('dbo.GetAllEntries', 'P') IS NOT NULL DROP PROCEDURE dbo.GetAllEntries;
IF OBJECT_ID('dbo.GetEntriesByPayerName', 'P') IS NOT NULL DROP PROCEDURE dbo.GetEntriesByPayerName;
IF OBJECT_ID('dbo.AddEntry', 'P') IS NOT NULL DROP PROCEDURE dbo.AddEntry;
IF OBJECT_ID('dbo.UpdateEntry', 'P') IS NOT NULL DROP PROCEDURE dbo.UpdateEntry;
IF OBJECT_ID('dbo.DeleteEntry', 'P') IS NOT NULL DROP PROCEDURE dbo.DeleteEntry;

IF OBJECT_ID('dbo.GetAllStalls', 'P') IS NOT NULL DROP PROCEDURE dbo.GetAllStalls;
IF OBJECT_ID('dbo.GetStallsByPayerName', 'P') IS NOT NULL DROP PROCEDURE dbo.GetStallsByPayerName;
IF OBJECT_ID('dbo.AddStall', 'P') IS NOT NULL DROP PROCEDURE dbo.AddStall;
IF OBJECT_ID('dbo.UpdateStall', 'P') IS NOT NULL DROP PROCEDURE dbo.UpdateStall;
IF OBJECT_ID('dbo.DeleteStall', 'P') IS NOT NULL DROP PROCEDURE dbo.DeleteStall;

IF OBJECT_ID('dbo.GetAllShavingsOrders', 'P') IS NOT NULL DROP PROCEDURE dbo.GetAllShavingsOrders;
IF OBJECT_ID('dbo.GetShavingsOrdersByPayerName', 'P') IS NOT NULL DROP PROCEDURE dbo.GetShavingsOrdersByPayerName;
IF OBJECT_ID('dbo.AddShavingsOrder', 'P') IS NOT NULL DROP PROCEDURE dbo.AddShavingsOrder;
IF OBJECT_ID('dbo.UpdateShavingsOrder', 'P') IS NOT NULL DROP PROCEDURE dbo.UpdateShavingsOrder;
IF OBJECT_ID('dbo.DeleteShavingsOrder', 'P') IS NOT NULL DROP PROCEDURE dbo.DeleteShavingsOrder;

IF OBJECT_ID('dbo.GetAllPaidTimes', 'P') IS NOT NULL DROP PROCEDURE dbo.GetAllPaidTimes;
IF OBJECT_ID('dbo.GetPaidTimesByPayerName', 'P') IS NOT NULL DROP PROCEDURE dbo.GetPaidTimesByPayerName;
IF OBJECT_ID('dbo.AddPaidTime', 'P') IS NOT NULL DROP PROCEDURE dbo.AddPaidTime;
IF OBJECT_ID('dbo.UpdatePaidTime', 'P') IS NOT NULL DROP PROCEDURE dbo.UpdatePaidTime;
IF OBJECT_ID('dbo.DeletePaidTime', 'P') IS NOT NULL DROP PROCEDURE dbo.DeletePaidTime;
GO

/* ======================================
   ENTRIES - הרשמות למקצים
   ====================================== */

-- פרוצדורה לקבלת כל ההרשמות למקצים
CREATE PROCEDURE dbo.GetAllEntries
AS
BEGIN
    SELECT 
        E.EntryId,
        E.RiderId,
        E.HorseId,
        E.PayerId,
        E.ClassId,
        R.RiderName,
        H.HorseName,
        P.PayerName,
        C.CompetitionName,
        CL.ClassName,
        CL.ClassDay,
        CL.ClassPrice
    FROM Entries E
    INNER JOIN Riders       R  ON E.RiderId  = R.RiderId
    INNER JOIN Horses       H  ON E.HorseId  = H.HorseId
    INNER JOIN Payers       P  ON E.PayerId  = P.PayerId
    INNER JOIN Classes      CL ON E.ClassId  = CL.ClassId
    INNER JOIN Competitions C  ON CL.CompetitionId = C.CompetitionId
    ORDER BY E.EntryId;
END
GO

-- פרוצדורה לקבלת כל ההרשמות של משלם מסוים
CREATE PROCEDURE dbo.GetEntriesByPayerName
    @PayerName NVARCHAR(100)
AS
BEGIN
    SELECT 
        E.EntryId,
        E.RiderId,
        E.HorseId,
        E.PayerId,
        E.ClassId,
        R.RiderName,
        H.HorseName,
        P.PayerName,
        C.CompetitionName,
        CL.ClassName,
        CL.ClassDay,
        CL.ClassPrice
    FROM Entries E
    INNER JOIN Riders       R  ON E.RiderId  = R.RiderId
    INNER JOIN Horses       H  ON E.HorseId  = H.HorseId
    INNER JOIN Payers       P  ON E.PayerId  = P.PayerId
    INNER JOIN Classes      CL ON E.ClassId  = CL.ClassId
    INNER JOIN Competitions C  ON CL.CompetitionId = C.CompetitionId
    WHERE P.PayerName = @PayerName
    ORDER BY E.EntryId;
END
GO

-- פרוצדורה להוספת הרשמה למקצה
CREATE PROCEDURE dbo.AddEntry
    @RiderId INT,
    @HorseId INT,
    @PayerId INT,
    @ClassId INT
AS
BEGIN
    INSERT INTO Entries (RiderId, HorseId, PayerId, ClassId)
    VALUES (@RiderId, @HorseId, @PayerId, @ClassId);

    SELECT SCOPE_IDENTITY() AS NewEntryId;
END
GO

-- פרוצדורה לעדכון הרשמה למקצה
CREATE PROCEDURE dbo.UpdateEntry
    @EntryId INT,
    @RiderId INT,
    @HorseId INT,
    @PayerId INT,
    @ClassId INT
AS
BEGIN
    UPDATE Entries
    SET RiderId = @RiderId,
        HorseId = @HorseId,
        PayerId = @PayerId,
        ClassId = @ClassId
    WHERE EntryId = @EntryId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- פרוצדורה למחיקת הרשמה למקצה
CREATE PROCEDURE dbo.DeleteEntry
    @EntryId INT
AS
BEGIN
    DELETE FROM Entries
    WHERE EntryId = @EntryId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

/* ======================================
   STALLS - הזמנת תאים
   ====================================== */

-- פרוצדורה לקבלת כל התאים
CREATE PROCEDURE dbo.GetAllStalls
AS
BEGIN
    SELECT 
        S.StallId,
        S.CompetitionId,
        S.HorseId,
        S.PayerId,
        S.StallNumber,
        S.ArrivalDate,
        S.DepartureDate,
        S.DailyRate,
        S.TotalPrice,
        H.HorseName,
        P.PayerName,
        C.CompetitionName
    FROM Stalls S
    INNER JOIN Horses       H ON S.HorseId       = H.HorseId
    INNER JOIN Payers       P ON S.PayerId       = P.PayerId
    INNER JOIN Competitions C ON S.CompetitionId = C.CompetitionId
    ORDER BY S.StallId;
END
GO

-- פרוצדורה לקבלת כל התאים של משלם מסוים
CREATE PROCEDURE dbo.GetStallsByPayerName
    @PayerName NVARCHAR(100)
AS
BEGIN
    SELECT 
        S.StallId,
        S.CompetitionId,
        S.HorseId,
        S.PayerId,
        S.StallNumber,
        S.ArrivalDate,
        S.DepartureDate,
        S.DailyRate,
        S.TotalPrice,
        H.HorseName,
        P.PayerName,
        C.CompetitionName
    FROM Stalls S
    INNER JOIN Horses       H ON S.HorseId       = H.HorseId
    INNER JOIN Payers       P ON S.PayerId       = P.PayerId
    INNER JOIN Competitions C ON S.CompetitionId = C.CompetitionId
    WHERE P.PayerName = @PayerName
    ORDER BY S.StallId;
END
GO

-- פרוצדורה להוספת תא
CREATE PROCEDURE dbo.AddStall
    @CompetitionId INT,
    @HorseId       INT,
    @PayerId       INT,
    @StallNumber   INT,
    @ArrivalDate   DATE,
    @DepartureDate DATE,
    @DailyRate     DECIMAL(10,2),
    @TotalPrice    DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Stalls
    (CompetitionId, HorseId, PayerId, StallNumber, ArrivalDate, DepartureDate, DailyRate, TotalPrice)
    VALUES
    (@CompetitionId, @HorseId, @PayerId, @StallNumber, @ArrivalDate, @DepartureDate, @DailyRate, @TotalPrice);

    SELECT SCOPE_IDENTITY() AS NewStallId;
END
GO

-- פרוצדורה לעדכון תא
CREATE PROCEDURE dbo.UpdateStall
    @StallId       INT,
    @CompetitionId INT,
    @HorseId       INT,
    @PayerId       INT,
    @StallNumber   INT,
    @ArrivalDate   DATE,
    @DepartureDate DATE,
    @DailyRate     DECIMAL(10,2),
    @TotalPrice    DECIMAL(10,2)
AS
BEGIN
    UPDATE Stalls
    SET CompetitionId = @CompetitionId,
        HorseId       = @HorseId,
        PayerId       = @PayerId,
        StallNumber   = @StallNumber,
        ArrivalDate   = @ArrivalDate,
        DepartureDate = @DepartureDate,
        DailyRate     = @DailyRate,
        TotalPrice    = @TotalPrice
    WHERE StallId = @StallId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- פרוצדורה למחיקת תא
CREATE PROCEDURE dbo.DeleteStall
    @StallId INT
AS
BEGIN
    DELETE FROM Stalls
    WHERE StallId = @StallId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

/* ======================================
   SHAVINGSORDERS - הזמנות נסורת
   ====================================== */

-- פרוצדורה לקבלת כל הזמנות הנסורת
CREATE PROCEDURE dbo.GetAllShavingsOrders
AS
BEGIN
    SELECT 
        SO.ShavingsOrderId,
        SO.StallId,
        SO.OrderDate,
        SO.BagsQuantity,
        SO.PricePerBag,
        SO.TotalPrice,
        S.StallNumber,
        H.HorseName,
        P.PayerName,
        C.CompetitionName
    FROM ShavingsOrders SO
    INNER JOIN Stalls       S ON SO.StallId       = S.StallId
    INNER JOIN Horses       H ON S.HorseId        = H.HorseId
    INNER JOIN Payers       P ON S.PayerId        = P.PayerId
    INNER JOIN Competitions C ON S.CompetitionId  = C.CompetitionId
    ORDER BY SO.ShavingsOrderId;
END
GO

-- פרוצדורה לקבלת כל הזמנות הנסורת של משלם מסוים
CREATE PROCEDURE dbo.GetShavingsOrdersByPayerName
    @PayerName NVARCHAR(100)
AS
BEGIN
    SELECT 
        SO.ShavingsOrderId,
        SO.StallId,
        SO.OrderDate,
        SO.BagsQuantity,
        SO.PricePerBag,
        SO.TotalPrice,
        S.StallNumber,
        H.HorseName,
        P.PayerName,
        C.CompetitionName
    FROM ShavingsOrders SO
    INNER JOIN Stalls       S ON SO.StallId       = S.StallId
    INNER JOIN Horses       H ON S.HorseId        = H.HorseId
    INNER JOIN Payers       P ON S.PayerId        = P.PayerId
    INNER JOIN Competitions C ON S.CompetitionId  = C.CompetitionId
    WHERE P.PayerName = @PayerName
    ORDER BY SO.ShavingsOrderId;
END
GO

-- פרוצדורה להוספת הזמנת נסורת
CREATE PROCEDURE dbo.AddShavingsOrder
    @StallId      INT,
    @OrderDate    DATETIME,
    @BagsQuantity INT,
    @PricePerBag  DECIMAL(10,2),
    @TotalPrice   DECIMAL(10,2)
AS
BEGIN
    INSERT INTO ShavingsOrders
    (StallId, OrderDate, BagsQuantity, PricePerBag, TotalPrice)
    VALUES
    (@StallId, @OrderDate, @BagsQuantity, @PricePerBag, @TotalPrice);

    SELECT SCOPE_IDENTITY() AS NewShavingsOrderId;
END
GO

-- פרוצדורה לעדכון הזמנת נסורת
CREATE PROCEDURE dbo.UpdateShavingsOrder
    @ShavingsOrderId INT,
    @StallId         INT,
    @OrderDate       DATETIME,
    @BagsQuantity    INT,
    @PricePerBag     DECIMAL(10,2),
    @TotalPrice      DECIMAL(10,2)
AS
BEGIN
    UPDATE ShavingsOrders
    SET StallId      = @StallId,
        OrderDate    = @OrderDate,
        BagsQuantity = @BagsQuantity,
        PricePerBag  = @PricePerBag,
        TotalPrice   = @TotalPrice
    WHERE ShavingsOrderId = @ShavingsOrderId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- פרוצדורה למחיקת הזמנת נסורת
CREATE PROCEDURE dbo.DeleteShavingsOrder
    @ShavingsOrderId INT
AS
BEGIN
    DELETE FROM ShavingsOrders
    WHERE ShavingsOrderId = @ShavingsOrderId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

/* ======================================
   PAIDTIMES - פייד טיים
   ====================================== */

-- פרוצדורה לקבלת כל הפייד טיים
CREATE PROCEDURE dbo.GetAllPaidTimes
AS
BEGIN
    SELECT 
        PT.PaidTimeId,
        PT.CompetitionId,
        PT.RiderId,
        PT.HorseId,
        PT.PayerId,
        PT.ArenaName,
        PT.Day,
        PT.SlotType,
        PT.Price,
        R.RiderName,
        H.HorseName,
        P.PayerName,
        C.CompetitionName
    FROM PaidTimes PT
    INNER JOIN Riders       R ON PT.RiderId       = R.RiderId
    INNER JOIN Horses       H ON PT.HorseId       = H.HorseId
    INNER JOIN Payers       P ON PT.PayerId       = P.PayerId
    INNER JOIN Competitions C ON PT.CompetitionId = C.CompetitionId
    ORDER BY PT.PaidTimeId;
END
GO

-- פרוצדורה לקבלת כל הפייד טיים של משלם מסוים
CREATE PROCEDURE dbo.GetPaidTimesByPayerName
    @PayerName NVARCHAR(100)
AS
BEGIN
    SELECT 
        PT.PaidTimeId,
        PT.CompetitionId,
        PT.RiderId,
        PT.HorseId,
        PT.PayerId,
        PT.ArenaName,
        PT.Day,
        PT.SlotType,
        PT.Price,
        R.RiderName,
        H.HorseName,
        P.PayerName,
        C.CompetitionName
    FROM PaidTimes PT
    INNER JOIN Riders       R ON PT.RiderId       = R.RiderId
    INNER JOIN Horses       H ON PT.HorseId       = H.HorseId
    INNER JOIN Payers       P ON PT.PayerId       = P.PayerId
    INNER JOIN Competitions C ON PT.CompetitionId = C.CompetitionId
    WHERE P.PayerName = @PayerName
    ORDER BY PT.PaidTimeId;
END
GO

-- פרוצדורה להוספת פייד טיים
CREATE PROCEDURE dbo.AddPaidTime
    @CompetitionId INT,
    @RiderId       INT,
    @HorseId       INT,
    @PayerId       INT,
    @ArenaName     NVARCHAR(50),
    @Day           DATE,
    @SlotType      NVARCHAR(20),
    @Price         DECIMAL(10,2)
AS
BEGIN
    INSERT INTO PaidTimes
    (CompetitionId, RiderId, HorseId, PayerId, ArenaName, Day, SlotType, Price)
    VALUES
    (@CompetitionId, @RiderId, @HorseId, @PayerId, @ArenaName, @Day, @SlotType, @Price);

    SELECT SCOPE_IDENTITY() AS NewPaidTimeId;
END
GO

-- פרוצדורה לעדכון פייד טיים
CREATE PROCEDURE dbo.UpdatePaidTime
    @PaidTimeId    INT,
    @CompetitionId INT,
    @RiderId       INT,
    @HorseId       INT,
    @PayerId       INT,
    @ArenaName     NVARCHAR(50),
    @Day           DATE,
    @SlotType      NVARCHAR(20),
    @Price         DECIMAL(10,2)
AS
BEGIN
    UPDATE PaidTimes
    SET CompetitionId = @CompetitionId,
        RiderId       = @RiderId,
        HorseId       = @HorseId,
        PayerId       = @PayerId,
        ArenaName     = @ArenaName,
        Day           = @Day,
        SlotType      = @SlotType,
        Price         = @Price
    WHERE PaidTimeId = @PaidTimeId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- פרוצדורה למחיקת פייד טיים
CREATE PROCEDURE dbo.DeletePaidTime
    @PaidTimeId INT
AS
BEGIN
    DELETE FROM PaidTimes
    WHERE PaidTimeId = @PaidTimeId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO
