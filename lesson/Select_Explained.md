# SELECT в SQL: Выборка данных и JOIN (SQLite)

Этот документ подробно объясняет оператор `SELECT`, все его варианты синтаксиса, а также работу с JOIN для объединения таблиц.

**Путь к базе данных:** `C:\projects\Modul-3\VPc04_learning\learning.db`

---

## Содержание

1. [Создание связанной таблицы](#создание-связанной-таблицы)
2. [Базовый оператор SELECT](#базовый-оператор-select)
3. [Фильтрация данных (WHERE)](#фильтрация-данных-where)
4. [Сортировка (ORDER BY)](#сортировка-order-by)
5. [Ограничение результатов (LIMIT)](#ограничение-результатов-limit)
6. [Агрегационные функции](#агрегационные-функции)
7. [Группировка (GROUP BY)](#группировка-group-by)
8. [Фильтрация групп (HAVING)](#фильтрация-групп-having)
9. [Подзапросы](#подзапросы)
10. [Типы JOIN](#типы-join)
11. [Практические примеры JOIN](#практические-примеры-join)

---

## Создание связанной таблицы

Для демонстрации JOIN создадим таблицу категорий с связью "один-ко-многим" с таблицей Products.

### Схема связи:

```
Categories (1) ────< Products (Many)
     ID                  Category (FK)
```

### SQL-скрипт создания таблицы Categories:

```sql
CREATE TABLE IF NOT EXISTS Categories (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE,
    Description TEXT,
    CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP
);
```

### Вставка данных в Categories:

```sql
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
```

### Пояснение синтаксиса:

| Оператор | Описание |
|----------|----------|
| `CREATE TABLE IF NOT EXISTS` | Создаёт таблицу только если её нет |
| `ID INTEGER PRIMARY KEY AUTOINCREMENT` | Уникальный идентификатор с автоинкрементом |
| `Name TEXT NOT NULL UNIQUE` | Имя категории — обязательно и уникально |
| `Description TEXT` | Описание категории (может быть NULL) |
| `DEFAULT CURRENT_TIMESTAMP` | Автоматическая дата создания записи |
| `INSERT INTO ... VALUES` | Вставка данных в таблицу |
| `(), (), ()` | Множественная вставка нескольких строк |

---

## Базовый оператор SELECT

### Синтаксис:

```sql
SELECT колонка1, колонка2, ...
FROM таблица
WHERE условие
ORDER BY колонка [ASC|DESC]
LIMIT количество;
```

### Простые примеры:

```sql
-- 1. Выбрать все колонки из таблицы
SELECT * FROM Products;

-- 2. Выбрать конкретные колонки
SELECT Name, Price, SKU FROM Products;

-- 3. Выбрать из таблицы Categories
SELECT * FROM Categories;

-- 4. Выбрать только названия категорий
SELECT Name FROM Categories;
```

### Пояснение операторов:

| Оператор | Описание |
|----------|----------|
| `SELECT` | Ключевое слово для начала запроса на выборку |
| `*` | Звёздочка — все колонки таблицы |
| `kolonka1, kolonka2` | Конкретные колонки через запятую |
| `FROM` | Ключевое слово перед именем таблицы |
| `FROM Products` | Таблица, из которой выбираем данные |

---

## Фильтрация данных (WHERE)

### Синтаксис WHERE:

```sql
SELECT колонки
FROM таблица
WHERE условие;
```

### Операторы сравнения:

| Оператор | Описание | Пример |
|----------|----------|--------|
| `=` | Равно | `WHERE Price = 1000` |
| `!=` или `<>` | Не равно | `WHERE Category != 'Книги'` |
| `>` | Больше | `WHERE Price > 5000` |
| `<` | Меньше | `WHERE Price < 100` |
| `>=` | Больше или равно | `WHERE Price >= 1000` |
| `<=` | Меньше или равно | `WHERE Price <= 50000` |
| `LIKE` | По шаблону | `WHERE Name LIKE '%смарт%'` |
| `IN` | В списке | `WHERE Category IN ('Книги', 'Мебель')` |
| `BETWEEN` | В диапазоне | `WHERE Price BETWEEN 1000 AND 10000` |
| `IS NULL` | NULL значение | `WHERE Description IS NULL` |
| `IS NOT NULL` | Не NULL | `WHERE Price IS NOT NULL` |

### Примеры WHERE:

```sql
-- 1. Товары с ценой больше 50000
SELECT Name, Price, SKU
FROM Products
WHERE Price > 50000;

-- 2. Товары из конкретной категории
SELECT Name, Price
FROM Products
WHERE Category = 'Электроника';

-- 3. Товары по шаблону названия
SELECT Name, Price
FROM Products
WHERE Name LIKE '%наушники%';

-- 4. Товары из нескольких категорий
SELECT Name, Category, Price
FROM Products
WHERE Category IN ('Книги', 'Мебель', 'Спорт и отдых');

-- 5. Товары в ценовом диапазоне
SELECT Name, Price
FROM Products
WHERE Price BETWEEN 1000 AND 10000;

-- 6. Товары без описания
SELECT Name, SKU
FROM Products
WHERE Description IS NULL;

-- 7. Сложное условие (AND)
SELECT Name, Price, Category
FROM Products
WHERE Category = 'Электроника' AND Price > 30000;

-- 8. Сложное условие (OR)
SELECT Name, Price, Category
FROM Products
WHERE Category = 'Книги' OR Category = 'Мебель';

-- 9. Исключение из условия (NOT)
SELECT Name, Price, Category
FROM Products
WHERE Category NOT IN ('Книги', 'Мебель');

-- 10. Комбинированные условия
SELECT Name, Price, Category
FROM Products
WHERE (Category = 'Электроника' OR Category = 'Бытовая техника')
  AND Price BETWEEN 5000 AND 50000;
```

### Операторы логики:

| Оператор | Описание |
|----------|----------|
| `AND` | Истина, если оба условия истинны |
| `OR` | Истина, если хотя бы одно условие истинно |
| `NOT` | Отрицание условия |
| `AND NOT` | Первое условие истинно, второе ложно |

---

## Сортировка (ORDER BY)

### Синтаксис:

```sql
SELECT колонки
FROM таблица
ORDER BY колонка [ASC | DESC];
```

### Примеры сортировки:

```sql
-- 1. Сортировка по возрастанию (по умолчанию)
SELECT Name, Price
FROM Products
ORDER BY Price ASC;

-- 2. Сортировка по убыванию
SELECT Name, Price
FROM Products
ORDER BY Price DESC;

-- 3. Сортировка по названию
SELECT Name, Category, Price
FROM Products
ORDER BY Name ASC;

-- 4. Сортировка по нескольким колонкам
SELECT Name, Category, Price
FROM Products
ORDER BY Category ASC, Price DESC;
-- Сначала по категории (по алфавиту), потом внутри категории по цене (убывание)

-- 5. Сортировка с ограничением (TOP N)
SELECT Name, Price
FROM Products
ORDER BY Price DESC
LIMIT 10;
-- 10 самых дорогих товаров

-- 6. Сортировка по вычисляемому полю
SELECT Name, Price, ROUND(Price * 1.10, 2) AS PriceWithTax
FROM Products
ORDER BY PriceWithTax DESC;
```

### Ключевые слова сортировки:

| Ключевое слово | Описание |
|----------------|----------|
| `ASC` | По возрастанию (A-Z, 0-9) — по умолчанию |
| `DESC` | По убыванию (Z-A, 9-0) |
| `ORDER BY` | Начало сортировки |

---

## Ограничение результатов (LIMIT)

### Синтаксис:

```sql
SELECT колонки
FROM таблица
LIMIT количество;

-- Или с пропуском строк
SELECT колонки
FROM таблица
LIMIT смещение, количество;
```

### Примеры:

```sql
-- 1. Первые 5 товаров
SELECT * FROM Products LIMIT 5;

-- 2. Первые 10 самых дорогих
SELECT Name, Price
FROM Products
ORDER BY Price DESC
LIMIT 10;

-- 3. Пагинация: строки 21-30
SELECT * FROM Products LIMIT 10 OFFSET 20;

-- 4. Пагинация: следующая страница по 50 записей
SELECT * FROM Products LIMIT 50 OFFSET 50;
-- OFFSET 50 пропускает первые 50, LIMIT 50 берёт следующие 50

-- 5. Последние товары (сначала сортировка)
SELECT Name, ID
FROM Products
ORDER BY ID DESC
LIMIT 5;
```

### Операторы LIMIT:

| Оператор | Описание |
|----------|----------|
| `LIMIT n` | Вернуть только первые n строк |
| `OFFSET n` | Пропустить первые n строк |
| `LIMIT n OFFSET m` | Пропустить m, вернуть n |

---

## Агрегационные функции

Агрегационные функции вычисляют одно значение по множеству строк.

### Основные функции:

| Функция | Описание | Пример |
|---------|----------|--------|
| `COUNT(*)` | Количество строк | `SELECT COUNT(*) FROM Products` |
| `COUNT(колонка)` | Количество непустых значений | `SELECT COUNT(Name) FROM Products` |
| `SUM(колонка)` | Сумма значений | `SELECT SUM(Price) FROM Products` |
| `AVG(колонка)` | Среднее значение | `SELECT AVG(Price) FROM Products` |
| `MIN(колонка)` | Минимальное значение | `SELECT MIN(Price) FROM Products` |
| `MAX(колонка)` | Максимальное значение | `SELECT MAX(Price) FROM Products` |
| `GROUP_CONCAT()` | Объединение строк | `SELECT GROUP_CONCAT(Name)` |

### Примеры агрегации:

```sql
-- 1. Общее количество товаров
SELECT COUNT(*) AS TotalProducts FROM Products;

-- 2. Количество товаров в категории "Электроника"
SELECT COUNT(*) AS ElectronicsCount
FROM Products
WHERE Category = 'Электроника';

-- 3. Общая стоимость всех товаров (сумма цен)
SELECT SUM(Price) AS TotalValue FROM Products;

-- 4. Средняя цена всех товаров
SELECT AVG(Price) AS AvgPrice FROM Products;

-- 5. Средняя цена с округлением
SELECT ROUND(AVG(Price), 2) AS AvgPrice FROM Products;

-- 6. Минимальная и максимальная цена
SELECT 
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice
FROM Products;

-- 7. Диапазон цен
SELECT 
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice,
    ROUND(MAX(Price) - MIN(Price), 2) AS PriceRange
FROM Products;

-- 8. Статистика по категории
SELECT 
    Category,
    COUNT(*) AS Count,
    ROUND(AVG(Price), 2) AS AvgPrice,
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice
FROM Products
WHERE Category = 'Электроника';

-- 9. Объединение названий в одну строку
SELECT GROUP_CONCAT(Name, ', ') AS AllProductNames
FROM Products
WHERE Category = 'Книги';

-- 10. Количество товаров с ценой выше средней
SELECT COUNT(*) AS ExpensiveProducts
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);
```

---

## Группировка (GROUP BY)

### Синтаксис:

```sql
SELECT колонка, агрегатная_функция(колонка)
FROM таблица
WHERE условие
GROUP BY колонка
HAVING условие_для_групп
ORDER BY колонка;
```

### Примеры GROUP BY:

```sql
-- 1. Количество товаров в каждой категории
SELECT 
    Category,
    COUNT(*) AS ProductCount
FROM Products
GROUP BY Category;

-- 2. Статистика цен по категориям
SELECT 
    Category,
    COUNT(*) AS Count,
    ROUND(AVG(Price), 2) AS AvgPrice,
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

-- 3. Категории с количеством товаров > 50
SELECT 
    Category,
    COUNT(*) AS Count
FROM Products
GROUP BY Category
HAVING COUNT(*) > 50;

-- 4. Категории со средней ценой > 50000
SELECT 
    Category,
    ROUND(AVG(Price), 2) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 50000;

-- 5. Сортировка групп по количеству
SELECT 
    Category,
    COUNT(*) AS Count,
    ROUND(AVG(Price), 2) AS AvgPrice
FROM Products
GROUP BY Category
ORDER BY Count DESC;

-- 6. Группировка с WHERE (фильтрация до группировки)
SELECT 
    Category,
    COUNT(*) AS Count
FROM Products
WHERE Price > 10000
GROUP BY Category;

-- 7. Количество уникальных названий в каждой категории
SELECT 
    Category,
    COUNT(DISTINCT Name) AS UniqueNames
FROM Products
GROUP BY Category;

-- 8. Общая стоимость товаров по категориям
SELECT 
    Category,
    ROUND(SUM(Price), 2) AS TotalValue
FROM Products
GROUP BY Category
ORDER BY TotalValue DESC;
```

### WHERE vs HAVING:

| Оператор | Когда применяется | Пример |
|----------|-------------------|--------|
| `WHERE` | До группировки — фильтрация строк | `WHERE Price > 1000` |
| `HAVING` | После группировки — фильтрация групп | `HAVING COUNT(*) > 10` |

```sql
-- Пример различия:
SELECT Category, COUNT(*) AS Count
FROM Products
WHERE Price > 50000           -- Фильтрует строки ДО группировки
GROUP BY Category
HAVING COUNT(*) > 5;          -- Фильтрует группы ПОСЛЕ группировки
```

---

## Подзапросы

Подзапрос — это SELECT внутри другого запроса.

### Типы подзапросов:

```sql
-- 1. Подзапрос в WHERE (возвращает одно значение)
SELECT Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);
-- Товары дороже средней цены

-- 2. Подзапрос с IN (возвращает список)
SELECT Name, Price, Category
FROM Products
WHERE Category IN (
    SELECT Name FROM Categories WHERE ID <= 5
);
-- Товары из первых 5 категорий

-- 3. Подзапрос в SELECT
SELECT 
    Name, 
    Price,
    (SELECT AVG(Price) FROM Products) AS AvgPrice,
    ROUND(Price - (SELECT AVG(Price) FROM Products), 2) AS DiffFromAvg
FROM Products;
-- Каждый товар со средней ценой и разницей от неё

-- 4. Подзапрос в FROM (вложенная таблица)
SELECT Category, AvgPrice
FROM (
    SELECT Category, ROUND(AVG(Price), 2) AS AvgPrice
    FROM Products
    GROUP BY Category
) AS CategoryStats
WHERE AvgPrice > 40000;

-- 5. Подзапрос с EXISTS
SELECT Name
FROM Categories c
WHERE EXISTS (
    SELECT 1 FROM Products p WHERE p.Category = c.Name
);
-- Категории, у которых есть товары

-- 6. Коррелированный подзапрос
SELECT 
    Name, 
    Price, 
    Category
FROM Products p1
WHERE Price = (
    SELECT MAX(Price) 
    FROM Products p2 
    WHERE p2.Category = p1.Category
);
-- Самый дорогой товар в каждой категории

-- 7. Подзапрос с JOIN
SELECT 
    p.Name,
    p.Price
FROM Products p
WHERE p.Category IN (
    SELECT c.Name 
    FROM Categories c 
    WHERE c.ID > 5
);
```

---

## Типы JOIN

JOIN используется для объединения строк из двух таблиц на основе связанного столбца.

### Предварительная подготовка:

```sql
-- Таблица Products уже существует с колонкой Category
-- Таблица Categories создана с колонкой ID и Name

-- Проверяем связь:
SELECT * FROM Categories;
SELECT DISTINCT Category FROM Products;
```

### Диаграммы JOIN:

```
INNER JOIN:     LEFT JOIN:        RIGHT JOIN:       FULL JOIN:
   A ││ B          A ││ B            A ││ B            A ││ B
   ──┼┼──          ──┼┼──            ──┼┼──            ──┼┼──
   ╔═╩═╗          ╔═╩═╗             ╔═╩═╗             ╔═╩═╗
   ║  ║║          ║  ║║             ║  ║║             ║  ║║
   ╚═╦═╝          ╚═╦═╝             ╚═╦═╝             ╚═╦═╝
     ║              ║                 ║                 ║
   Только         Всё из A          Всё из B          Всё из A
   пересечение    + NULL из B       + NULL из A       + Всё из B
```

### Типы JOIN:

| Тип JOIN | Описание |
|----------|----------|
| `INNER JOIN` | Только совпадающие строки из обеих таблиц |
| `LEFT JOIN` | Все строки из левой + совпадения из правой (или NULL) |
| `RIGHT JOIN` | Все строки из правой + совпадения из левой (или NULL) |
| `FULL JOIN` | Все строки из обеих таблиц (в SQLite через UNION) |
| `CROSS JOIN` | Декартово произведение (все комбинации) |

---

## Практические примеры JOIN

### 1. INNER JOIN — только совпадающие записи

```sql
-- Товары с их категориями (только если категория есть в таблице Categories)
SELECT 
    p.Name AS ProductName,
    p.Price,
    p.SKU,
    c.Name AS CategoryName,
    c.Description AS CategoryDescription
FROM Products p
INNER JOIN Categories c ON p.Category = c.Name;

-- Упрощённый синтаксис (JOIN = INNER JOIN)
SELECT p.Name, p.Price, c.Name AS Category
FROM Products p
JOIN Categories c ON p.Category = c.Name;
```

**Результат:** Только товары, у которых категория совпадает с Name в таблице Categories.

### 2. LEFT JOIN — все товары + категории (если есть)

```sql
-- Все товары и их категории (даже если категории нет в Categories)
SELECT 
    p.Name AS ProductName,
    p.Price,
    p.Category AS ProductCategory,
    c.Name AS CategoryName,
    c.Description
FROM Products p
LEFT JOIN Categories c ON p.Category = c.Name;

-- Товары без категорий (NULL в правой таблице)
SELECT 
    p.Name,
    p.Price,
    p.Category
FROM Products p
LEFT JOIN Categories c ON p.Category = c.Name
WHERE c.ID IS NULL;
```

**Результат:** Все товары из Products, категории подтянутся если совпадут.

### 3. RIGHT JOIN — все категории + товары (если есть)

```sql
-- Все категории и товары внутри них (даже пустые категории)
SELECT 
    c.Name AS CategoryName,
    c.Description,
    p.Name AS ProductName,
    p.Price
FROM Products p
RIGHT JOIN Categories c ON p.Category = c.Name;

-- Пустые категории (без товаров)
SELECT 
    c.Name AS CategoryName,
    c.Description
FROM Products p
RIGHT JOIN Categories c ON p.Category = c.Name
WHERE p.ID IS NULL;
```

**Результат:** Все категории из Categories, товары подтянутся если есть.

### 4. FULL JOIN — всё из обеих таблиц

```sql
-- SQLite не поддерживает FULL JOIN напрямую, используем UNION
SELECT 
    p.Name AS ProductName,
    p.Price,
    p.Category,
    c.Name AS CategoryName,
    c.Description
FROM Products p
LEFT JOIN Categories c ON p.Category = c.Name

UNION ALL

SELECT 
    p.Name AS ProductName,
    p.Price,
    p.Category,
    c.Name AS CategoryName,
    c.Description
FROM Products p
RIGHT JOIN Categories c ON p.Category = c.Name
WHERE p.ID IS NULL;
```

### 5. CROSS JOIN — все комбинации

```sql
-- Каждую категорию с каждым товаром (10 категорий × 1000 товаров = 10000 строк)
SELECT 
    c.Name AS Category,
    p.Name AS Product
FROM Categories c
CROSS JOIN Products p
LIMIT 20;  -- Ограничим для примера

-- Используется редко, в основном для генерации тестовых данных
```

### 6. Множественные JOIN (три и более таблицы)

Создадим третью таблицу для примера:

```sql
CREATE TABLE IF NOT EXISTS Suppliers (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Country TEXT,
    Phone TEXT
);

INSERT INTO Suppliers (Name, Country, Phone) VALUES
    ('TechCorp', 'Китай', '+86-123-4567'),
    ('BookWorld', 'Россия', '+7-495-123-4567'),
    ('HomeStyle', 'Италия', '+39-123-456789');
```

Теперь добавим связь с Products:

```sql
-- Добавим колонку SupplierID в Products (если нужно)
ALTER TABLE Products ADD COLUMN SupplierID INTEGER;

-- Обновим некоторых поставщиков
UPDATE Products SET SupplierID = 1 WHERE Category = 'Электроника';
UPDATE Products SET SupplierID = 2 WHERE Category = 'Книги';
UPDATE Products SET SupplierID = 3 WHERE Category = 'Мебель';
```

Теперь JOIN трёх таблиц:

```sql
-- Товары с категориями и поставщиками
SELECT 
    p.Name AS Product,
    p.Price,
    c.Name AS Category,
    c.Description AS CategoryDesc,
    s.Name AS Supplier,
    s.Country
FROM Products p
LEFT JOIN Categories c ON p.Category = c.Name
LEFT JOIN Suppliers s ON p.SupplierID = s.ID
WHERE p.Price > 10000
ORDER BY p.Price DESC
LIMIT 10;
```

### 7. Агрегация с JOIN

```sql
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
ORDER BY TotalValue DESC;

-- Поставщики и их товары
SELECT 
    s.Name AS Supplier,
    s.Country,
    COUNT(p.ID) AS ProductCount,
    ROUND(SUM(p.Price), 2) AS TotalInventoryValue
FROM Suppliers s
LEFT JOIN Products p ON s.ID = p.SupplierID
GROUP BY s.ID, s.Name, s.Country
HAVING COUNT(p.ID) > 0;
```

### 8. Подзапрос с JOIN

```sql
-- Категории с товарами дороже средней цены
SELECT 
    c.Name AS Category,
    p.Name AS ExpensiveProduct,
    p.Price
FROM Categories c
INNER JOIN Products p ON c.Name = p.Category
WHERE p.Price > (SELECT AVG(Price) FROM Products)
ORDER BY p.Price DESC;

-- Товары из категорий с общим запасом > 100000
SELECT 
    p.Name,
    p.Price,
    p.Category
FROM Products p
WHERE p.Category IN (
    SELECT Category 
    FROM Products 
    GROUP BY Category 
    HAVING SUM(Price) > 100000
);
```

---

## Сравнение типов JOIN

| Тип JOIN | Строки из левой | Строки из правой | Когда использовать |
|----------|-----------------|------------------|-------------------|
| `INNER` | Только совпадения | Только совпадения | Нужны только связанные данные |
| `LEFT` | Все | Только совпадения | Все товары + доп. информация |
| `RIGHT` | Только совпадения | Все | Все категории + товары |
| `FULL` | Все | Все | Полная картина по обеим таблицам |
| `CROSS` | Все | Все (комбинации) | Тестовые данные, матрицы |

---

## Практический скрипт Python для тестирования JOIN

```python
import sqlite3

def run_join_examples(db_path: str) -> None:
    """Выполняет примеры JOIN и выводит результаты."""
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    queries = [
        ("INNER JOIN: Товары с категориями", """
            SELECT p.Name, p.Price, c.Name AS Category
            FROM Products p
            INNER JOIN Categories c ON p.Category = c.Name
            LIMIT 5
        """),
        ("LEFT JOIN: Все товары + категории", """
            SELECT p.Name, p.Category, c.Description
            FROM Products p
            LEFT JOIN Categories c ON p.Category = c.Name
            LIMIT 5
        """),
        ("Агрегация с JOIN: Статистика по категориям", """
            SELECT 
                c.Name AS Category,
                COUNT(p.ID) AS Count,
                ROUND(AVG(p.Price), 2) AS AvgPrice
            FROM Categories c
            LEFT JOIN Products p ON c.Name = p.Category
            GROUP BY c.ID, c.Name
            ORDER BY Count DESC
        """),
    ]
    
    for title, query in queries:
        print(f"\n{'=' * 60}")
        print(f"{title}")
        print('=' * 60)
        
        try:
            cursor.execute(query)
            rows = cursor.fetchall()
            
            # Вывод заголовков
            columns = [desc[0] for desc in cursor.description]
            print(' | '.join(columns))
            print('-' * 60)
            
            # Вывод строк
            for row in rows:
                print(' | '.join(str(val) for val in row))
                
        except sqlite3.Error as e:
            print(f"Ошибка: {e}")
    
    conn.close()


if __name__ == "__main__":
    db_path = r"C:\projects\Modul-3\VPc04_learning\learning.db"
    run_join_examples(db_path)
```

---

## Ключевые выводы

### SELECT:

| Правило | Описание |
|---------|----------|
| `SELECT колонки` | Всегда указывайте конкретные колонки вместо `*` |
| `WHERE` | Фильтрация строк ДО группировки |
| `GROUP BY` | Группировка для агрегации |
| `HAVING` | Фильтрация групп ПОСЛЕ группировки |
| `ORDER BY` | Сортировка результата |
| `LIMIT` | Ограничение количества строк |

### JOIN:

| Правило | Описание |
|---------|----------|
| `INNER JOIN` | Только совпадающие строки |
| `LEFT JOIN` | Все из левой + совпадения из правой |
| `ON` | Условие соединения таблиц |
| `Алиасы` | Используйте `p.Name` вместо `Products.Name` |
| `NULL` | Проверка `IS NULL` для несовпавших строк |

---

## Быстрый старт

```bash
# 1. Создать таблицу Categories
sqlite3 C:\projects\Modul-3\VPc04_learning\learning.db <<EOF
CREATE TABLE IF NOT EXISTS Categories (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE,
    Description TEXT
);
EOF

# 2. Вставить данные
# 3. Запустить примеры JOIN
# 4. Проверить результаты
```
