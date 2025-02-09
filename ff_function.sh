#!/bin/bash

# Функция для завершения ветки
ff() {
    # Получаем текущую ветку
    current_branch=$(git branch --show-current 2>/dev/null)
    if [ -z "$current_branch" ]; then
        echo "Ошибка: Невозможно определить текущую ветку. Убедитесь, что вы в Git-репозитории."
        return 1
    fi

    # Извлекаем название фичи (убираем префикс feature/)
    feature=${current_branch#feature/}
    echo "Текущая ветка: $feature"

    # Проверяем, есть ли изменения в рабочей директории или индексе
    if [ -n "$(git status --porcelain)" ]; then
        # Добавляем все изменения
        git add .

        # Проверяем, есть ли изменения в индексе
        if [ -z "$(git diff --cached --name-only)" ]; then
            echo "Ошибка: Нет изменений для коммита. Завершение ветки отменено."
            return 1
        fi
    fi

    # Проверяем наличие commitizen и создаем завершающий коммит
    if ! command -v cz >/dev/null 2>&1; then
        echo -e "\e[33mПредупреждение: commitizen не установлен\e[0m"
        echo "Для лучшего опыта работы рекомендуется установить commitizen:"
        echo "poetry add commitizen"
        echo "Для продолжения установите commitizen"
        return 1
    fi

    # Создаем завершающий коммит через commitizen
    echo "Создание завершающего коммита через commitizen..."
    if ! cz commit; then
        echo "Ошибка: не удалось создать коммит через commitizen"
        return 1
    fi

    # Завершаем ветку с git-flow
    echo "Завершение ветки $feature..."
    if ! git flow feature finish "$feature"; then
        echo "Ошибка: Не удалось завершить ветку. Убедитесь, что git-flow установлен и настроен."
        return 1
    fi

    # Пушим изменения если настроен remote
    if git remote -v | grep -q "origin"; then
        git push --all
    else
        echo "Предупреждение: Удаленный репозиторий не настроен. Пропуск отправки изменений."
    fi

    echo "Ветка $feature успешно завершена."
}
