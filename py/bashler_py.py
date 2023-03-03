import enum
import os
import re
import typing
from collections import deque
from pathlib import Path

Home: str = os.environ["HOME"]
BASHLER_PATH: str = os.environ["BASHLER_PATH"]

REGEX_BASH_NAME = "[\\w\\d~\\-/_.,\"' \\{\\}]"


class color(enum.Enum):
    reset = "\x1b[0m"
    #################
    green = "\x1b[92m"
    yellow = "\x1b[93m"
    read = "\x1b[31m"
    # Рамка
    frame = "\x1b[51m"


def self_bashler_path():
    return f"{BASHLER_PATH}"


def read_sh_file(folder_search):
    """
    Прочитать весь текст из sh файлов
    :param folder_search:  Папка со скриптами
    """

    _text_all_sh = ""
    for x in os.listdir(f"{folder_search}"):
        # Пропускаем не желательные папки
        if x in {".git"}:
            continue
        # Читаем файл
        full_path = f"{folder_search}/{x}"
        # Это должен быть .sh файл
        if os.path.isfile(full_path) and os.path.splitext(full_path)[1] == ".sh":
            with open(f"{full_path}", "r") as _f:
                _text_all_sh += f"{_f.read()}\n"
    return _text_all_sh


def print_doc(_name, _value):
    """
    Вывести результат поисков в консоль

    :param _name:
    :param _value:
    """
    print(
        "{yellow}{name}{reset}\t\t=\t{green}{value}{reset}".format(
            name=_name,
            value=_value,
            yellow=color.yellow.value,
            green=color.green.value,
            reset=color.reset.value,
        )
    )


def search_from_name_alias(_similar_alias_name: str):
    """
    Поиск алиаса по имени
    """
    return "alias( *(?:-g|-s| ) *{1}*{0}{1}*)=({1}*)".format(
        _similar_alias_name, REGEX_BASH_NAME
    )


def search_from_value_alias(_similar_alias_value: str):
    """
    Поиск по значению алиаса
    """
    return "alias( *(?:-g|-s| ) *{1}+)=({1}*{0}{1}*)".format(
        _similar_alias_value, REGEX_BASH_NAME
    )


def search_func(name_regex_bash_fun: str, text_all_sh: str):
    """
    Ищем похожие функции
    """
    # Ищем функции по шаблону
    _similar_commands = re.findall(
        r"([\w\d\-_]*%s[\w\d\-_]*)\(\) *{" % name_regex_bash_fun, text_all_sh
    )
    # Если есть команда которая полностью соответствует шаблону поиска, то показываем только его.
    _similar_commands_qe = [x for x in _similar_commands if x == name_regex_bash_fun]
    if _similar_commands_qe:
        _similar_commands = _similar_commands_qe
    # Если команда не найдена
    if not _similar_commands:
        return []
    return _similar_commands


def search_full_doc(name_bash_fun: str, _template_comment: str, text_all_sh: str):
    """
    Если есть только одна команда то выводим полную документацию о ней
    """
    # Документация функции
    _docstring: re.Match = re.search(
        r"\n%s\(\) *{\s*((%s)+)" % (name_bash_fun, _template_comment), text_all_sh
    )
    if _docstring:
        # Убираем лишние отступы
        d = re.sub("[\t#]| {2,}", "", _docstring.group(1))
        print(
            "{yellow}{0}{reset}\n\n{frame}{1}{reset}".format(
                name_bash_fun,
                d,
                yellow=color.yellow.value,
                frame=color.frame.value,
                reset=color.reset.value,
            )
        )


def search_shot_doc(similar_commands: str, _template_comment: str, text_all_sh: str):
    """
    Если есть много команд, то выводим краткий обзор команд
    """
    for _name_func in similar_commands:
        _command: re.Match = re.search(
            r"\n%s\(\) *{\s((%s)+)" % (_name_func, _template_comment), text_all_sh
        )
        if _command:
            # Берем первый комментарий
            print(
                "{yellow}{0}{reset}\n\t{green}{1}{reset}".format(
                    _name_func,
                    re.sub("[\t#]| {2,}|\n {0,}", "", _command.group(1).split("#")[1]),
                    green=color.green.value,
                    yellow=color.yellow.value,
                    reset=color.reset.value,
                )
            )
        else:
            print(
                "{read}У функции нет документации:{reset} {0}".format(
                    _name_func,
                    read=color.read.value,
                    reset=color.reset.value,
                )
            )


def create_doc_from():
    """
    Создать документацию `bash` функций
    """
    ###
    # Заголовок
    doc_func = deque()
    doc_func.append("# Документация функций `bashler`")
    ###
    # Перебираем все файлы в папке `./sh`, и получаем их документацию функций
    for x in (Path(self_bashler_path()) / "sh").glob("*.sh"):
        doc_func.append(f"\n## Раздел: `{x.name}`")
        text_all_sh = x.read_text()
        for doc in create_doc_from_sh_file(text_all_sh):
            doc_func.append(doc)
    ###
    # Путь к документации
    doc_source_code = Path(self_bashler_path()) / "doc_source_code.md"
    # Запись файл
    doc_source_code.write_text("\n".join(doc_func))


def create_doc_from_sh_file(text_all_sh: str) -> typing.Iterable[str]:
    """
    Поиск документации функций в `bash` тексте
    """
    # Шаблон для поиска функции и их документации
    template = re.compile(
        r"(?<=\n)(?P<name>[\w\d_-]+)\(\) {\s*(?P<doc>(?:(?:#.+)\s*)+)?"
    )
    for x in template.finditer(text_all_sh):
        name = x["name"]
        # Не документируем системны и вспомогательные функции
        if not re.search(r"\A(?:--|__|-|_)\w?", name):
            # Обрезаем лишнии отступы
            doc = re.sub("[\t#]| {2,}", "", x["doc"] if x["doc"] else "")
            # Формируем строку документации функции
            line_doc_func = "\n### Функция: `{name}`\n\n```bash\n{doc}\n```".format(
                name=name, doc=doc.strip()
            )
            yield line_doc_func


# if __name__ == "__main__":
#     create_doc_from()
