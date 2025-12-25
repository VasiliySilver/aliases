# =========================================================================
# Начало функций для инициализации Python-проектов с uv
# (Возвращаемся к ручной генерации pyproject.toml для контроля `requires-python`)
# =========================================================================

# Вспомогательная функция для проверки и установки uv
_ensure_uv_for_init_project() {
    echo "--- Проверка uv ---"
    if ! command -v uv &> /dev/null; then
        echo "uv не найден. Устанавливаем uv..."
        if ! command -v curl &> /dev/null; then
            echo "Ошибка: curl не установлен. Невозможно установить uv. Пожалуйста, установите curl." >&2
            return 1
        fi
          curl -LsSf https://astral.sh/uv/install.sh | sh
          export PATH="$HOME/.cargo/bin:$PATH" # Добавляем uv в PATH для текущей сессии
          echo "uv установлен и добавлен в PATH."
      else
          echo "uv уже установлен."
      fi

      if ! command -v uv &> /dev/null; then
          echo "Ошибка: uv был установлен, но не найден в PATH после установки. Проверьте ваш PATH." >&2
          return 1
      fi
      echo "--- uv готов к работе ---"
      return 0
  }


  # Основная функция для инициализации Python проекта с uv
  init-python-uv() {
      local _original_set_e_status=$(shopt -oq errexit; echo $?)
      local _original_set_x_status=$(shopt -oq xtrace; echo $?)
      set -e

      # set -x # <-- Оставляем раскомментированным для отладки

      local LOG_FILE="init_project_debug.log"
      rm -f "$LOG_FILE" # Удаляем старый лог перед каждым запуском
      # exec 2> >(tee -a "$LOG_FILE" >&2) # Дублирует stderr (включая set -x) в файл и в терминал

      echo "=== НАЧАЛО: Запуск init-python-project ==="

      # Инициализация Git
      echo "Шаг: Инициализация Git..."
      git init || { echo "ОШИБКА: Не удалось инициализировать Git." >&2; return 1; }

      # Инициализация Git Flow
      echo "Шаг: Инициализация Git Flow..."
      git flow init -d || { echo "ОШИБКА: Не удалось инициализировать Git Flow. Убедитесь, что git-flow установлен." >&2; return 1; }

      # Проверка и установка uv
      echo "Шаг: Проверка и установка uv..."
      _ensure_uv_for_init_project || { echo "ОШИБКА: Не удалось обеспечить наличие uv. Выход."; return 1; }

      # Запрос версии Python
      echo "Шаг: Запрос версии Python..."
      echo -n "Введите желаемую версию Python (например, 3.12): "
      read python_version
      local default_version="3.12"

      if [ -z "$python_version" ]; then
          echo "Используется версия по умолчанию: ${default_version}"
          python_version="${default_version}"
      fi

      # Создание виртуального окружения
      echo "Шаг: Создание виртуального окружения для Python $python_version..."
      if [ -d ".venv" ]; then
          echo "Обнаружена существующая директория .venv. Удаляем..."
          rm -rf .venv || { echo "ОШИБКА: Не удалось удалить существующую директорию .venv. Проверьте права доступа." >&2; return 1; }
      fi

      # Создание .venv с помощью uv venv
      uv venv .venv --python "$python_version" || {
          echo "---------------------------------------------------------" >&2
          echo "ОШИБКА: Не удалось создать виртуальное окружение с uv!" >&2
          echo "Возможные причины:" >&2
          echo "  1. Python $python_version не установлен в вашей системе." >&2
          echo "  2. Python $python_version не находится в вашем системном PATH." >&2
          echo "  3. uv не может найти интерпретатор Python для этой версии." >&2
          echo "Пожалуйста, убедитесь, что Python $python_version установлен и доступен." >&2
          echo "---------------------------------------------------------" >&2
          return 1
      }
      echo "Виртуальное окружение '.venv' создано."
      source .venv/bin/activate
      echo "Виртуальное окружение '.venv' активировано."

      # Создание pyproject.toml с правильной спецификацией `requires-python`
    echo "Шаг: Создание pyproject.toml..."
    local python_version_nodots="${python_version//./}" # Преобразуем 3.13 в 313 для target-version
    cat << EOF > pyproject.toml
[project]
name = "$(basename "$(pwd)")"
version = "0.1.0"
description = "A short description of my project."
authors = [{ name = "Your Name", email = "your.email@example.com" }]
requires-python = ">=${python_version}" # <-- ИСПРАВЛЕНО: используем ~ вместо ~
dependencies = []

[tool.uv]
# Configuration specific to uv can go here

[tool.ruff]
line-length = 88
target-version = "py${python_version_nodots}"

[tool.pytest.ini_options]
addopts = "--strict-markers"

[tool.black]
line-length = 88
target-version = ["py${python_version_nodots}"]

[tool.isort]
profile = "black"
line_length = 88

[tool.commitizen]
name = "cz_conventional_commits"
EOF
    echo "pyproject.toml создан."

    # Установка зависимостей для разработки с помощью uv add
    echo "Шаг: Установка зависимостей для разработки с uv add..."
    uv add ruff pytest black isort commitizen flake8 debugpy --dev || {
        echo "ОШИБКА: Не удалось установить зависимости для разработки с uv add." >&2
        echo "Проверьте подключение к интернету или правильность pyproject.toml." >&2
        return 1
    }
    echo "Зависимости для разработки установлены."

    # # Проверка и установка commitizen через npm
    # echo "Шаг: Проверка и установка commitizen через npm..."
    # _ensure_commitizen_for_init_project || { echo "ОШИБКА: Не удалось обеспечить наличие commitizen. Выход."; return 1; }

    # Инициализация commitizen
    echo "Шаг: Инициализация commitizen..."
    cz init || echo "Предупреждение: Инициализация Commitizen не удалась или была пропущена. Возможно, вам потребуется настроить его вручную."

    # Генерация .gitignore для Python
    echo "Шаг: Генерация .gitignore для Python..."
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
#   Usually these files are written by a python script from a template
#   before PyInstaller builds the exe, so as to inject date/other infos into it.
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
uv.lock # Explicitly include uv.lock if you want reproducibility

# poetry
#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control
poetry.lock

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
#   JetBrains specific template is maintained in a separate JetBrains.gitignore that can
#   be found at https://github.com/github/gitignore/blob/main/Global/JetBrains.gitignore
#   and can be added to the global gitignore or merged into this file.  For a more nuclear
#   option (not recommended) you can uncomment the following to ignore the entire idea folder.
#.idea/

# Ruff stuff:
.ruff_cache/

# PyPI configuration file
.pypirc
EOF
    echo ".gitignore создан."


    # Выполнение функций старта и финиша новой фичи
    echo "Шаг: Выполнение функций старта и финиша новой фичи..."
    echo -n "Введите имя для первой Git Flow фичи (например, initial-setup): "
    read feature_name
    if [ -z "$feature_name" ]; then
        feature_name="initial-setup"
        echo "Имя фичи не введено, используется по умолчанию: ${feature_name}"
    fi

    
    # 1. Создаём feature и делаем коммит
    git flow feature start "$feature_name" || { echo "ОШИБКА: Не удалось начать новую фичу Git Flow." >&2; return 1; }
    git add . || { echo "ОШИБКА: Не удалось добавить файлы в Git." >&2; return 1; }
    git commit -m "feat: init project" || { echo "ОШИБКА: Не удалось сделать коммит." >&2; return 1; }

    # 2. Создание удалённого репозитория
    gh repo create || {
        echo "Предупреждение: Не удалось создать удаленный репозиторий через gh." >&2
    }

    # 3. Пуш feature на remote
    git push -u origin feature/"$feature_name" || { echo "ОШИБКА: Не удалось запушить feature на remote." >&2; return 1; }

    # 4. Завершаем feature локально (удаление remote-ветки произойдёт, если возможно)
    git flow feature finish "$feature_name" || echo "Предупреждение: локальная feature завершена, remote-ветка осталась."

    # 5. Переключаемся на develop
    git checkout develop || { echo "ОШИБКА: Не удалось переключиться на develop." >&2; return 1; }


    echo "=== КОНЕЦ: Инициализация завершена! ==="
    echo "Виртуальное окружение активировано. Для деактивации используйте 'deactivate'."

    # Восстанавливаем состояние set -e и set -x
    [ "$_original_set_e_status" -eq 1 ] && set +e || true
    [ "$_original_set_x_status" -eq 1 ] && set +x || true
    exec 2>&1 # Возвращаем stderr в обычное состояние
}

# =========================================================================
# Конец функций
# =========================================================================
