#!/bin/bash

# Функция для запуска линтера
function lint() {
    echo "Проверка кода линтером и автоисправление..."
    directories=""
    while IFS= read -p "Введите директорию для проверки (или оставьте пустым для продолжения): " dir; do
        if [ -z "$dir" ]; then
            break
        fi
        directories="$directories $dir"
    done

    if [ -z "$directories" ]; then
        directories="."
    fi

    for dir in $directories; do
        echo "Проверка директории: $dir"
        poetry run ruff check "$dir"
        poetry run ruff format "$dir"
        poetry run mypy "$dir"
    done
    echo "Проверка кода завершена."
}

function lint-fix() {
    echo "Проверка кода линтером и автоисправление..."
    directories=""
    while IFS= read -p "Введите директорию для проверки (или оставьте пустым для продолжения): " dir; do
        if [ -z "$dir" ]; then
            break
        fi
        directories="$directories $dir"
    done

    if [ -z "$directories" ]; then
        directories="."
    fi

    for dir in $directories; do
        echo "Проверка и исправление директории: $dir"
        poetry run ruff check --fix "$dir"
        poetry run ruff format "$dir"
    done
    echo "Автоматическое исправление ошибок завершено."
}