#!/bin/bash

# Функция для релиза
release() {
    echo "Определение следующей версии..."
    
    # Get next version from commitizen
    next_version=$(cz bump --dry-run | grep "bump: version" | awk -F'→' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')
    
    # If no version found, set initial version
    if [ -z "$next_version" ]; then
        next_version="0.2.0"
        echo "Первый релиз. Следующая версия: $next_version"
    fi
    
    echo "Следующая версия: $next_version"
    echo "Подтверждаете ли вы эту версию? (y/n)"
    read confirm
    
    if [ "$confirm" != "y" ]; then
        echo "Введите номер релиза вручную"
        read version
    else
        version=$next_version
    fi
    
    echo "Создание новой ветки релиза: $version"
    if ! git flow release start "$version"; then
        echo "Ошибка: Не удалось создать ветку релиза."
        return 1
    fi
    
    echo "Завершение релиза: $version"
    if ! cz changelog; then
        echo "Ошибка: Не удалось сгенерировать changelog."
        return 1
    fi
    
    if ! cz bump --yes; then
        echo "Ошибка: Не удалось обновить версию."
        return 1
    fi
    
    if ! git tag -d "$version" 2> /dev/null; then
        echo "Предупреждение: Тег $version не найден для удаления."
    fi
    
    if ! git flow release finish "$version"; then
        echo "Ошибка: Не удалось завершить релиз."
        return 1
    fi
    
    if ! git push --all; then
        echo "Ошибка: Не удалось отправить изменения в origin."
        return 1
    fi
    
    if ! git push --tag; then
        echo "Ошибка: Не удалось отправить теги."
        return 1
    fi
}