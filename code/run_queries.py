"""
run_queries.py - Выполнение SQL-запросов из sql/queries.sql
"""

import sqlite3
from pathlib import Path


def run_queries():
    """Выполняет все SQL-запросы из файла queries.sql."""
    
    db_path = r"C:\projects\Modul-3\VPc04_learning\learning.db"
    sql_path = Path(__file__).parent.parent / "sql" / "queries.sql"
    
    if not sql_path.exists():
        print(f"❌ Файл SQL не найден: {sql_path}")
        return
    
    print("=" * 70)
    print("🔍 ВЫПОЛНЕНИЕ SQL-ЗАПРОСОВ")
    print("=" * 70)
    print(f"\nБаза данных: {db_path}")
    print(f"SQL файл: {sql_path}")
    print()
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Читаем SQL файл
    with open(sql_path, 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    # Разбиваем на отдельные запросы по разделителю ;
    raw_queries = sql_content.split(';')
    
    success_count = 0
    error_count = 0
    skip_count = 0
    query_num = 0
    
    for raw_query in raw_queries:
        # Очищаем от комментариев
        lines = []
        for line in raw_query.split('\n'):
            stripped = line.strip()
            if not stripped.startswith('--'):
                lines.append(line)
        query = '\n'.join(lines).strip()
        
        # Пропускаем пустые
        if not query:
            continue
        
        query_num += 1
        
        # Пропускаем параметризованные запросы (с ?)
        if '?' in query:
            skip_count += 1
            continue
        
        try:
            # Пытаемся выполнить запрос
            cursor.execute(query)
            
            # Если это SELECT, выводим результаты
            if query.strip().upper().startswith('SELECT'):
                results = cursor.fetchall()
                if results:
                    print(f"\n✓ Запрос {query_num}: {len(results)} строк")
                    # Показываем первые 5 строк
                    for row in results[:5]:
                        print(f"  {row}")
                    if len(results) > 5:
                        print(f"  ... и ещё {len(results) - 5} строк")
                else:
                    print(f"✓ Запрос {query_num}: (нет результатов)")
            else:
                conn.commit()
                print(f"✓ Запрос {query_num}: выполнено успешно")
            
            success_count += 1
            
        except sqlite3.Error as e:
            error_count += 1
            print(f"\n❌ Ошибка в запросе {query_num}:")
            print(f"   SQL: {query[:100]}...")
            print(f"   Ошибка: {e}")
    
    conn.close()
    
    print("\n" + "=" * 70)
    print("📊 РЕЗУЛЬТАТЫ")
    print("=" * 70)
    print(f"✅ Успешно: {success_count}")
    print(f"❌ Ошибки: {error_count}")
    print(f"⏭️  Пропущено: {skip_count}")
    print("=" * 70)
    
    if error_count == 0:
        print("✅ ВСЕ ЗАПРОСЫ ВЫПОЛНЕНЫ БЕЗ ОШИБОК!")
    else:
        print(f"⚠ ЕСТЬ {error_count} ОШИБОК - исправьте queries.sql")


if __name__ == "__main__":
    run_queries()
