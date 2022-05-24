#!/bin/bash
# Git
alias gadd="git add -A && git commit -m $(date +\"%c\")"
alias gaddp="gadd && git push"
alias gst="git status"
alias glog="git log"
alias gbra="git branch"
alias gcd="git checkout $1"
alias gmer="git merge $1"
# Разница между коммитами или ветками
alias gdif="git diff $1"
alias gback="git reset --hard"

garch() {
    # Сделать архив текущей ветки
    req="git archive --format zip --output $1.zip "
    req+=$(git rev-parse --abbrev-ref HEAD)
    echo $req
    eval $req
}
