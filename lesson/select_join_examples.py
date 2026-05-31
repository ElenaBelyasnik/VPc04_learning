"""
Скрипт для демонстрации JOIN и операторов SELECT в SQLite.
Создаёт таблицу Categories, заполняет её и выполняет примеры JOIN.
"""

import sqlite3
from pathlib import Path


def setup_categories_table(db_path: str) -> None:
    """Создаёт таблицу Categories и заполняет данными."""
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Создание таблицы Categories
        print("📦 Создание таблицы Categories...")
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Categories (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                Name TEXT NOT NULL UNIQUE,
                Description TEXT,
                CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # Вставка данных (пропускаем, если уже есть)
        categories = [
            ('Электроника', 'Технические устройства и гаджеты'),
            ('Книги', 'Литература и учебные материалы'),
            ('Мебель', 'Предметы мебели для дома и офиса'),
            ('Инструменты', 'Строительные и ремонтные инструменты'),
            ('Одежда и аксессуары', 'Одежда, обувь и аксессуары'),
            ('Спорт и отдых', 'Спортивное снаряжение и товары для отдыха'),
            ('Для дома', 'Товары для домашнего хозяйства'),
            ('Бытовая техника', 'Электрические приборы для дома'),
            ('Автомобильные', 'Аксессуары и запчасти для авто'),
            ('Косметика и здоровье', 'Косметика и товары для здоровья')
        ]
        
        cursor.execute("SELECT COUNT(*) FROM Categories")
        if cursor.fetchone()[0] == 0:
            cursor.executemany(
                "INSERT INTO Categories (Name, Description) VALUES (?, ?)",
                categories
            )
            conn.commit()
            print(f"✓ Вставлено {len(categories)} категорий")
        else:
            print("✓ Таблица Categories уже заполнена")
        
        # Проверка наличия Products
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='Products'")
        if not cursor.fetchone():
            print("⚠ Таблица Products не найдена! Сначала запустите test_insert.py")
            return
        
        # Добавляем SupplierID в Products если нет
        cursor.execute("PRAGMA table_info(Products)")
        columns = [col[1] for col in cursor.fetchall()]
        if 'SupplierID' not in columns:
            print("📦 Добавляем колонку SupplierID в Products...")
            cursor.execute("ALTER TABLE Products ADD COLUMN SupplierID INTEGER")
            conn.commit()
        
        # Создаём таблицу Suppliers
        print("📦 Создание таблицы Suppliers...")
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Suppliers (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                Name TEXT NOT NULL,
                Country TEXT,
                Phone TEXT
            )
        """)
        
        cursor.execute("SELECT COUNT(*) FROM Suppliers")
        if cursor.fetchone()[0] == 0:
            suppliers = [
                ('TechCorp', 'Китай', '+86-123-4567'),
                ('BookWorld', 'Россия', '+7-495-123-4567'),
                ('HomeStyle', 'Италия', '+39-123-456789')
            ]
            cursor.executemany(
                "INSERT INTO Suppliers (Name, Country, Phone) VALUES (?, ?, ?)",
                suppliers
            )
            conn.commit()
            print(f"✓ Вставлено {len(suppliers)} поставщиков")
        
        # Обновляем SupplierID в Products
        print("📦 Назначаем поставщиков товарам...")
        cursor.execute("""
            UPDATE Products SET SupplierID = 1 WHERE Category = 'Электроника'
        """)
        cursor.execute("""
            UPDATE Products SET SupplierID = 2 WHERE Category = 'Книги'
        """)
        cursor.execute("""
            UPDATE Products SET SupplierID = 3 WHERE Category = 'Мебель'
        """)
        conn.commit()
        print(f"✓ Обновлено {cursor.rowcount} записей")
        
        print("✓ Настройка таблиц завершена\n")
        
    except sqlite3.Error as e:
        print(f"⚠ Ошибка при настройке: {e}")
        conn.rollback()
    finally:
        conn.close()


def execute_query(db_path: str, title: str, query: str) -> None:
    """Выполняет SQL-запрос и выводит результаты."""
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    print(f"\n{'=' * 70}")
    print(f"{title}")
    print('=' * 70)
    print(f"SQL: {query[:100]}{'...' if len(query) > 100 else ''}")
    print('-' * 70)
    
    try:
        cursor.execute(query)
        rows = cursor.fetchall()
        
        if not rows:
            print("Нет результатов")
            return
        
        # Заголовки
        columns = [desc[0] for desc in cursor.description]
        print(' | '.join(f"{col:<20}" for col in columns))
        print('-' * 70)
        
        # Данные
        for row in rows:
            print(' | '.join(f"{str(val):<20}" for val in row))
        
        print(f"\n✅ Всего строк: {len(rows)}")
        
    except sqlite3.Error as e:
        print(f"❌ Ошибка: {e}")
    finally:
        conn.close()


def main():
    """Основная функция."""
    
    db_path = r"C:\projects\Modul-3\VPc04_learning\learning.db"
    
    if not Path(db_path).exists():
        print(f"⚠ Файл базы данных не найден: {db_path}")
        print("Сначала запустите test_insert.py")
        return
    
    # Настройка таблиц
    setup_categories_table(db_path)
    
    # Примеры SELECT
    print("\n" + "=" * 70)
    print("📊 РАЗДЕЛ 1: БАЗОВЫЕ ЗАПРОСЫ SELECT")
    print("=" * 70)
    
    execute_query(
        db_path,
        "1.1. Все товары (первые 5)",
        "SELECT Name, Price, SKU FROM Products LIMIT 5"
    )
    
    execute_query(
        db_path,
        "1.2. Товары дороже 50000 ₽",
        "SELECT Name, Price, Category FROM Products WHERE Price > 50000 LIMIT 5"
    )
    
    execute_query(
        db_path,
        "1.3. Сортировка по цене (топ-5)",
        "SELECT Name, Price FROM Products ORDER BY Price DESC LIMIT 5"
    )
    
    # Агрегация
    print("\n" + "=" * 70)
    print("📊 РАЗДЕЛ 2: АГРЕГАЦИОННЫЕ ФУНКЦИИ")
    print("=" * 70)
    
    execute_query(
        db_path,
        "2.1. Общая статистика",
        """
        SELECT 
            COUNT(*) AS Total,
            ROUND(AVG(Price), 2) AS AvgPrice,
            MIN(Price) AS MinPrice,
            MAX(Price) AS MaxPrice
        FROM Products
        """
    )
    
    execute_query(
        db_path,
        "2.2. Статистика по категориям",
        """
        SELECT 
            Category,
            COUNT(*) AS Count,
            ROUND(AVG(Price), 2) AS AvgPrice
        FROM Products
        GROUP BY Category
        ORDER BY Count DESC
        """
    )
    
    # JOIN
    print("\n" + "=" * 70)
    print("📊 РАЗДЕЛ 3: JOIN ОПЕРАТОРЫ")
    print("=" * 70)
    
    execute_query(
        db_path,
        "3.1. INNER JOIN: Товары с категориями",
        """
        SELECT 
            p.Name AS Product,
            p.Price,
            c.Name AS Category,
            c.Description
        FROM Products p
        INNER JOIN Categories c ON p.Category = c.Name
        LIMIT 5
        """
    )
    
    execute_query(
        db_path,
        "3.2. LEFT JOIN: Все товары + описание категории",
        """
        SELECT 
            p.Name,
            p.Category,
            c.Description AS CategoryDesc
        FROM Products p
        LEFT JOIN Categories c ON p.Category = c.Name
        LIMIT 5
        """
    )
    
    execute_query(
        db_path,
        "3.3. RIGHT JOIN: Все категории + товары",
        """
        SELECT 
            c.Name AS Category,
            c.Description,
            p.Name AS Product
        FROM Products p
        RIGHT JOIN Categories c ON p.Category = c.Name
        LIMIT 5
        """
    )
    
    execute_query(
        db_path,
        "3.4. Агрегация с JOIN: Статистика по категориям",
        """
        SELECT 
            c.Name AS Category,
            c.Description,
            COUNT(p.ID) AS ProductCount,
            ROUND(SUM(p.Price), 2) AS TotalValue
        FROM Categories c
        LEFT JOIN Products p ON c.Name = p.Category
        GROUP BY c.ID, c.Name, c.Description
        ORDER BY ProductCount DESC
        """
    )
    
    execute_query(
        db_path,
        "3.5. Тройной JOIN: Товары + Категории + Поставщики",
        """
        SELECT 
            p.Name AS Product,
            p.Price,
            c.Name AS Category,
            s.Name AS Supplier,
            s.Country
        FROM Products p
        LEFT JOIN Categories c ON p.Category = c.Name
        LEFT JOIN Suppliers s ON p.SupplierID = s.ID
        WHERE s.Name IS NOT NULL
        LIMIT 5
        """
    )
    
    # Подзапросы
    print("\n" + "=" * 70)
    print("📊 РАЗДЕЛ 4: ПОДЗАПРОСЫ")
    print("=" * 70)
    
    execute_query(
        db_path,
        "4.1. Товары дороже средней цены",
        """
        SELECT Name, Price, Category
        FROM Products
        WHERE Price > (SELECT AVG(Price) FROM Products)
        ORDER BY Price DESC
        LIMIT 5
        """
    )
    
    execute_query(
        db_path,
        "4.2. Категории с общим запасом > 2000000",
        """
        SELECT 
            Category,
            COUNT(*) AS Count,
            ROUND(SUM(Price), 2) AS TotalValue
        FROM Products
        GROUP BY Category
        HAVING SUM(Price) > 2000000
        """
    )
    
    print("\n" + "=" * 70)
    print("✅ Все примеры выполнены!")
    print("=" * 70)


if __name__ == "__main__":
    main()
