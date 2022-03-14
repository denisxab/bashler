#!/bin/bash

# Импортирование всех модлей в проекте

list_dir=`~py -c "
import os
import sys
res=''
for x in os.listdir(os.path.dirname(sys.argv[1])):
    # исключить собственный файл, чтобы небыло рекурсии
    if x not in {'.git', '__init__.sh'}:
        res+='%s ' % x 
print(res)
" $0`


# echo "$0/$list_dir"



for x in `echo $list_dir`
do
    cm="source $HOME/bashler/$x"
    echo $cm
    eval $cm
done



