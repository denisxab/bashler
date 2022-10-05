#!/bin/bash

# Find
-find() {

    # find [ОткудаИскать...] -name "ЧтоИскать"

    # `*`				= Любой символ до и после
    # -iname 			= Поиск БЕЗ учета регистра
    # -name 			= Поиск С учетом регистра
    # --not -name 		= Поиск НЕ совпадений шаблону
    # -maxdepth Число 	= Максимальная глубина поиска
    # -type d			= Поиск только папок
    # -type f			= Поиск только файлов
    # -perm 0664		= Поиск по разришению файлов

    # -mtime Дней		= Модифецированные столько дней назад
    # -atime Дней		= Открытые столько дней назад

    # -not 		= НЕ
    # -o 		= ИЛИ
    find $@
}
-find-e() {
    # Поиск всех файлов с указаным разширением
    find . -name *.$1
}
-find-f() {
    # Поиск файла или папки по указаному шаблоному имени
    find . -name $1
}
-find-tree() {
    # Фильтрация вывода
    # > шаблон_слово
    tree -a -F | grep $@
}
-find-t() {
    # Поиск текста в файлах по указаному шаблону
    res='grep'
    if [[ -n $2 ]]; then
        res+=" --exclude-dir={$2}"
    fi
    res+=" -rnw . -e $1"
    echo $res
    eval $res
}

-find-c() {
    # TODO Доделать дни для поиска, тестировал в /media/denis/dd19b13d-bd85-46bb-8db9-5b8f6cf7a825/Dowload/srinchot/
    # Файлы в директории `$1` которые не изменялись более `$2` дней
    day=$(expr $2 - 1)
    if [[ $2 -eq 0 ]]; then
        day=0
    fi
    if [[ day -gt 0 ]]; then
        day="+$day"
    fi
    res="find $1 -mtime $day  -printf '%TY-%Tm-%Td %TT %p\n' | sort -r"
    echo $res
    eval $res
}
