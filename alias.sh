#!/bin/bash

######################################################################################
# Мои переменные окурежния
# Путь к диску с данными
export DiskData="/media/denis/dd19b13d-bd85-46bb-8db9-5b8f6cf7a825"
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
alias configer="$DiskData/MyProject/PycharmProjects/configer/venv/bin/python3.10 $DiskData/MyProject/PycharmProjects/configer/configer/main.py"
alias gitclones="$DiskData/MyProject/PycharmProjects/git_clons/venv/bin/python3.10 $DiskData/MyProject/PycharmProjects/git_clons/git_clons/main.py"
alias pytots="$DiskData/MyProject/python_to_ts_type/venv/bin/python3.11 $DiskData/MyProject/python_to_ts_type/main.py"
alias showlogsmal="/home/denis/PycharmProjects/showlofsmal/showlogsmal.bin"
alias ~py=python3.11
alias pip="~py -m pip"
alias ~bpy="~py -m bpython"
alias syncthing="$DiskData/AlienApp/aplication/other/Syncthing/syncthing-linux-amd64-v1.20.1/syncthing"
alias dbeaver="snap run dbeaver-ce"
# 
alias ..="cd .."
# замена ls на NNN
alias nnn='nnn -de'
######################################################################################
