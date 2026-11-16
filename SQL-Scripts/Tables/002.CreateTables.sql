DROP TABLE IF EXISTS stg.dimproduct

CREATE TABLE stg.dimproduct
(
    ProductID NVARCHAR(50) NOT NULL,
    SKUCode NVARCHAR(100) NULL,
    ProductName NVARCHAR(200) NULL,
    ShortDescription NVARCHAR(500) NULL,

    Category NVARCHAR(100) NULL,
    SubCategory NVARCHAR(100) NULL,
    Department NVARCHAR(100) NULL,

    Brand NVARCHAR(100) NULL,
    ModelNumber NVARCHAR(100) NULL,
    Color NVARCHAR(50) NULL,
    Size NVARCHAR(50) NULL,

    Weight DECIMAL(10,2) NULL,
    UnitOfMeasure NVARCHAR(50) NULL,

    SupplierID NVARCHAR(50) NULL,
    SupplierName NVARCHAR(200) NULL,
    CountryOfOrigin NVARCHAR(100) NULL,

    CostPrice DECIMAL(18,2) NULL,
    MRP DECIMAL(18,2) NULL,
    StandardSellingPrice DECIMAL(18,2) NULL,
    TaxPercent DECIMAL(5,2) NULL,
    ReorderLevel INT NULL,
    LaunchDate NVARCHAR(50) NULL,
    ProductStatus NVARCHAR(50) NULL,
    FileName NVARCHAR(50)

);

DROP TABLE IF EXISTS dw.DimProduct

CREATE TABLE dw.DimProduct
(   
    --Surrogate key
    ProductKey INT IDENTITY(1,1) Primary Key,
    -- Business Key
    ProductID NVARCHAR(50) ,

    -- Attributes
    SKUCode NVARCHAR(100) NULL,
    ProductName NVARCHAR(200) NULL,
    ShortDescription NVARCHAR(500) NULL,

    Category NVARCHAR(100) NULL,
    SubCategory NVARCHAR(100) NULL,
    Department NVARCHAR(100) NULL,

    Brand NVARCHAR(100) NULL,
    ModelNumber NVARCHAR(100) NULL,
    Color NVARCHAR(50) NULL,
    Size NVARCHAR(50) NULL,

    Weight DECIMAL(10,2) NULL,
    UnitOfMeasure NVARCHAR(50) NULL,

    SupplierID NVARCHAR(50) NULL,
    SupplierName NVARCHAR(200) NULL,
    CountryOfOrigin NVARCHAR(100) NULL,

    CostPrice DECIMAL(18,2) NULL,
    MRP DECIMAL(18,2) NULL,
    StandardSellingPrice DECIMAL(18,2) NULL,
    TaxPercent DECIMAL(5,2) NULL,

    ReorderLevel INT NULL,

    LaunchDate DATE NULL,

    ProductStatus NVARCHAR(50) NULL,

    -- SCD2 Columns
    StartDate DATETIME2 NOT NULL,
    EndDate DATETIME2 ,
    IsCurrent BIT NOT NULL,
    HashValue VARBINARY(32) NOT NULL
        
);

SELECT * FROM dw.dimproduct

/* ==========================================================================
   Create customers table
============================================================================= */
DROP TABLE IF EXISTS stg.DimCustomer

CREATE TABLE stg.DimCustomer
(

    CustomerID INT,
    CustomerNumber NVARCHAR(50),

    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    FullName NVARCHAR(200),

    Gender NVARCHAR(10),
    DateOfBirth NVARCHAR(50),

    Email NVARCHAR(200),
    PhoneNumber NVARCHAR(50),

    AddressLine1 NVARCHAR(200),
    AddressLine2 NVARCHAR(200),
    City NVARCHAR(100),
    StateProvince NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),

    CustomerSegment NVARCHAR(50),
    CustomerCategory NVARCHAR(50),

    RegistrationDate NVARCHAR(50),
    PreferredLanguage NVARCHAR(50),
    PreferredCurrency NVARCHAR(10),

    LoyaltyProgramID NVARCHAR(50),
    LoyaltyPoints INT,

    MarketingOptIn BIT,
    EmailOptIn BIT,
    SMSOptIn BIT,

    CustomerStatus NVARCHAR(50),
    FileName NVARCHAR(50)
)
DROP TABLE IF EXISTS dw.DimCustomer;
CREATE TABLE dw.DimCustomer
(
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,

    CustomerID INT,
    CustomerNumber NVARCHAR(50),

    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    FullName NVARCHAR(200),

    Gender NVARCHAR(10),
    DateOfBirth DATE,

    Email NVARCHAR(200),
    PhoneNumber NVARCHAR(50),

    AddressLine1 NVARCHAR(200),
    AddressLine2 NVARCHAR(200),
    City NVARCHAR(100),
    StateProvince NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),

    CustomerSegment NVARCHAR(50),
    CustomerCategory NVARCHAR(50),

    RegistrationDate DATE,
    PreferredLanguage NVARCHAR(50),
    PreferredCurrency NVARCHAR(10),

    LoyaltyProgramID NVARCHAR(50),
    LoyaltyPoints INT,

    MarketingOptIn BIT,
    EmailOptIn BIT,
    SMSOptIn BIT,

    CustomerStatus NVARCHAR(50),


    StartDate DATETIME2,
    EndDate DATETIME2,
    IsCurrent BIT,

    HashValue VARBINARY(32)
)



/* ==========================================================================
   Create Stores table
============================================================================= */
DROP TABLE IF EXISTS  stg.DimStore;
CREATE TABLE stg.DimStore
(
    

    StoreID INT,
    StoreCode NVARCHAR(50),
    StoreName NVARCHAR(200),

    StoreType NVARCHAR(50),
    StoreFormat NVARCHAR(50),

    AddressLine1 NVARCHAR(200),
    AddressLine2 NVARCHAR(200),

    City NVARCHAR(100),
    StateProvince NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    Region NVARCHAR(100),

    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6),

    StoreManager NVARCHAR(150),
    ManagerEmail NVARCHAR(200),
    ManagerPhone NVARCHAR(50),

    StoreSizeSqFt INT,
    NumberOfEmployees INT,

    OpeningDate NVARCHAR(20),
    ClosingDate NVARCHAR(20),

    IsFranchise BIT,
    StoreStatus NVARCHAR(50),

    TargetRevenue DECIMAL(18,2),
    FileName NVARCHAR(300)
)


CREATE TABLE dw.DimStore
(
    StoreKey INT IDENTITY(1,1) PRIMARY KEY,

    StoreID INT,
    StoreCode NVARCHAR(50),
    StoreName NVARCHAR(200),

    StoreType NVARCHAR(50),
    StoreFormat NVARCHAR(50),

    AddressLine1 NVARCHAR(200),
    AddressLine2 NVARCHAR(200),

    City NVARCHAR(100),
    StateProvince NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    Region NVARCHAR(100),

    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6),

    StoreManager NVARCHAR(150),
    ManagerEmail NVARCHAR(200),
    ManagerPhone NVARCHAR(50),

    StoreSizeSqFt INT,
    NumberOfEmployees INT,

    OpeningDate DATE,
    ClosingDate DATE,

    IsFranchise BIT,
    StoreStatus NVARCHAR(50),

    TargetRevenue DECIMAL(18,2),

    StartDate DATETIME2,
    EndDate DATETIME2,
    IsCurrent BIT,

    HashValue VARBINARY(32)
)


/* ==========================================================================
   Create FactSales table
============================================================================= */
DROP TABLE IF EXISTS stg.FactSales;



CREATE TABLE stg.FactSales
(
    

    SalesID BIGINT,
    OrderNumber NVARCHAR(100),
    OrderLineNumber INT,

    OrderDate NVARCHAR(20),
    ShipDate NVARCHAR(20),
    DeliveryDate NVARCHAR(20),

    CustomerID INT,
    ProductID INT,
    StoreID INT,
    PromotionID INT,

    SalesChannel NVARCHAR(50),
    DeviceType NVARCHAR(50),

    Quantity INT,
    UnitPrice DECIMAL(18,2),
    UnitCost DECIMAL(18,2),
    ListPrice DECIMAL(18,2),

    GrossAmount DECIMAL(18,2),
    DiscountAmount DECIMAL(18,2),
    CouponDiscountAmount DECIMAL(18,2),
    PromotionDiscountAmount DECIMAL(18,2),

    TaxAmount DECIMAL(18,2),
    ShippingAmount DECIMAL(18,2),
    HandlingAmount DECIMAL(18,2),

    NetAmount DECIMAL(18,2),
    ProfitAmount DECIMAL(18,2),
    MarginPercent DECIMAL(10,2),

    PaymentMethod NVARCHAR(50),
    PaymentStatus NVARCHAR(50),
    PaymentGateway NVARCHAR(100),

    CurrencyCode NVARCHAR(10),
    ExchangeRate DECIMAL(18,6),

    OrderStatus NVARCHAR(50),
    FulfillmentStatus NVARCHAR(50),

    ShippingCarrier NVARCHAR(100),
    ShippingMethod NVARCHAR(100),
    TrackingNumber NVARCHAR(100),

    WarehouseID NVARCHAR(50),

    DeliveryDays INT,

    IsGift NVARCHAR(10),
    GiftWrapAmount DECIMAL(18,2),

    IsReturn NVARCHAR(10),
    ReturnQuantity INT,
    ReturnAmount DECIMAL(18,2),
    ReturnReason NVARCHAR(200),

    IsExchange NVARCHAR(10),
    ExchangeQuantity INT,

    CustomerRating INT,
    CustomerReview NVARCHAR(500),

    FraudFlag NVARCHAR(10),
    FraudScore DECIMAL(10,2),
    FileName NVARCHAR(300)
)


DROP TABLE IF EXISTS dw.FactSales ;
CREATE TABLE dw.FactSales
(
    SalesKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    SalesID BIGINT,
    OrderNumber NVARCHAR(100),
    OrderLineNumber INT,

    OrderDate DATE,
    ShipDate DATE,
    DeliveryDate DATE,

    CustomerKey INT,
    ProductKey INT,
    StoreKey INT,
    PromotionKey INT,

    SalesChannel NVARCHAR(50),
    DeviceType NVARCHAR(50),

    Quantity INT,
    UnitPrice DECIMAL(18,2),
    UnitCost DECIMAL(18,2),
    ListPrice DECIMAL(18,2),

    GrossAmount DECIMAL(18,2),
    DiscountAmount DECIMAL(18,2),
    CouponDiscountAmount DECIMAL(18,2),
    PromotionDiscountAmount DECIMAL(18,2),

    TaxAmount DECIMAL(18,2),
    ShippingAmount DECIMAL(18,2),
    HandlingAmount DECIMAL(18,2),

    NetAmount DECIMAL(18,2),
    ProfitAmount DECIMAL(18,2),
    MarginPercent DECIMAL(10,2),

    PaymentMethod NVARCHAR(50),
    PaymentStatus NVARCHAR(50),
    PaymentGateway NVARCHAR(100),

    CurrencyCode NVARCHAR(10),
    ExchangeRate DECIMAL(18,6),

    OrderStatus NVARCHAR(50),
    FulfillmentStatus NVARCHAR(50),

    ShippingCarrier NVARCHAR(100),
    ShippingMethod NVARCHAR(100),
    TrackingNumber NVARCHAR(100),

    WarehouseID NVARCHAR(50),

    DeliveryDays INT,

    IsGift BIT,
    GiftWrapAmount DECIMAL(18,2),

    IsReturn BIT,
    ReturnQuantity INT,
    ReturnAmount DECIMAL(18,2),
    ReturnReason NVARCHAR(200),

    IsExchange BIT,
    ExchangeQuantity INT,

    CustomerRating INT,
    CustomerReview NVARCHAR(500),

    FraudFlag BIT,
    FraudScore DECIMAL(10,2)
)

/* ==========================================================================
   Create foreign keys
============================================================================= */


ALTER TABLE dw.FactSales
ADD CONSTRAINT FK_FactSales_Product
FOREIGN KEY (ProductKey)
REFERENCES dw.DimProduct(ProductKey)

ALTER TABLE dw.FactSales
ADD CONSTRAINT FK_FactSales_Customer
FOREIGN KEY (CustomerKey)
REFERENCES dw.DimCustomer(CustomerKey)

ALTER TABLE dw.FactSales
ADD CONSTRAINT FK_FactSales_Store
FOREIGN KEY (StoreKey)
REFERENCES dw.DimStore(StoreKey)

ALTER TABLE dw.FactSales
ADD CONSTRAINT FK_FactSales_Promotion
FOREIGN KEY (PromotionKey)
REFERENCES dw.DimPromotion(PromotionKey)