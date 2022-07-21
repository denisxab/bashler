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

gadd() {
    # Создать комит всех изменений
    date=$(date +\"%c\")
    req="git add -A && git commit -m '$date - $1'"
    echo $req
    eval $req
}
gaddp() {
    # Создать комит всех изменений и выполнить push
    gadd $@
    echo 'git push'
    git push
}
garch() {
    # Сделать архив текущей ветки
    req="git archive --format zip --output $1.zip "
    req+=$(git rev-parse --abbrev-ref HEAD)
    echo $req
    eval $req
}

grmh(){
    # Удалить файл из отслеживания
	git rm --cached $1
}
