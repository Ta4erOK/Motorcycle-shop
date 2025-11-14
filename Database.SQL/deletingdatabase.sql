USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'MotorcycleShop')
BEGIN
    ALTER DATABASE MotorcycleShop SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MotorcycleShop;
    PRINT 'База данных MotorcycleShop удалена';
END
ELSE
BEGIN
    PRINT 'База данных MotorcycleShop не существует';
END
GO