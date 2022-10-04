# Как подключать

Для удобства импортирования мы можем в одну команду собрать
все `.sh` файлы в один единый файл по имени `source_code.sh`.
Это позволяет нам не беспокоиться о структуре проекта при его импортирование

Для этого выполните команду

```bash
make build
```

Для того чтобы ваши функции и алиасы были доступны во всех оболочка вам нужно импортировать файл `source_code.sh` в `~/.zshrc`

```bash
export BASHLER_PATH=~/bashler

-zsh-full-reload(){
    # Перезагрузить полностью zsh
    source ~/.zshrc
}
-zsh-reload(){
    # Перезагрузить библиотеки zsh
    # Импортировать МОИ модули
    res='source "$BASHLER_PATH/source_code.sh"'
    echo $res
    eval $res
}
# Импортировать зависимости
-zsh-reload
```

Если вы изменили код в `~/bashler` то соберите файл `source_code.sh` снова, и выполните команду `-zsh-reload`

# Основные фичи

## Поиск описания функция и алиасов внутри `.sh` файлов

- `-- ШаблонФункции` Поиск функций подходящих по указному шаблону.

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

## Работа с пакетными менеджерами

Существуют множества пакетных менеджеров, которые делают одно и тоже но имеют разные команды, я стандартизировал основные команды

- **Установка пакета** `pinst ИмяПакета`. Можно указывать также `.dep` файлы. На основе переменной окружение `$BASE_SYSTEM_OS` подберется команда для установки пакета. Также все имена пакетов которые вы устанавливаете через эту команду будут записаны в файл `~/.bashler_pinst`

- **Удаление пакета** `prem ИмяПакета`. На основе переменной окружение `$BASE_SYSTEM_OS` подберется команда для удаления пакета. Также все имена пакетов которые вы удалили через эту команду будут удалены из файла `~/.bashler_pinst`

- **Обновление пакетов** `pupd`. Обновление у пакетного менеджера у `snap` и `flatpak`

## Автозапуск программ

в файле `~/.zshrc` нужно создать переменную окружения по имени `export AUTORUN_BASHLER="$HOME/.autorun_bashler"` которая будет хранить путь к файлу, в этом файле мы запишем команды, который должен по порядку единожды(до перезагрузки системы) выполниться в фоновом режиме в разных процессах.

- Структура файла `.autorun_bashler`.(Не используйте алиасы, они не будут работать)

  ```json
  ["Команда_1", "Команда_2", "Команда_N"]
  ```

- После этого мы можем запустить команды. Они выполнятся единожды(до перезагрузки системы).

  ```bash
  autorun-bashler
  ```

- Принудительно запустить программы.

  ```
  autorun-bashler-force
  ```

# Правила создания функций

- Если вы используете стороною программу то в имени функции нужно указывать префикс `-ИмяПрограммы-Остальное`
- Если вы используете стандартные программы в linux то для функции НЕ нужен префикс `-`
