#!/bin/bash

export SSH_TERMIX_NAME=u0a417
export SSH_TERMIX_HOST='10.0.0.3'
export SSH_TERMIX_PORT=8022

# SSH - Сервер
-ssh-keygen() {
    # Сгенерировать ssh ключи
    ssh-keygen
}
-ssh-restart() {
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
-ssh-start() {
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

-ssh-stop() {
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
-ssh-c() {
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
## Termix
-ssh-c-termix() {
    # Поключиться по SSH к Termix
    ssh -p $SSH_TERMIX_PORT "$SSH_TERMIX_NAME@$SSH_TERMIX_HOST"
}
-ssh-copy-key-termix() {
    # Скопироввать SSH ключ на Termix
    ssh-copy-id -p $SSH_TERMIX_PORT "$SSH_TERMIX_NAME@$SSH_TERMIX_HOST"
}
