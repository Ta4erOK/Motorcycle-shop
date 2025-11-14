USE MotorcycleShop;
GO

DELETE FROM Payments;
DELETE FROM OrderItems;
DELETE FROM ShoppingCartItems;
DELETE FROM Orders;
DELETE FROM ShoppingCart;
DELETE FROM Motorcycles;

DBCC CHECKIDENT ('Payments', RESEED, 0);
DBCC CHECKIDENT ('OrderItems', RESEED, 0);
DBCC CHECKIDENT ('ShoppingCartItems', RESEED, 0);
DBCC CHECKIDENT ('Orders', RESEED, 0);
DBCC CHECKIDENT ('ShoppingCart', RESEED, 0);
DBCC CHECKIDENT ('Motorcycles', RESEED, 0);

PRINT 'Все данные в базе MotorcycleShop очищены, идентификаторы сброшены';
GO