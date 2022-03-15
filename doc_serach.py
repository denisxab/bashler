import re
import sys
import os
from bashler_py import print_doc, read_sh_file, color, \
    search_from_name_alias, search_from_value_alias, \
    self_bashler_path, search_full_doc, search_func, search_shot_doc


def manger_search_func():
    '''
    Поиск функций и документации к ним

    [имя]   = Имя функции
    '''
    name_regex = sys.argv[1]
    # Весь текст из sh скриптов
    text_all_sh: str = read_sh_file(self_bashler_path())
    #: Похожие команды
    similar_commands: list[str] = search_func(name_regex, text_all_sh)

    # #: Шаблон поиска документации
    template_comment = '[\n\t ]*#[\w\d\t,.\-_ @:\>\<\(\)\[\]\`=*]+'
    if len(similar_commands) == 1:
        search_full_doc(similar_commands[0], template_comment, text_all_sh)
    elif len(similar_commands) > 1:
        search_shot_doc(similar_commands, template_comment, text_all_sh)
    else:
        print('{read}команда не найдена:{reset} {0}'.format(
            name_regex,
            read=color.read.value,
            reset=color.reset.value,
        ))


def search_alias():
    '''
    Поиск алиасов

    [имя]   = Что икать
    -n      = Поиск по имени алиаса
    -v      = Поиск по значению алиаса
    '''

    name_regex = sys.argv[1]
    type_search = sys.argv[2]
    text_all_sh: str = read_sh_file(self_bashler_path())

    # Если нужно искать по значению
    if type_search == '-v':
        is_text = False

        def _search_bashler_file():
            '''Поиск в файлах проекта'''
            nonlocal is_text
            pattern: str = search_from_value_alias(name_regex)
            for x in re.finditer(pattern, text_all_sh):
                print_doc(x.group(1), x.group(2))
                is_text = True

        _search_bashler_file()

        if not is_text:
            print('{read}Нет похожих значений алиаса:{reset} {0}'.format(
                name_regex,
                read=color.read.value,
                reset=color.reset.value,
            ))

    # Если нужно искать по имени
    elif type_search == '-n':
        is_text = False

        def _search_bashler_file():
            '''Поиск в файлах проекта'''
            nonlocal is_text

            pattern: str = search_from_name_alias(name_regex)
            for x in re.finditer(pattern, text_all_sh):
                print_doc(x.group(1), x.group(2))
                is_text = True

        _search_bashler_file()

        if not is_text:
            print('{read}Нет похожих значений алиаса:{reset} {0}'.format(
                name_regex,
                read=color.read.value,
                reset=color.reset.value,
            ))
