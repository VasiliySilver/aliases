#!/bin/bash

# Функция для создания новой ветки
fs() {
    # Проверяем, находимся ли мы в Git-репозитории
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Ошибка: Это не Git-репозиторий."
        return 1
    fi

    # Ищем последний коммит с форматом M-N, исключая мерджи и теги
    last_feature=$(git log --oneline --no-merges | grep -E 'feat\(M-[0-9]+\):' | head -n1)
    
    if [ -n "$last_feature" ]; then
        # Извлекаем номер из последнего M-N коммита
        current_num=$(echo "$last_feature" | sed -E 's/.*feat\(M-([0-9]+)\).*/\1/')
        next_num=$((current_num + 1))
        feature="M-${next_num}"
    else
        # Если нет коммитов с M-N форматом, начинаем с M-1
        feature="M-1"
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
