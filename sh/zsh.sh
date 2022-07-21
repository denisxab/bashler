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
