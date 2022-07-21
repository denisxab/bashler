
"""
Собрать все .sh файл в один файл, это 
нужно для удобства импортирования
"""
import pathlib
path =pathlib.Path(__file__).resolve().parent 
print(path)
source_code = (path / 'source_code.sh')
source_code.write_text('')
res='\n'.join([x.read_text() for x in (path/ 'sh').glob("*.sh")])
print(f"Ok {len(res)} symbol")
source_code.write_text(res)





