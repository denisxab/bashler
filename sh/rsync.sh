#!/bin/bash

-rsync-server() {
	# Синхронезировать с сервером по SSH, если в ВЫХОДНОЙ(out) папке отличия, то удалить их
	#
	# $1 = localpath
	# $2 = username@ip:pat
	# -p = port
	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
	# -d = Удаляить файлы и папки в `out` если их нет в `in`
	# rsync -azvh --progress ./firebird_book1 root@5.63.154.238:/home/ubuntu/test -e "ssh -p 22"

	#
	# Парсим командную строку
	#
	parms=$(__pypars $@)
	echo $parms
	eval $parms
	#
	# Исключение папок
	#
	exclud_folder=""
	if [[ -n ${e[@]} ]]; then
		for key in "${e[@]}"; do
			exclud_folder="$exclud_folder --exclude=$key"
		done
	fi
	#
	# Порт
	#
	SSH_RES=""
	if [[ -n $3 ]] && [[ ${3:0:2} != '-e' ]]; then
		SSH_RES="-e \"ssh -p ${p[1]}\""
	fi
	#
	# Нужно ли удалять файлы и папки в `out` если их нет в `in`
	#
	is_delete=""
	if [[ ${_f[*]} =~ "d" ]]; then
		is_delete='--delete'
	fi
	#
	# Формируем и выполняем запрос
	#
	res="rsync -azvh --progress $is_delete ${_p[1]} ${_p[2]} $SSH_RES $exclud_folder"
	echo $res
	eval $res
}

-rsync-parse-conf() {
	# Выполнить синхронизацию из `.bash_remote.json`
	#
	# $1 = ПроизвольноеИмяПодключения_RSYNC
	#
	res=$(~py -c '''
import pathlib
import sys
import json

path_to_remote_file = sys.argv[1]
name_connect_from_conf = sys.argv[2]

json_conf = json.loads(pathlib.Path(path_to_remote_file).read_text())
# Конфигурация Rsync
conf_rsync = json_conf["rsync"].get(name_connect_from_conf)
res = []

if conf_rsync:
    # Конфигурация SSH которая указана в Rsync
    conf_ssh = json_conf["ssh"].get(conf_rsync["ssh"])
    if conf_ssh:
        port = conf_ssh["port"]
        user = conf_ssh["user"]
        host = conf_ssh["host"]
        for _path in conf_rsync["sync_dir"]:
            # Формируем команды
            res.append(
                f"""-rsync-server {_path["in"]} {user}@{host}:{_path["out"]} -p {port} {"-d_" if _path.get("d") else ""}"""
            )
else:
    raise KeyError(
        f"Не найдено SSH подключение по имени - {name_connect_from_conf}"
    )

# Выводим команды
print(";\n".join(res))
    ''' $BASHLER_REMOTE_PATH $1)

	echo $res
	eval $res
}

#################
# -rsync-local-folder() {
# 	# Синхронизировать локальные папки
# 	# > откуда куда
# 	# -e папка_1 папка_... 	= Исключить папки или файлы из сихронизации
# 	# --dry-run			 	= Показать какие файлы будут сихронезированы без выполени программы
# 	exclud_folder=$(__rsync-exlude-folder $@)
# 	res="rsync -azvh --progress $1 $2 $exclud_folder"
# 	echo $res
# 	eval $res
# }
# -rsync-delete-local-folder() {
# 	# Синхронизировать папки, если в ВЫХОДНОЙ(out) папке отличия, то удалить их
# 	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
# 	exclud_folder=$(__rsync-exlude-folder $@)
# 	res="rsync -azvh --progress --delete $1 $2 $exclud_folder"
# 	echo $res
# 	eval $res
# }
# -rsync-server-folder() {
# 	# Синхронезировать с сервером по SSH
# 	# > port username@ip:path localpath
# 	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
# 	exclud_folder=$(__rsync-exlude-folder $@)
# 	SSH_RES="ssh -p $1"
# 	res="rsync -azvh --progress -e $SSH_RES $2 $3 $exclud_folder"
# 	echo $res
# 	eval $res
# }

##############
# -rsync-read-file() {
# 	# Прочитать файл с сохранеными путями синхронизации
# 	eval $(~py -c "
# import os.path
# file = '.rsyncpath'
# if os.path.exists(file):
#     with open(file, 'r') as _f:
#         print(_f.read())
# 	" $@)
# }
# __rsync-exlude-folder() {
# 	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
# 	# можно создать файл .rsyncignore(по типу .gitignore) для хранения исключений
# 	~py -c "
# import os.path
# import sys

# def main(argv:list):
#     '''
#     >>> main(['sd', 'in', 'out', '-e', 'ewe', 'edde', 'deed'])
#     --exclude=ewe --exclude=edde --exclude=deed
#     '''
#     file = '.rsyncignore'
#     exclude = []
#     # Получаем исключения из консоли
#     exclude.extend(argv[3:])
#     if exclude and exclude.pop(0) == '-e':
#         # Получаем исключения из файла
#         if os.path.exists(file):
#             with open(file, 'r') as _f:
#                 exclude.extend(_f.read().split('\n'))
#         res = ''
#         for x in exclude:
#             res += '--exclude=%s ' % x
#         # убрать последний пробел
#         res = res[:-1] if res.endswith(' ') else res
#         print(res)
#     else:
#         print('', end='')
# main(sys.argv)
# 	" $@
# }
