#!/bin/bash

# Функция для создания новой ветки
fs() {
    # Проверяем, находимся ли мы в Git-репозитории
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Ошибка: Это не Git-репозиторий."
        return 1
    fi

    # Извлечение номеров задач (только числа) из коммитов
    feature_branches=$(git log --oneline | grep -E 'feat\((.*)\): #([0-9]+) - ' | sed -E 's/.*#([0-9]+).*/\1/')

    # Если список веток пуст, начинаем с 1
    if [ -z "$feature_branches" ]; then
      next_num=1
    else
      # Получение следующего номера, сортировка по убыванию и прибавление 1
      next_num=$(echo "$feature_branches" | sort -nr | head -n1)
      next_num=$((next_num + 1))
    fi

    feature="#$next_num"

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
