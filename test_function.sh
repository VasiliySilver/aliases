#!/bin/bash

# Функция для запуска тестов
function test() {
    poetry run pytest
}