-- ============================================================================
-- SELECT в SQL: Полное руководство с примерами (SQLite)
-- ============================================================================
-- База данных: learning.db
-- Таблица: Products (должна существовать из test_insert.py)
-- ============================================================================

-- ============================================================================
-- РАЗДЕЛ 1: БАЗОВЫЙ СИНТАКСИС SELECT
-- ============================================================================

-- 1.1. Выбор всех колонок из таблицы
-- Звёздочка (*) означает "все колонки"
SELECT * FROM Products;

-- 1.2. Выбор конкретных колонок
-- Рекомендуется указывать только нужные колонки вместо *
SELECT Name, Price, SKU FROM Products;

-- 1.3. Выбор с алиасами (псевдонимами) для колонок
SELECT 
    Name AS Товар,
    Price AS Цена,
    SKU AS Артикул
FROM Products;

-- 1.4. Уникальные значения (DISTINCT)
-- Показывает только уникальные категории
SELECT DISTINCT Category FROM Products;

-- ============================================================================
-- РАЗДЕЛ 2: ФИЛЬТРАЦИЯ ДАННЫХ (WHERE)
-- ============================================================================

-- 2.1. Простое условие с оператором =
SELECT Name, Price, Category
FROM Products
WHERE Category = 'Электроника';

-- 2.2. Условия неравенства (!= или <>)
SELECT Name, Price, Category
FROM Products
WHERE Category != 'Книги';

-- 2.3. Больше / Меньше (>, <, >=, <=)
-- Товары дороже 50000 ₽
SELECT Name, Price, Category
FROM Products
WHERE Price > 50000;

-- Товары дешевле 1000 ₽
SELECT Name, Price
FROM Products
WHERE Price < 1000;

-- 2.4. BETWEEN - диапазон значений (включая границы)
-- Товары от 5000 до 15000 ₽
SELECT Name, Price
FROM Products
WHERE Price BETWEEN 5000 AND 15000;

-- 2.5. IN - значение в списке
-- Товары из нескольких категорий
SELECT Name, Category, Price
FROM Products
WHERE Category IN ('Книги', 'Мебель', 'Спорт и отдых');

-- 2.6. LIKE - поиск по шаблону
-- Товары, название которых содержит "наушники"
SELECT Name, Price
FROM Products
WHERE Name LIKE '%наушники%';

-- Товары, начинающиеся на "Смарт"
SELECT Name, Price
FROM Products
WHERE Name LIKE 'Смарт%';

-- Товары, заканчивающиеся на "Мяч"
SELECT Name, Price
FROM Products
WHERE Name LIKE '%Мяч';

-- Товары с артикулом ART-000X (где X - любая цифра)
SELECT Name, SKU
FROM Products
WHERE SKU LIKE 'ART-000_';

-- 2.7. IS NULL и IS NOT NULL
-- Товары без описания
SELECT Name, SKU, Description
FROM Products
WHERE Description IS NULL;

-- Товары с описанием
SELECT Name, SKU
FROM Products
WHERE Description IS NOT NULL;

-- 2.8. AND - оба условия должны быть истинны
SELECT Name, Price, Category
FROM Products
WHERE Category = 'Электроника' AND Price > 30000;

-- 2.9. OR - хотя бы одно условие истинно
SELECT Name, Price, Category
FROM Products
WHERE Category = 'Книги' OR Category = 'Мебель';

-- 2.10. NOT - отрицание
-- Товары НЕ из категории "Книги"
SELECT Name, Category
FROM Products
WHERE Category NOT IN ('Книги', 'Мебель');

-- 2.11. Комбинированные условия с скобками
SELECT Name, Price, Category
FROM Products
WHERE (Category = 'Электроника' OR Category = 'Бытовая техника')
  AND Price BETWEEN 5000 AND 50000;

-- ============================================================================
-- РАЗДЕЛ 3: СОРТИРОВКА (ORDER BY)
-- ============================================================================

-- 3.1. Сортировка по возрастанию (ASC - по умолчанию)
SELECT Name, Price
FROM Products
ORDER BY Price ASC;

-- 3.2. Сортировка по убыванию (DESC)
-- Самые дорогие товары
SELECT Name, Price
FROM Products
ORDER BY Price DESC;

-- 3.3. Сортировка по названию (алфавит)
SELECT Name, Category, Price
FROM Products
ORDER BY Name ASC;

-- 3.4. Сортировка по нескольким колонкам
-- Сначала по категории, внутри категории - по цене (убывание)
SELECT Name, Category, Price
FROM Products
ORDER BY Category ASC, Price DESC;

-- 3.5. Сортировка по вычисляемому полю
SELECT 
    Name,
    Price,
    ROUND(Price * 1.10, 2) AS PriceWithTax
FROM Products
ORDER BY PriceWithTax DESC;

-- ============================================================================
-- РАЗДЕЛ 4: ОГРАНИЧЕНИЕ РЕЗУЛЬТАТОВ (LIMIT и OFFSET)
-- ============================================================================

-- 4.1. Ограничение количества строк
-- Первые 5 товаров
SELECT * FROM Products LIMIT 5;

-- 4.2. TOP N с сортировкой
-- 10 самых дорогих товаров
SELECT Name, Price, Category
FROM Products
ORDER BY Price DESC
LIMIT 10;

-- 4.3. Пагинация: пропуск N строк, взять M
-- Строки с 21 по 30 (пропускаем 20, берём 10)
SELECT Name, Price
FROM Products
LIMIT 10 OFFSET 20;

-- 4.4. Пагинация: следующая страница по 50 записей
-- Пропускаем первые 50, берём следующие 50
SELECT Name, SKU
FROM Products
LIMIT 50 OFFSET 50;

-- 4.5. 5 самых дешёвых товаров
SELECT Name, Price
FROM Products
ORDER BY Price ASC
LIMIT 5;

-- ============================================================================
-- РАЗДЕЛ 5: АГРЕГАЦИОННЫЕ ФУНКЦИИ
-- ============================================================================

-- 5.1. COUNT - подсчёт количества строк
-- Общее количество товаров
SELECT COUNT(*) AS TotalProducts FROM Products;

-- Количество товаров в конкретной категории
SELECT COUNT(*) AS ElectronicsCount
FROM Products
WHERE Category = 'Электроника';

-- 5.2. SUM - сумма значений
-- Общая стоимость всех товаров (сумма всех цен)
SELECT SUM(Price) AS TotalInventoryValue FROM Products;

-- 5.3. AVG - среднее значение
-- Средняя цена всех товаров
SELECT AVG(Price) AS AvgPrice FROM Products;

-- 5.4. ROUND с AVG - среднее с округлением
SELECT ROUND(AVG(Price), 2) AS AvgPrice FROM Products;

-- 5.5. MIN - минимальное значение
SELECT MIN(Price) AS MinPrice FROM Products;

-- 5.6. MAX - максимальное значение
SELECT MAX(Price) AS MaxPrice FROM Products;

-- 5.7. Диапазон цен (MIN, MAX, разница)
SELECT 
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice,
    ROUND(MAX(Price) - MIN(Price), 2) AS PriceRange
FROM Products;

-- 5.8. Полная статистика в одном запросе
SELECT 
    COUNT(*) AS TotalCount,
    ROUND(AVG(Price), 2) AS AvgPrice,
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice,
    ROUND(SUM(Price), 2) AS TotalValue
FROM Products;

-- 5.9. COUNT с DISTINCT - уникальные значения
-- Количество уникальных названий товаров
SELECT COUNT(DISTINCT Name) AS UniqueProductNames FROM Products;

-- 5.10. GROUP_CONCAT - объединение строк в одну
-- Все названия товаров через запятую (ограничим 100 символами)
SELECT SUBSTR(GROUP_CONCAT(Name, ', '), 1, 100) || '...' AS AllProducts
FROM Products;

-- ============================================================================
-- РАЗДЕЛ 6: ГРУППИРОВКА (GROUP BY)
-- ============================================================================

-- 6.1. Количество товаров в каждой категории
SELECT 
    Category,
    COUNT(*) AS ProductCount
FROM Products
GROUP BY Category;

-- 6.2. Статистика цен по категориям
SELECT 
    Category,
    COUNT(*) AS Count,
    ROUND(AVG(Price), 2) AS AvgPrice,
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

-- 6.3. Сортировка групп по количеству
SELECT 
    Category,
    COUNT(*) AS Count,
    ROUND(AVG(Price), 2) AS AvgPrice
FROM Products
GROUP BY Category
ORDER BY Count DESC;

-- 6.4. Общая стоимость товаров по категориям
SELECT 
    Category,
    ROUND(SUM(Price), 2) AS TotalValue
FROM Products
GROUP BY Category
ORDER BY TotalValue DESC;

-- 6.5. GROUP BY с WHERE (фильтрация ДО группировки)
-- Статистика только для "Электроники"
SELECT 
    Category,
    COUNT(*) AS Count,
    ROUND(AVG(Price), 2) AS AvgPrice
FROM Products
WHERE Price > 10000
GROUP BY Category;

-- 6.6. HAVING - фильтрация групп ПОСЛЕ группировки
-- Категории с количеством товаров больше 100
SELECT 
    Category,
    COUNT(*) AS Count
FROM Products
GROUP BY Category
HAVING COUNT(*) > 100;

-- 6.7. HAVING с другими условиями
-- Категории со средней ценой выше 50000
SELECT 
    Category,
    ROUND(AVG(Price), 2) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 50000;

-- 6.8. WHERE + HAVING вместе
-- Фильтруем строки, группируем, фильтруем группы
SELECT 
    Category,
    COUNT(*) AS Count,
    ROUND(AVG(Price), 2) AS AvgPrice
FROM Products
WHERE Price > 5000              -- Фильтр строк ДО группировки
GROUP BY Category
HAVING COUNT(*) > 50;           -- Фильтр групп ПОСЛЕ группировки

-- ============================================================================
-- РАЗДЕЛ 7: ПОДЗАПРОСЫ (SUBQUERIES)
-- ============================================================================

-- 7.1. Подзапрос в WHERE (возвращает одно значение)
-- Товары дороже средней цены
SELECT Name, Price, Category
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- 7.2. Подзапрос с IN (возвращает список)
-- Товары из категорий, где средняя цена > 50000
SELECT Name, Price, Category
FROM Products
WHERE Category IN (
    SELECT Category
    FROM Products
    GROUP BY Category
    HAVING AVG(Price) > 50000
);

-- 7.3. Подзапрос в SELECT
-- Каждый товар со средней ценой и разницей от неё
SELECT 
    Name,
    Price,
    (SELECT ROUND(AVG(Price), 2) FROM Products) AS AvgPrice,
    ROUND(
        Price - (SELECT AVG(Price) FROM Products), 
        2
    ) AS DiffFromAvg
FROM Products
LIMIT 10;

-- 7.4. Подзапрос в FROM (вложенная таблица)
SELECT Category, AvgPrice
FROM (
    SELECT Category, ROUND(AVG(Price), 2) AS AvgPrice
    FROM Products
    GROUP BY Category
) AS CategoryStats
WHERE AvgPrice > 40000
ORDER BY AvgPrice DESC;

-- 7.5. EXISTS - проверка существования строк
-- (Пример с гипотетической таблицей Categories)
-- SELECT Name
-- FROM Categories c
-- WHERE EXISTS (
--     SELECT 1 FROM Products p WHERE p.Category = c.Name
-- );

-- 7.6. Коррелированный подзапрос
-- Самый дорогой товар в каждой категории
SELECT 
    p1.Name,
    p1.Price,
    p1.Category
FROM Products p1
WHERE p1.Price = (
    SELECT MAX(p2.Price) 
    FROM Products p2 
    WHERE p2.Category = p1.Category
)
ORDER BY p1.Price DESC;

-- ============================================================================
-- РАЗДЕЛ 8: СОЗДАНИЕ И ЗАПОЛНЕНИЕ ТАБЛИЦЫ CATEGORIES
-- ============================================================================

-- 8.1. Создание таблицы Categories
CREATE TABLE IF NOT EXISTS Categories (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE,
    Description TEXT,
    CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP
);

-- 8.2. Вставка данных в Categories
INSERT INTO Categories (Name, Description) VALUES
    ('Электроника', 'Технические устройства и гаджеты'),
    ('Книги', 'Литература и учебные материалы'),
    ('Мебель', 'Предметы мебели для дома и офиса'),
    ('Инструменты', 'Строительные и ремонтные инструменты'),
    ('Одежда и аксессуары', 'Одежда, обувь и аксессуары'),
    ('Спорт и отдых', 'Спортивное снаряжение и товары для отдыха'),
    ('Для дома', 'Товары для домашнего хозяйства'),
    ('Бытовая техника', 'Электрические приборы для дома'),
    ('Автомобильные', 'Аксессуары и запчасти для авто'),
    ('Косметика и здоровье', 'Косметика и товары для здоровья');

-- 8.3. Проверка вставленных данных
SELECT * FROM Categories;

-- ============================================================================
-- РАЗДЕЛ 9: JOIN - ОБЪЕДИНЕНИЕ ТАБЛИЦ
-- ============================================================================

-- 9.1. INNER JOIN - только совпадающие строки
SELECT 
    p.Name AS Product,
    p.Price,
    p.SKU,
    c.Name AS Category,
    c.Description AS CategoryDescription
FROM Products p
INNER JOIN Categories c ON p.Category = c.Name
LIMIT 10;

-- 9.2. LEFT JOIN - все строки из левой таблицы + совпадения из правой
SELECT 
    p.Name AS Product,
    p.Category,
    c.Description AS CategoryDesc
FROM Products p
LEFT JOIN Categories c ON p.Category = c.Name
LIMIT 10;

-- 9.3. LEFT JOIN: Товары без категорий (NULL в правой таблице)
SELECT 
    p.Name,
    p.Price,
    p.Category
FROM Products p
LEFT JOIN Categories c ON p.Category = c.Name
WHERE c.ID IS NULL;

-- 9.4. RIGHT JOIN - все строки из правой таблицы + совпадения из левой
SELECT 
    c.Name AS Category,
    c.Description,
    p.Name AS Product,
    p.Price
FROM Products p
RIGHT JOIN Categories c ON p.Category = c.Name
LIMIT 10;

-- 9.5. RIGHT JOIN: Пустые категории (без товаров)
SELECT 
    c.Name AS Category,
    c.Description
FROM Products p
RIGHT JOIN Categories c ON p.Category = c.Name
WHERE p.ID IS NULL;

-- 9.6. FULL JOIN через UNION (SQLite не поддерживает напрямую)
SELECT 
    p.Name AS Product,
    p.Price,
    c.Name AS Category
FROM Products p
LEFT JOIN Categories c ON p.Category = c.Name

UNION ALL

SELECT 
    p.Name AS Product,
    p.Price,
    c.Name AS Category
FROM Products p
RIGHT JOIN Categories c ON p.Category = c.Name
WHERE p.ID IS NULL;

-- 9.7. Агрегация с JOIN
-- Количество товаров и общая стоимость по категориям
SELECT 
    c.Name AS Category,
    c.Description,
    COUNT(p.ID) AS ProductCount,
    ROUND(SUM(p.Price), 2) AS TotalValue,
    ROUND(AVG(p.Price), 2) AS AvgPrice
FROM Categories c
LEFT JOIN Products p ON c.Name = p.Category
GROUP BY c.ID, c.Name, c.Description
ORDER BY ProductCount DESC;

-- 9.8. Множественный JOIN (три таблицы)
-- Создаём таблицу Suppliers
CREATE TABLE IF NOT EXISTS Suppliers (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Country TEXT,
    Phone TEXT
);

-- Вставляем поставщиков
INSERT INTO Suppliers (Name, Country, Phone) VALUES
    ('TechCorp', 'Китай', '+86-123-4567'),
    ('BookWorld', 'Россия', '+7-495-123-4567'),
    ('HomeStyle', 'Италия', '+39-123-456789');

-- Добавляем колонку SupplierID в Products (если не существует)
-- ALTER TABLE Products ADD COLUMN SupplierID INTEGER;

-- Обновляем SupplierID
-- UPDATE Products SET SupplierID = 1 WHERE Category = 'Электроника';
-- UPDATE Products SET SupplierID = 2 WHERE Category = 'Книги';
-- UPDATE Products SET SupplierID = 3 WHERE Category = 'Мебель';

-- Тройной JOIN: Товары + Категории + Поставщики
-- SELECT 
--     p.Name AS Product,
--     p.Price,
--     c.Name AS Category,
--     s.Name AS Supplier,
--     s.Country
-- FROM Products p
-- LEFT JOIN Categories c ON p.Category = c.Name
-- LEFT JOIN Suppliers s ON p.SupplierID = s.ID
-- WHERE s.Name IS NOT NULL
-- LIMIT 10;

-- 9.9. CROSS JOIN - декартово произведение (все комбинации)
-- (Ограничим вывод для примера)
-- SELECT 
--     c.Name AS Category,
--     'Товар_' || p.ID AS Product
-- FROM Categories c
-- CROSS JOIN Products p
-- LIMIT 20;

-- ============================================================================
-- РАЗДЕЛ 10: ПРАКТИЧЕСКИЕ ЗАПРОСЫ
-- ============================================================================

-- 10.1. Топ-10 самых дорогих товаров с категорией
SELECT 
    p.Name,
    p.Price,
    p.SKU,
    c.Description
FROM Products p
LEFT JOIN Categories c ON p.Category = c.Name
ORDER BY p.Price DESC
LIMIT 10;

-- 10.2. Категории с товарами дороже 50000 ₽
SELECT 
    Category,
    COUNT(*) AS ExpensiveCount,
    ROUND(SUM(Price), 2) AS TotalValue
FROM Products
WHERE Price > 50000
GROUP BY Category
ORDER BY ExpensiveCount DESC;

-- 10.3. Товары в 2 раза дороже средней цены
SELECT 
    Name,
    Price,
    Category
FROM Products
WHERE Price > 2 * (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;

-- 10.4. Среднее отклонение цены от категории
SELECT 
    p.Name,
    p.Price,
    p.Category,
    ROUND(c.AvgPrice, 2) AS CategoryAvgPrice,
    ROUND(p.Price - c.AvgPrice, 2) AS DiffFromCategoryAvg
FROM Products p
INNER JOIN (
    SELECT Category, AVG(Price) AS AvgPrice
    FROM Products
    GROUP BY Category
) c ON p.Category = c.Category
ORDER BY DiffFromCategoryAvg DESC
LIMIT 10;

-- 10.5. Поиск по нескольким условиям
SELECT 
    Name,
    Price,
    Category,
    SKU
FROM Products
WHERE (Price BETWEEN 1000 AND 10000)
  AND (Name LIKE '%книг%' OR Name LIKE '%мяч%' OR Name LIKE '%стул%')
ORDER BY Price ASC;

-- 10.6. Статистика для отчёта
SELECT 
    'Всего товаров' AS Metric,
    COUNT(*) AS Value
FROM Products

UNION ALL

SELECT 
    'Средняя цена',
    ROUND(AVG(Price), 2)
FROM Products

UNION ALL

SELECT 
    'Общая стоимость',
    ROUND(SUM(Price), 2)
FROM Products

UNION ALL

SELECT 
    'Количество категорий',
    COUNT(DISTINCT Category)
FROM Products;

-- ============================================================================
-- РАЗДЕЛ 11: УПРАЖНЕНИЯ ДЛЯ ПРАКТИКИ
-- ============================================================================

-- Упражнение 1: Найдите 5 товаров с ценой от 5000 до 15000 ₽
-- Решение:
SELECT Name, Price, Category
FROM Products
WHERE Price BETWEEN 5000 AND 15000
LIMIT 5;

-- Упражнение 2: Посчитайте количество товаров в каждой категории со средней ценой
-- Решение:
SELECT 
    Category,
    COUNT(*) AS Count,
    ROUND(AVG(Price), 2) AS AvgPrice
FROM Products
GROUP BY Category;

-- Упражнение 3: Найдите товары дороже средней цены в их категории
-- Решение:
SELECT 
    p.Name,
    p.Price,
    p.Category
FROM Products p
WHERE p.Price > (
    SELECT AVG(Price) 
    FROM Products 
    WHERE Category = p.Category
)
LIMIT 10;

-- Упражнение 4: Найдите категории, где больше 100 товаров
-- Решение:
SELECT 
    Category,
    COUNT(*) AS Count
FROM Products
GROUP BY Category
HAVING COUNT(*) > 100;

-- Упражнение 5: Найдите 3 самых дешёвых товара в каждой категории
-- Решение (коррелированный подзапрос):
SELECT 
    p1.Name,
    p1.Price,
    p1.Category
FROM Products p1
WHERE (
    SELECT COUNT(*) 
    FROM Products p2 
    WHERE p2.Category = p1.Category AND p2.Price < p1.Price
) < 3
ORDER BY p1.Category, p1.Price;

-- ============================================================================
-- РАЗДЕЛ 12: ОЧИСТКА ДАННЫХ (ПО ТРЕБОВАНИЮ)
-- ============================================================================

-- Удалить таблицу Categories
-- DROP TABLE IF EXISTS Categories;

-- Удалить таблицу Suppliers
-- DROP TABLE IF EXISTS Suppliers;

-- Очистить таблицу Products
-- DELETE FROM Products;

-- Сбросить автоинкремент
-- DELETE FROM sqlite_sequence WHERE name = 'Products';

-- ============================================================================
-- КОНЕЦ СКРИПТА
-- ============================================================================
