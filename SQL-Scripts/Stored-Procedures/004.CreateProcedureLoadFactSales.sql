CREATE OR ALTER PROCEDURE dw.usp_LoadFactSales
(
    @FileName NVARCHAR(300)
)
AS
BEGIN

SET NOCOUNT ON;

BEGIN TRY

    BEGIN TRAN;

    /* ==========================================
       STEP 1: Insert into Fact Table
    ========================================== */

    INSERT INTO dw.FactSales
    (
        SalesID,
        OrderNumber,
        OrderLineNumber,

        OrderDate,
        ShipDate,
        DeliveryDate,

        CustomerKey,
        ProductKey,
        StoreKey,
        PromotionKey,

        SalesChannel,
        DeviceType,

        Quantity,
        UnitPrice,
        UnitCost,
        ListPrice,

        GrossAmount,
        DiscountAmount,
        CouponDiscountAmount,
        PromotionDiscountAmount,

        TaxAmount,
        ShippingAmount,
        HandlingAmount,

        NetAmount,
        ProfitAmount,
        MarginPercent,

        PaymentMethod,
        PaymentStatus,
        PaymentGateway,

        CurrencyCode,
        ExchangeRate,

        OrderStatus,
        FulfillmentStatus,

        ShippingCarrier,
        ShippingMethod,
        TrackingNumber,

        WarehouseID,
        DeliveryDays,

        IsGift,
        GiftWrapAmount,

        IsReturn,
        ReturnQuantity,
        ReturnAmount,
        ReturnReason,

        IsExchange,
        ExchangeQuantity,

        CustomerRating,
        CustomerReview,

        FraudFlag,
        FraudScore
    )

    SELECT

        S.SalesID,
        S.OrderNumber,
        S.OrderLineNumber,

        TRY_CONVERT(date,S.OrderDate,105) AS OrderDate,
        TRY_CONVERT(date,S.ShipDate,105),
        TRY_CONVERT(date,S.DeliveryDate,105),

        C.CustomerKey,
        P.ProductKey,
        ST.StoreKey,
        PR.PromotionKey,

        S.SalesChannel,
        S.DeviceType,

        S.Quantity,
        S.UnitPrice,
        S.UnitCost,
        S.ListPrice,

        S.GrossAmount,
        S.DiscountAmount,
        S.CouponDiscountAmount,
        S.PromotionDiscountAmount,

        S.TaxAmount,
        S.ShippingAmount,
        S.HandlingAmount,

        S.NetAmount,
        S.ProfitAmount,
        S.MarginPercent,

        S.PaymentMethod,
        S.PaymentStatus,
        S.PaymentGateway,

        S.CurrencyCode,
        S.ExchangeRate,

        S.OrderStatus,
        S.FulfillmentStatus,

        S.ShippingCarrier,
        S.ShippingMethod,
        S.TrackingNumber,

        S.WarehouseID,
        S.DeliveryDays,

        S.IsGift,
        S.GiftWrapAmount,

        S.IsReturn,
        S.ReturnQuantity,
        S.ReturnAmount,
        S.ReturnReason,

        S.IsExchange,
        S.ExchangeQuantity,

        S.CustomerRating,
        S.CustomerReview,

        S.FraudFlag,
        S.FraudScore

    FROM stg.FactSales S

    /* ==========================================
       SCD2 LOOKUPS (TIME-BASED)
    ========================================== */

    LEFT JOIN dw.DimProduct P
        ON S.ProductID = P.ProductID
       AND TRY_CONVERT(date,S.OrderDate,105)
           BETWEEN P.StartDate AND P.EndDate

    LEFT JOIN dw.DimCustomer C
        ON S.CustomerID = C.CustomerID
       AND TRY_CONVERT(date,S.OrderDate,105)
           BETWEEN C.StartDate AND C.EndDate

    LEFT JOIN dw.DimStore ST
        ON S.StoreID = ST.StoreID
       AND TRY_CONVERT(date,S.OrderDate,105)
           BETWEEN ST.StartDate AND ST.EndDate

    LEFT JOIN dw.DimPromotion PR
        ON S.PromotionID = PR.PromotionID
       AND TRY_CONVERT(date,S.OrderDate,105)
           BETWEEN PR.StartDate AND PR.EndDate

    /* ==========================================
       DUPLICATE PROTECTION
    ========================================== */

    LEFT JOIN dw.FactSales F
        ON S.SalesID = F.SalesID

    WHERE 
        S.FileName = @FileName
        AND F.SalesID IS NULL;


    /* ==========================================
       CLEAN ONLY PROCESSED FILE
    ========================================== */

    DELETE FROM stg.FactSales
    WHERE FileName = @FileName;


    COMMIT TRAN;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;

    THROW;

END CATCH

END