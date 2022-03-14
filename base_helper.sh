#!/bin/bash

alias -g "pp"="-- $1"

--(){
	# Поиск bash команды в папке bashler
	# > часть_имени_команды
	~py -c "
reset = '\x1b[0m'
green = '\x1b[92m'
yellow = '\x1b[93m'
read = '\x1b[31m'
import os
import re

import sys

name_regex_bash_fun = sys.argv[1]


def read_sh_file(folder_search):
    '''
    Прочитать весь текст из sh файлов
    :param folder_search:  Папка со скриптами
    '''

    _text_all_sh = ''
    for x in os.listdir(f'{folder_search}'):
        # Пропускаем не желательные папки
        if x in {'.git'}:
            continue
        # Читаем файл
        full_path = f'{folder_search}/{x}'
        # Это должен быть .sh файл
        if os.path.isfile(full_path) and os.path.splitext(full_path)[1] == '.sh':
            with open(f'{full_path}', 'r') as _f:
                _text_all_sh += f'{_f.read()}\n'
    return _text_all_sh


def serch_command():
    '''Ищем похожие команды'''
    _similar_commands = re.findall('([\w\-_]*%s[\w\-_]*)\(\){' % name_regex_bash_fun, text_all_sh)
    # Если команда не найдена
    if not _similar_commands:
        return []
    return _similar_commands


def serch_shot_doc(_template_comment):
    '''Если есть много команд, то выводим краткий обзор команд'''
    for _name_func in similar_commands:
        _command: re.Match = re.search('%s\(\){\s((%s)+)' % (_name_func, _template_comment), text_all_sh)
        if _command:
            # Берем первый комментарий
            print(
                '{yellow}{0}{reset}\n\t{green}{1}{reset}'.format(
                    _name_func,
                    re.sub('[\t#]| {2,}|\n {0,}', '', _command.group(1).split('#')[1]),
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


def serch_full_doc(name_bash_fun: str, _template_comment: str):
    '''Если есть только одна команда то выводим полную документацию о ней'''
    _docstring: re.Match = re.search('%s\(\){\s((%s)+)' % (name_bash_fun, _template_comment), text_all_sh)
    if _docstring:
        # Убираем лишние отступы
        d = re.sub('[\t#]| {2,}|\n {1,}', '', _docstring.group(1))
        print('{frame}{0}{reset}'.format(
            d,
            frame='\x1b[51m',
            reset=reset,
        ))

Home: str = os.environ['HOME']
# Весь текст из sh скриптов
text_all_sh: str = read_sh_file(f'{Home}/bashler/')
#: Похожие команды
similar_commands: list[str] = serch_command()
#: Шаблон поиска документации
template_comment = '[\n\t ]*#[\w\d\t,.\-_ @:\>\<\(\)\[\]\`=*]+'
if len(similar_commands) == 1:
    serch_full_doc(similar_commands[0], template_comment)
elif len(similar_commands) > 1:
    serch_shot_doc(template_comment)
else:
    print('{read}команда не найдена:{reset} {0}'.format(
        name_regex_bash_fun,
        read=read,
        reset=reset,
    ))
" $@
}

__read-line-file-return-bash-for(){
	# Прочитать файл с переносами строк и вернуть bash массив
    ~py -c "
import sys
name_file=sys.argv[1]
with open(name_file,'r') as _f:
	data = _f.read()
res=''
for x in data.split():
    res+='\"%s\" ' % x
print(res)
" $1	
}

__test_(){
    __read-line-file-return-bash-for __init__.txt
}

__write-file(){
	# Записать текст в файл
	echo "$1" > $2
}
