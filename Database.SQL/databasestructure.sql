USE MotorcycleShop;
GO

SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE t.name IN ('Motorcycles', 'Orders', 'ShoppingCart', 'ShoppingCartItems', 'OrderItems', 'Payments')
ORDER BY t.name, c.column_id;
GO
