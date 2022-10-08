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
alias -g ~py=python3.10
alias -g ~bpy=bpython
alias -g syncthing="$DiskData/AlienApp/aplication/other/syncthing-linux-amd64-v1.20.1/syncthing"
alias poetry="python -m poetry $@"
alias ..="cd .."
# замена ls на NNN
alias ls='nnn -de'
######################################################################################
