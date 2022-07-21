#!/bin/bash

sy-ie() {
    # Проверить включена ли служба в автозапуск
    sudo systemctl is-enabled $1
}
sy-e() {
    # Добвить службу в автозапуск
    sudo systemctl enabled $1
}
sy-d() {
    # Удалить службу из автозапуска
    sudo systemctl disable $1
}
sy-r() {
    # Перезапустить службу
    sudo systemctl restart $1
}
sy-s() {
    # Статус службы
    sudo systemctl status $1
}
sy-str() {
    # Запустить службы
    sudo systemctl start $1
}
sy-stp() {
    # Остановить службу
    sudo systemctl stop $1
}
