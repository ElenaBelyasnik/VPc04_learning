"""
Скрипт для вставки 1000 случайных товаров в SQLite базу данных.
Использует модуль random для генерации тестовых данных.
"""

import sqlite3
import random
from pathlib import Path


def generate_random_products(count: int = 1000) -> list[tuple]:
    """
    Генерирует список кортежей со случайными данными о товарах.
    
    Args:
        count: Количество товаров для генерации (по умолчанию 1000)
    
    Returns:
        Список кортежей (name, description, category, price, sku)
    """
    
    # Списки для генерации случайных данных
    product_names = [
        "Беспроводные наушники", "Смартфон XYZ", "Ноутбук Pro", "Планшет Mini",
        "Умные часы", "Камера 4K", "Игровая консоль", "Монитор 27\"",
        "Клавиатура механическая", "Мышь беспроводная", "Книга по Python",
        "Книга по SQL", "Книга по дизайну", "Офисное кресло", "Письменный стол",
        "Настольная лампа LED", "Набор отвёрток", "Дрель аккумуляторная",
        "Уровень строительный", "Рулетка 5м", "Кофемашина", "Блендер",
        "Тостер", "Микроволновка", "Холодильник", "Стиральная машина",
        "Пылесос робот", "Утюг паровой", "Фен профессиональный", "Электрическая зубная щётка",
        "Рюкзак туристический", "Спортивная сумка", "Велосипед горный", "Беговая дорожка",
        "Гантели наборные", "Коврик для йоги", "Теннисная ракетка", "Бадминтон набор",
        "Футбольный мяч", "Баскетбольный мяч"
    ]
    
    categories = [
        "Электроника", "Книги", "Мебель", "Инструменты", "Одежда и аксессуары",
        "Спорт и отдых", "Для дома", "Бытовая техника", "Автомобильные", "Косметика и здоровье"
    ]
    
    descriptions = [
        "Высокое качество, гарантия 2 года", "Хит продаж 2024", "Новинка сезона",
        "Премиум качество", "Бюджетный вариант", "Профессиональное оборудование",
        "Рекомендуем покупателям", "Ограниченная партия", "Высокий спрос", "Для дома и офиса",
        "Энергоэффективный", "Компактный дизайн", "Удобное использование",
        "Современный стиль", "Надёжная конструкция"
    ]
    
    products = []
    used_skus = set()  # Для контроля уникальности SKU
    
    for i in range(count):
        # Генерация уникального SKU
        while True:
            sku = f"ART-{random.randint(10000, 99999)}-{random.choice(['A', 'B', 'C', 'D'])}"
            if sku not in used_skus:
                used_skus.add(sku)
                break
        
        # Случайный выбор из списков
        name = random.choice(product_names)
        category = random.choice(categories)
        description = f"{random.choice(descriptions)}. Товар номер #{i + 1} в категории {category}."
        
        # Случайная цена от 99.99 до 99999.99
        price = round(random.uniform(99.99, 99999.99), 2)
        
        products.append((name, description, category, price, sku))
    
    return products


def insert_products_batch(db_path: str, products: list[tuple]) -> None:
    """
    Вставляет товары в базу данных массовой вставкой (batch insert).
    
    Args:
        db_path: Путь к файлу SQLite базы данных
        products: Список кортежей с данными товаров
    """
    
    # Подключение к базе данных
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Создание таблицы (если не существует)
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Products (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                Name TEXT NOT NULL,
                Description TEXT,
                Category TEXT,
                Price REAL,
                SKU TEXT UNIQUE
            )
        """)
        
        # Массовая вставка данных (executemany)
        # Это эффективный способ вставки множества строк за один раз
        insert_query = """
            INSERT INTO Products (Name, Description, Category, Price, SKU)
            VALUES (?, ?, ?, ?, ?)
        """
        
        cursor.executemany(insert_query, products)
        
        # Фиксация транзакции
        conn.commit()
        
        print(f"✓ Успешно вставлено {cursor.rowcount} записей в таблицу Products")
        
    except sqlite3.IntegrityError as e:
        print(f"⚠ Ошибка целостности данных: {e}")
        conn.rollback()
    except sqlite3.Error as e:
        print(f"⚠ Ошибка базы данных: {e}")
        conn.rollback()
    finally:
        conn.close()


def insert_products_values_clause(db_path: str, products: list[tuple]) -> None:
    """
    Альтернативный способ вставки через перечисление всех значений в VALUES.
    Показывает синтаксис массовой вставки с явным перечислением кортежей.
    
    Args:
        db_path: Путь к файлу SQLite базы данных
        products: Список кортежей с данными товаров
    """
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Формирование SQL-запроса с явным перечислением всех значений
        # Синтаксис: INSERT INTO table (cols) VALUES (...), (...), (...);
        
        # Создаём часть VALUES для каждого товара
        value_placeholders = []
        params = []
        
        for name, description, category, price, sku in products:
            # Добавляем кортеж значений
            value_placeholders.append("(?, ?, ?, ?, ?)")
            params.extend([name, description, category, price, sku])
        
        # Формируем полный запрос
        insert_query = f"""
            INSERT INTO Products (Name, Description, Category, Price, SKU)
            VALUES {', '.join(value_placeholders)}
        """
        
        cursor.execute(insert_query, params)
        conn.commit()
        
        print(f"✓ Успешно вставлено {len(products)} записей через VALUES clause")
        
    except sqlite3.IntegrityError as e:
        print(f"⚠ Ошибка целостности данных (возможно дублирование SKU): {e}")
        conn.rollback()
    except sqlite3.Error as e:
        print(f"⚠ Ошибка базы данных: {e}")
        conn.rollback()
    finally:
        conn.close()


def verify_insertion(db_path: str) -> None:
    """
    Проверяет вставленные данные: считает количество и показывает примеры.
    
    Args:
        db_path: Путь к файлу SQLite базы данных
    """
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Подсчёт общего количества
        cursor.execute("SELECT COUNT(*) FROM Products")
        total = cursor.fetchone()[0]
        print(f"\n📊 Итого записей в таблице Products: {total}")
        
        if total == 0:
            print("⚠ Таблица пуста — вставка не выполнена")
            return
        
        # Показать первые 5 товаров
        print("\n📋 Первые 5 товаров:")
        print("-" * 80)
        cursor.execute("SELECT * FROM Products LIMIT 5")
        for row in cursor.fetchall():
            print(f"ID: {row[0]}, SKU: {row[5]}, Name: {row[1]}, Price: {row[4]} ₽")
        
        # Статистика по категориям
        print("\n📈 Статистика по категориям:")
        print("-" * 80)
        cursor.execute("""
            SELECT Category, COUNT(*) as count, ROUND(AVG(Price), 2) as avg_price
            FROM Products
            GROUP BY Category
            ORDER BY count DESC
        """)
        for row in cursor.fetchall():
            print(f"{row[0]:<25} | Количество: {row[1]:>3} | Средняя цена: {row[2]:>10} ₽")
        
        # Диапазон цен
        print("\n💰 Диапазон цен:")
        print("-" * 80)
        cursor.execute("""
            SELECT MIN(Price) as min, MAX(Price) as max, ROUND(AVG(Price), 2) as avg
            FROM Products
        """)
        row = cursor.fetchone()
        min_price = row[0] if row[0] is not None else 0
        max_price = row[1] if row[1] is not None else 0
        avg_price = row[2] if row[2] is not None else 0
        print(f"Минимальная: {min_price:>12} ₽ | Максимальная: {max_price:>12} ₽ | Средняя: {avg_price:>12} ₽")
        
    except sqlite3.Error as e:
        print(f"⚠ Ошибка при проверке: {e}")
    finally:
        conn.close()


def main():
    """Основная функция: генерирует и вставляет 1000 товаров."""
    
    # Путь к базе данных
    db_path = r"C:\projects\Modul-3\VPc04_learning\learning.db"
    
    # Проверка существования файла базы данных
    if not Path(db_path).exists():
        print(f"⚠ Файл базы данных не найден: {db_path}")
        print("Создадим новый файл базы данных...")
    
    print("=" * 60)
    print("Генерация и вставка 1000 случайных товаров в SQLite")
    print("=" * 60)
    
    # Генерация случайных данных
    print("\n📝 Генерация 1000 случайных товаров...")
    products = generate_random_products(1000)
    print(f"✓ Сгенерировано {len(products)} товаров")
    
    # Вариант 1: Массовая вставка через executemany (рекомендуемый)
    print("\n💾 Вставка данных через executemany (рекомендуемый способ)...")
    insert_products_batch(db_path, products)
    
    # Проверка результатов
    verify_insertion(db_path)
    
    # Пример альтернативного способа (раскомментировать при необходимости)
    # print("\n💾 Альтернативная вставка через VALUES clause...")
    # insert_products_values_clause(db_path, products[:10])  # Только 10 записей для примера


if __name__ == "__main__":
    main()
