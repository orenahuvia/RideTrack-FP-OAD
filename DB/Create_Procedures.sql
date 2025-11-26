use [RideTrack-FP-OAD];
go

/* ======================================
   ENTRIES - הרשמות למקצים
   ====================================== */

-- פרוצדורה לקבלת כל ההרשמות למקצים
CREATE PROCEDURE GetAllEntries
AS
BEGIN
    SELECT 
        E.EntryId,
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
go

-- פרוצדורה לקבלת כל ההרשמות של משלם מסוים
CREATE PROCEDURE GetEntriesByPayerName
    @PayerName NVARCHAR(100)
AS
BEGIN
    SELECT 
        E.EntryId,
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
go

-- פרוצדורה להוספת הרשמה למקצה
CREATE PROCEDURE AddEntry
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
go

-- פרוצדורה לעדכון הרשמה למקצה
CREATE PROCEDURE UpdateEntry
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
go

-- פרוצדורה למחיקת הרשמה למקצה
CREATE PROCEDURE DeleteEntry
    @EntryId INT
AS
BEGIN
    DELETE FROM Entries
    WHERE EntryId = @EntryId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
go

/* ======================================
   STALLS - הזמנת תאים
   ====================================== */

-- פרוצדורה לקבלת כל התאים
CREATE PROCEDURE GetAllStalls
AS
BEGIN
    SELECT 
        S.StallId,
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
go

-- פרוצדורה לקבלת כל התאים של משלם מסוים
CREATE PROCEDURE GetStallsByPayerName
    @PayerName NVARCHAR(100)
AS
BEGIN
    SELECT 
        S.StallId,
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
go

-- פרוצדורה להוספת תא
CREATE PROCEDURE AddStall
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
go

-- פרוצדורה לעדכון תא
CREATE PROCEDURE UpdateStall
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
go

-- פרוצדורה למחיקת תא
CREATE PROCEDURE DeleteStall
    @StallId INT
AS
BEGIN
    DELETE FROM Stalls
    WHERE StallId = @StallId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
go

/* ======================================
   SHAVINGSORDERS - הזמנות נסורת
   ====================================== */

-- פרוצדורה לקבלת כל הזמנות הנסורת
CREATE PROCEDURE GetAllShavingsOrders
AS
BEGIN
    SELECT 
        SO.ShavingsOrderId,
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
go

-- פרוצדורה לקבלת כל הזמנות הנסורת של משלם מסוים
CREATE PROCEDURE GetShavingsOrdersByPayerName
    @PayerName NVARCHAR(100)
AS
BEGIN
    SELECT 
        SO.ShavingsOrderId,
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
go

-- פרוצדורה להוספת הזמנת נסורת
CREATE PROCEDURE AddShavingsOrder
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
go

-- פרוצדורה לעדכון הזמנת נסורת
CREATE PROCEDURE UpdateShavingsOrder
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
go

-- פרוצדורה למחיקת הזמנת נסורת
CREATE PROCEDURE DeleteShavingsOrder
    @ShavingsOrderId INT
AS
BEGIN
    DELETE FROM ShavingsOrders
    WHERE ShavingsOrderId = @ShavingsOrderId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
go

/* ======================================
   PAIDTIMES - פייד טיים
   ====================================== */

-- פרוצדורה לקבלת כל הפייד טיים
CREATE PROCEDURE GetAllPaidTimes
AS
BEGIN
    SELECT 
        PT.PaidTimeId,
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
go

-- פרוצדורה לקבלת כל הפייד טיים של משלם מסוים
CREATE PROCEDURE GetPaidTimesByPayerName
    @PayerName NVARCHAR(100)
AS
BEGIN
    SELECT 
        PT.PaidTimeId,
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
go

-- פרוצדורה להוספת פייד טיים
CREATE PROCEDURE AddPaidTime
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
go

-- פרוצדורה לעדכון פייד טיים
CREATE PROCEDURE UpdatePaidTime
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
go

-- פרוצדורה למחיקת פייד טיים
CREATE PROCEDURE DeletePaidTime
    @PaidTimeId INT
AS
BEGIN
    DELETE FROM PaidTimes
    WHERE PaidTimeId = @PaidTimeId;

    SELECT @@ROWCOUNT AS RowsAffected;
END
go
