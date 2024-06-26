# Источник: https://gist.github.com/denisxab/7b91e1d09ff8fbe6d8e738a5326e9ced
######################################################################################

# Путь к внешнему диску
export DISK="/home/denis/DISK"
alias telegram="/home/denis/DISK/AlienApp/aplication/other/Telegram/Telegram"
alias bruno="snap run bruno"
######################################################################################
# Можем настраивать различные варинты для клиента и сервера
export IS_SERVER="no"
# Путь к Bahler
export BASHLER_PATH="$DISK/MyProject/bashler"
# ОС (ubuntu/arch)
export BASE_SYSTEM_OS="ubuntu"
# Путь к файлу автозапуска
export AUTORUN_BASHLER="$HOME/.autorun_bashler"
# Путь к настроикам удаленного доступа
export BASHLER_REMOTE_PATH="$HOME/.bashler_remote"
# Путь к конфигурации ruff.toml
export RUFF_ROOT_CONFIG="$DISK/MyProject/open_lessen/Python/auto_code_review/ruff.toml"
# Путь к конфигурации mypy.ini
export MYPY_ROOT_CONFIG="$DISK/MyProject/open_lessen/Python/auto_code_review/mypy.ini"
# Путь к конфигурации .pylintrc 
export PYLINT_ROOT_CONFIG="$DISK/MyProject/open_lessen/Python/auto_code_review/.pylintrc"
# Путь к auto_code_review.py  
export AUTO_CODE_REVIEW="$DISK/MyProject/open_lessen/Python/auto_code_review/auto_code_review.py"
######### Другое ####################################

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
zsh-full-reload() {
    # Перезагрузить польностью zsh
    source ~/.zshrc
}
zsh-reload() {
    # Перезагрузить библотеки zsh
    # Импортировать МОИ модули
    res='source "$BASHLER_PATH/source_code.sh"'
    echo $res
    eval $res
}
######################################################################################

######################################################################################
# Импортировать зависемотси
zsh-reload
######################################################################################

source ~/.invoke-completion.sh

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
