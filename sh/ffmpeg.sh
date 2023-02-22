#!/bin/bash

ffmpeg-video-to-audio() {
    # Извлечь аудио из видео
    # $1 = Путь к видео
    res="ffmpeg -i $1 -vn -acodec copy $(basename $1 | cut -d. -f1).m4a"
    echo $res
    eval $res
}
