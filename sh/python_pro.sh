#!/bin/bash

# pep 8
pepd() {
    # Отформатировать все python файлы в указанной диреткории
    # [путь_к_папке] = по умолчанию так где сейчас
    dir=$1
    if [[ -z $dir ]]; then
        dir=$(pwd)
    fi

    ~py -m autopep8 --in-place --aggressive --aggressive -v -r $dir
}

pepf() {
    # Отформатировать python файл
    # [путь_к_файлу]

    ~py -m autopep8 --in-place --aggressive --aggressive -v $1
}

# PIP
pipupdate() {
    # Обновить pip
    ~py -m pip install --upgrade pip
}

pvenv() {
    # Создать виртальное окуржение
    ~py -m venv venv
}

poetry_init() {
    # Звгрузить poetry
    pip install cachecontrol
    pipupdate
    pip install poetry
    poetry install
}
