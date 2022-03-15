#!/bin/bash

# Импортирование всех модлей в проекте

# Импортировать алиасы заренне
source "$BASHLER_PATH/alias.sh"

list_dir=$(~py -c "
import os
import sys
res=''
for x in os.listdir(sys.argv[1]):
    # исключить собственный файл, чтобы небыло рекурсии
    if x not in {'.git', '__init__.sh', '__pycache__', 'alias.sh'}:
        fil_path=f'{sys.argv[1]}/{x}'
        # Это должен быть sh скрипт
        if os.path.isfile(fil_path) and os.path.splitext(fil_path)[1] == '.sh':
            print('\"%s\" ' % x )            
" "$BASHLER_PATH")

# echo "$BASHLER_PATH/$list_dir"

for x in $(echo $list_dir); do
    cm="source $BASHLER_PATH/$x"
    echo $cm
    eval $cm
done
