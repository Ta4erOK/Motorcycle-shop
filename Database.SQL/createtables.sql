IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'MotorcycleShop')
BEGIN
    CREATE DATABASE MotorcycleShop;
END
GO

USE MotorcycleShop;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Motorcycles')
BEGIN
    CREATE TABLE Motorcycles (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Brand NVARCHAR(100) NOT NULL,
        Model NVARCHAR(100) NOT NULL,
        Year INT NOT NULL,
        Color NVARCHAR(50) NOT NULL,
        EngineVolume DECIMAL(10,2) NOT NULL,
        Mileage INT NOT NULL DEFAULT 0,
        Price DECIMAL(18,2) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        ImageUrl NVARCHAR(500) NULL,
        InStock BIT NOT NULL DEFAULT 1,
        CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Motorcycles_Brand' AND object_id = OBJECT_ID('Motorcycles'))
    CREATE INDEX IX_Motorcycles_Brand ON Motorcycles(Brand);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Motorcycles_Year' AND object_id = OBJECT_ID('Motorcycles'))
    CREATE INDEX IX_Motorcycles_Year ON Motorcycles(Year);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Motorcycles_Price' AND object_id = OBJECT_ID('Motorcycles'))
    CREATE INDEX IX_Motorcycles_Price ON Motorcycles(Price);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Motorcycles_InStock' AND object_id = OBJECT_ID('Motorcycles'))
    CREATE INDEX IX_Motorcycles_InStock ON Motorcycles(InStock);
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Orders')
BEGIN
    CREATE TABLE Orders (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        OrderNumber NVARCHAR(50) NOT NULL UNIQUE,
        CustomerName NVARCHAR(200) NOT NULL,
        CustomerEmail NVARCHAR(255) NOT NULL,
        CustomerPhone NVARCHAR(20) NOT NULL,
        DeliveryAddress NVARCHAR(500) NOT NULL,
        OrderDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        TotalAmount DECIMAL(18,2) NOT NULL,
        Status NVARCHAR(50) NOT NULL DEFAULT N'Ожидает оплаты',
        Comments NVARCHAR(MAX) NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_OrderNumber' AND object_id = OBJECT_ID('Orders'))
    CREATE INDEX IX_Orders_OrderNumber ON Orders(OrderNumber);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_CustomerEmail' AND object_id = OBJECT_ID('Orders'))
    CREATE INDEX IX_Orders_CustomerEmail ON Orders(CustomerEmail);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_Status' AND object_id = OBJECT_ID('Orders'))
    CREATE INDEX IX_Orders_Status ON Orders(Status);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_OrderDate' AND object_id = OBJECT_ID('Orders'))
    CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ShoppingCart')
BEGIN
    CREATE TABLE ShoppingCart (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        SessionId NVARCHAR(100) NOT NULL,
        CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        LastModified DATETIME2 NOT NULL DEFAULT GETDATE(),
        TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ShoppingCart_SessionId' AND object_id = OBJECT_ID('ShoppingCart'))
    CREATE INDEX IX_ShoppingCart_SessionId ON ShoppingCart(SessionId);
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ShoppingCartItems')
BEGIN
    CREATE TABLE ShoppingCartItems (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        ShoppingCartId INT NOT NULL,
        MotorcycleId INT NOT NULL,
        Quantity INT NOT NULL DEFAULT 1,
        AddedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        
        CONSTRAINT FK_ShoppingCartItems_ShoppingCart FOREIGN KEY (ShoppingCartId) 
            REFERENCES ShoppingCart(Id) ON DELETE CASCADE,
        CONSTRAINT FK_ShoppingCartItems_Motorcycle FOREIGN KEY (MotorcycleId) 
            REFERENCES Motorcycles(Id)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ShoppingCartItems_ShoppingCartId' AND object_id = OBJECT_ID('ShoppingCartItems'))
    CREATE INDEX IX_ShoppingCartItems_ShoppingCartId ON ShoppingCartItems(ShoppingCartId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ShoppingCartItems_MotorcycleId' AND object_id = OBJECT_ID('ShoppingCartItems'))
    CREATE INDEX IX_ShoppingCartItems_MotorcycleId ON ShoppingCartItems(MotorcycleId);
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderItems')
BEGIN
    CREATE TABLE OrderItems (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        OrderId INT NOT NULL,
        MotorcycleId INT NOT NULL,
        Quantity INT NOT NULL DEFAULT 1,
        UnitPrice DECIMAL(18,2) NOT NULL,
        
        CONSTRAINT FK_OrderItems_Order FOREIGN KEY (OrderId) 
            REFERENCES Orders(Id) ON DELETE CASCADE,
        CONSTRAINT FK_OrderItems_Motorcycle FOREIGN KEY (MotorcycleId) 
            REFERENCES Motorcycles(Id)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderItems_OrderId' AND object_id = OBJECT_ID('OrderItems'))
    CREATE INDEX IX_OrderItems_OrderId ON OrderItems(OrderId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_OrderItems_MotorcycleId' AND object_id = OBJECT_ID('OrderItems'))
    CREATE INDEX IX_OrderItems_MotorcycleId ON OrderItems(MotorcycleId);
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Payments')
BEGIN
    CREATE TABLE Payments (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        OrderId INT NOT NULL UNIQUE,
        PaymentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        Amount DECIMAL(18,2) NOT NULL,
        PaymentMethod NVARCHAR(50) NOT NULL DEFAULT N'Карта',
        CardLastFour NVARCHAR(4) NOT NULL,
        TransactionId NVARCHAR(100) NULL,
        Status NVARCHAR(50) NOT NULL DEFAULT N'Ожидает',
        
        CONSTRAINT FK_Payments_Order FOREIGN KEY (OrderId) 
            REFERENCES Orders(Id)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Payments_OrderId' AND object_id = OBJECT_ID('Payments'))
    CREATE INDEX IX_Payments_OrderId ON Payments(OrderId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Payments_TransactionId' AND object_id = OBJECT_ID('Payments'))
    CREATE INDEX IX_Payments_TransactionId ON Payments(TransactionId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Payments_Status' AND object_id = OBJECT_ID('Payments'))
    CREATE INDEX IX_Payments_Status ON Payments(Status);
GO

IF NOT EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_ShoppingCartItems_UpdateLastModified')
BEGIN
    EXEC('
    CREATE TRIGGER TR_ShoppingCartItems_UpdateLastModified
    ON ShoppingCartItems
    AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
        SET NOCOUNT ON;
        
        DECLARE @CartId INT;
        
        -- Получаем ID корзины из inserted или deleted
        IF EXISTS (SELECT * FROM inserted)
            SELECT @CartId = ShoppingCartId FROM inserted;
        ELSE 
            SELECT @CartId = ShoppingCartId FROM deleted;
            
        IF @CartId IS NOT NULL
        BEGIN
            -- Обновляем LastModified
            UPDATE ShoppingCart 
            SET LastModified = GETDATE()
            WHERE Id = @CartId;
            
            -- Обновляем TotalAmount через отдельный UPDATE
            UPDATE sc
            SET TotalAmount = ISNULL((
                SELECT SUM(m.Price * sci.Quantity)
                FROM ShoppingCartItems sci
                INNER JOIN Motorcycles m ON sci.MotorcycleId = m.Id
                WHERE sci.ShoppingCartId = sc.Id
            ), 0)
            FROM ShoppingCart sc
            WHERE sc.Id = @CartId;
        END
    END
    ');
END
GO

IF NOT EXISTS (SELECT 1 FROM Motorcycles)
BEGIN
    INSERT INTO Motorcycles (Brand, Model, Year, Color, EngineVolume, Mileage, Price, Description, ImageUrl, InStock)
    VALUES
        (N'Yamaha', N'YZF-R1', 2023, N'Синий', 998.00, 0, 1850000.00, N'Спортивный мотоцикл для трека и города', N'/images/yamaha_r1.jpg', 1),
        (N'Honda', N'CBR1000RR-R', 2023, N'Красный', 999.00, 0, 1950000.00, N'Флагманский спортбайк от Honda', N'/images/honda_cbr.jpg', 1),
        (N'Kawasaki', N'Ninja ZX-10R', 2023, N'Зеленый', 998.00, 500, 1750000.00, N'Легендарный ниндзя с мощным двигателем', N'/images/kawasaki_ninja.jpg', 1),
        (N'Suzuki', N'GSX-R1000', 2023, N'Синий/Белый', 999.00, 0, 1650000.00, N'Классический японский спортбайк', N'/images/suzuki_gsxr.jpg', 1),
        (N'Ducati', N'Panigale V4', 2023, N'Красный', 1103.00, 0, 2500000.00, N'Итальянский премиум спортбайк', N'/images/ducati_panigale.jpg', 1),
        (N'BMW', N'S1000RR', 2023, N'Белый/Синий', 999.00, 1000, 2200000.00, N'Немецкий спортбайк с инновационными технологиями', N'/images/bmw_s1000rr.jpg', 1),
        (N'Harley-Davidson', N'Street Glide', 2023, N'Черный', 1868.00, 0, 2100000.00, N'Классический чоппер для дальних поездок', N'/images/harley_streetglide.jpg', 1),
        (N'KTM', N'1290 Super Duke R', 2023, N'Оранжевый', 1301.00, 300, 1900000.00, N'Мощный нейкед для города', N'/images/ktm_superduke.jpg', 1);
END
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'vw_OrderDetails')
BEGIN
    EXEC('
    CREATE VIEW vw_OrderDetails AS
    SELECT 
        o.Id,
        o.OrderNumber,
        o.CustomerName,
        o.CustomerEmail,
        o.CustomerPhone,
        o.DeliveryAddress,
        o.OrderDate,
        o.TotalAmount,
        o.Status AS OrderStatus,
        o.Comments,
        p.PaymentDate,
        p.Amount AS PaymentAmount,
        p.PaymentMethod,
        p.CardLastFour,
        p.TransactionId,
        p.Status AS PaymentStatus
    FROM Orders o
    LEFT JOIN Payments p ON o.Id = p.OrderId
    ');
END
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'vw_ShoppingCartDetails')
BEGIN
    EXEC('
    CREATE VIEW vw_ShoppingCartDetails AS
    SELECT 
        sc.Id AS CartId,
        sc.SessionId,
        sc.TotalAmount,
        sci.Id AS CartItemId,
        sci.Quantity,
        sci.AddedDate,
        m.Id AS MotorcycleId,
        m.Brand,
        m.Model,
        m.Year,
        m.Color,
        m.EngineVolume,
        m.Price,
        m.ImageUrl
    FROM ShoppingCart sc
    INNER JOIN ShoppingCartItems sci ON sc.Id = sci.ShoppingCartId
    INNER JOIN Motorcycles m ON sci.MotorcycleId = m.Id
    ');
END
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'vw_AvailableMotorcycles')
BEGIN
    EXEC('
    CREATE VIEW vw_AvailableMotorcycles AS
    SELECT 
        Id,
        Brand,
        Model,
        Year,
        Color,
        EngineVolume,
        Mileage,
        Price,
        Description,
        ImageUrl,
        CreatedAt
    FROM Motorcycles
    WHERE InStock = 1
    ');
END
GO

DECLARE @TableCount INT;
DECLARE @ViewCount INT;
DECLARE @MotorcycleCount INT;

SELECT @TableCount = COUNT(*) 
FROM sys.tables 
WHERE name IN ('Motorcycles', 'Orders', 'ShoppingCart', 'ShoppingCartItems', 'OrderItems', 'Payments');

SELECT @ViewCount = COUNT(*) 
FROM sys.views 
WHERE name IN ('vw_OrderDetails', 'vw_ShoppingCartDetails', 'vw_AvailableMotorcycles');

SELECT @MotorcycleCount = COUNT(*) FROM Motorcycles;

PRINT '=== Создание базы данных MotorcycleShop завершено ===';
PRINT 'Создано таблиц: ' + CAST(@TableCount AS NVARCHAR(10));
PRINT 'Создано представлений: ' + CAST(@ViewCount AS NVARCHAR(10));
PRINT 'Количество тестовых записей в Motorcycles: ' + CAST(@MotorcycleCount AS NVARCHAR(10));
PRINT 'Все объекты успешно созданы!';
GO