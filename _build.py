
"""
Собрать все .sh файл в один файл, это
нужно для удобства импортирования
"""
import pathlib
path = pathlib.Path(__file__).resolve().parent
print(path)
source_code = (path / 'source_code.sh')
# Отчищаем итоговый файл
source_code.write_text('')
# Читаем все sh файлы и объедением их через перенос строки 
res = '\n'.join([x.read_text() for x in (path / 'sh').glob("*.sh")])
print(f"Ok {len(res)} symbol")
# В начало файла вставляем алиасы, для успешного использования их в функциях
res_alias = (path / 'alias.sh')
source_code.write_text(res_alias.read_text() + res)
