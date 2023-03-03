# Документация функций `bashler`

## Раздел: `git.sh`

### Функция: `gadd`

```bash
Создать комит всех изменений
```

### Функция: `gaddp`

```bash
Создать комит всех изменений и выполнить push
```

### Функция: `garch`

```bash
Сделать архив текущей ветки
```

### Функция: `grmh`

```bash
Удалить файл из отслеживания
```

### Функция: `gremot-up-token`

```bash
Обновить токен в URL
 $1 = Токен
```

## Раздел: `python_pro.sh`

### Функция: `pep`

```bash
Форматировать Python код
 $1 =путь к файлу или папки, если указана папка то тогда отформатируется вссе файлы в этой папке

 Форматирвоать отстпов
```

### Функция: `pimport`

```bash
Форматировать иморты, удалить не используемые импорты
 $1 =путь к файлу или папки, если указана папка то тогда отформатируется вссе файлы в этой папке
 Установить `pip install autoflake`
```

### Функция: `pipin`

```bash
Если актевировано окружение то установить пакет в него
```

### Функция: `piprm`

```bash
Если актевировано окружение то удляем пакет из него
```

### Функция: `pipup-self`

```bash
Обновить pip
```

### Функция: `poetry-`

```bash

```

### Функция: `poetry-req`

```bash
Создать файл requirements.txt
```

### Функция: `pcvenv`

```bash

```

### Функция: `pavenv`

```bash

```

### Функция: `pdvenv`

```bash

```

### Функция: `poetry_init`

```bash
Звгрузить poetry
```

### Функция: `phttpserver`

```bash
Запустить сервер п разадчи файлов
 $1 порт
```

## Раздел: `find.sh`

### Функция: `find`

```bash
find [ОткудаИскать...] -name "ЧтоИскать"

 `*`= Любой символ до и после
 -iname = Поиск БЕЗ учета регистра
 -name = Поиск С учетом регистра
 --not -name = Поиск НЕ совпадений шаблону
 -maxdepth Число = Максимальная глубина поиска
 -type d= Поиск только папок
 -type f= Поиск только файлов
 -perm 0664= Поиск по разришению файлов

 -mtime Дней= Модифецированные столько дней назад
 -atime Дней= Открытые столько дней назад

 -not = НЕ
 -o = ИЛИ
```

### Функция: `find-e`

```bash
Поиск всех файлов с указаным разширением
```

### Функция: `find-f`

```bash
Поиск файла или папки по указаному шаблоному имени
```

### Функция: `find-tree`

```bash
Фильтрация вывода
 > шаблон_слово
```

### Функция: `find-t`

```bash
Поиск текста в файлах по указаному шаблону
 $1 - Что искать
 $2 - Где искать
 $3 - Исключить пути из поиска
```

### Функция: `find-chage-more`

```bash
Поиск файлов в директории `$1` которые изменялись более `$2` дней
 `$1` Путь к паке в которой искать
 `$2` Сколько дней назад изменялось, если нужно сегодня то укажите 0
 `$3` Во сколько директория можно углубляться, по умолчанию во все
```

## Раздел: `lib.sh`

## Раздел: `autoran.sh`

### Функция: `autorun-bashler`

```bash
Логика запуска программ
```

### Функция: `autorun-bashler-force`

```bash
Принудтельно перезапустить программ
```

## Раздел: `rsync.sh`

### Функция: `rsync-server`

```bash
Синхронезировать с сервером по SSH, если в ВЫХОДНОЙ(out) папке отличия, то удалить их
```

### Функция: `rsync-parse-conf`

```bash
Выполнить синхронизацию из `.bash_remote.json`
```

### Функция: `rsync-local-folder`

```bash
Синхронизировать локальные папки
 $1 = откуда(ИСТОЧНИК)
 $2 = куда
 --exclude=папка_1 --exclude=папка_ = Исключить папки или файлы из сихронизации
 --dry-run  = Показать какие файлы будут сихронезированы без выполени программы
 --delete = Удалить файлы и папки которые не соответвуют ИСТОЧНИКУ
```

### Функция: `rsync-server-folder`

```bash
Синхронезировать с сервером по SSH
 $1 = PORT
 $2 = username@ip:path
 $3 = Путь к локальнйо папке
 --exclude=папка_1 --exclude=папка_ = Исключить папки или файлы из сихронизации
```

## Раздел: `docker.sh`

### Функция: `dk-build`

```bash
Собрать образ
 $1 Имя для оброза
 $2 Путь к папке в которой расположен Dockergile
 $@ Остальные аргументы

 Собрать образ
```

### Функция: `dk-images`

```bash
Посмотреть образы
 $1 - Если -w то будет отлеживать
```

### Функция: `dk-imag-rm`

```bash
Удалить указанный образ
 $1 - Имя оброза
```

### Функция: `dk-run`

```bash
Создать и запустить контейнер из оброза
 $1 Имя для оброза
 $@ Остальные аргументы

 Путь куда сохранятсья настройки запущеного контейнера
```

### Функция: `dk-create`

```bash
Создать контейнер из оброза
 $1 Имя для оброза
 $@ Остальные аргументы

 Путь куда сохранятсья настройки запущеного контейнера
```

### Функция: `dk-attach`

```bash
Подключиться выводу консоли контейнера
 $1 Имя контейнера
```

### Функция: `dk-sh`

```bash
Войти в запущеннй контейнер
 $1 Имя контейнера
```

### Функция: `dk-start`

```bash
Запустить существубщий контенер
 $1 Имя контейнера
```

### Функция: `dk-stop`

```bash
Остановить существубщий контенер
 $1 Имя контейнера
```

### Функция: `dk-restart`

```bash
Перезапустить существубщий контенер
 $1 Имя контейнера
```

### Функция: `dk-ps`

```bash
Посмотреть контейнеры
 $1 - Если -w то будет отлеживать
```

### Функция: `dk-info-ip`

```bash
Получить ip адрес указанного контейнера
 $1 Имя контейнера
```

### Функция: `dk-prune`

```bash
Отчитстить контейнеры
```

### Функция: `dkp-init`

```bash
Создать файл `docker-compose.yml` в текущем пути
```

## Раздел: `zsh.sh`

### Функция: `zsh-hotkey`

```bash

```

### Функция: `zsh-edit`

```bash
Открыть редактирование zsh
```

### Функция: `zsh-install-plugin`

```bash
Установить плагины Zsh
```

### Функция: `zsh-mount-disk`

```bash
Примонтировать повседневныедиски

 Google Disk
```

### Функция: `zsh-clean-history`

```bash
Отчистить историю команд
```

## Раздел: `human.sh`

### Функция: `doc`

```bash
Поиск документции у функции
```

### Функция: `an`

```bash
Поиск алиасов по имени
```

### Функция: `av`

```bash
Поиск алиасов по значению
```

### Функция: `aa-dev`

```bash
Посик алисов по значению и имени
```

## Раздел: `ssh.sh`

### Функция: `ssh-keygen`

```bash
Сгенерировать ssh ключи
```

### Функция: `ssh-restart`

```bash
Перезапутсить SSH сервер
```

### Функция: `ssh-start`

```bash
Запустить SSH сервер
```

### Функция: `ssh-stop`

```bash
Остановить SSH сервер
```

### Функция: `ssh-c`

```bash
Поключиться по SSH
 $1 - Имя пользователя
 $2 - Host(ip) сервера
 $3 - Порт
```

### Функция: `ssh-cf`

```bash
Поключиться по SSH. Взять данные для подлючения из файла
 $1 - ПроизвольноеИмя из файла для ssh
```

### Функция: `ssh-copy-key-cf`

```bash
Скопироввать SSH ключ. Взять данные для подлючения из файла
 $1 - ПроизвольноеИмя из файла для ssh
```

## Раздел: `systemctl.sh`

### Функция: `sy-ie`

```bash
Проверить включена ли служба в автозапуск
```

### Функция: `sy-e`

```bash
Добвить службу в автозапуск
```

### Функция: `sy-d`

```bash
Удалить службу из автозапуска
```

### Функция: `sy-r`

```bash
Перезапустить службу
```

### Функция: `sy-s`

```bash
Статус службы
```

### Функция: `sy-str`

```bash
Запустить службы
```

### Функция: `sy-stp`

```bash
Остановить службу
```

## Раздел: `file.sh`

### Функция: `f-dir-copy`

```bash
Скопировать папку
```

### Функция: `f-dir-rename`

```bash
Переименовать папку
```

### Функция: `f-dir-create`

```bash
Создать папку
```

### Функция: `f-dir-remove`

```bash
Удалить папку
```

### Функция: `d-size-folder`

```bash
Получить разме файлов в указанной директории
```

### Функция: `d-size-disk`

```bash
Использование дисков
```

### Функция: `d-list-disk`

```bash
Все подключенные диски
```

### Функция: `tree_`

```bash
Показать дерево катологов
 $1 = Уровень вложенности дерева(Например=3)
 $2 = Какую директорию посмотерть
 
 -a = скрытые файлы
 -d = только директории
 -f = показать относительный путь для файлов
 -L = уровень вложенности
 -P = поиск по шаблону (* сделать на python)
 -h = Вывести размер файлов и папок
 -Q = Заключать названия в двойные кавычки
 -F = Добовлять символы отличия для папок, файлов и сокетов
 -I = Исключить из списка по патерну
```

### Функция: `p-joinfile`

```bash
Объеденить текс всех файлов из указанной директории
 1 - Путь к папке
 2 - Кодировка файлов
 3 - Разделитель при записи в итоговый файл
```

## Раздел: `package.sh`

### Функция: `pinst`

```bash
Установить программу в Linux
```

### Функция: `prem`

```bash
Удалить указаный пакет
```

### Функция: `pupd`

```bash
Обновить все пакеты
```

### Функция: `p-apt-baseinstall`

```bash
Устновить все необходимые программы
```

### Функция: `p-apt-install`

```bash
Установить программу
```

### Функция: `p-pkg-install`

```bash

```

### Функция: `p-apt-install-file`

```bash
Установить из файла
 sudo dpkg -i $1
```

### Функция: `p-apt-remove`

```bash
Установить программу
```

### Функция: `p-pkg-remove`

```bash

```

### Функция: `p-apt-update`

```bash
Обновить ссылки, программы, отчистить лишнее
```

### Функция: `p-pkg-update`

```bash
Обнавления для Termix
```

### Функция: `p-packman-update`

```bash
Обновления для Pacman
```

### Функция: `p-snap-update`

```bash
Обнавить программы из Snap
```

### Функция: `p-flatpack-update`

```bash
Обнавить программы из flatpak
```

## Раздел: `sys.sh`

## Раздел: `vpn.sh`

### Функция: `vpn-on`

```bash
Включить VPN
```

### Функция: `vpn-off`

```bash
Выключить VPN
```

### Функция: `vpn-info`

```bash
Информация о подключение к VPN
```

### Функция: `open-vpn-on`

```bash

```

## Раздел: `ffmpeg.sh`

### Функция: `ffmpeg-video-to-audio`

```bash
Извлечь аудио из видео
 $1 = Путь к видео
```

### Функция: `ffmpeg-video-to-audio-dir`

```bash
Извлечь аудио из видео, в текущей папке.
 $1 = Расширение для видео которые нужно конертировать
```

### Функция: `ffmpeg-cup`

```bash
Обрезать длительносить видео
 $1 = Путь к видео
 $3 = Откуда начать отсчёт продолжительности, по умолчнаию с начала видео
 $2 = Где закончить отсчёт продолжительности
```

### Функция: `ffmpeg-remove-audio-from-video`

```bash
Удалить аудио дорожку у указаного видео
 $1 = Путь к видео
```

### Функция: `ffmpeg-join-audio-to-video`

```bash
Обьеденить музыку с видео.
 $1 = Путь к видео
 $2 = Путь к музыке
```

### Функция: `pytube-download`

```bash
Скачать видео с Yotube
 $1 = Url ссылка на видео
```

## Раздел: `video.sh`

### Функция: `gifzip`

```bash
Сжать Gif видео
```