#!/bin/bash

# Функция для очистки временных файлов и кэша
function clean() {
    find . -type d -name "__pycache__" -exec rm -rf {} +
    find . -type f -name "*.pyc" -delete
    find . -type f -name "*.pyo" -delete
    find . -type f -name "*.pyd" -delete
    find . -type f -name "*.db" -delete
    rm -rf .pytest_cache
    rm -rf .mypy_cache
}