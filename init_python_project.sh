#!/bin/bash

# Функция для проверки и установки commitizen через npm
function ensure_commitizen() {
    if ! command -v cz &> /dev/null; then
        echo "commitizen не найден. Устанавливаем через npm..."
        if ! command -v npm &> /dev/null; then
            echo "npm не установлен. Установите Node.js и npm перед продолжением."
            exit 1
        fi
        npm install -g commitizen
    fi
}

# Функция для инициализации Git Flow
function init-python-project() {
    # Инициализация Git
    echo "Инициализация Git..."
    git init

    # Инициализация Git Flow
    echo "Инициализация Git Flow..."
    git flow init -d

    # Настройка виртуального окружения с помощью pyenv
    echo "Настройка виртуального окружения..."
    echo -n "Введите имя окружения: "
    read environment

    echo -n "Введите номер версии Python: "
    read python_version

    default_version="3.12.0"

    if [ -n "$python_version" ]; then
        version="$python_version"
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
    poetry init -n  # Используем -n для неинтерактивного режима

    # Установка зависимостей для разработки
    echo "Установка зависимостей для разработки..."
    poetry add ruff pytest black isort --dev

    # Проверка и установка commitizen через npm
    echo "Проверка и установка commitizen через npm..."
    ensure_commitizen

    # Инициализация commitizen
    echo "Инициализация commitizen..."
    cz init || echo "Ошибка инициализации commitizen. Продолжаем..."

    # Генерация .gitignore для Python
    echo "Генерация .gitignore для Python..."
    cat << EOF > .gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
#   For a library or package, you might want to ignore these files since the code is
#   intended to run in multiple environments; otherwise, check them in:
# .python-version

# pipenv
#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
#   However, in case of collaboration, if having platform-specific dependencies or dependencies
#   having no cross-platform support, pipenv may install dependencies that don't work, or not
#   install all needed dependencies.
#Pipfile.lock

# UV
#   Similar to Pipfile.lock, it is generally recommended to include uv.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#uv.lock

# poetry
#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control
#poetry.lock

# pdm
#   Similar to Pipfile.lock, it is generally recommended to include pdm.lock in version control.
#pdm.lock
#   pdm stores project-wide configurations in .pdm.toml, but it is recommended to not include it
#   in version control.
#   https://pdm.fming.dev/latest/usage/project/#working-with-version-control
.pdm.toml
.pdm-python
.pdm-build/

# PEP 582; used by e.g. github.com/David-OConnor/pyflow and github.com/pdm-project/pdm
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/

# PyCharm
#  JetBrains specific template is maintained in a separate JetBrains.gitignore that can
#  be found at https://github.com/github/gitignore/blob/main/Global/JetBrains.gitignore
#  and can be added to the global gitignore or merged into this file.  For a more nuclear
#  option (not recommended) you can uncomment the following to ignore the entire idea folder.
#.idea/

# Ruff stuff:
.ruff_cache/

# PyPI configuration file
.pypirc
EOF

    # Выполнение функций старта и финиша новой фичи
    echo "Выполнение функций старта и финиша новой фичи..."
    git flow feature start C-1
    git add .
    git commit -m "feat: init project"

    # Загрузка изменений в удаленный репозиторий
    echo "Загрузка изменений в удаленный репозиторий..."
    gh repo create 
    git push -u origin develop

    echo "Инициализация завершена!"
}