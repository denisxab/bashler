#!/bin/bash

#
## Рабата с видео и Gif
#

gifzip() {
    # Сжать Gif видео
    e="gifsicle -i \"$1\" -o \"out_$1\" --optimize=3 --colors=256 --lossy=30"
    echo $e
    eval $e
}
