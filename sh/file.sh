#!/bin/bash

## Действия с папками
f-dir-copy() {
	# Скопировать папку
	cp -R $1 $2
}
f-dir-rename() {
	# Переименовать папку
	mv $1 $2
}
f-dir-create() {
	# Создать папку
	mkdir $1
}
f-dir-remove() {
	# Удалить папку
	rm -rf $1
}

## Размер Диска и использование его
d-size-folder() {
	# Получить разме файлов в указанной директории
	du $1 -ach -d 1 | sort -h
}
d-size-disk() {
	# Использование дисков
	df -h $@
}
d-list-disk() {
	# Все подключенные диски
	sudo fdisk -l
}
## Tree
tree_() {
	# Показать дерево катологов
	# $1 = Уровень вложенности дерева(Например=3)
	# $2 = Какую директорию посмотерть
	#
	# -a = скрытые файлы
	# -d = только директории
	# -f = показать относительный путь для файлов
	# -L = уровень вложенности
	# -P = поиск по шаблону (* сделать на python)
	# -h = Вывести размер файлов и папок
	# -Q = Заключать названия в двойные кавычки
	# -F = Добовлять символы отличия для папок, файлов и сокетов
	# -I = Исключить из списка по патерну
	res='tree -a -L'

	if [[ -z $1 ]]; then
		res+=' 3'
	else
		res+=" $1"
	fi
	res+=' -h -F'
	if [[ -z $2 ]]; then
		res+=' ./'
	else
		res+=" $2"
	fi
	echo $res
	eval $res
}

## Python

p-joinfile() {
	# Объеденить текс всех файлов из указанной директории
	# 1 - Путь к папке
	# 2 - Кодировка файлов
	# 3 - Разделитель при записи в итоговый файл

	res=$(~py -c '''
import pathlib
import sys

# Путь к папке
dir=sys.argv[1]
# Кодировка файлов
encode=sys.argv[2] # "windows-1251"
# Разделитель при записи в итоговый файл
sep=sys.argv[3] # "\n"

res_text = []
p = pathlib.Path(dir).resolve()
for x in p.glob("*.txt"):
    res_text.append(x.read_text(encode))

(p / "join.out").write_text(sep.join(res_text))

    ''' "$1" "$2" "$3")
	echo $res
}

pls() {
	# Вывести список файлов и деректория, для выбора через TUI.
	res=""
	if [[ -z $1 ]]; then
		res=$(pwd)
	else
		res="$1"
	fi
	~py $BASHLER_PATH/py/core_lister.py $res
}
