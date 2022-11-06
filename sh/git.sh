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
grmh() {
    # Удалить файл из отслеживания
    res=`git rm --cached -r $1`
    echo $res
    eval $res
}

gitignore(){
    template='''__pycache__
log
venv
/html
.vscode
'''
    echo $template > '.gitignore'
}

gremot-up-token() {
    # Обновить токен в URL
    # $1 = Токен
    git_url=$(git remote get-url origin)
    new_token=$1
    new_url=$(~py -c '''
import sys
import re
gir_url = sys.argv[1]
new_token = sys.argv[2]
res=new_token.join(re.search("(.+:).+(@.+)",gir_url).group(1,2))
print(res)
    ''' $git_url $new_token)
    res="git remote set-url origin $new_url"
    echo $res
    eval $res
}
