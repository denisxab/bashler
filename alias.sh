#!/bin/bash


######################################################################################
# Мои переменные окурежния
# Путь к диску с данными
export DiskData="/mnt/mydisk_adata"
######################################################################################
# Открывать файлы с указаным разширенем в указанной программе
alias -s {txt,md,conf,log}=micro
alias -s {js,py,cs,ts,html}=code
######################################################################################
# Глобальные Alias
alias -g configer="/home/denis/PycharmProjects/configer/configer.bin"
alias -g gitclones="/home/denis/PycharmProjects/git_clons/gitclones.bin"
alias -g showlogsmal="/home/denis/PycharmProjects/showlofsmal/showlogsmal.bin"
alias -g ~py=python3.10
alias -g ~bpy=bpython
alias ..="cd .."
######################################################################################


# Git
alias gadd="git add -A && git commit -m \"+\""