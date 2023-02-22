#!/bin/bash

ffmpeg-video-to-audio() {
    # Извлечь аудио из видео
    # $1 = Путь к видео
    res="ffmpeg -i '$1' -vn -acodec copy '$(basename $1 | cut -d. -f1).m4a'"
    echo $res
    eval $res
}

ffmpeg-video-to-audio-dir() {
    # Извлечь аудио из видео, в текущей папке.
    # $1 = Расширение для видео которые нужно конертировать
    ext="*.mp4"
    if [ -n "$1" ]; then
        ext="*$1"
    fi
    res="
    for file in $ext
    do
        r=\"ffmpeg-video-to-audio '\$file'\"
        echo \$r
        eval \$r
    done
    "
    eval $res
}

ffmpeg-cup() {
    # Обрезать длительносить видео
    # $1 = Путь к видео
    # $2 = Продолжительность
    # $3 = Откуда начать отсчёт продолжительности, по умолчнаию с начала видео

    time_long='1:00'
    start_time='00:00:00'

    if [ -n "$3" ]; then
        start_time="$3"
    fi
    if [ -n "$2" ]; then
        time_long="$2"
    fi
    new_name_file=$(echo "$start_time $time_long" | sed 's/:/_/g')

    res="ffmpeg -i '$1' -ss $start_time -t $time_long '$new_name_file $1' "
    echo $res
    eval $res
}

ffmpeg-remove-audio-from-video() {
    # Удалить аудио дорожку у указаного видео
    # $1 = Путь к видео

    res="ffmpeg -i '$1' -c:v copy -an 'del_audio_$1'"
    echo $res
    eval $res
}

ffmpeg-join-audio-to-video() {
    # Обьеденить музыку с видео.
    # $1 = Путь к видео
    # $2 = Путь к музыке

    ffmpeg-remove-audio-from-video $1
    res="ffmpeg -i 'del_audio_$1' -i $2 -c:v copy -c:a aac -strict experimental 'join_$(basename $2 | cut -d. -f1)_$1'"
    echo $res
    eval $res
}

pytube-download() {
    # Скачать видео с Yotube
    # $1 = Url ссылка на видео

    ~py -c "from pytube import YouTube;YouTube(\"$1\").streams.filter(progressive=True, file_extension='mp4').order_by('resolution').desc().first().download()"
}
