#!/bin/bash

__read-line-file-return-bash-for() {
    # Прочитать файл с переносами строк и вернуть bash массив
    #
    # Пример испоильзования
    #
    # list_text=`__read-line-file-return-bash-for sd`
    # for x in `echo $das`
    # do
    #     echo ") $x"
    # done
    echo $(~py -c "
import sys
name_file=sys.argv[1]
with open(name_file,'r') as _f:
	data = _f.read()
res=''
for x in data.split():
    res+='\"%s\" ' % x
print(res)
" $1)
}

__write-file() {
    # Записать текст в файл
    echo "$1" >$2
}

__pypars() {
    # Парсить командную строку
    #
    # :Вот так вызывать:
    #
    # parms=$(__pypars $@)
    # eval $parms
    res=$(eval "~py $BASHLER_PATH_PY_PYPARS \"$@\"")
    echo $res
}

#------------------


-uid(){
    #
    # Сгинироровать UUID в виде `x6nUxOD56_MAAA__`
    #
    # echo ${$(uuidgen -t)//-/}
    echo $(~py -c '''
import base64
import random
import re

len_b=8
value = random.getrandbits(64)
by = value.to_bytes(len_b, byteorder="little")
b64 = base64.urlsafe_b64encode(by).decode("ascii")

print(re.sub(r"[\=\-]", "_", b64))
    ''')
}