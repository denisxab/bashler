#!/bin/bash

# rsync

-rsync-local-folder() {
	# Синхронизировать локальные папки
	# > откуда куда
	# -e папка_1 папка_... 	= Исключить папки или файлы из сихронизации
	# --dry-run			 	= Показать какие файлы будут сихронезированы без выполени программы
	exclud_folder=$(__rsync-exlude-folder $@)
	rsync -azvh --progress $1 $2 $exclud_folder
}
-rsync-delete-local-folder() {
	# Синхронизировать папки, если в ВЫХОДНОЙ(out) папке отличия, то удалить их
	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
	exclud_folder=$(__rsync-exlude-folder $@)
	rsync -azvh --progress --delete $1 $2 $exclud_folder
}
-rsync-server-folder() {
	# Синхронезировать с сервером по SSH
	# > port username@ip:path localpath
	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
	exclud_folder=$(__rsync-exlude-folder $@)
	rsync -azvh --progress -e "ssh -p $1" $2 $3 $exclud_folder
}
-rsync-delete-server-folder() {
	# Синхронезировать с сервером по SSH, если в ВЫХОДНОЙ(out) папке отличия, то удалить их
	# > port username@ip:path localpath
	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
	exclud_folder=$(__rsync-exlude-folder $@)
	rsync -azvh --progress --delete -e "ssh -p $1" $2 $3 $exclud_folder
}
##############
-rsync-read-file() {
	# Прочитать файл с сохранеными путями синхронизации
	eval $(~py -c "
import os.path
file = '.rsyncpath'
if os.path.exists(file):
    with open(file, 'r') as _f:
        print(_f.read())
	" $@)
}
__rsync-exlude-folder() {
	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
	# можно создать файл .rsyncignore(по типу .gitignore) для хранения исключений
	~py -c "
import os.path
import sys

def main(argv:list):
    '''
    >>> main(['sd', 'in', 'out', '-e', 'ewe', 'edde', 'deed'])
    --exclude=ewe --exclude=edde --exclude=deed
    '''
    file = '.rsyncignore'
    exclude = []
    # Получаем исключения из консоли
    exclude.extend(argv[3:])
    if exclude and exclude.pop(0) == '-e':
        # Получаем исключения из файла
        if os.path.exists(file):
            with open(file, 'r') as _f:
                exclude.extend(_f.read().split('\n'))
        res = ''
        for x in exclude:
            res += '--exclude=%s ' % x
        # убрать последний пробел
        res = res[:-1] if res.endswith(' ') else res
        print(res)
    else:
        print('', end='')
main(sys.argv)
	" $@
}
