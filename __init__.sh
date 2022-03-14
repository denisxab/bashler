#!/bin/bash

# Импортирование всех модлей в проекте

# Импортировать алиасы заренне
source ./alias.sh

list_dir=$(~py -c "
import os
import sys
res=''
for x in os.listdir(os.path.dirname(sys.argv[1])):
    # исключить собственный файл, чтобы небыло рекурсии
    if x not in {'.git', '__init__.sh', '__pycache__', 'alias.sh'}:
        # Это должен быть sh скрипт
        if os.path.isfile(x) and os.path.splitext(x)[1] == '.sh':
            res+='\"%s\" ' % x 
print(res)
" $0)

# echo "$0/$list_dir"

for x in $(echo $list_dir); do
    cm="source $HOME/bashler/$x"
    echo $cm
    eval $cm
done
