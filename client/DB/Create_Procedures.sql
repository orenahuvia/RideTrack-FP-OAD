USE [RideTrack-FP-OAD];
GO

/* ================================
   ENTRIES – CRUD PROCEDURES
   ================================ */

IF OBJECT_ID('dbo.usp_Entries_GetAll', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Entries_GetAll;
GO

CREATE PROCEDURE dbo.usp_Entries_GetAll
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        EntryId,
        CompetitionName,
        DayName,
        ClassName,
        RiderName,
        HorseName,
        TrainerName,
        PayerName,
        PrizeReceiver,
        Fee,
        IsPaid
    FROM dbo.Entries;
END;
GO


IF OBJECT_ID('dbo.usp_Entries_GetById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Entries_GetById;
GO

CREATE PROCEDURE dbo.usp_Entries_GetById
    @EntryId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        EntryId,
        CompetitionName,
        DayName,
        ClassName,
        RiderName,
        HorseName,
        TrainerName,
        PayerName,
        PrizeReceiver,
        Fee,
        IsPaid
    FROM dbo.Entries
    WHERE EntryId = @EntryId;
END;
GO


IF OBJECT_ID('dbo.usp_Entries_Insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Entries_Insert;
GO

CREATE PROCEDURE dbo.usp_Entries_Insert
    @CompetitionName NVARCHAR(100),
    @DayName         NVARCHAR(20),
    @ClassName       NVARCHAR(100),
    @RiderName       NVARCHAR(100),
    @HorseName       NVARCHAR(100),
    @TrainerName     NVARCHAR(100),
    @PayerName       NVARCHAR(100),
    @PrizeReceiver   NVARCHAR(100),
    @Fee             DECIMAL(10,2),
    @IsPaid          BIT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Entries
    (
        CompetitionName,
        DayName,
        ClassName,
        RiderName,
        HorseName,
        TrainerName,
        PayerName,
        PrizeReceiver,
        Fee,
        IsPaid
    )
    VALUES
    (
        @CompetitionName,
        @DayName,
        @ClassName,
        @RiderName,
        @HorseName,
        @TrainerName,
        @PayerName,
        @PrizeReceiver,
        @Fee,
        @IsPaid
    );

    SELECT SCOPE_IDENTITY() AS NewEntryId;
END;
GO


IF OBJECT_ID('dbo.usp_Entries_Update', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Entries_Update;
GO

CREATE PROCEDURE dbo.usp_Entries_Update
    @EntryId         INT,
    @CompetitionName NVARCHAR(100),
    @DayName         NVARCHAR(20),
    @ClassName       NVARCHAR(100),
    @RiderName       NVARCHAR(100),
    @HorseName       NVARCHAR(100),
    @TrainerName     NVARCHAR(100),
    @PayerName       NVARCHAR(100),
    @PrizeReceiver   NVARCHAR(100),
    @Fee             DECIMAL(10,2),
    @IsPaid          BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Entries
    SET
        CompetitionName = @CompetitionName,
        DayName         = @DayName,
        ClassName       = @ClassName,
        RiderName       = @RiderName,
        HorseName       = @HorseName,
        TrainerName     = @TrainerName,
        PayerName       = @PayerName,
        PrizeReceiver   = @PrizeReceiver,
        Fee             = @Fee,
        IsPaid          = @IsPaid
    WHERE EntryId = @EntryId;
END;
GO


IF OBJECT_ID('dbo.usp_Entries_Delete', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Entries_Delete;
GO

CREATE PROCEDURE dbo.usp_Entries_Delete
    @EntryId INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.Entries
    WHERE EntryId = @EntryId;
END;
GO


/* ================================
   STALLS – CRUD PROCEDURES
   ================================ */

IF OBJECT_ID('dbo.usp_Stalls_GetAll', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Stalls_GetAll;
GO

CREATE PROCEDURE dbo.usp_Stalls_GetAll
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        StallId,
        CompetitionName,
        HorseName,
        PayerName,
        TrainerName,
        StableName,
        StartDay,
        EndDay,
        Days,
        PricePerDay,
        Total
    FROM dbo.Stalls;
END;
GO


IF OBJECT_ID('dbo.usp_Stalls_GetById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Stalls_GetById;
GO

CREATE PROCEDURE dbo.usp_Stalls_GetById
    @StallId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        StallId,
        CompetitionName,
        HorseName,
        PayerName,
        TrainerName,
        StableName,
        StartDay,
        EndDay,
        Days,
        PricePerDay,
        Total
    FROM dbo.Stalls
    WHERE StallId = @StallId;
END;
GO


IF OBJECT_ID('dbo.usp_Stalls_Insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Stalls_Insert;
GO

CREATE PROCEDURE dbo.usp_Stalls_Insert
    @CompetitionName NVARCHAR(100),
    @HorseName       NVARCHAR(100),
    @PayerName       NVARCHAR(100),
    @TrainerName     NVARCHAR(100),
    @StableName      NVARCHAR(100),
    @StartDay        NVARCHAR(20),
    @EndDay          NVARCHAR(20),
    @Days            INT,
    @PricePerDay     DECIMAL(10,2),
    @Total           DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Stalls
    (
        CompetitionName,
        HorseName,
        PayerName,
        TrainerName,
        StableName,
        StartDay,
        EndDay,
        Days,
        PricePerDay,
        Total
    )
    VALUES
    (
        @CompetitionName,
        @HorseName,
        @PayerName,
        @TrainerName,
        @StableName,
        @StartDay,
        @EndDay,
        @Days,
        @PricePerDay,
        @Total
    );

    SELECT SCOPE_IDENTITY() AS NewStallId;
END;
GO


IF OBJECT_ID('dbo.usp_Stalls_Update', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Stalls_Update;
GO

CREATE PROCEDURE dbo.usp_Stalls_Update
    @StallId         INT,
    @CompetitionName NVARCHAR(100),
    @HorseName       NVARCHAR(100),
    @PayerName       NVARCHAR(100),
    @TrainerName     NVARCHAR(100),
    @StableName      NVARCHAR(100),
    @StartDay        NVARCHAR(20),
    @EndDay          NVARCHAR(20),
    @Days            INT,
    @PricePerDay     DECIMAL(10,2),
    @Total           DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Stalls
    SET
        CompetitionName = @CompetitionName,
        HorseName       = @HorseName,
        PayerName       = @PayerName,
        TrainerName     = @TrainerName,
        StableName      = @StableName,
        StartDay        = @StartDay,
        EndDay          = @EndDay,
        Days            = @Days,
        PricePerDay     = @PricePerDay,
        Total           = @Total
    WHERE StallId = @StallId;
END;
GO


IF OBJECT_ID('dbo.usp_Stalls_Delete', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Stalls_Delete;
GO

CREATE PROCEDURE dbo.usp_Stalls_Delete
    @StallId INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.Stalls
    WHERE StallId = @StallId;
END;
GO


/* ================================
   SHAVINGSORDERS – CRUD PROCEDURES
   ================================ */

IF OBJECT_ID('dbo.usp_Shavings_GetAll', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Shavings_GetAll;
GO

CREATE PROCEDURE dbo.usp_Shavings_GetAll
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ShavingsId,
        CompetitionName,
        HorseName,
        PayerName,
        TrainerName,
        StableName,
        Bags,
        PricePerBag,
        Total
    FROM dbo.ShavingsOrders;
END;
GO


IF OBJECT_ID('dbo.usp_Shavings_GetById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Shavings_GetById;
GO

CREATE PROCEDURE dbo.usp_Shavings_GetById
    @ShavingsId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ShavingsId,
        CompetitionName,
        HorseName,
        PayerName,
        TrainerName,
        StableName,
        Bags,
        PricePerBag,
        Total
    FROM dbo.ShavingsOrders
    WHERE ShavingsId = @ShavingsId;
END;
GO


IF OBJECT_ID('dbo.usp_Shavings_Insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Shavings_Insert;
GO

CREATE PROCEDURE dbo.usp_Shavings_Insert
    @CompetitionName NVARCHAR(100),
    @HorseName       NVARCHAR(100),
    @PayerName       NVARCHAR(100),
    @TrainerName     NVARCHAR(100),
    @StableName      NVARCHAR(100),
    @Bags            INT,
    @PricePerBag     DECIMAL(10,2),
    @Total           DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.ShavingsOrders
    (
        CompetitionName,
        HorseName,
        PayerName,
        TrainerName,
        StableName,
        Bags,
        PricePerBag,
        Total
    )
    VALUES
    (
        @CompetitionName,
        @HorseName,
        @PayerName,
        @TrainerName,
        @StableName,
        @Bags,
        @PricePerBag,
        @Total
    );

    SELECT SCOPE_IDENTITY() AS NewShavingsId;
END;
GO


IF OBJECT_ID('dbo.usp_Shavings_Update', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Shavings_Update;
GO

CREATE PROCEDURE dbo.usp_Shavings_Update
    @ShavingsId      INT,
    @CompetitionName NVARCHAR(100),
    @HorseName       NVARCHAR(100),
    @PayerName       NVARCHAR(100),
    @TrainerName     NVARCHAR(100),
    @StableName      NVARCHAR(100),
    @Bags            INT,
    @PricePerBag     DECIMAL(10,2),
    @Total           DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.ShavingsOrders
    SET
        CompetitionName = @CompetitionName,
        HorseName       = @HorseName,
        PayerName       = @PayerName,
        TrainerName     = @TrainerName,
        StableName      = @StableName,
        Bags            = @Bags,
        PricePerBag     = @PricePerBag,
        Total           = @Total
    WHERE ShavingsId = @ShavingsId;
END;
GO


IF OBJECT_ID('dbo.usp_Shavings_Delete', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Shavings_Delete;
GO

CREATE PROCEDURE dbo.usp_Shavings_Delete
    @ShavingsId INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.ShavingsOrders
    WHERE ShavingsId = @ShavingsId;
END;
GO


/* ================================
   PAIDTIMES – CRUD PROCEDURES
   ================================ */

IF OBJECT_ID('dbo.usp_PaidTimes_GetAll', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PaidTimes_GetAll;
GO

CREATE PROCEDURE dbo.usp_PaidTimes_GetAll
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        PaidTimeId,
        CompetitionName,
        PayerName,
        RiderName,
        HorseName,
        TrainerName,
        StableName,
        DayName,
        RequestedTime,
        Type,
        Price,
        Comments
    FROM dbo.PaidTimes;
END;
GO


IF OBJECT_ID('dbo.usp_PaidTimes_GetById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PaidTimes_GetById;
GO

CREATE PROCEDURE dbo.usp_PaidTimes_GetById
    @PaidTimeId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        PaidTimeId,
        CompetitionName,
        PayerName,
        RiderName,
        HorseName,
        TrainerName,
        StableName,
        DayName,
        RequestedTime,
        Type,
        Price,
        Comments
    FROM dbo.PaidTimes
    WHERE PaidTimeId = @PaidTimeId;
END;
GO


IF OBJECT_ID('dbo.usp_PaidTimes_Insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PaidTimes_Insert;
GO

CREATE PROCEDURE dbo.usp_PaidTimes_Insert
    @CompetitionName NVARCHAR(100),
    @PayerName       NVARCHAR(100),
    @RiderName       NVARCHAR(100),
    @HorseName       NVARCHAR(100),
    @TrainerName     NVARCHAR(100),
    @StableName      NVARCHAR(100),
    @DayName         NVARCHAR(20),
    @RequestedTime   NVARCHAR(20),
    @Type            NVARCHAR(10),
    @Price           DECIMAL(10,2),
    @Comments        NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.PaidTimes
    (
        CompetitionName,
        PayerName,
        RiderName,
        HorseName,
        TrainerName,
        StableName,
        DayName,
        RequestedTime,
        Type,
        Price,
        Comments
    )
    VALUES
    (
        @CompetitionName,
        @PayerName,
        @RiderName,
        @HorseName,
        @TrainerName,
        @StableName,
        @DayName,
        @RequestedTime,
        @Type,
        @Price,
        @Comments
    );

    SELECT SCOPE_IDENTITY() AS NewPaidTimeId;
END;
GO


IF OBJECT_ID('dbo.usp_PaidTimes_Update', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PaidTimes_Update;
GO

CREATE PROCEDURE dbo.usp_PaidTimes_Update
    @PaidTimeId      INT,
    @CompetitionName NVARCHAR(100),
    @PayerName       NVARCHAR(100),
    @RiderName       NVARCHAR(100),
    @HorseName       NVARCHAR(100),
    @TrainerName     NVARCHAR(100),
    @StableName      NVARCHAR(100),
    @DayName         NVARCHAR(20),
    @RequestedTime   NVARCHAR(20),
    @Type            NVARCHAR(10),
    @Price           DECIMAL(10,2),
    @Comments        NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.PaidTimes
    SET
        CompetitionName = @CompetitionName,
        PayerName       = @PayerName,
        RiderName       = @RiderName,
        HorseName       = @HorseName,
        TrainerName     = @TrainerName,
        StableName      = @StableName,
        DayName         = @DayName,
        RequestedTime   = @RequestedTime,
        Type            = @Type,
        Price           = @Price,
        Comments        = @Comments
    WHERE PaidTimeId = @PaidTimeId;
END;
GO


IF OBJECT_ID('dbo.usp_PaidTimes_Delete', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PaidTimes_Delete;
GO

CREATE PROCEDURE dbo.usp_PaidTimes_Delete
    @PaidTimeId INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.PaidTimes
    WHERE PaidTimeId = @PaidTimeId;
END;
GO
