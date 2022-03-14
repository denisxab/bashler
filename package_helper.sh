#!/bin/bash



## P = пакетные менеджеры
p-apt-baseinstall(){
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

p-apt-install(){
	# Установить программу
	sudo apt install $@
}
p-apt-install-file(){
	# Установить из файла
	sudo dpkg -i $1
}
p-apt-remove(){
	# Удалить программу
	sudo apt remove $@
}
p-apt-update(){
	# Обновить ссылки, программы, отчистить лишнее
	sudo apt update && sudo apt upgrade -y  && sudo apt autoremove && sudo apt clean
}
p-snap-update(){
	snap refresh
}
p-flatpack-update(){
	flatpak update
}
p-full-update(){
	p-apt-update && p-snap-update && p-flatpack-update
}
p-pkg-update(){
	# Обновить все пакеты
	pkg up
}
p-pkg-install(){
	pkg install $@
}