import enum
import os
import re

Home: str = os.environ['HOME']
BASHLER_PATH: str = os.environ['BASHLER_PATH']

REGEX_BASH_NAME = "[\\w\\d~\\-/_.,\"' \\{\\}]"


class color(enum.Enum):
    reset = '\x1b[0m'
    #################
    green = '\x1b[92m'
    yellow = '\x1b[93m'
    read = '\x1b[31m'
    # Рамка
    frame = '\x1b[51m'


def self_bashler_path():
    return f'{BASHLER_PATH}'


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
        if os.path.isfile(full_path) and os.path.splitext(
                full_path)[1] == '.sh':
            with open(f'{full_path}', 'r') as _f:
                _text_all_sh += f'{_f.read()}\n'
    return _text_all_sh


def print_doc(_name, _value):
    '''
    Вывести результат поисков в консоль

    :param _name:
    :param _value:
    '''
    print('{yellow}{name}{reset}\t\t=\t{green}{value}{reset}'.format(
        name=_name,
        value=_value,
        yellow=color.yellow.value,
        green=color.green.value,
        reset=color.reset.value
    ))


def search_from_name_alias(_similar_alias_name: str):
    '''
    Поиск алиаса по имени
    '''
    return 'alias( *(?:-g|-s| ) *{1}*{0}{1}*)=({1}*)'.format(
        _similar_alias_name,
        REGEX_BASH_NAME
    )


def search_from_value_alias(_similar_alias_value: str):
    '''
    Поиск по значению алиаса
    '''
    return 'alias( *(?:-g|-s| ) *{1}+)=({1}*{0}{1}*)'.format(
        _similar_alias_value,
        REGEX_BASH_NAME
    )


def search_func(name_regex_bash_fun: str, text_all_sh: str):
    '''
    Ищем похожие функции
    '''
    _similar_commands = re.findall(
        '([\w\\-_]*%s[\w\-_]*)\(\) *{' % name_regex_bash_fun, text_all_sh
    )
    # Если команда не найдена
    if not _similar_commands:
        return []
    return _similar_commands


def search_full_doc(
        name_bash_fun: str,
        _template_comment: str,
        text_all_sh: str):
    '''
    Если есть только одна команда то выводим полную документацию о ней
    '''
    _docstring: re.Match = re.search(
        '%s\(\) *{\s*((%s)+)' %
        (name_bash_fun, _template_comment), text_all_sh)
    if _docstring:
        # Убираем лишние отступы
        d = re.sub('[\t#]| {2,}', '', _docstring.group(1))
        print('{yellow}{0}{reset}\n\n{frame}{1}{reset}'.format(
            name_bash_fun,
            d,
            yellow=color.yellow.value,
            frame=color.frame.value,
            reset=color.reset.value,
        ))


def search_shot_doc(
        similar_commands: str,
        _template_comment: str,
        text_all_sh: str):
    '''
    Если есть много команд, то выводим краткий обзор команд
    '''
    for _name_func in similar_commands:
        _command: re.Match = re.search(
            '%s\(\) *{\s((%s)+)' %
            (_name_func, _template_comment), text_all_sh)
        if _command:
            # Берем первый комментарий
            print(
                '{yellow}{0}{reset}\n\t{green}{1}{reset}'.format(
                    _name_func,
                    re.sub(
                        '[\t#]| {2,}|\n {0,}',
                        '',
                        _command.group(1).split('#')[1]),
                    green=color.green.value,
                    yellow=color.yellow.value,
                    reset=color.reset.value,
                ))
        else:
            print('{read}У функции нет документации:{reset} {0}'.format(
                _name_func,
                read=color.read.value,
                reset=color.reset.value,
            ))
