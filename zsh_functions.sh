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

# Функция для запуска тестов
function test() {
    poetry run pytest
}

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

# Функция для обновления зависимостей проекта
function update-deps() {
    poetry update
}

# Функция дл�� создания новой миграции базы данных
function revision() {
    read -p "Введите сообщение для миграции: " msg
    poetry run alembic revision --autogenerate -m "$msg"
}


# Функция для инициализации Git Flow
function init-python-project() {
    # Инициализация Git
    echo "Инициализация Git..."
    git init

    # Инициализация Git Flow
    echo "Инициализация Git Flow..."
    git flow init

    # Настройка виртуального окружения с помощью pyenv
    echo "Настройка виртуального окружения..."
    echo -n "Введите имя окружения: "
    read environment

    echo -n "Введите номер версии Python: "
    read python_version

    default_version="3.12.0"

    if [ -n "$(echo "$python_version")" ] && [ "${python_version}" != "" ]; then
        version="${VERSION}"
    else
        echo "Используется версия по умолчанию: ${default_version}"
        version="${default_version}"
    fi

    pyenv virtualenv $version $environment
    echo "Виртуальное окружение '$environment' создано с версией Python $version"

    pyenv local $environment

    # Установка poetry
    echo "Установка poetry..."
    pip install poetry

    # Настройка poetry
    echo "Настройка poetry..."
    poetry config virtualenvs.create false
    poetry config virtualenvs.in-project true
    poetry init

    # Установка зависимостей для разработки
    echo "Установка зависимостей для разработки..."
    poetry add commitizen ruff pytest black isort

    # Инициализация commitizen
    echo "Инициализация commitizen..."
    cz init

    # Генерация .gitignore для Python
    echo "Генерация .gitignore для Python..."
    cat << EOF > .gitignore
# Виртуальные окружения
venv/
env/

# Сборка
build/
dist/
*.egg-info/
.installed.cfg
*.spec

# Документация
docs/_build/
*.log

# Тесты
tests/
test_*.py
.pytest_cache/

# Л��нтеры
__pycache__/
*.py[cod]
*$py.class
*~.py
*.pyo
*.pyc
*.pyd

# IDE
.vscode/
.idea/
*.swp
*.swo

# Отладка
*.pyd
*.so

# Результаты сборки
*.exe
*.dll
*.dylib
*.so

# Кэширование
*.cache
*.lock

# Файлы ��онфигурации
*.conf
*.cfg
*.json
*.ini

# Файлы логов
*.log
*.out
*.txt

# Файлы сборки
*.exe
*.zip
*.tar.gz
*.tgz
*.tar.bz2
*.bz2
*.rar
*.7z

# Файлы архива
*.gz
*.tar
*.ar
*.zip
*.cab
*.jar
*.war
*.ear
*.rar
*.7z
EOF
    
    # Выполнение функций старта и финиша новой фичи
    echo "Выполнение функций старта и финиша новой фичи..."
    fs
    ff
    
    # Загрузка изменений в удаленный репозиторий
    echo "Загрузка изменений в удаленный репоситорий..."
    gh repo create

    echo "Инициализация завершена!"
}

# Функция для создания новой ветки
fs() {
    echo "2 последних изменения в репозитории:"
    git log --oneline -4
    
    # Try to detect project prefix from existing commits - handles both single letters and complex prefixes
    prefix=$(git log --oneline | grep -oE 'feat\(([A-Z]-|[A-Z0-9]+-)?[0-9]+\)' | head -1 | grep -oE '[A-Z]-|[A-Z0-9]+-' || echo "")
    
    # Get highest existing number from commit messages
    current_max=$(git log --oneline | grep -oE 'feat\(([A-Z]-|[A-Z0-9]+-)?[0-9]+\)' | grep -oE '[0-9]+' | sort -n | tail -1)
    
    # Set next number (or start with 1 if no branches exist)
    next_num=$((${current_max:-0} + 1))
    
    # Generate suggested branch name
    suggested_feature="${prefix}${next_num}"
    
    echo "Создать ветку с автоматическим названием '$suggested_feature'? (y/n)"
    read auto_name
    
    if [ "$auto_name" = "y" ]; then
        feature=$suggested_feature
    else
        echo "Введите название новой ветки"
        read custom_name
        feature=$custom_name
    fi
    
    echo "Создание новой ветки: $feature"
    git flow feature start "$feature"
}


# Функция для завершения ветки
ff() {
    current_branch=$(git branch --show-current)
    feature=${current_branch#feature/}
    
    echo "Текущая ветка: $feature"
    echo "Хотите завершить ветку $feature? (y/N)"
    read confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Отмена завершения ветки"
        return 0
    fi
    
    echo "Текущий статус репозитория:"
    git status
    
    echo "Хотите добавить все изменения? (y/n)"
    read add_all
    if [ "$add_all" = "y" ]; then
        git add .
    else
        echo "Введите файлы для добавления (через пробел)"
        read files
        git add $files
    fi
    
    echo "Создание коммита..."
    cz commit
    git flow feature finish "$feature"
    git push --all
}


# Функция для релиза
release() {
    echo "Определение следующей версии..."
    
    # Get next version from commitizen
    next_version=$(cz bump --dry-run | grep "bump: version" | awk -F'→' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')
    
    # If no version found, set initial version
    if [ -z "$next_version" ]; then
        next_version="0.2.0"
        echo "Первый релиз. Следующая версия: $next_version"
    fi
    
    echo "Следующая версия: $next_version"
    echo "Подтверждаете ли вы эту версию? (y/n)"
    read confirm
    
    if [ "$confirm" != "y" ]; then
        echo "Введите номер релиза вручную"
        read version
    else
        version=$next_version
    fi
    
    echo "Создание новой ветки релиза: $version"
    if ! git flow release start "$version"; then
        echo "Ошибка: Не удалось создать ветку релиза."
        return 1
    fi
    
    echo "Завершение релиза: $version"
    if ! cz changelog; then
        echo "Ошибка: Не удалось сгенерировать changelog."
        return 1
    fi
    
    if ! cz bump --yes; then
        echo "Ошибка: Не удалось обновить версию."
        return 1
    fi
    
    if ! git tag -d "$version" 2> /dev/null; then
        echo "Предупреждение: Тег $version не найден для удаления."
    fi
    
    if ! git flow release finish "$version"; then
        echo "Ошибка: Не удалось завершить релиз."
        return 1
    fi
    
    if ! git push --all; then
        echo "Ошибка: Не удалось отправить изменения в origin."
        return 1
    fi
    
    if ! git push --tag; then
        echo "Ошибка: Не удалось отправить теги."
        return 1
    fi
}



# Функция для начала нового хотфикса
function start-hotfix() {
    read -p "Введите номер хотфикса: " version
    echo "Создание новой ветки хотфикса: $version"
    git flow hotfix start "$version"
}

# Функция ��ля завершения хотфикса
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
    cz commit
    git flow hotfix finish "$version"
}
