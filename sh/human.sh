#!/bin/bash

##################################################
--() {
    # Поиск документции у функции
    ---dev $@ | less
}
an() {
    # Поиск алиасов по имени
    aa-dev $@ -n | less
}
av() {
    # Поиск алиасов по значению
    aa-dev $@ -v | less
}
##################################################

##################################################
# Реализацию писать через постфикс -dev

---dev() {
    # Поиск bash команды в папке bashler
    #
    # [часть_имени_команды]
    #
    ~py -c "
import sys
sys.path.insert(0,'$BASHLER_PATH_PY')
from doc_serach import manger_search_func
manger_search_func()
    " $@
}
aa-dev() {
    # Посик алисов по значению и имени
    #
    # [часть_алиаса]
    # -v                = Поиск по знаечнию
    # -n                = Поиск по имени
    ~py -c "
import sys
sys.path.insert(0,'$BASHLER_PATH_PY')
from doc_serach import search_alias
search_alias()
    " $@ $(alias)

    alias | grep $1
}
