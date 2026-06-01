-- ============================================================================
-- queries.sql - Базовые операции с таблицами Products и Orders
-- База данных: C:\projects\Modul-3\VPc04_learning\learning.db
-- ============================================================================

-- ============================================================================
-- ЧАСТЬ 1: БАЗОВЫЕ ОПЕРАЦИИ (INSERT, UPDATE, DELETE)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- INSERT: 3 ручных запроса + 1 массовая вставка
-- ----------------------------------------------------------------------------

-- 1.1. Ручная вставка товара "Яблоки"
INSERT INTO Products (Name, Description, Category, Price, SKU)
VALUES ('Яблоки', 'Свежие яблоки, 1 кг', 'Продукты', 500.00, 'ART-99999-A');

-- 1.2. Ручная вставка товара "Бананы"
INSERT INTO Products (Name, Description, Category, Price, SKU)
VALUES ('Бананы', 'Спелые бананы, 1 кг', 'Продукты', 120.50, 'ART-99998-B');

-- 1.3. Ручная вставка заказа на товар ID=1
INSERT INTO Orders (Product_ID, Quantity, Order_Date)
VALUES (1, 5, '2024-05-15');

-- 1.4. Массовая вставка нескольких товаров
INSERT INTO Products (Name, Description, Category, Price, SKU)
VALUES 
    ('Молоко', 'Свежее молоко 3.2%, 1 л', 'Продукты', 89.90, 'ART-99997-C'),
    ('Хлеб', 'Белый хлеб, 400 г', 'Продукты', 45.00, 'ART-99996-D'),
    ('Сыр', 'Твёрдый сыр, 200 г', 'Продукты', 250.00, 'ART-99995-A'),
    ('Куриное филе', 'Охлаждённое, 1 кг', 'Продукты', 350.00, 'ART-99994-B'),
    ('Рис', 'Длиннозёрный, 1 кг', 'Продукты', 95.00, 'ART-99993-C');

-- ----------------------------------------------------------------------------
-- UPDATE: 3 осмысленных обновления с WHERE
-- ----------------------------------------------------------------------------

-- 2.1. Скидка 10% для всех товаров категории "Продукты"
UPDATE Products
SET Price = ROUND(Price * 0.90, 2)
WHERE Category = 'Продукты';

-- 2.2. Исправление цены по конкретному SKU
UPDATE Products
SET Price = 499.99
WHERE SKU = 'ART-99999-A';

-- 2.3. Обновление описания для товаров с ценой выше 50000 ₽
UPDATE Products
SET Description = 'Премиум товар. ' || Description
WHERE Price > 50000;

-- ----------------------------------------------------------------------------
-- DELETE: Безопасное удаление тестовых записей
-- ----------------------------------------------------------------------------

-- 3.1. Удаление тестовых товаров (по SKU с суффиксом Z)
DELETE FROM Products
WHERE SKU LIKE '%-Z';

-- 3.2. Удаление заказов старше 2 лет (пример)
-- DELETE FROM Orders
-- WHERE Order_Date < '2022-01-01';

-- ============================================================================
-- ЧАСТЬ 2: ЧТЕНИЕ И АНАЛИЗ (SELECT)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SELECT с WHERE + ORDER BY + LIMIT (топ-N по цене)
-- ----------------------------------------------------------------------------

-- 4.1. Топ-10 самых дорогих товаров
SELECT Name, Price, Category
FROM Products
ORDER BY Price DESC
LIMIT 10;

-- 4.2. Топ-5 товаров из категории "Электроника"
SELECT Name, Price, SKU
FROM Products
WHERE Category = 'Электроника'
ORDER BY Price DESC
LIMIT 5;

-- 4.3. 5 самых дешёвых товаров
SELECT Name, Price
FROM Products
ORDER BY Price ASC
LIMIT 5;

-- ----------------------------------------------------------------------------
-- Агрегация: GROUP BY + HAVING
-- ----------------------------------------------------------------------------

-- 5.1. Количество товаров и средняя цена по категориям (где > 5 товаров)
SELECT 
    Category,
    COUNT(*) AS product_count,
    ROUND(AVG(Price), 2) AS avg_price
FROM Products
GROUP BY Category
HAVING COUNT(*) > 5;

-- 5.2. Статистика заказов по товарам, заказанным более 3-х раз
SELECT 
    Product_ID,
    COUNT(*) AS order_count,
    SUM(Quantity) AS total_quantity,
    ROUND(AVG(Quantity), 2) AS avg_quantity
FROM Orders
GROUP BY Product_ID
HAVING COUNT(*) > 3;

-- 5.3. Общая стоимость продаж по категориям (через JOIN)
SELECT 
    p.Category,
    COUNT(o.ID) AS total_orders,
    SUM(o.Quantity) AS total_items_sold,
    ROUND(SUM(o.Quantity * p.Price), 2) AS total_revenue
FROM Orders o
JOIN Products p ON o.Product_ID = p.ID
GROUP BY p.Category
ORDER BY total_revenue DESC;

-- ----------------------------------------------------------------------------
-- LIKE / поиск по шаблону (case-insensitive через UPPER)
-- Примечание: UPPER() в SQLite работает только с ASCII (английские буквы)!
-- Для русского языка используйте LIKE без UPPER или COLLATE NOCASE
-- ----------------------------------------------------------------------------

-- 6.1. Товары, название которых начинается на "Б"
-- Примечание: UPPER() в SQLite работает только с ASCII, для русского языка используйте LIKE
SELECT Name, Price, Category
FROM Products
WHERE Name LIKE 'Б%';

-- 6.2. Товары категории "Книги" (без UPPER, т.к. SQLite не поддерживает русский регистр)
-- Примечание: UPPER() в SQLite работает только с ASCII, для русского языка используйте LIKE
SELECT Name, Price, Category
FROM Products
WHERE Category LIKE '%Книг%';

-- 6.3. Товары с артикулом ART-99XXX
SELECT Name, SKU, Price
FROM Products
WHERE SKU LIKE 'ART-99%';


-- ----------------------------------------------------------------------------
-- JOIN: сводная выборка заказов с названием товара
-- ----------------------------------------------------------------------------

-- 7.1. Все заказы с названиями товаров
SELECT 
    o.ID AS order_id,
    p.Name AS product_name,
    p.Category,
    o.Quantity,
    o.Order_Date,
    ROUND(p.Price * o.Quantity, 2) AS total_price
FROM Orders o
JOIN Products p ON o.Product_ID = p.ID
ORDER BY o.Order_Date DESC
LIMIT 20;

-- 7.2. Сводная выборка: сумма по категориям
SELECT 
    p.Category,
    COUNT(o.ID) AS order_count,
    SUM(o.Quantity) AS total_quantity,
    ROUND(SUM(o.Quantity * p.Price), 2) AS total_revenue,
    ROUND(AVG(p.Price), 2) AS avg_product_price
FROM Orders o
JOIN Products p ON o.Product_ID = p.ID
GROUP BY p.Category
ORDER BY total_revenue DESC;

-- 7.3. Товары без заказов (LEFT JOIN)
SELECT 
    p.ID,
    p.Name,
    p.Price,
    p.Category
FROM Products p
LEFT JOIN Orders o ON p.ID = o.Product_ID
WHERE o.ID IS NULL;

-- 7.4. Топ-5 товаров по количеству заказов
SELECT 
    p.Name,
    p.Category,
    COUNT(o.ID) AS order_count,
    SUM(o.Quantity) AS total_sold
FROM Products p
JOIN Orders o ON p.ID = o.Product_ID
GROUP BY p.ID, p.Name, p.Category
ORDER BY order_count DESC
LIMIT 5;

-- 7.5. Полная статистика с LEFT JOIN (все товары, даже без заказов)
SELECT 
    p.Name,
    p.Category,
    p.Price,
    COUNT(o.ID) AS orders_count,
    COALESCE(SUM(o.Quantity), 0) AS total_quantity,
    COALESCE(ROUND(SUM(o.Quantity * p.Price), 2), 0) AS revenue
FROM Products p
LEFT JOIN Orders o ON p.ID = o.Product_ID
GROUP BY p.ID, p.Name, p.Category, p.Price
ORDER BY revenue DESC;

-- ============================================================================
-- ЧАСТЬ 3: БЕЗОПАСНОСТЬ (МИНИ-ДЕМО)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- НЕБЕЗОПАСНЫЙ ВАРИАНТ (конкатенация строк) - НИКОГДА ТАК НЕ ДЕЛАЙТЕ!
-- ----------------------------------------------------------------------------

-- В Python это выглядело бы так (ОПАСНО!):
-- user_input = "1 OR 1=1"
-- query = f"SELECT * FROM Products WHERE ID = {user_input}"
-- Результат: SELECT * FROM Products WHERE ID = 1 OR 1=1
-- → Получим ВСЕ товары! SQL-инъекция!

-- ----------------------------------------------------------------------------
-- БЕЗОПАСНЫЙ ВАРИАНТ (параметризованный запрос)
-- ----------------------------------------------------------------------------

-- В Python это выглядит так (БЕЗОПАСНО!):
-- user_input = "1 OR 1=1"
-- cursor.execute("SELECT * FROM Products WHERE ID = ?", (user_input,))
-- → SQLite корректно обработает ввод как строку, а не SQL-код

-- Пример параметризованного запроса в SQL (показать, как это работает):
-- Пользователь ищет товар по SKU
SELECT * FROM Products WHERE SKU = ?;
-- Значение подставляется через параметр, а не конкатенацию

-- Пример с несколькими параметрами
SELECT Name, Price 
FROM Products 
WHERE Category = ? AND Price BETWEEN ? AND ?;
-- Параметры: ('Электроника', 1000, 10000)

-- ============================================================================
-- ЧАСТЬ 4: ДОПОЛНИТЕЛЬНЫЕ ЗАПРОСЫ ДЛЯ ПРАКТИКИ
-- ============================================================================

-- 8.1. Подзапрос: товары дороже средней цены
SELECT Name, Price, Category
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- 8.2. HAVING с несколькими условиями
SELECT 
    Category,
    COUNT(*) AS count,
    ROUND(AVG(Price), 2) AS avg_price
FROM Products
GROUP BY Category
HAVING COUNT(*) > 5 AND AVG(Price) > 10000;

-- 8.3. LEFT JOIN с агрегацией
SELECT 
    p.Category,
    p.Name AS product_name,
    p.Price,
    COUNT(o.ID) AS orders,
    SUM(o.Quantity) AS sold
FROM Products p
LEFT JOIN Orders o ON p.ID = o.Product_ID
GROUP BY p.Category, p.Name , p.Price
HAVING COUNT(o.ID) > 0
ORDER BY sold DESC;


-- ============================================================================
-- КОНЕЦ ФАЙЛА
-- ============================================================================