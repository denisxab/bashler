"""
Собрать все .sh файл в один файл, это
нужно для удобства импортирования
"""
import hashlib
import pathlib
import re

from py.bashler_py import create_doc_from

path = pathlib.Path(__file__).resolve().parent
print(path)
source_code = path / "source_code.sh"
# Отчищаем итоговый файл
source_code.write_text("")
# Читаем все sh файлы и объедением их через перенос строки
res = "\n".join([x.read_text() for x in (path / "sh").glob("*.sh")])
# В начало файла вставляем алиасы, для успешного использования их в функциях
res_alias = path / "alias.sh"
# Собранный текст
text_source_code = res_alias.read_text() + res


def checking_uniqueness(_text_source_code):
    names = {}
    for m in re.finditer(
        r"export[\t ](?P<export>.+)=.+|alias[\t ](?:-[gs][\t ])?(?P<alias>.+)=.+|(?P<func>.+)\(\).*{",
        _text_source_code,
    ):
        tmp = [(v, k) for k, v in m.groupdict().items() if v][0]
        if not names.get(tmp[0], None):
            names[tmp[0]] = tmp[1]
        else:
            raise ValueError(f"Имя `{tmp[0]}` уже занято, в типе `{tmp[1]}`")


# Проверить на уникальность имена
checking_uniqueness(text_source_code)
# Записать в итоговый файл
source_code.write_text(text_source_code)
# Формируем документацию для `source_code.md`
create_doc_from()
# Лог
print(f"Ok: md5='{hashlib.md5(text_source_code.encode()).hexdigest()}'")
