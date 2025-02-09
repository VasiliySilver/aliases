#!/bin/bash

# Функция для создания новой ветки
fs() {
    git log --oneline
    # Проверяем, находимся ли мы в Git-репозитории
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Ошибка: Это не Git-репозиторий."
        return 1
    fi

    # Сначала ищем коммиты с форматом #N
    last_number=$(git log --oneline --no-merges | grep -E '(feat|chore)\([^)]*\): #[0-9]+' | sed -E 's/.*: #([0-9]+).*/\1/' | sort -nr | head -n1)
    
    if [ -n "$last_number" ]; then
        # Если нашли коммит с #N, просто увеличиваем номер
        next_num=$((last_number + 1))
        suggested_feature="#${next_num}"
    else
        # Если не нашли #N, ищем коммиты с форматом PREFIX-N
        last_feature=$(git log --oneline --no-merges | grep -E 'feat\([A-Z]+-[0-9]+\)' | head -n1)
        
        if [ -n "$last_feature" ]; then
            # Извлекаем префикс и номер
            prefix=$(echo "$last_feature" | sed -E 's/.*feat\(([A-Z]+)-[0-9]+\).*/\1/')
            current_num=$(echo "$last_feature" | sed -E 's/.*feat\([A-Z]+-([0-9]+)\).*/\1/')
            next_num=$((current_num + 1))
            suggested_feature="${prefix}-${next_num}"
        else
            # Если вообще нет коммитов нужного формата
            echo -n "Введите префикс для ветки (или # для формата #N): "
            read prefix
            if [ "$prefix" = "#" ]; then
                suggested_feature="#1"
            else
                suggested_feature="${prefix}-1"
            fi
        fi
    fi

    echo -e "\nПредлагаемое название ветки: feature/${suggested_feature}"
    echo "1. Использовать это название"
    echo "2. Указать свое название"
    echo -n "Выберите действие (1/2): "
    read choice

    if [ "$choice" = "2" ]; then
        echo -n "Введите название ветки (без prefix feature/): "
        read feature
    else
        feature="$suggested_feature"
    fi

    # Проверяем, существует ли уже такая веткa
    if git show-ref --quiet refs/heads/feature/"$feature"; then
        echo "Ошибка: Ветка 'feature/$feature' уже существует."
        return 1
    fi

    # Создаем feature-ветку с помощью Git Flow
    echo "Создание новой ветки: feature/$feature..."
    git flow feature start "$feature"
    echo -e "\e[32mВетка 'feature/$feature' успешно создана!\e[0m"

    echo -e "\nРекомендации для commitizen:"
    echo "1. Type: выберите тип изменений (feat, fix, etc)"
    echo "2. Scope: укажите область изменений (компонент или фича)"
    echo "3. Description: ${feature} - краткое описание"
    echo "Примеры:"
    echo "Type: feat"
    echo "Scope: users"
    echo "Description: ${feature} - add email validation"
    echo -e "\nИтоговое сообщение будет:"
    echo "feat(users): ${feature} - add email validation"
}
