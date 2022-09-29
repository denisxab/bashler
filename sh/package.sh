#!/bin/bash

# Работа с пакетными менеджарами
pinst() {
	# Установить программу в Linux
	RES_EXE="$(~py -c '''
import sys
import re
os = sys.argv[-1]
pakage = sys.argv[1]
if os == "ubuntu":
	if re.search(".deb$", pakage): 
		# Установка из файла
		print("p-apt-install-file")
	else:
		# Установка из интернета
		print("p-apt-install")
elif os == "arch":
	print("p-packman-install")
elif os == "termux":
	print("p-pkg-install")
else:
	print("None")
''' $1 $BASE_SYSTEM_OS) $@"

	echo $RES_EXE
	eval $RES_EXE
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
	eval $RES_EXE
}

pupd() {
	# Обновить все пакеты
	p-full-update
}
pupdp(){
	p-pkg-update
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

p-apt-install() {
	# Установить программу
	sudo apt install $@
}
p-pkg-install(){
	pkg install $@
}
p-pkg-remove(){
	pkg uninstall $@
}
p-pkg-update(){
	pkg update && pkg upgrade -y && pkg autoclean && apt autoremove
}
p-apt-remove() {
	# Установить программу
	sudo apt remove $@
}
p-apt-install-file() {
	# Установить из файла
	sudo dpkg -i $1
}
p-apt-remove() {
	# Удалить программу
	sudo apt remove $@
}
p-apt-update() {
	# Обновить ссылки, программы, отчистить лишнее
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove && sudo apt clean
}
p-snap-update() {
	snap refresh --list
}
p-flatpack-update() {
	flatpak update
}
p-full-update() {
	p-apt-update && p-snap-update && p-flatpack-update
}
p-pkg-install() {
	pkg install $@
}
