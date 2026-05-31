# UPDATE в SQL: Обновление данных (SQLite)

Этот документ объясняет, как обновлять существующие данные в таблице с помощью оператора `UPDATE`, включая массовое обновление множества строк.

**Путь к базе данных:** `C:\projects\Modul-3\VPc04_learning\learning.db`  
**Таблица:** `Products`

---

## Содержание

1. [Структура таблицы Products](#структура-таблицы-products)
2. [Базовый оператор UPDATE](#базовый-оператор-update)
3. [Обновление с условием WHERE](#обновление-с-условием-where)
4. [Массовое обновление данных](#массовое-обновление-данных)
5. [Обновление нескольких колонок](#обновление-нескольких-колонок)
6. [Обновление на основе вычислений](#обновление-на-основе-вычислений)
7. [Безопасное обновление (Python)](#безопасное-обновление-python)
8. [Проверка результатов](#проверка-результатов)

---

## Структура таблицы Products

```sql
CREATE TABLE Products (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Description TEXT,
    Category TEXT,
    Price REAL,
    SKU TEXT UNIQUE
);
```

---

## Базовый оператор UPDATE

### Синтаксис:

```sql
UPDATE Products
SET Price = 2999.99
WHERE SKU = 'ART-12345-A';
```

### Пояснение синтаксиса:

| Часть запроса | Описание |
|---------------|----------|
| `UPDATE` | Ключевое слово, указывающее на операцию обновления |
| `Products` | Имя таблицы, в которой обновляем данные |
| `SET` | Ключевое слово перед списком колонок для обновления |
| `Price = 2999.99` | Новая цена — значение, которое запишется в колонку |
| `WHERE` | **Критически важно!** Условие выбора строк для обновления |
| `SKU = 'ART-12345-A'` | Условие: обновляем только строку с этим SKU |

### ⚠️ КРИТИЧЕСКИ ВАЖНО:

| Сценарий | Результат |
|----------|-----------|
| С `WHERE` | Обновляются только строки, удовлетворяющие условию |
| **Без `WHERE`** | **Обновляются ВСЕ строки в таблице!** |

```sql
-- ✅ Безопасно: обновляем одну строку
UPDATE Products SET Price = 2999.99 WHERE SKU = 'ART-12345-A';

-- ❌ ОПАСНО: обновляет ВСЕ товары до цены 2999.99!
UPDATE Products SET Price = 2999.99;
```

---

## Обновление с условием WHERE

### Примеры различных условий:

```sql
-- 1. Обновление по точному значению
UPDATE Products
SET Price = 1999.99
WHERE Name = 'Беспроводные наушники';

-- 2. Обновление по категории
UPDATE Products
SET Category = 'Бытовая техника'
WHERE Category = 'Для дома';

-- 3. Обновление по диапазону цен
UPDATE Products
SET Price = Price * 0.9
WHERE Price > 10000;

-- 4. Обновление по шаблону (LIKE)
UPDATE Products
SET Description = 'Акция! Скидка 20%' || Description
WHERE Name LIKE '%наушники%';

-- 5. Обновление по нескольким условиям (AND)
UPDATE Products
SET Price = 5999.99
WHERE Category = 'Электроника' AND Price > 5000;

-- 6. Обновление по условию OR
UPDATE Products
SET Description = 'Распродажа' || ' - ' || Description
WHERE Category = 'Книги' OR Category = 'Спорт и отдых';

-- 7. Обновление строк с NULL значениями
UPDATE Products
SET Description = 'Описание отсутствует'
WHERE Description IS NULL;
```

### Операторы сравнения в WHERE:

| Оператор | Описание | Пример |
|----------|----------|--------|
| `=` | Равно | `WHERE Price = 1000` |
| `!=` или `<>` | Не равно | `WHERE Category != 'Книги'` |
| `>` | Больше | `WHERE Price > 5000` |
| `<` | Меньше | `WHERE Price < 100` |
| `>=` | Больше или равно | `WHERE Price >= 1000` |
| `<=` | Меньше или равно | `WHERE Price <= 50000` |
| `LIKE` | По шаблону | `WHERE Name LIKE '%смарт%'` |
| `IN` | В списке значений | `WHERE Category IN ('Книги', 'Мебель')` |
| `BETWEEN` | В диапазоне | `WHERE Price BETWEEN 1000 AND 10000` |
| `IS NULL` | NULL значение | `WHERE Description IS NULL` |
| `IS NOT NULL` | Не NULL | `WHERE Price IS NOT NULL` |
| `AND` | И (оба условия) | `WHERE Category = 'Книги' AND Price < 500` |
| `OR` | ИЛИ (любое условие) | `WHERE Category = 'Книги' OR Category = 'Мебель'` |

---

## Массовое обновление данных

### Пример: увеличение цены на 10% для всех товаров в категории "Электроника"

```sql
-- Массовое обновление: +10% ко всем ценам в категории "Электроника"
UPDATE Products
SET Price = ROUND(Price * 1.10, 2)
WHERE Category = 'Электроника';
```

### Пояснение:

| Часть запроса | Описание |
|---------------|----------|
| `UPDATE Products` | Обновляем таблицу Products |
| `SET Price = Price * 1.10` | Новая цена = старая цена × 1.10 (увеличение на 10%) |
| `ROUND(..., 2)` | Округление до 2 знаков после запятой |
| `WHERE Category = 'Электроника'` | Обновляем только товары этой категории |

### Результат выполнения:

| Старая цена | Новая цена (после +10%) |
|-------------|------------------------|
| 1000.00 ₽ | 1100.00 ₽ |
| 2999.99 ₽ | 3299.99 ₽ |
| 45999.00 ₽ | 50598.90 ₽ |

---

## Примеры массовых обновлений

### 1. Скидка 15% для всех товаров категории "Книги"

```sql
UPDATE Products
SET Price = ROUND(Price * 0.85, 2)
WHERE Category = 'Книги';
```

### 2. Обновление описания для всех товаров в категории "Мебель"

```sql
UPDATE Products
SET Description = 'Премиум мебель. ' || Description
WHERE Category = 'Мебель';
```

### 3. Изменение категории для нескольких товаров

```sql
UPDATE Products
SET Category = 'Бытовая техника'
WHERE Category IN ('Для дома', 'Кухня');
```

### 4. Увеличение цены на 5% для товаров дороже 50000 ₽

```sql
UPDATE Products
SET Price = ROUND(Price * 1.05, 2)
WHERE Price > 50000;
```

### 5. Добавление префикса к названию для всех товаров

```sql
UPDATE Products
SET Name = '[АКЦИЯ] ' || Name;
-- ⚠️ Внимание: обновит ВСЕ строки!
```

### 6. Сброс описания для товаров с NULL

```sql
UPDATE Products
SET Description = 'Описание скоро появится'
WHERE Description IS NULL;
```

### 7. Обновление SKU по шаблону

```sql
-- Заменить 'ART-' на 'PROD-' во всех SKU
UPDATE Products
SET SKU = 'PROD' || SUBSTR(SKU, 4)
WHERE SKU LIKE 'ART-%';
```

---

## Обновление нескольких колонок

```sql
-- Обновление нескольких полей одновременно
UPDATE Products
SET 
    Price = 3499.99,
    Description = 'Новое описание товара',
    Category = 'Электроника'
WHERE SKU = 'ART-12345-A';
```

### Синтаксис:

```sql
UPDATE Products
SET 
    Колонка1 = НовоеЗначение1,
    Колонка2 = НовоеЗначение2,
    Колонка3 = НовоеЗначение3
WHERE Условие;
```

### Пример: комплексное обновление

```sql
-- Обновление цены, описания и категории для группы товаров
UPDATE Products
SET 
    Price = ROUND(Price * 1.15, 2),
    Description = 'Распродажа! ' || Description,
    Category = 'Акция'
WHERE Category IN ('Электроника', 'Бытовая техника') AND Price < 10000;
```

---

## Обновление на основе вычислений

### Использование значений из других колонок:

```sql
-- Увеличение цены на фиксированную сумму
UPDATE Products
SET Price = Price + 500
WHERE Category = 'Книги';

-- Увеличение цены на процент от текущей
UPDATE Products
SET Price = Price + (Price * 0.20)  -- +20%
WHERE Category = 'Электроника';

-- Использование ROUND для округления
UPDATE Products
SET Price = ROUND(Price * 1.10, 2)
WHERE Price < 1000;

-- Вычисление на основе нескольких колонок
UPDATE Products
SET Description = Description || ' (Категория: ' || Category || ')'
WHERE Description NOT LIKE '%Категория%';
```

### Доступные функции для вычислений:

| Функция | Описание | Пример |
|---------|----------|--------|
| `ROUND(x, n)` | Округление до n знаков | `ROUND(Price * 1.10, 2)` |
| `ABS(x)` | Абсолютное значение | `ABS(Price - 1000)` |
| `MIN(x, y)` | Минимум из двух | `MIN(Price, 10000)` |
| `MAX(x, y)` | Максимум из двух | `MAX(Price, 500)` |
| `SUBSTR(x, start, len)` | Подстрока | `SUBSTR(SKU, 5, 4)` |
| `LENGTH(x)` | Длина строки | `LENGTH(Name)` |
| `UPPER(x)` | Верхний регистр | `UPPER(Name)` |
| `LOWER(x)` | Нижний регистр | `LOWER(Category)` |
| `TRIM(x)` | Удаление пробелов | `TRIM(Name)` |
| `REPLACE(x, a, b)` | Замена подстроки | `REPLACE(Name, ' ', '_')` |

---

## Безопасное обновление (Python)

### Рекомендуемый способ через Python:

```python
import sqlite3

def update_products_price(db_path: str, category: str, increase_percent: float) -> int:
    """
    Увеличивает цену товаров в указанной категории на заданный процент.
    
    Args:
        db_path: Путь к базе данных
        category: Категория товаров
        increase_percent: Процент увеличения (например, 10 для +10%)
    
    Returns:
        Количество обновлённых записей
    """
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Формула: новая цена = старая цена × (1 + процент/100)
        multiplier = 1 + (increase_percent / 100)
        
        # Обновление с параметром (защита от SQL-инъекций)
        query = """
            UPDATE Products
            SET Price = ROUND(Price * ?, 2)
            WHERE Category = ?
        """
        
        cursor.execute(query, (multiplier, category))
        conn.commit()
        
        updated_count = cursor.rowcount
        print(f"✓ Обновлено {updated_count} товаров в категории '{category}'")
        
        return updated_count
        
    except sqlite3.Error as e:
        print(f"⚠ Ошибка при обновлении: {e}")
        conn.rollback()
        return 0
    finally:
        conn.close()


# Пример использования:
db_path = r"C:\projects\Modul-3\VPc04_learning\learning.db"
update_products_price(db_path, "Электроника", 10)  # +10% для Электроники
```

### Массовое обновление через executemany:

```python
def bulk_update_products(db_path: str, updates: list[tuple]) -> int:
    """
    Обновляет несколько товаров по списку.
    
    Args:
        db_path: Путь к базе данных
        updates: Список кортежей (new_price, new_description, sku)
    
    Returns:
        Количество обновлённых записей
    """
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        query = """
            UPDATE Products
            SET Price = ?, Description = ?
            WHERE SKU = ?
        """
        
        cursor.executemany(query, updates)
        conn.commit()
        
        return cursor.rowcount
        
    except sqlite3.Error as e:
        print(f"⚠ Ошибка: {e}")
        conn.rollback()
        return 0
    finally:
        conn.close()


# Пример использования:
updates = [
    (2999.99, 'Новое описание 1', 'ART-12345-A'),
    (45999.00, 'Новое описание 2', 'ART-67890-B'),
    (899.50, 'Новое описание 3', 'ART-11111-C'),
]

bulk_update_products(db_path, updates)
```

---

## Проверка результатов

### Запросы для проверки изменений:

```sql
-- 1. Посчитать количество обновлённых строк
SELECT COUNT(*) AS updated_count
FROM Products
WHERE Category = 'Электроника';

-- 2. Показать примеры обновлённых товаров
SELECT ID, Name, Category, Price, SKU
FROM Products
WHERE Category = 'Электроника'
ORDER BY Price DESC
LIMIT 10;

-- 3. Сравнить средние цены до и после (если есть исторические данные)
SELECT 
    Category,
    ROUND(AVG(Price), 2) AS avg_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM Products
WHERE Category = 'Электроника'
GROUP BY Category;

-- 4. Проверить диапазон цен в категории
SELECT 
    COUNT(*) AS total_products,
    ROUND(AVG(Price), 2) AS avg_price,
    ROUND(STDDEV(Price), 2) AS stddev_price  -- если поддерживается
FROM Products
WHERE Category = 'Электроника';

-- 5. Найти товары с аномально высокой/низкой ценой
SELECT Name, Price, Category
FROM Products
WHERE Price > 80000 OR Price < 200
ORDER BY Price DESC;
```

### Проверка в Python:

```python
def verify_update(db_path: str, category: str) -> None:
    """Проверяет результаты обновления."""
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Подсчёт
        cursor.execute("SELECT COUNT(*) FROM Products WHERE Category = ?", (category,))
        count = cursor.fetchone()[0]
        print(f"Товаров в категории '{category}': {count}")
        
        # Статистика цен
        cursor.execute("""
            SELECT ROUND(AVG(Price), 2), MIN(Price), MAX(Price)
            FROM Products
            WHERE Category = ?
        """, (category,))
        avg, min_p, max_p = cursor.fetchone()
        print(f"Средняя цена: {avg} ₽ | Мин: {min_p} ₽ | Макс: {max_p} ₽")
        
        # Примеры
        print("\nПримеры товаров:")
        cursor.execute("SELECT Name, Price FROM Products WHERE Category = ? LIMIT 5", (category,))
        for name, price in cursor.fetchall():
            print(f"  - {name}: {price} ₽")
            
    except sqlite3.Error as e:
        print(f"Ошибка: {e}")
    finally:
        conn.close()
```

---

## Откат изменений (если нужно)

### В SQLite нет прямого отката UPDATE, но можно:

```sql
-- 1. Использовать транзакцию (до выполнения UPDATE)
BEGIN TRANSACTION;
    UPDATE Products SET Price = Price * 1.10 WHERE Category = 'Электроника';
    -- Если всё хорошо:
COMMIT;
    -- Если ошибка:
ROLLBACK;

-- 2. Создать резервную копию перед массовым обновлением
CREATE TABLE Products_backup AS SELECT * FROM Products;

-- 3. Восстановить из резервной копии при необходимости
DELETE FROM Products;
INSERT INTO Products SELECT * FROM Products_backup;
DROP TABLE Products_backup;
```

---

## Практический пример: Полный скрипт обновления

### Файл `update_products.py`:

```python
import sqlite3

def main():
    db_path = r"C:\projects\Modul-3\VPc04_learning\learning.db"
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        print("=" * 60)
        print("Массовое обновление: +10% для категории 'Электроника'")
        print("=" * 60)
        
        # 1. Показать текущие данные
        print("\n📊 Текущая статистика:")
        cursor.execute("""
            SELECT COUNT(*), ROUND(AVG(Price), 2), MIN(Price), MAX(Price)
            FROM Products WHERE Category = 'Электроника'
        """)
        row = cursor.fetchone()
        print(f"Товаров: {row[0]}, Средняя: {row[1]} ₽, Диапазон: {row[2]} - {row[3]} ₽")
        
        # 2. Выполнить обновление
        print("\n💾 Выполняется обновление...")
        cursor.execute("""
            UPDATE Products
            SET Price = ROUND(Price * 1.10, 2)
            WHERE Category = 'Электроника'
        """)
        conn.commit()
        
        print(f"✓ Обновлено {cursor.rowcount} товаров")
        
        # 3. Показать результаты
        print("\n📈 Новая статистика:")
        cursor.execute("""
            SELECT COUNT(*), ROUND(AVG(Price), 2), MIN(Price), MAX(Price)
            FROM Products WHERE Category = 'Электроника'
        """)
        row = cursor.fetchone()
        print(f"Товаров: {row[0]}, Средняя: {row[1]} ₽, Диапазон: {row[2]} - {row[3]} ₽")
        
        # 4. Показать примеры
        print("\n📋 Примеры обновлённых товаров:")
        cursor.execute("""
            SELECT Name, Price FROM Products 
            WHERE Category = 'Электроника' 
            ORDER BY Price DESC 
            LIMIT 5
        """)
        for name, price in cursor.fetchall():
            print(f"  - {name}: {price} ₽")
        
    except sqlite3.Error as e:
        print(f"⚠ Ошибка: {e}")
        conn.rollback()
    finally:
        conn.close()

if __name__ == "__main__":
    main()
```

---

## Ключевые выводы

| Правило | Описание |
|---------|----------|
| **Всегда используйте WHERE** | Без WHERE обновляются ВСЕ строки! |
| **Тестируйте на копии** | Сначала `SELECT` с тем же WHERE, потом `UPDATE` |
| **Используйте транзакции** | `BEGIN TRANSACTION` → `UPDATE` → `COMMIT`/`ROLLBACK` |
| **Сохраняйте бэкап** | `CREATE TABLE backup AS SELECT * FROM Products;` |
| **Проверяйте результат** | Сразу после UPDATE сделайте SELECT для проверки |
| **Используйте ROUND** | Для цен всегда округляйте до 2 знаков |

---

## Быстрый старт

```bash
# 1. Запустить скрипт обновления
python update_products.py

# 2. Проверить результаты в DB Browser for SQLite

# 3. При необходимости откатить из резервной копии
```
