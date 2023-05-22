#!/bin/bash

# SSH - Сервер
# ssh-keygen() {
#     # Сгенерировать ssh ключи
#     ssh-keygen $@
# }
ssh-restart() {
    # Перезапутсить SSH сервер
    res=''
    if [[ $BASE_SYSTEM_OS == "termix" ]]; then
        res="-ssh-stop && -ssh-start"
        echo "Termix - SSH перезагружен "
    elif [[ $BASE_SYSTEM_OS == "ubuntu" ]]; then
        res="sudo systemctl restart shhd"
        echo "Ubuntu - SSH перезагружен"
    fi
    echo $res
    eval $res
}
ssh-start() {
    # Запустить SSH сервер
    res=''
    if [[ $BASE_SYSTEM_OS == "termix" ]]; then
        res="sshd"
        echo "Termix - SSH перезагружен "
    elif [[ $BASE_SYSTEM_OS == "ubuntu" ]]; then
        res="sudo systemctl start shhd"
        echo "Ubuntu - SSH перезагружен "
    fi
    echo $res
    eval $res
}
ssh-stop() {
    # Остановить SSH сервер
    res=''
    if [[ $BASE_SYSTEM_OS == "termix" ]]; then
        res="pkill sshd"
        echo "Termix - SSH перезагружен "
    elif [[ $BASE_SYSTEM_OS == "ubuntu" ]]; then
        res="sudo systemctl stop shhd"
        echo "Ubuntu - SSH перезагружен "
    fi
    echo $res
    eval $res
}
# SSH - Подключение к серверу
ssh-c() {
    # Поключиться по SSH
    # $1 - Имя пользователя
    # $2 - Host(ip) сервера
    # $3 - Порт
    port=22
    if [[ -z $3 ]]; then
        port=$3
    fi
    #
    res=ssh -p 22 "$1@$2"
    echo res
    eval res
}
ssh-cf() {
    # Поключиться по SSH. Взять данные для подлючения из файла
    # $1 - ПроизвольноеИмя из файла для ssh
    res=$(--ssh-parse-conf $1)
    user=$(echo $res | cut -d "|" -f 1)
    host=$(echo $res | cut -d "|" -f 2)
    port=$(echo $res | cut -d "|" -f 3)
    echo "ssh -p $port $user@$host:$port"
    # Подключение по сереру
    ssh -p $port "$user@$host"
}
ssh-copy-key-cf() {
    # Скопироввать SSH ключ. Взять данные для подлючения из файла
    # $1 - ПроизвольноеИмя из файла для ssh
    res=$(--ssh-parse-conf $1)
    user=$(echo $res | cut -d "|" -f 1)
    host=$(echo $res | cut -d "|" -f 2)
    port=$(echo $res | cut -d "|" -f 3)
    echo "$user@$host:$port"
    ssh-copy-id -p $port "$user@$host"
}
######################################################################
# Системные команды

--ssh-parse-conf() {
    # Получаем данные для подключения по `ПроизвольноеИмяПодключения_SSH`
    #
    # $1 = ПроизвольноеИмяПодключения_SSH
    #
    res=$(~py -c '''
import pathlib
import sys
import json

path_to_remote_file = sys.argv[1]
name_connect_from_conf = sys.argv[2]

text_conf = pathlib.Path(path_to_remote_file).read_text()
json_conf = json.loads(text_conf)

conf = json_conf["ssh"].get(name_connect_from_conf)

if conf:
    print(conf["user"], conf["host"], conf["port"], sep="|")
else:
    raise KeyError(
        f"Не найдено SSH подключение по имени - {name_connect_from_conf}"
    )
    ''' $BASHLER_REMOTE_PATH $1)

    echo $res
    return 0 # Выйти из функции 0 хорошо 1 плохо
}
