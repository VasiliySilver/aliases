#!/bin/bash

# Функция для завершения хотфикса
function finish-hotfix() {
    read -p "Введите номер хотфикса: " version
    echo "Завершение хотфикс��: $version"
    echo "Текущий статус репозитория:"
    git status
    read -p "Хотите добавить все изменения? (y/n): " add_all
    if [ "$add_all" = "y" ]; then
        git add .
    else
        read -p "Введите файлы для добавления (через пробел): " files
        git add $files
    fi
    echo "Создание коммита..."
    cz 
    git flow hotfix finish "$version"
}