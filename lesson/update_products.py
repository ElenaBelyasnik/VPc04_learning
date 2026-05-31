"""
Скрипт для массового обновления цен в категории "Электроника".
Увеличивает цену на 10% с сохранением транзакции.
"""

import sqlite3
from pathlib import Path


def update_electronics_price(db_path: str, increase_percent: float = 10.0) -> None:
    """
    Увеличивает цену всех товаров в категории "Электроника" на заданный процент.
    
    Args:
        db_path: Путь к базе данных SQLite
        increase_percent: Процент увеличения цены (по умолчанию 10%)
    """
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Начало транзакции для безопасности
        print("=" * 60)
        print("Массовое обновление: увеличение цен на 10% для 'Электроника'")
        print("=" * 60)
        
        # 1. Показать текущую статистику
        print("\n📊 ТЕКУЩАЯ СТАТИСТИКА:")
        print("-" * 60)
        cursor.execute("""
            SELECT 
                COUNT(*) AS total,
                ROUND(AVG(Price), 2) AS avg_price,
                MIN(Price) AS min_price,
                MAX(Price) AS max_price
            FROM Products 
            WHERE Category = 'Электроника'
        """)
        row = cursor.fetchone()
        print(f"Товаров: {row[0]}")
        print(f"Средняя цена: {row[1]} ₽")
        print(f"Диапазон цен: {row[2]} ₽ — {row[3]} ₽")
        
        # 2. Показать примеры до обновления
        print("\n📋 Примеры товаров ДО обновления:")
        print("-" * 60)
        cursor.execute("""
            SELECT Name, Price 
            FROM Products 
            WHERE Category = 'Электроника' 
            ORDER BY Price DESC 
            LIMIT 5
        """)
        for name, price in cursor.fetchall():
            print(f"  • {name}: {price} ₽")
        
        # 3. Выполнить обновление
        print("\n💾 Выполняется обновление...")
        multiplier = 1 + (increase_percent / 100)
        cursor.execute("""
            UPDATE Products
            SET Price = ROUND(Price * ?, 2)
            WHERE Category = 'Электроника'
        """, (multiplier,))
        
        updated_count = cursor.rowcount
        conn.commit()
        
        print(f"✓ Успешно обновлено {updated_count} товаров")
        
        # 4. Показать новую статистику
        print("\n📊 НОВАЯ СТАТИСТИКА:")
        print("-" * 60)
        cursor.execute("""
            SELECT 
                COUNT(*) AS total,
                ROUND(AVG(Price), 2) AS avg_price,
                MIN(Price) AS min_price,
                MAX(Price) AS max_price
            FROM Products 
            WHERE Category = 'Электроника'
        """)
        row = cursor.fetchone()
        print(f"Товаров: {row[0]}")
        print(f"Средняя цена: {row[1]} ₽")
        print(f"Диапазон цен: {row[2]} ₽ — {row[3]} ₽")
        
        # 5. Показать примеры после обновления
        print("\n📋 Примеры товаров ПОСЛЕ обновления:")
        print("-" * 60)
        cursor.execute("""
            SELECT Name, Price 
            FROM Products 
            WHERE Category = 'Электроника' 
            ORDER BY Price DESC 
            LIMIT 5
        """)
        for name, price in cursor.fetchall():
            print(f"  • {name}: {price} ₽")
        
        print("\n" + "=" * 60)
        print(f"Готово! Цены увеличены на {increase_percent}%")
        print("=" * 60)
        
    except sqlite3.Error as e:
        print(f"⚠ Ошибка при обновлении: {e}")
        conn.rollback()
        print("🔄 Изменения отменены (ROLLBACK)")
    finally:
        conn.close()


def create_backup(db_path: str) -> None:
    """Создаёт резервную копию таблицы Products."""
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Удалить старую бэкап-таблицу если есть
        cursor.execute("DROP TABLE IF EXISTS Products_backup")
        
        # Создать копию
        cursor.execute("CREATE TABLE Products_backup AS SELECT * FROM Products")
        conn.commit()
        
        print("✓ Резервная копия Products_backup создана")
        
    except sqlite3.Error as e:
        print(f"⚠ Ошибка при создании бэкапа: {e}")
        conn.rollback()
    finally:
        conn.close()


def restore_from_backup(db_path: str) -> None:
    """Восстанавливает данные из резервной копии."""
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Удалить текущие данные
        cursor.execute("DELETE FROM Products")
        
        # Восстановить из бэкапа
        cursor.execute("INSERT INTO Products SELECT * FROM Products_backup")
        conn.commit()
        
        print("✓ Данные восстановлены из Products_backup")
        
    except sqlite3.Error as e:
        print(f"⚠ Ошибка при восстановлении: {e}")
        conn.rollback()
    finally:
        conn.close()


def main():
    """Основная функция."""
    
    db_path = r"C:\projects\Modul-3\VPc04_learning\learning.db"
    
    if not Path(db_path).exists():
        print(f"⚠ Файл базы данных не найден: {db_path}")
        return
    
    # Создать резервную копию перед обновлением
    print("\n📦 Создание резервной копии...")
    create_backup(db_path)
    
    # Выполнить обновление
    print("\n")
    update_electronics_price(db_path, increase_percent=10.0)
    
    # Вопрос о восстановлении (для тестирования)
    # restore_from_backup(db_path)


if __name__ == "__main__":
    main()
