#!/bin/bash

autorun-bashler() {
    # Логика запуска программ
    tmp_path="/tmp/autorun_bashler"
    exists_tmp_path="$tmp_path/.run_autorun_bashler"

    if [[ -d $tmp_path ]]; then
        echo "Папка существует $tmp_path"
    else
        # Создаем католог в /tmp
        mkdir $tmp_path
        echo "Создана папка $tmp_path"
    fi

    if [[ -f $exists_tmp_path ]]; then
        echo "Уже запущенно. Файл существует $exists_tmp_path"
    else
        if [[ -f $AUTORUN_BASHLER ]]; then
            echo $AUTORUN_BASHLER

            list_dir="$(~py -c '''
import json
from pathlib import Path
import os
p_AUTORUN_BASHLER = Path(os.environ["AUTORUN_BASHLER"])
q = """ " """.replace(" ","")
r = json.loads(p_AUTORUN_BASHLER.read_text())
res = ""
for script in r:
    res += f"{script} "
print(res)
''')"
            for x in $(echo $list_dir); do
                echo $x
                # Фоновый запуск
                nohup $x >/dev/null &
            done

            touch $exists_tmp_path
        else
            echo "Путь не существует $AUTORUN_BASHLER"
        fi
    fi

}
autorun-bashler-force() {
    # Принудтельно перезапустить программ
    tmp_path="/tmp/autorun_bashler"
    rm -rf $tmp_path
    autorun-bashler
}
