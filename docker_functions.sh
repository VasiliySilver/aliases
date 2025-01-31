#!/bin/bash

# Функция для запуска всех сервисов
function up() {
    docker compose -f docker/docker-compose.local.yml up -d
}

# Функция для остановки всех сервисов
function down() {
    docker compose -f docker/docker-compose.local.yml down
}

# Функция для перезапуска всех сервисов
function restart() {
    down
    up
}

# Функция для запуска локального API
function local-api() {
    docker compose -f docker/docker-compose.local.yml up -d api
}

# Функция для запуска локального бота
function local-bot() {
    docker compose -f docker/docker-compose.local.yml up -d bot
}

# Функция для запуска локального Celery worker
function local-celery() {
    docker compose -f docker/docker-compose.local.yml up -d celery
}

# Функция для просмотра логов контейнеров
function logs() {
    docker compose -f docker/docker-compose.local.yml logs -f
}

# Функция для сборки образов
function build() {
    docker compose -f docker/docker-compose.development.yml build
}