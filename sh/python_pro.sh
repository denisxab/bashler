#!/bin/bash

# pep 8
pep() {
    # $1 =  путь к файлу или папки, если указана папка то тогда отформатируется вссе файлы в этой папке
    pimport $1 && ppep8 $1
}
ppep8() {
    # Отформатировать python файл
    # $1 =  путь к файлу или папки, если указана папка то тогда отформатируется вссе файлы в этой папке
    # Установить `pip install autopep8`
    if [[ -f $1 ]]; then
        ~py -m autopep8 --in-place --aggressive -v $1
    elif [[ -d $1 ]]; then
        ~py -m autopep8 --in-place --aggressive -v -r $1
    fi

}
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
pipupdate() {
    # Обновить pip
    ~py -m pip install --upgrade pip
}

# Venv
pvenv() {
    # Создать виртальное окуржение
    if [[ -z $1 ]]; then
        b_dirname='venv'
    else
        b_dirname=$1
    fi
    res="~py -m venv $b_dirname"
    echo $res
}

# Poetry
poetry_init() {
    # Звгрузить poetry
    pip install cachecontrol
    pipupdate
    pip install poetry
    poetry install
}
