#!/bin/bash

######################################################################################
# Мои переменные окурежния
# Если не указн путь к Bashler то брем путь по умолчанию
if [[ -z $BASHLER_PATH ]]; then
    export BASHLER_PATH="$HOME/bashler"
fi
# Путь к файлу автозапуска
if [[ -z $AUTORUN_BASHLER ]]; then
    export AUTORUN_BASHLER="$HOME/.autorun_bashler"
fi
# Путь к найтрокам удаленного доступа
if [[ -z $BASHLER_REMOTE_PATH ]]; then
    export BASHLER_REMOTE_PATH="$HOME/.bashler_remote"
fi
# Путь к Python модулям
export BASHLER_PATH_PY="$BASHLER_PATH/py"
# Путь к парсеру комадной строки
export BASHLER_PATH_PY_PYPARS="$BASHLER_PATH_PY/pypars.py"
######################################################################################
# Открывать файлы с указаным разширенем в указанной программе
alias {txt,md,conf,log}=micro
alias {js,py,cs,ts,html}=code
######################################################################################
#
# Глобальные Alias
#
# Алиасы для программ
alias configer="$DISK/MyProject/PycharmProjects/configer/venv/bin/python3.10 $DISK/MyProject/PycharmProjects/configer/configer/main.py"
alias gitclones="$DISK/MyProject/PycharmProjects/git_clons/venv/bin/python3.10 $DISK/MyProject/PycharmProjects/git_clons/git_clons/main.py"
alias pytots="$DISK/MyProject/python_to_ts_type/venv/bin/python3.11 $DISK/MyProject/python_to_ts_type/main.py"
alias showlogsmal="/home/denis/PycharmProjects/showlofsmal/showlogsmal.bin"
alias ~py=python3.11
alias pip="~py -m pip"
alias ~bpy="~py -m bpython"
alias syncthing="$DISK/AlienApp/aplication/other/Syncthing/syncthing-linux-amd64-v1.20.1/syncthing"
alias dbeaver="snap run dbeaver-ce"
#
alias ..="cd .."
# замена ls на NNN
alias nnn='nnn -de'
######################################################################################
#!/bin/bash

# Git
alias gst="git status"
alias glog="git log"
alias gbra="git branch"
alias gcd="git checkout $1"
alias gmer="git merge $1"
# Разница между коммитами или ветками
alias gdif="git diff $1"
alias grst="git reset --hard"

gadd() {
    # Создать комит всех изменений
    date=$(date +\"%c\")
    req="git add -A && git commit -m '$date - $1'"
    echo $req
    eval $req
}
gaddp() {
    # Создать комит всех изменений и выполнить push
    gadd $@
    echo 'git push'
    git push
}
garch() {
    # Сделать архив текущей ветки
    req="git archive --format zip --output $1.zip "
    req+=$(git rev-parse --abbrev-ref HEAD)
    echo $req
    eval $req
}
grmh() {
    # Удалить файл из отслеживания
    res=`git rm --cached -r $1`
    echo $res
    eval $res
}

gitignore(){
    template='''__pycache__
log
venv
/html
.vscode
/dist
'''
    echo $template > '.gitignore'
}

gremot-up-token() {
    # Обновить токен в URL
    # $1 = Токен
    git_url=$(git remote get-url origin)
    new_token=$1
    new_url=$(~py -c '''
import sys
import re
gir_url = sys.argv[1]
new_token = sys.argv[2]
res=new_token.join(re.search("(.+:).+(@.+)",gir_url).group(1,2))
print(res)
    ''' $git_url $new_token)
    res="git remote set-url origin $new_url"
    echo $res
    eval $res
}

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
# Деактевировать окружение
pdvenv() {
    deactivate
}

# Poetry
poetry_init() {
    # Звгрузить poetry
    pip install cachecontrol
    pipupdate
    pip install poetry
    poetry install
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
    find . -name "*.$1"
}
-find-f() {
    # Поиск файла или папки по указаному шаблоному имени
    find . -iname "$1"
}
-find-tree() {
    # Фильтрация вывода
    # > шаблон_слово
    tree -a -F | grep $@
}
-find-t() {
    # Поиск текста в файлах по указаному шаблону
    # $1 - Что искать
    # $2 - Где искать
    # $3 - Исключить пути из поиска

    res='grep'
    path_="$2"
    if [[ -z $2 ]]; then
        path_="."
    fi
    if [[ -n $3 ]]; then
        res+=" --exclude-dir={$3}"
    fi
    res+=" -rnw '$path_' -e '$1'"
    echo $res
    eval $res
}

-find-chage-more() {
    # Поиск файлов в директории `$1` которые изменялись более `$2` дней
    # `$1` Путь к паке в которой искать
    # `$2` Сколько дней назад изменялось, если нужно сегодня то укажите 0
    # `$3` Во сколько директория можно углубляться, по умолчанию во все

    day=$(expr $2 - 1)

    if [[ $2 -eq 0 ]]; then
        day=0
    else
        # 0 Изменялись сегодня
        # +0 Изменялись вчера и далее
        # +1 Изменялись позавчера и далее
        day="+$day"
    fi

    maxdepth='-maxdepth'
    if [[ -z $3 ]]; then
        maxdepth=""
    else
        maxdepth="$maxdepth $3"
    fi

    # %TY-%Tm-%Td %TT %p\n
    res="find $1 $maxdepth -mtime $day -printf '\033[92m%TY-%Tm-%Td %TT\033[0m\t\033[93m%p\033[0m\n' | sort -r"
    echo $res
    eval $res
}

#!/bin/bash

__read-line-file-return-bash-for() {
    # Прочитать файл с переносами строк и вернуть bash массив
    #
    # Пример испоильзования
    #
    # list_text=`__read-line-file-return-bash-for sd`
    # for x in `echo $das`
    # do
    #     echo ") $x"
    # done
    echo $(~py -c "
import sys
name_file=sys.argv[1]
with open(name_file,'r') as _f:
	data = _f.read()
res=''
for x in data.split():
    res+='\"%s\" ' % x
print(res)
" $1)
}

__write-file() {
    # Записать текст в файл
    echo "$1" >$2
}

__pypars() {
    # Парсить командную строку
    #
    # :Вот так вызывать:
    #
    # parms=$(__pypars $@)
    # eval $parms
    res=$(eval "~py $BASHLER_PATH_PY_PYPARS \"$@\"")
    echo $res
}

#------------------


-uid(){
    #
    # Сгинироровать UUID в виде `x6nUxOD56_MAAA__`
    #
    # echo ${$(uuidgen -t)//-/}
    echo $(~py -c '''
import base64
import random
import re

len_b=8
value = random.getrandbits(64)
by = value.to_bytes(len_b, byteorder="little")
b64 = base64.urlsafe_b64encode(by).decode("ascii")

print(re.sub(r"[\=\-]", "_", b64))
    ''')
}
#!/bin/bash

autorun-bashler() {
    # Логика запуска программ
    tmp_path="/tmp/autorun_bashler"
    exists_tmp_path="$tmp_path/.run_autorun_bashler"

    if [[ -d $tmp_path ]]; then
        echo "Папка существует $tmp_path"
    else
        # Создаем католог в /tmp
        mkdir $tmp_path
        echo "Создана папка $tmp_path"
    fi

    if [[ -f $exists_tmp_path ]]; then
        echo "Уже запущенно. Файл существует $exists_tmp_path"
    else
        if [[ -f $AUTORUN_BASHLER ]]; then
            echo $AUTORUN_BASHLER

            list_dir="$(~py -c '''
import json
from pathlib import Path
import os
p_AUTORUN_BASHLER = Path(os.environ["AUTORUN_BASHLER"])
r = json.loads(p_AUTORUN_BASHLER.read_text())
res = ""
for script in r:
    res += f"{script}\n"
print(res)
''')"
            IFS=$'\n'
            for x in $(echo $list_dir); do
                # Фоновый запуск
                res="$x >/dev/null &"
                echo $res
                eval $res
            done

            touch $exists_tmp_path
        else
            echo "Путь не существует $AUTORUN_BASHLER"
        fi
    fi

}
autorun-bashler-force() {
    # Принудтельно перезапустить программ
    tmp_path="/tmp/autorun_bashler"
    rm -rf $tmp_path
    autorun-bashler
}


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

q = chr(34) # Знак двойных кавычек
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
                "-rsync-server {path_in} {user}@{host}:{path_out} -p {port} {d} {e}".format(
                    path_in=_path["in"],
                    user=user,
                    host=host,
                    path_out=_path["out"],
                    port=port,
                    d="-d_" if _path.get("d") else "",
                    e="-e {q}{f}{q}".format(q=q, f=f"{q} {q}".join(
                        _path["e"])
                    ) if _path.get("e") else ""
                )
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

#!/bin/bash

####
# Работа с оброзом
###

dk-build() {
	# Собрать образ
	# $1 Имя для оброза
	# $2 Путь к папке в которой расположен Dockergile
	# $@ Остальные аргументы

	# Собрать образ
	q1="docker build -t $1 $2 ${@:3}"
	echo $q1
	eval $q1
	# Путь куда сохранятсья настройки созданого образа
	conf_docker_image="conf_docker_image.json"
	# Создать файл с конфигурациями образа
	q2="docker inspect $1 > $2/$conf_docker_image"
	echo $q2
	eval $q2
}
dk-images() {
	# Посмотреть образы
	# $1 - Если -w то будет отлеживать
	if [[ $1 == '-w' ]]; then
		sudo watch -d -n 2 docker images
	else
		docker images
	fi
}

####
# Работа с контейнером
###

dk-run() {
	# Создать и запустить контейнер из оброза
	# $1 Имя для оброза
	# $@ Остальные аргументы

	# Путь куда сохранятсья настройки запущеного контейнера
	conf_docker_container="conf_docker_container.json"
	# Запускаем контейнер и полуаем его ID
	q1="docker run -it ${@:2} --rm -d $1"
	echo $q1
	container_id=$(eval $q1)
	# Создать файл с конфигурациями образа
	q2="docker inspect $container_id > $conf_docker_container"
	echo $q2
	eval $q2
}
dk-create() {
	# Создать контейнер из оброза
	# $1 Имя для оброза
	# $@ Остальные аргументы

	# Путь куда сохранятсья настройки запущеного контейнера
	conf_docker_container="conf_docker_container.json"
	# Запускаем контейнер и полуаем его ID
	container_id=$(docker create -it $1 ${@:2})
	# Создать файл с конфигурациями образа
	q2="docker inspect $container_id > $conf_docker_container"
	echo $q2
	eval $q2
}

dk-attach() {
	# Подключиться выводу консоли контейнера
	# $1 Имя контейнера

	q1="docker container attach $1 ${@:2}"
	echo $q1
	eval $q1
}

dk-sh() {
	# Войти в запущеннй контейнер
	# $1 Имя контейнера
	docker exec -ti $1 /bin/sh
}

dk-start() {
	# Запустить существубщий контенер
	# $1 Имя контейнера
	docker container start $1
}
dk-stop() {
	# Остановить существубщий контенер
	# $1 Имя контейнера
	docker container stop $1
}
dk-restart() {
	# Перезапустить существубщий контенер
	# $1 Имя контейнера
	docker container restart $1
}

dk-ps() {
	# Посмотреть контейнеры
	# $1 - Если -w то будет отлеживать
	if [[ $1 == '-w' ]]; then
		watch -d -n 2 docker ps -a
	else
		docker ps -a
	fi
}

dk-info-ip() {
	# Получить ip адрес указанного контейнера
	# $1 Имя контейнера
	docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

###
# Общее
###
dk-prune() {
	# Отчитстить контейнеры
	docker container prune
	# Отчитстить образы
	docker container prune
}

#################################
#################################
#################################

-docker-compose-select-envfile() {
	# Сохранить путь к env файлу
	# -docker-compose-select-env-file ./file/__env.env
	__write-file $1 .env_path
}
-docker-compose-build() {
	# Запустить образы контейнеров
	if [[ -r .env_path ]]; then
		docker-compose --env-file $(cat .env_path) build
	fi
	docker-compose build
}
-docker-compose-up() {
	# Запустить контейнеры а после окончанию отчистить удалить их
	if [[ -r .env_path ]]; then
		docker-compose --env-file $(cat .env_path) up && docker-compose --env-file $(cat .env_path) rm -fsv
	fi
	docker-compose up && docker-compose rm -fsv
}
-docker-compose-rm() {
	# Удалить ненужные контейнеры
	if [[ -r .env_path ]]; then
		docker-compose --env-file $(cat .env_path) rm -fsv
	fi
	docker-compose rm -fsv
}

#!/bin/bash

# Zsh
-zsh-hotkey() {
	echo "	
Ctrl+a = Переместить курсор в начало команды
Ctrl+e = Переместить курсор в конец команды
Ctrl+r = Поиск команды по истории
Ctrl+c = Прервать команду
Ctrl+z = Свернуть выполненеи команды (fg = вернуться)
Ctrl+w = Удалить слово в право
Ctrl+u = Удалить весь текст в лево
Ctrl+k = Удалить весь текст в право
Ctrl+y = Вставить текст
Ctrl+x затем Ctrl+e = Открыть команду в текстовом редакторе указанным в $(EDITOR), после выхода она вставиться в консоль 
Ctrl+s =  Поставить на паузу выполение команжы (Ctrl+q возобновить)
	"
}
-zsh-edit() {
	# Открыть редактирование zsh
	$EDITOR ~/.zshrc
}
-zsh-install-plugin() {
	# Установить плагины Zsh
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions &&
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting &&
		git clone https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete &&
		mkdir $ZSH_CUSTOM/plugins/poetry &&
		poetry completions zsh >$ZSH_CUSTOM/plugins/poetry/_poetry
}
-zsh-mount-disk() {
	# Примонтировать повседневные  диски

	# Google Disk
	google-drive-ocamlfuse /mnt/google_disk
}
-zsh-clean-history() {
	# Отчистить историю команд
	history -c
}

#!/bin/bash

##################################################
--() {
    # Поиск документции у функции
    ---dev $@ | less
}
an() {
    # Поиск алиасов по имени
    aa-dev $@ -n | less
}
av() {
    # Поиск алиасов по значению
    aa-dev $@ -v | less
}
##################################################

##################################################
# Реализацию писать через постфикс -dev

---dev() {
    # Поиск bash команды в папке bashler
    #
    # [часть_имени_команды]
    #
    ~py -c "
import sys
sys.path.insert(0,'$BASHLER_PATH_PY')
from doc_serach import manger_search_func
manger_search_func()
    " $@
}
aa-dev() {
    # Посик алисов по значению и имени
    #
    # [часть_алиаса]
    # -v                = Поиск по знаечнию
    # -n                = Поиск по имени
    ~py -c "
import sys
sys.path.insert(0,'$BASHLER_PATH_PY')
from doc_serach import search_alias
search_alias()
    " $@ $(alias)

    alias | grep $1
}

#!/bin/bash

# SSH - Сервер
-ssh-keygen() {
    # Сгенерировать ssh ключи
    ssh-keygen
}
-ssh-restart() {
    # Перезапутсить SSH сервер
    res=''
    if [[ $BASE_SYSTEM_OS == "termix" ]]; then
        res="-ssh-stop && -ssh-start"
        echo "Termix - SSH перезагружен "
    elif [[ $BASE_SYSTEM_OS == "ubuntu" ]]; then
        res="sudo systemctl restart shhd"
        echo "Ubuntu - SSH перезагружен"
    fi
    echo $res
    eval $res
}
-ssh-start() {
    # Запустить SSH сервер
    res=''
    if [[ $BASE_SYSTEM_OS == "termix" ]]; then
        res="sshd"
        echo "Termix - SSH перезагружен "
    elif [[ $BASE_SYSTEM_OS == "ubuntu" ]]; then
        res="sudo systemctl start shhd"
        echo "Ubuntu - SSH перезагружен "
    fi
    echo $res
    eval $res
}

-ssh-stop() {
    # Остановить SSH сервер
    res=''
    if [[ $BASE_SYSTEM_OS == "termix" ]]; then
        res="pkill sshd"
        echo "Termix - SSH перезагружен "
    elif [[ $BASE_SYSTEM_OS == "ubuntu" ]]; then
        res="sudo systemctl stop shhd"
        echo "Ubuntu - SSH перезагружен "
    fi
    echo $res
    eval $res
}

# SSH - Подключение к серверу
-ssh-c() {
    # Поключиться по SSH
    # $1 - Имя пользователя
    # $2 - Host(ip) сервера
    # $3 - Порт
    port=22
    if [[ -z $3 ]]; then
        port=$3
    fi
    #
    res=ssh -p 22 "$1@$2"
    echo res
    eval res
}
-ssh-cf() {
    # Поключиться по SSH. Взять данные для подлючения из файла
    # $1 - ПроизвольноеИмя из файла для ssh
    res=$(-ssh-parse-conf $1)
    user=$(echo $res | cut -d "|" -f 1)
    host=$(echo $res | cut -d "|" -f 2)
    port=$(echo $res | cut -d "|" -f 3)
    echo "$user@$host:$port"
    # Подключение по сереру
    ssh -p $port "$user@$host"
}
-ssh-copy-key-cf() {
    # Скопироввать SSH ключ. Взять данные для подлючения из файла
    # $1 - ПроизвольноеИмя из файла для ssh
    res=$(-ssh-parse-conf $1)
    user=$(echo $res | cut -d "|" -f 1)
    host=$(echo $res | cut -d "|" -f 2)
    port=$(echo $res | cut -d "|" -f 3)
    echo "$user@$host:$port"
    ssh-copy-id -p $port "$user@$host"
}

-ssh-parse-conf() {
    # Получаем данные для подключения по `ПроизвольноеИмяПодключения_SSH`
    #
    # $1 = ПроизвольноеИмяПодключения_SSH
    #
    res=$(~py -c '''
import pathlib
import sys
import json

path_to_remote_file = sys.argv[1]
name_connect_from_conf = sys.argv[2]

text_conf = pathlib.Path(path_to_remote_file).read_text()
json_conf = json.loads(text_conf)

conf = json_conf["ssh"].get(name_connect_from_conf)

if conf:
    print(conf["user"], conf["host"], conf["port"], sep="|")
else:
    raise KeyError(
        f"Не найдено SSH подключение по имени - {name_connect_from_conf}"
    )
    ''' $BASHLER_REMOTE_PATH $1)

    echo $res
    return 0 # Выйти из функции 0 хорошо 1 плохо
}

#!/bin/bash

sy-ie() {
    # Проверить включена ли служба в автозапуск
    sudo systemctl is-enabled $1
}
sy-e() {
    # Добвить службу в автозапуск
    sudo systemctl enabled $1
}
sy-d() {
    # Удалить службу из автозапуска
    sudo systemctl disable $1
}
sy-r() {
    # Перезапустить службу
    sudo systemctl restart $1
}
sy-s() {
    # Статус службы
    sudo systemctl status $1
}
sy-str() {
    # Запустить службы
    sudo systemctl start $1
}
sy-stp() {
    # Остановить службу
    sudo systemctl stop $1
}

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
-tree() {
	# > УровеньВложенности ДиректориюПосмотерть
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

-p-joinfile() {
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

#!/bin/bash

# Работа с пакетными менеджарами

pinst() {
	# Установить программу в Linux
	RES_EXE="$(~py -c '''
import json
import sys
import re
from pathlib import Path
import os

platform = sys.argv[-1]
pakage = sys.argv[1]

# Установка программы
if platform == "ubuntu":
	if re.search(".deb$", pakage): 
		# Установка из файла
		print("p-apt-install-file")
	else:
		# Установка из интернета
		print("p-apt-install")
elif platform == "arch":
	print("p-packman-install")
elif platform == "termux":
	print("p-pkg-install")
else:
	print("None")
''' $1 $BASE_SYSTEM_OS) $@"

	echo $RES_EXE
	eval $RES_EXE && ~py -c '''
# Добавить программу в `.bashler_pinst`
import json
import sys
import re
from pathlib import Path
import os

platform = sys.argv[-1]
pakage = sys.argv[1]

# Чтение файла `.bashler_pinst`
home = os.environ["HOME"]
path_bashler_pinst =  Path(f"{home}/.bashler_pinst")
text = path_bashler_pinst.read_text()
if not text:
    text  = "{}"
dict_app = json.loads(text)
# Добавляем приложение
dict_app[pakage] = ""
# Запись в файл `.bashler_pinst`
with open(path_bashler_pinst, "w") as _jsonFile:
	json.dump(dict_app, _jsonFile, skipkeys=False, sort_keys=True, indent=4, ensure_ascii=False)
''' $1 $BASE_SYSTEM_OS
}

prem() {
	# Удалить указаный пакет
	RES_EXE="$(~py -c '''
import sys
import re
os = sys.argv[-1]
pakage = sys.argv[1]
if os == "ubuntu":
	if re.search(".deb$", pakage): 
		# Удалить из файла
		print("p-apt-remove")
	else:
		# Удалить из интернета
		print("p-apt-remove")
elif os == "arch":
	print("p-packman-remove")
elif os == "termux":
	print("p-pkg-remove")
else:
	print("None")
''' $1 $BASE_SYSTEM_OS) $@"

	echo $RES_EXE
	eval $RES_EXE && ~py -c '''
# Добавить программу в `.bashler_pinst`
import json
import sys
import re
from pathlib import Path
import os

platform = sys.argv[-1]
pakage = sys.argv[1]

# Чтение файла `.bashler_pinst`
home = os.environ["HOME"]
path_bashler_pinst =  Path(f"{home}/.bashler_pinst")
text = path_bashler_pinst.read_text()
if not text:
    text  = "{}"
dict_app = json.loads(text)
# Убрать приложение
dict_app.pop(pakage)
# Запись в файл `.bashler_pinst`
with open(path_bashler_pinst, "w") as _jsonFile:
	json.dump(dict_app, _jsonFile, skipkeys=False, sort_keys=True, indent=4, ensure_ascii=False)
''' $1 $BASE_SYSTEM_OS
}

pupd() {
	# Обновить все пакеты
	res=''
	if [[ $BASE_SYSTEM_OS == "termix" ]]; then
		res="p-pkg-update"
	elif [[ $BASE_SYSTEM_OS == "ubuntu" ]]; then
		res="p-apt-update && p-snap-update && p-flatpack-update"
	elif [[ $BASE_SYSTEM_OS == "ubuntu" ]]; then
		res="p-packman-update"
	fi
	eval $res
}

#############
p-apt-baseinstall() {
	# Устновить все необходимые программы

	res=~py -c "

import sys

is_server=sys.argv[1]

if is_server = 'yes':
	print('Server')
	print('Client')

if input('Установить зависемости ? (y/n)') == 'y':
	if is_server:
		os.system(''' 
	# Обновить пакеты
	p-apt-update;
	# Установить пакеты
	sudo apt install git curl wget vim nginx net-tools make tree;
		''')
		
	else:
		os.system(''' 
	# Обновим пакеты apt
	p-apt-update;
	# Устоновим пакетный менеджер flatpak и snap
	sudo apt install flatpak snap
	# Обновить все пакеты в системе
	p-full-update;
	# Установить базовые  пакеты
	sudo apt install git zsh curl micro keepassx net-tools make krusader;
	# Программы snap
	sudo snap install code --classic;
		'''
		)	
else:
	print('Отставить!')
	" $IS_SERVER
}
# -------------------------
p-apt-install() {
	# Установить программу
	sudo apt install $@
}
p-pkg-install() {
	pkg install $@
}
p-apt-install-file() {
	# Установить из файла
	# sudo dpkg -i $1
	p-apt-install $1
}
# -------------------------
p-apt-remove() {
	# Установить программу
	sudo apt remove $@
}
p-pkg-remove() {
	pkg uninstall $@
}
# -------------------------
p-apt-update() {
	# Обновить ссылки, программы, отчистить лишнее
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove && sudo apt clean
}
p-pkg-update() {
	# Обнавления для Termix
	pkg update && pkg upgrade -y && pkg autoclean && apt autoremove
}
p-packman-update() {
	# Обновления для Pacman
	sudo pacman -Syu
}
p-snap-update() {
	# Обнавить программы из Snap
	snap refresh --list
	snap refresh
}
p-flatpack-update() {
	# Обнавить программы из flatpak
	flatpak update
}

# -------------------------

#!/bin/bash

## S = система
s-watch(){
	# Обновление команды через определенный период времяни
	watch -d -n $@
}

#!/bin/bash

export Wireguard_VPN_CONF="wg0"

-vpn-on() {
    # Включить VPN
    sudo wg-quick up $Wireguard_VPN_CONF
}
-vpn-off() {
    # Выключить VPN
    sudo wg-quick down $Wireguard_VPN_CONF
}
-vpn-info() {
    # Информация о подключение к VPN
    sudo wg show
}

#!/bin/bash

#
## Рабата с видео и Gif
#

-gifzip() {
    # Сжать Gif видео
    e="gifsicle -i \"$1\" -o \"out_$1\" --optimize=3 --colors=256 --lossy=30"
    echo $e
    eval $e
}
