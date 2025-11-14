USE MotorcycleShop;
GO

PRINT '================================================================================';
PRINT '                    БАЗА ДАННЫХ MOTORCYCLESHOP - ВСЕ ДАННЫЕ';
PRINT '================================================================================';
PRINT '';
GO

PRINT '1. ТАБЛИЦА: Motorcycles (Мотоциклы)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    Id,
    Brand AS 'Марка',
    Model AS 'Модель',
    Year AS 'Год',
    Color AS 'Цвет',
    EngineVolume AS 'Объем двигателя',
    Mileage AS 'Пробег',
    Price AS 'Цена',
    CASE 
        WHEN InStock = 1 THEN 'В наличии'
        ELSE 'Нет в наличии'
    END AS 'Наличие',
    CreatedAt AS 'Дата добавления'
FROM Motorcycles
ORDER BY Brand, Model;
PRINT '';

PRINT '2. ТАБЛИЦА: ShoppingCart (Корзины)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    Id,
    SessionId AS 'ID сессии',
    CreatedDate AS 'Дата создания',
    LastModified AS 'Последнее изменение',
    TotalAmount AS 'Общая сумма'
FROM ShoppingCart
ORDER BY CreatedDate;
PRINT '';

PRINT '3. ТАБЛИЦА: ShoppingCartItems (Позиции корзины)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    sci.Id,
    sci.ShoppingCartId AS 'ID корзины',
    m.Brand + ' ' + m.Model AS 'Мотоцикл',
    sci.Quantity AS 'Количество',
    sci.AddedDate AS 'Дата добавления'
FROM ShoppingCartItems sci
INNER JOIN Motorcycles m ON sci.MotorcycleId = m.Id
ORDER BY sci.ShoppingCartId, sci.AddedDate;
PRINT '';

PRINT '4. ТАБЛИЦА: Orders (Заказы)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    Id,
    OrderNumber AS 'Номер заказа',
    CustomerName AS 'ФИО клиента',
    CustomerEmail AS 'Email',
    CustomerPhone AS 'Телефон',
    TotalAmount AS 'Сумма заказа',
    Status AS 'Статус',
    OrderDate AS 'Дата заказа'
FROM Orders
ORDER BY OrderDate DESC;
PRINT '';

PRINT '5. ТАБЛИЦА: OrderItems (Позиции заказа)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    oi.Id,
    oi.OrderId AS 'ID заказа',
    o.OrderNumber AS 'Номер заказа',
    m.Brand + ' ' + m.Model AS 'Мотоцикл',
    oi.Quantity AS 'Количество',
    oi.UnitPrice AS 'Цена за единицу'
FROM OrderItems oi
INNER JOIN Orders o ON oi.OrderId = o.Id
INNER JOIN Motorcycles m ON oi.MotorcycleId = m.Id
ORDER BY oi.OrderId;
PRINT '';

PRINT '6. ТАБЛИЦA: Payments (Платежи)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    p.Id,
    p.OrderId AS 'ID заказа',
    o.OrderNumber AS 'Номер заказа',
    p.PaymentDate AS 'Дата платежа',
    p.Amount AS 'Сумма',
    p.PaymentMethod AS 'Способ оплаты',
    p.CardLastFour AS 'Последние 4 цифры карты',
    p.TransactionId AS 'ID транзакции',
    p.Status AS 'Статус платежа'
FROM Payments p
INNER JOIN Orders o ON p.OrderId = o.Id
ORDER BY p.PaymentDate DESC;
PRINT '';

PRINT '7. ПРЕДСТАВЛЕНИЯ - ОБЗОР ДАННЫХ';
PRINT '================================================================================';

PRINT '7.1. vw_ShoppingCartDetails (Детали корзины)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    CartId AS 'ID корзины',
    SessionId AS 'ID сессии',
    Brand AS 'Марка',
    Model AS 'Модель',
    Quantity AS 'Количество',
    Price AS 'Цена',
    TotalAmount AS 'Общая сумма корзины'
FROM vw_ShoppingCartDetails
ORDER BY CartId;
PRINT '';

PRINT '7.2. vw_OrderDetails (Детали заказов)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    OrderNumber AS 'Номер заказа',
    CustomerName AS 'Клиент',
    TotalAmount AS 'Сумма заказа',
    OrderStatus AS 'Статус заказа',
    OrderDate AS 'Дата заказа',
    PaymentStatus AS 'Статус оплаты',
    PaymentAmount AS 'Сумма оплаты'
FROM vw_OrderDetails
ORDER BY OrderDate DESC;
PRINT '';

PRINT '7.3. vw_AvailableMotorcycles (Доступные мотоциклы)';
PRINT '--------------------------------------------------------------------------------';
SELECT 
    Brand AS 'Марка',
    Model AS 'Модель',
    Year AS 'Год',
    Color AS 'Цвет',
    EngineVolume AS 'Объем двигателя',
    Price AS 'Цена'
FROM vw_AvailableMotorcycles
ORDER BY Brand, Model;
PRINT '';

PRINT '8. СТАТИСТИКА БАЗЫ ДАННЫХ';
PRINT '================================================================================';

DECLARE @MotorcycleCount INT, @OrderCount INT, @PaymentCount INT, @CartCount INT;

SELECT @MotorcycleCount = COUNT(*) FROM Motorcycles;
SELECT @OrderCount = COUNT(*) FROM Orders;
SELECT @PaymentCount = COUNT(*) FROM Payments;
SELECT @CartCount = COUNT(*) FROM ShoppingCart;

PRINT 'Количество мотоциклов: ' + CAST(@MotorcycleCount AS NVARCHAR(10));
PRINT 'Количество заказов: ' + CAST(@OrderCount AS NVARCHAR(10));
PRINT 'Количество платежей: ' + CAST(@PaymentCount AS NVARCHAR(10));
PRINT 'Количество корзин: ' + CAST(@CartCount AS NVARCHAR(10));

PRINT '';
PRINT 'Статистика по статусам заказов:';
SELECT 
    Status AS 'Статус',
    COUNT(*) AS 'Количество',
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders) AS DECIMAL(5,2)) AS 'Процент'
FROM Orders 
GROUP BY Status
ORDER BY COUNT(*) DESC;

PRINT '';
PRINT 'Статистика по брендам мотоциклов:';
SELECT 
    Brand AS 'Марка',
    COUNT(*) AS 'Количество моделей',
    AVG(Price) AS 'Средняя цена',
    SUM(CASE WHEN InStock = 1 THEN 1 ELSE 0 END) AS 'В наличии'
FROM Motorcycles 
GROUP BY Brand
ORDER BY COUNT(*) DESC;
GO