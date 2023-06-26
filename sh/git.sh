#!/bin/bash

# Git
alias gst="git status"
alias glog="git log"
alias gbra="git branch"
alias gcd="git checkout $1"
alias gmer="git merge $1"
# Разница между коммитами или ветками
alias gdif="git diff $1"
alias grst="git reset --hard"

gbrac() {
    # Создать и переключиться на ветку

    res="git branch -c $1 && git checkout $1"
    echo $res
    eval $res
}

gcom() {
    # Создать коммит с текущей датой
    # $1 - Дополнительное сообщеие

    date=$(date +\"%c\")
    git commit -m "$date - $1"
}
gadd() {
    # Создать коммит всех изменений
    date=$(date +\"%c\")
    git add -A && git commit -m "$date - $1"
}

gaddp() {
    # Создать комит всех изменений и выполнить push
    gadd $@
    echo 'git push'
    git push
}
garch() {
    # Сделать архив текущей ветки
    git archive --format zip --output "$1.zip" "$(git rev-parse --abbrev-ref HEAD)"
}
grmh() {
    # Удалить файл из отслеживания
    res=$(git rm --cached -r $1)
    echo $res
    eval $res
}

gitignore() {
    # Создать файл .gitignore
    cat <<EOF >.gitignore
__pycache__
log
venv
/html
.vscode
/dist
EOF
}

gremot-up-token() {
    # Обновить токен в URL
    # $1 = Токен
    git_url=$(git remote get-url origin)
    new_token="$1"
    new_url=$(~py -c "import sys,re;gir_url=sys.argv[1];new_token=sys.argv[2];print(new_token.join(re.search('(.+:).+(@.+)',gir_url).group(1,2)))" "$git_url" "$new_token")
    git remote set-url origin "$new_url"
}

