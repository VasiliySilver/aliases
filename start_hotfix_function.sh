#!/bin/bash

# Функция для начала нового хотфикса
function start-hotfix() {
    read -p "Введите номер хотфикса: " version
    echo "Создание новой ветки хотфикса: $version"
    git flow hotfix start "$version"
}
