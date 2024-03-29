# Bashler

`Bashler` - сборщик `.sh` файлов, который из коробки имеет полезные функции, для пользовательского использования `Linux` системы.

Что включает в себя сборщик:

- Собирает множество `.sh` файлов, в единый `source_code.sh` файл;
- Проверка уникальности имени алиаса и функции, при сборки в единый `source_code.sh` файл;
- Упаковка `python` файлов, документации, и `.sh` файлов в `export_bashler.zip` архив, чтобы можно было легко распространять;
- Документирует алиасы и функции в `.sh` файлах, в `doc_source_code.md`;
- Позволяет делать поиск по алиасам и функциям, в `.sh` файлах;

Ссылки:

- [Документация встроенных функций `bashler`](./doc_source_code.md#документация-функций)

## Как подключать

Для того, чтобы ваши функции и алиасы были доступны во всех оболочка, вам нужно импортировать файл `./source_code.sh` в `~/.zshrc` или `~/.bashrc`.

Пример как это можно сделать:

```bash
# ОС (ubuntu/arch/termix)
export BASE_SYSTEM_OS="ubuntu"
# Путь к Bahler
export BASHLER_PATH="$HOME/bashler"
###
# Подключить `Bashler`
source "$BASHLER_PATH/source_code.sh"
```

## Основные фичи `bashler`

### Поиск описания функция и алиасов внутри `.sh` файлов

- `doc ШаблонФункции` Поиск функций подходящих по указному шаблону.

  Для того чтобы отображалась документация у функций, ей нужно писать на новой сроке после символа `{`, будут все первые комментарии

  **Пример**

  ```bash
  ИмяФункции() {
      # Документация которая отобразиться
      # Документация которая отобразиться
      # Документация которая отобразиться
      # Документация которая отобразиться
      ~py -c "
  import sys
  sys.path.insert(0,'$BASHLER_PATH_PY')
  from doc_serach import manger_search_func
  manger_search_func()
      " $@
  }
      # А этот текс уже не отобразиться
  ```

- `an ШаблонИмениАлиаса` Поиск алиасов по имени

  Первыми в список попадут алиасы из проекта, а потом все остальные

- `av ШаблонЗначенияАлиаса` Поиск алиасов по значению
  Первыми в список попадут алиасы из проекта, а потом все остальные

### pls - Список файлов в виде TUI

Часто бывает нужно выбрать несколько файлов или папок, для использования их в качестве аргументов в CLI командах.

По моему самый удобный способ - это вывести список всех файлов и папок, и через пробел выбрать те что мне нужны. Поэтому я и сделал утилиту `pls`

Вызвать команду:

```bash
pls [Путь]
```

Клавиши для управления:

- `Стрелка Вверх/Вниз`    = Вверх или вниз;
- `Стрелка Вправо/Влево`  = На следующие или на предыдущею страницу;
- `Пробел/Enter`          = Выбрать;
- `Q/Esc`                 = Выйти, после выхода из TUI, в консоль выведутся все выбранные файлы и папки;

![pls_doc](./media_doc/pls_doc.png)

### Работа с пакетными менеджерами

Существуют множества пакетных менеджеров, которые делают одно и тоже но имеют разные команды, я стандартизировал основные команды

- **Установка пакета** = `pinst ИмяПакета`. Можно указывать также `.dep` файлы. На основе переменной окружение `$BASE_SYSTEM_OS` подберется команда для установки пакета. Также все имена пакетов которые вы устанавливаете через эту команду будут записаны в файл `~/.bashler_pinst`

- **Удаление пакета** = `prem ИмяПакета`. На основе переменной окружение `$BASE_SYSTEM_OS` подберется команда для удаления пакета. Также все имена пакетов которые вы удалили через эту команду будут удалены из файла `~/.bashler_pinst`

- **Обновление пакетов** = `pupd`. Обновление у пакетного менеджера у `snap` и `flatpak`

### Автозапуск программ

в файле `~/.zshrc` нужно создать переменную окружения по имени `export AUTORUN_BASHLER="$HOME/.autorun_bashler"` которая будет хранить путь к файлу, в этом файле мы запишем команды, который должен по порядку единожды(до перезагрузки системы) выполниться в фоновом режиме в разных процессах.

- Структура файла `.autorun_bashler`(Вы можете использовать алиасы и переменные окружения).

  ```json
  ["Команда_1", "Команда_2", "Команда_N"]
  ```

- После этого мы можем запустить команды. Они выполнятся единожды(до перезагрузки системы).

  ```bash
  autorun-bashler
  ```

- Принудительно запустить программы.

  ```bash
  autorun-bashler-force
  ```

### Удаленный доступ

Для удобного хранения данных для удаленного доступа, нужно создать файл `.bashler_remote`. И указать в переменной `BASHLER_REMOTE_PATH` путь к этому файлу.

У него будет следующая структура:

```jsonc
{
  "ssh":{
    "ПроизвольноеИмяПодключения_SSH":{
      "user":"ИмяПользователяНаСервере",
      "host":"IP", 
      "port":8080
    }
    , ...
  },
  "rsync":{
    "ПроизвольноеИмяПодключения_RSYNC":{
      // Берем настройки из SHH подключения
      "ssh":"ПроизвольноеИмяПодключения_SSH",
      // Настройки того что и куда нужно синхронизировать
      "sync_dir":[
        {
          "in":"ПапкаОткуда"
          ,"out":"ПапкаКуда"
          // Исключить Список Путей
          ,"e":"Путь1,Путь2,...",
          // Если True то удаляет файлы и папки которые есть в `out`, но которых нет в `in`
          "d":true
        }
        , ...
      ]
    }
  }
}
```

#### SSH

- Пример подключения по `SSH` используя данные из файла `.bashler_remote`

```bash
ssh-cf ПроизвольноеИмяПодключения
```

#### Rsync

- Пример удаленной синхронизации файлов через `rsync` используя данные из файла `.bashler_remote`

```bash
rsync-parse-conf regПроизвольноеИмяПодключенияru1 
```

## Как модифицировать

### Правила создания пользовательских функций

- Если начинается на `\w`(буквы), то это обычная функция, которая будет документироваться;
- Если начинается на `_`, то это вспомогательная функций, которая НЕ будет документироваться;
- Если начинается на `--`, то это системная функция, которая НЕ будет документироваться;

### Сборка модифицированного `bashler`

**Все новые `.sh` файлы должны храниться в папке `./sh`**

Если вы хотите модифицировать `bashler` по себя, то вы можете создавать новые файлы `.sh` файлы в папке `./sh`.
Чтобы эти файлы собрались в единый `source_code.sh` -> выполните команду:

```bash
python _build.py  
```

> При выполнение `python _build.py` также создается новая документация функций в `./doc_source_code.md`

После этого, пере подключите файл `source_code.sh` в текущем терминале

```bash
source "$BASHLER_PATH/source_code.sh"
```
