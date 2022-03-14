#!/bin/bash

--(){
	# Поиск bash команды
	# > часть_имени_команды
	~py -c "
reset = '\x1b[0m'
green = '\x1b[92m'
yellow = '\x1b[93m'
read = '\x1b[31m'
template_comment = ''
import os
import re
import sys

name_regex_bash_fun = sys.argv[1]

# Читаем файл
with open('{0}/.zshrc'.format(os.environ['HOME']), 'r') as _f:
    data = _f.read()

# Ищем похожие команды
res = re.findall('([\w\-_]*%s[\w\-_]*)\(\){' % name_regex_bash_fun, data)
# Если команда не найдена
if not res:
    print('{read}команда не найдена:{reset} {0}'.format(
        name_regex_bash_fun,
        read=read,
        reset=reset,
    ))
# Если есть только одна команда то выводим полную документацию о ней
template_comment = '[\n\t ]*#[\w\d\t,.\-_ @:\>\<\(\)\[\]\`=*]+'
if len(res) == 1:
    name_bash_fun = res[0]
    res = re.search('%s\(\){\s(:?(%s)+)' % (name_bash_fun, template_comment), data)
    if res:
        d = res.group(1)

        d = re.sub('[\t#]| {2,}|\n {1,}', '', d)
        print('{frame}{0}{reset}'.format(
            d,
            frame='\x1b[51m',
            reset=reset,
        ))
    else:
        print(f'команда не найдена: {name_bash_fun}')
# Если есть много команд, то выводим краткий обзор команд
else:
    for _name_func in res:
        p = re.search('%s\(\)\{\s(:?(%s)+)' % (_name_func, template_comment), data)
        if p:
            # Берем первый комментарий
            print(
                '{yellow}{0}{reset}\n\t{green}{1}{reset}'.format(
                    _name_func,
                    re.sub('[\t#]| {2,}|\n {0,}', '', p.group(1).split('#')[1]),
                    green=green,
                    yellow=yellow,
                    reset=reset,
                )
            )
        else:
            print('{read}У функции нет документации:{reset} {0}'.format(
                _name_func,
                read=read,
                reset=reset,
            ))
" $@
}

__read-line-file-return-bash-for(){
	# Прочитать файл с переносами строк и вернуть bash массив
	~py -c "
name_file=$1
with open('name_file','r') as _f:
	data = _f.read()
res=''
for x in data.split():
	res+=f'\"{x}\" '
print(res)
"	
}