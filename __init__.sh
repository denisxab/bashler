# Импортирование всех модлей в проекте

list_dir=`~py -c "
import os
import sys
self_file = sys.argv[1] 
res=''
for x in os.listdir():
    # исключить собственный файл, чтобы небыло рекурсии
    if x != self_file:
        res+='%s ' % x 
print(res)
" $0`

for x in `echo $list_dir`
do
    cm="source $(pwd)/$x"
    echo $cm
    eval $cm
done



