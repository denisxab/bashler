#!/bin/bash

######################################################################################
# Мои переменные окурежния
# Путь к диску с данными
export DiskData="/media/denis/dd19b13d-bd85-46bb-8db9-5b8f6cf7a825"
# Путь к Python модулям
export BASHLER_PATH_PY="$BASHLER_PATH/py"
######################################################################################
# Открывать файлы с указаным разширенем в указанной программе
alias -s {txt,md,conf,log}=micro
alias -s {js,py,cs,ts,html}=code
######################################################################################
# Глобальные Alias
alias -g configer="$DiskData/MyProject/PycharmProjects/configer/venv/bin/python3.10 $DiskData/MyProject/PycharmProjects/configer/configer/main.py"
alias -g gitclones="$DiskData/MyProject/PycharmProjects/git_clons/venv/bin/python3.10 $DiskData/MyProject/PycharmProjects/git_clons/git_clons/main.py"
alias -g showlogsmal="/home/denis/PycharmProjects/showlofsmal/showlogsmal.bin"
alias -g ~py=python3.11
alias -g ~bpy="~py -m bpython"
alias -g syncthing="$DiskData/AlienApp/aplication/other/Syncthing/syncthing-linux-amd64-v1.20.1/syncthing"
alias ..="cd .."
# замена ls на NNN
alias ls='nnn -de'
######################################################################################
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
                res="nohup $x >/dev/null &"
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

-rsync-local-folder() {
	# Синхронизировать локальные папки
	# > откуда куда
	# -e папка_1 папка_... 	= Исключить папки или файлы из сихронизации
	# --dry-run			 	= Показать какие файлы будут сихронезированы без выполени программы
	exclud_folder=$(__rsync-exlude-folder $@)
	res="rsync -azvh --progress $1 $2 $exclud_folder"
	echo res
	eval res
}
-rsync-delete-local-folder() {
	# Синхронизировать папки, если в ВЫХОДНОЙ(out) папке отличия, то удалить их
	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
	exclud_folder=$(__rsync-exlude-folder $@)
	res="rsync -azvh --progress --delete $1 $2 $exclud_folder"
	echo res
	eval res
}
-rsync-server-folder() {
	# Синхронезировать с сервером по SSH
	# > port username@ip:path localpath
	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
	exclud_folder=$(__rsync-exlude-folder $@)
	SSH_RES="ssh -p $1"
	res="rsync -azvh --progress -e $SSH_RES $2 $3 $exclud_folder"
	echo res
	eval res
}
-rsync-delete-server-folder() {
	# Синхронезировать с сервером по SSH, если в ВЫХОДНОЙ(out) папке отличия, то удалить их
	# > port username@ip:path localpath
	# -e папка_1 папка_... = Исключить папки или файлы из сихронизации
	exclud_folder=$(__rsync-exlude-folder $@)
	SSH_RES="ssh -p $1"
	res="rsync -azvh --progress --delete -e $SSH_RES $2 $3 $exclud_folder"
	echo res
	eval res
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
	RES_EXE="$(~py -c '''
import sys
import re
os = sys.argv[-1]
pakage = sys.argv[1]
if os == "ubuntu":
	print("p-full-update")
elif os == "arch":
	print("p-packman-update")
elif os == "termux":
	print("p-pkg-update")
else:
	print("None")
''' $1 $BASE_SYSTEM_OS) $@"

	echo $RES_EXE
	eval $RES_EXE
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
	pkg update && pkg upgrade -y && pkg autoclean && apt autoremove
}
p-packman-update() {
	sudo pacman -Syu
}
p-snap-update() {
	snap refresh --list
	snap refresh
}
p-flatpack-update() {
	flatpak update
}
p-full-update() {
	p-apt-update && p-snap-update && p-flatpack-update
}
# -------------------------

#!/bin/bash

## S = система
s-watch(){
	# Обновление команды через определенный период времяни
	watch -d -n $@
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

# Docekr
-docker-ip() {
	# Получить	 ip адрес   указанного 	 контейнера
	# -docker-ip имя_контейнера
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $NAME_PROJ
}

__docker-create-filename() {
	# Взять название проекта из файла
	if [[ -r .name_docker_container ]]; then
		NAME_PROJ=$(cat .name_docker_container)
		echo "$NAME_PROJ"
		return 0
	fi
	NAME_PROJ="$1"
	__write-file "$NAME_PROJ" .name_docker_container
	echo "$NAME_PROJ"
}
-docker-build() {
	# Создать образ проекта(Нужно находиться на одном уровне с `Dockerfile`)
	# -docker-build [имя_для_контейнера]
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	WORK_DIR="/usr/src/$NAME_PROJ"
	image_name="img_$NAME_PROJ"
	sudo docker build --build-arg WORK_DIR=$WORK_DIR --build-arg NAME_PROJ=$NAME_PROJ -t $image_name .
}
-docker-run() {
	# Создать и запустить контейнер с проектом
	# -docker-run [имя_контейнра] [--rm (удалить при выходе контейенр)]
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	container_name="$NAME_PROJ"
	image_name="img_$NAME_PROJ"
	sudo docker run --rm -ti --name $container_name $image_name $@
	#-v $(my_path)/deploy:$(WORK_DIR)/deploy -p $(EXTERNAL_WEB_PORT):$(EXTERNAL_WEB_PORT)
}
-docker-start() {
	#  Запустить существубщий контенер
	# [-a (войти в контейнер)]
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	sudo docker container start $NAME_PROJ
}
-docker-stop() {
	#  Остановить существубщий контенер
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	sudo docker container stop $NAME_PROJ
}
-docker-exec() {
	# Войти в контейнер
	# -docker-exec [имя_контейнера]
	NAME_PROJ=$(__docker-create-filename $@)
	echo "Проект: $NAME_PROJ"
	sudo docker exec -ti $NAME_PROJ /bin/sh
}
-dshc() {
	# Посмотреть контейнеры
	# docker-show-container
	if [[ $1 == '-w' ]]; then
		watch -d -n 2 sudo docker ps -a
	else
		sudo docker ps -a
	fi

}
-dshi() {
	# Посмотреть образы
	# docker-show-image
	if [[ $1 == '-w' ]]; then
		sudo watch -d -n 2 sudo docker images
	else
		sudo docker images
	fi
}
-dcp() {
	# Отчитстить контейнеры
	sudo docker container prune
}
-dip() {
	# Отчитстить образы
	sudo docker container prune
}

-docker-compose-select-envfile() {
	# Сохранить путь к env файлу
	# -docker-compose-select-env-file ./file/__env.env
	__write-file $1 .env_path
}
-docker-compose-build() {
	# Запустить образы контейнеров
	if [[ -r .env_path ]]; then
		sudo docker-compose --env-file $(cat .env_path) build
	fi
	sudo docker-compose build
}
-docker-compose-up() {
	# Запустить контейнеры а после окончанию отчистить удалить их
	if [[ -r .env_path ]]; then
		sudo docker-compose --env-file $(cat .env_path) up && sudo docker-compose --env-file $(cat .env_path) rm -fsv
	fi
	sudo docker-compose up && sudo docker-compose rm -fsv
}
-docker-compose-rm() {
	# Удалить ненужные контейнеры
	if [[ -r .env_path ]]; then
		sudo docker-compose --env-file $(cat .env_path) rm -fsv
	fi
	sudo docker-compose rm -fsv
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
    git rm --cached $1
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
    res='grep'
    if [[ -n $2 ]]; then
        res+=" --exclude-dir={$2}"
    fi
    res+=" -rnw . -e $1"
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
