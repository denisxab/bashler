import sys
import typing
import re


class TArgs(typing.TypedDict):
    # Текущий путь
    in_path: str
    #  Позиционные аргументы, те что не начинаются на `-Символы`
    position_args: list[str]
    # Именованные аргументы, те что начинаются на `-Символы`
    named_args: dict[str, str]
    # Флаги, те что начинаются на `-Символы?`
    flags: list[str]


def parse_args(in_path, argv: list[str]):
    #
    # Поулчить флаги
    #
    flags = []
    for i, x in enumerate(argv):
        if (r := re.search("-([\w\d]+)\?", x)):
            flags.append(r.group(1))
            argv[i] = None
    #
    # Получить именованные аргументы
    #
    last_key = []
    named_args = {}
    for i, x in enumerate(argv):
        if not x:
            continue
        # Берем название ключа
        if (r := re.search("\A-([\w\d]+)(?!\?)\Z", x)):
            last_key = r.group(1)
            named_args[last_key] = []
            argv[i] = None
            continue
        # Прекращаем добавлять массив значения если значение началось на `-`
        if x.startswith("-"):
            last_key = None
            continue
        # Добавляем значение в ключ
        if last_key:
            named_args[last_key].append(x)
            argv[i] = None
    #
    # Получить позиционные аргументы
    #
    position_args = [x for x in argv if x]
    return TArgs(dict(in_path=in_path, flags=flags, named_args=named_args, position_args=position_args))


def toBash(argv):
    # Аргументы командной строки в нормальном виде
    targs: TArgs = parse_args(in_path=argv[0], argv=argv[1].split())
    # Итоговая команда
    res_command = []
    #
    # Формируем флаги
    #
    res_command.append("_flags=({f})".format(f=' '.join(
        [f'"{x}"' for x in targs["flags"]]
    )))
    #
    # Формируем позиционные аргументы
    #
    res_command.append("_position_args=({f})".format(f=' '.join(
        [f'"{x}"' for x in targs["position_args"]]
    )))
    #
    # Формируем именованные аргименты
    #
    for k, v in targs["named_args"].items():
        res_command.append("{k}=({f})".format(
            k=k, f=' '.join([f'"{x}"' for x in v])))
    return ';\n'.join(res_command)+';'


print(sys.argv)
print(toBash(sys.argv))
