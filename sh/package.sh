#!/bin/bash

#
# Работа с пакетными менеджарами
#

# Функция для установки пакетов
pinst() {
	# Получение имени пакета из аргументов командной строки
	pakage="$1"

	# Установка пакета в зависимости от платформы
	case "$BASE_SYSTEM_OS" in
	ubuntu)
		if [[ "$pakage" == *.deb ]]; then
			# Установка из файла
			sudo dpkg -i "$pakage"
		else
			# Установка из интернета
			sudo apt install -y "$pakage"
		fi
		;;
	arch)
		# Установка на Arch Linux
		sudo pacman -S --noconfirm "$pakage"
		;;
	termux)
		# Установка на Termux
		pkg install "$pakage"
		;;
	*)
		echo "Unsupported platform"
		exit 1
		;;
	esac

	# Добавление пакета в файл `.bashler_pinst`
	path_bashler_pinst="$HOME/.bashler_pinst"

	# Чтение файла `.bashler_pinst`
	dict_app="$(jq -rcM '{}' "$path_bashler_pinst" 2>/dev/null)"

	# Добавление пакета в словарь
	dict_app="$(echo "$dict_app" | jq --arg pakage "$pakage" '.[$pakage]=""')"

	# Запись словаря в файл `.bashler_pinst`
	echo "$dict_app" >"$path_bashler_pinst"
}

# Функция для удаления пакетов
prem() {
	# Получение имени пакета из аргументов командной строки
	pakage="$1"

	# Удаление пакета в зависимости от платформы
	case "$BASE_SYSTEM_OS" in
	ubuntu)
		# Удаление на Ubuntu
		sudo apt-get remove -y "$pakage"
		;;
	arch)
		# Удаление на Arch Linux
		sudo pacman -R --noconfirm "$pakage"
		;;
	termux)
		# Удаление на Termux
		pkg uninstall "$pakage"
		;;
	*)
		echo "Unsupported platform"
		exit 1
		;;
	esac

	# Удаление пакета из файла `.bashler_pinst`
	path_bashler_pinst="$HOME/.bashler_pinst"

	# Чтение файла `.bashler_pinst`
	dict_app="$(jq -rcM '{}' "$path_bashler_pinst" 2>/dev/null)"

	# Удаление пакета из словаря
	dict_app="$(echo "$dict_app" | jq "del(.$pakage)")"

	# Запись словаря в файл `.bashler_pinst`
	echo "$dict_app" >"$path_bashler_pinst"
}

# Функция для обновления пакетов
pupd() {
	# Обновление пакетов в зависимости от платформы
	case "$BASE_SYSTEM_OS" in
	ubuntu)
		# Обновление на Ubuntu
		p-apt-update -y && p-snap-update && p-flatpack-update
		;;
	arch)
		# Обновление на Arch Linux
		p-packman-update
		;;
	termux)
		# Обновление на Termux
		p-pkg-update
		;;
	*)
		echo "Unsupported platform"
		exit 1
		;;
	esac
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
