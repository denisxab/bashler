# Источник: https://gist.github.com/denisxab/7b91e1d09ff8fbe6d8e738a5326e9ced
######################################################################################

######################################################################################
# Можем настраивать различные варинты для клиента и сервера
export IS_SERVER="no"
# Путь к Bahler
export BASHLER_PATH='/media/denis/dd19b13d-bd85-46bb-8db9-5b8f6cf7a825/MyProject/bashler/'
# ОС (ubuntu/arch)
export BASE_SYSTEM_OS="ubuntu"
# Путь к файлу автозапуска
export AUTORUN_BASHLER="$HOME/.autorun_bashler"
# Другое
export FIREBIRD_UDF="/usr/lib/x86_64-linux-gnu/firebird/3.0/UDF/"
# Путь к директории для автозапуска программ при страте системы
export AUTORUN_PATH="$HOME/.config/й" 
######################################################################################

######################################################################################
if [[ $IS_SERVER == "yes" ]]; then
    echo "zsh server"
    # Чтобы не нагружать сервер лишнеми плагинами
    plugins=(
        # Автодополнения
        git
        docker docker-compose
        # Истории
        history dirhistory
        sudo
        # Подстветка синтаксиса
        zsh-syntax-highlighting
        # Подсказка команд
        zsh-autosuggestions
    )
else
    plugins=(
        # Автодополнения
        git
        docker docker-compose
        # Истории
        history dirhistory
        sudo
        # Коприрование
        copyfile copypath copybuffer
        # Подстветка синтаксиса
        zsh-syntax-highlighting
        # Подсказка команд
        zsh-autosuggestions
        # Высплвающая подсказка
        zsh-autocomplete
    )
fi
# 1. Копировать содержимое файла `copyfile <ИмяФайла>` (*copyfile)
# 2. Перемещатся по истории папок `alt+<` / `alt+>` (*dirhistory)
# 3. h = Показать историю команд (*history)
# 4. sudo = два раза нажмите `esc` и команда `sudo` вставиться в начало всей строки (* sudo)
# 5. `google <ЧтоИскать>` (*web-search)
# 6. `copypath` скопировать путь на в котором мы находимся (*copydir)
# 7. `ctrl+o` скопировать команду в буфер обмена (*copybuffer)
# 8. `ctrl+r` живой поиск по истории команд (*zsh-autocomplete)

# Путь к плагинам
export ZSH="$HOME/.oh-my-zsh"
# Тема  zsh
export ZSH_THEME="gnzh"
# !!! всегда должен быть после plugins !!!
source $ZSH/oh-my-zsh.sh
export PATH="$HOME/.poetry/bin:$PATH"
# утановить `micro` как редактор такста по умолчанию
export EDITOR=micro
######################################################################################

######################################################################################
-zsh-full-reload() {
    # Перезагрузить польностью zsh
    source ~/.zshrc
}
-zsh-reload() {
    # Перезагрузить библотеки zsh
    # Импортировать МОИ модули
    res='source "$BASHLER_PATH/source_code.sh"'
    echo $res
    eval $res
}
######################################################################################

######################################################################################
# Импортировать зависемотси
-zsh-reload
######################################################################################

######################################################################################
# C# Автодополнения
#_dotnet_zsh_complete()
# {
#  local completions=("$(dotnet complete "$words")")
#  reply=( "${(ps:\n:)completions}" )
#}
#compctl -K _dotnet_zsh_complete dotnet
######################################################################################
# Путь до GoLang
#export PATH="$PATH:/usr/local/go/bin"
######################################################################################
