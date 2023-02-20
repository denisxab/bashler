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
alias templaer="~py -m templaer"
#
alias ..="cd .."
# замена ls на NNN
alias nnn='nnn -de'
######################################################################################
