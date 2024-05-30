#!/bin/bash

###
# Формтирование и линтеры
###
# Убрать предупреждение E501,W505,C901,F401,W605 и игнорировать папку venv
alias flake8='~py -m flake8 --extend-ignore E501,W505,C901,F401,W605 --exclude venv'
alias isort='~py -m isort'
alias black='~py -m black'

gitpep() {
    # Форматировать файлы которые помечены на коммит
    # pip install black autoflake isort pylint vulture flake8
    files=$(git diff --cached --name-only)
    res=$(python -c '
files="""'$files'""" 
for file in files.split("\n"):
    if file.endswith(".py"):
        # Форматирование кода
        print("python -m black " + file + ";")
        print("python -m autoflake --in-place --remove-unused-variables --remove-all-unused-imports --ignore-init-module-imports --expand-star-imports " + file + ";")
        print("python -m isort " + file + ";")
        print("python -m black " + file + ";")
        # Анализаторы кода
        # print("python -m pylint " + file + ";")
        print("python -m vulture " + file + ";")
        print("python -m flake8  " + file + ";")
    ')
    echo $res
    eval $res
}

# pep 8
pep() {
    # Форматировать Python код
    # $1 =  путь к файлу или папки, если указана папка то тогда отформатируется вссе файлы в этой папке

    # Форматирвоать отстпов
    black $1
    # Удалить неиспользуемые импорты
    pimport $1
    # Отсортировать Импроты
    isort $1
}
# ppep8() {
#     # Отформатировать python файл
#     # $1 =  путь к файлу или папки, если указана папка то тогда отформатируется вссе файлы в этой папке
#     # Установить `pip install autopep8`
#     if [[ -f $1 ]]; then
#         ~py -m autopep8 --in-place --aggressive -v $1
#     elif [[ -d $1 ]]; then
#         ~py -m autopep8 --in-place --aggressive -v -r $1
#     fi
# }
pimport() {
    # Форматировать иморты, удалить не используемые импорты
    # $1 =  путь к файлу или папки, если указана папка то тогда отформатируется вссе файлы в этой папке
    # Установить `pip install autoflake`
    if [[ -f $1 ]]; then
        ~py -m autoflake --in-place --remove-unused-variables $1
    elif [[ -d $1 ]]; then
        ~py -m autoflake --in-place --remove-unused-variables -r $1
    fi
}

# PIP
# Установаить пакет
pipin() {
    # Если актевировано окружение то установить пакет в него
    res=""
    if [[ -n $VIRTUAL_ENV ]]; then
        res="$VIRTUAL_ENV/bin/python -m pip install $1"
    else
        res="~py -m pip install $1"
    fi
    echo $res
    eval $res && ~py -c '''
import pathlib
import sys
import re

path_self = sys.argv[1]
package = sys.argv[2]

requirements = pathlib.Path(path_self) / "requirements.txt"

if requirements.exists():
    if_exist = re.search(f"{package}[ \t><=!\n]", requirements.read_text())
    if not if_exist:
        with requirements.open("a") as f:
            f.write(f"{package}\n")
else:
    requirements.write_text(package)
    ''' $(pwd) $1
}
# Удалить пакет
piprm() {
    # Если актевировано окружение то удляем пакет из него
    res=""
    if [[ -n $VIRTUAL_ENV ]]; then
        res="$VIRTUAL_ENV/bin/python -m pip uninstall $1"
    else
        res="~py -m pip uninstall $1"
    fi
    echo $res
    eval $res && ~py -c '''
import pathlib
import sys
import re

path_self = sys.argv[1]
package = sys.argv[2]

requirements = pathlib.Path(path_self) / "requirements.txt"

if requirements.exists():
    rt = requirements.read_text()
    rtn = re.sub(f"{package}[ \t><=!\n]","", rt)
    requirements.write_text(rtn)
    ''' $(pwd) $1
}
# Обновить сам pip
pipup-self() {
    # Обновить pip
    ~py -m pip install --upgrade pip
}
# Poetry
poetry-() {
    res=""
    if [[ -n $VIRTUAL_ENV ]]; then
        res="$VIRTUAL_ENV/bin/python -m poetry $@"
    else
        res="~py -m poetry $@"
    fi
    echo $res
    eval $res
}

poetry-req() {
    # Создать файл requirements.txt
    poetry export --dev --format requirements.txt --output requirements.txt
}

# Venv
# Создать окружение
pcvenv() {
    if [[ -z $1 ]]; then
        b_dirname='venv'
    else
        b_dirname=$1
    fi
    res="~py -m venv $b_dirname"
    echo $res
    eval $res
}
# Актевировать окружение
pavenv() {
    if [[ -z $1 ]]; then
        b_dirname='./venv/bin/activate'
    else
        b_dirname=$1
    fi
    res="source $b_dirname"
    echo $res
    eval $res
}
# Деактивировать окружение
pdvenv() {
    deactivate
}

# Poetry
poetry_init() {
    # Загрузить poetry
    pip install cachecontrol
    pipupdate
    pip install poetry
    poetry install
}

homeruff() {
    res="~py -m ruff $@ --config=$RUFF_ROOT_CONFIG"
    echo $res
    eval $res
}

homemypy() {
    res="~py -m mypy $@ --config-file=$MYPY_ROOT_CONFIG"
    echo $res
    eval $res
}

# -------------------

phttpserver() {
    # Запустить сервер п разадчи файлов
    # $1 порт
    ~py -c '''
from http.server import HTTPServer, SimpleHTTPRequestHandler, test
import sys

class CORSRequestHandler (SimpleHTTPRequestHandler):
    def end_headers(self):
        # Для разрешения CROS.(Запросы от других url)
        self.send_header("Access-Control-Allow-Origin", "*")
        SimpleHTTPRequestHandler.end_headers(self)

test(
    CORSRequestHandler,
    HTTPServer,
    port=int(sys.argv[1]) if len(sys.argv) > 1 else 8000,
)
''' $1
}
