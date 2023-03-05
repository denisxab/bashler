""" 
Модуль для работы отображения списка файлов в виде TUI
"""

import os
import curses
from typing import Literal


def MainHandler(
    selected_states, last_shift_pos, files, stdscr, last_toggle_pos, shift_pressed, pos
):
    """
    Основной цикл обработки приложения

    1. Вывод списка файлов и директорий
    2. Обработка нажатий клавиш

    """

    def ViewListFile():
        """Выводим спсиок файлов"""
        extend_str: Literal["", "/"]
        is_select: Literal["[ ] ", "[X] "]
        for i, file in enumerate(files):
            # Файлы или папка
            extend_str = "/" if os.path.isdir(file) else ""
            is_select = "[ ] "
            ###
            # Если файл/директория выбран
            if selected_states[i]:
                is_select = "[X] "
                stdscr.addstr(
                    i + 1, 0, is_select + file + extend_str, curses.color_pair(1)
                )
            # Если файл/директория НЕ выбран
            else:
                stdscr.addstr(
                    i + 1,
                    0,
                    is_select + file + extend_str,
                    curses.color_pair(2 if extend_str == "/" else 0),
                )
            # Выделяем файл или папку на которой сейчас находиться курсор
            if pos == i:
                stdscr.addstr(
                    i + 1, 0, is_select + file + extend_str, curses.color_pair(3)
                )
        ###
        # Обновляем экран
        stdscr.refresh()

    def HandlerKeyEnter():
        """Обработка нажатий клавиш"""
        nonlocal last_shift_pos, last_toggle_pos, pos
        # Получаем нажатую клавишу
        key = stdscr.getch()
        # Обработка клавиши q
        if key == ord("q"):
            return False
        ###
        # Обработка клавиши Пробела/Enter
        elif key in (ord(" "), ord("\n")):
            if shift_pressed:
                start_pos = min(pos, last_shift_pos)
                end_pos = max(pos, last_shift_pos)
                for i in range(start_pos, end_pos + 1):
                    selected_states[i] = not selected_states[i]
            else:
                selected_states[pos] = not selected_states[pos]
                last_toggle_pos = pos
            last_shift_pos = pos
        ###
        # Обработка клавиш навигации
        elif key == curses.KEY_UP:
            # Перемещаемся вверх
            if pos > 0:
                pos -= 1
            # Если достиг верха то переходим в самый низ
            else:
                pos = len(files) - 1
        elif key == curses.KEY_DOWN:
            # Перемещаемся вниз
            if pos < len(files) - 1:
                pos += 1
            # Если достиг низ то переходим в самый верх
            else:
                pos = 0
        return True

    ###
    # Выводим заголовок
    stdscr.addstr(0, 0, "Выберите файлы(Spase/Up/Down/Q):")
    ###
    # Выводим список файлов
    ViewListFile()
    ###
    # Обработка нажатий клавиш
    if HandlerKeyEnter():
        # Если нужно работать
        return (
            True,
            selected_states,
            last_shift_pos,
            files,
            stdscr,
            last_toggle_pos,
            shift_pressed,
            pos,
        )
    else:
        # Если НЕ нужно работать
        return (
            False,
            selected_states,
            last_shift_pos,
            files,
            stdscr,
            last_toggle_pos,
            shift_pressed,
            pos,
        )


def main_run(stdscr: curses.window, dir_path: str):
    ###
    # Установка цветовой схемы
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLACK)
    curses.init_pair(3, curses.COLOR_BLACK, curses.COLOR_CYAN)
    curses.init_pair(4, curses.COLOR_BLACK, curses.COLOR_YELLOW)
    # Цвет фона
    curses.init_color(0, 0, 0, 0)
    ##
    # Скрываем курсор
    curses.curs_set(0)
    ###
    # Получаем список файлов в переданной директории
    files = sorted(os.listdir(dir_path))
    # Инициализируем состояния выбранных файлов
    selected_states = [False] * len(files)
    last_toggle_pos = 0
    last_shift_pos = 0
    shift_pressed = False
    pos = 0
    ###
    # Отчистка терминала
    stdscr.clear()
    # Отображаем список файлов
    while True:
        (
            is_run,
            selected_states,
            last_shift_pos,
            files,
            stdscr,
            last_toggle_pos,
            shift_pressed,
            pos,
        ) = MainHandler(
            selected_states,
            last_shift_pos,
            files,
            stdscr,
            last_toggle_pos,
            shift_pressed,
            pos,
        )
        # Прерываем программу, если ей больше не нужно работать
        if not is_run:
            break
    ###
    # Включение отображения курсора
    curses.curs_set(1)
    ###
    # Возврат выбранных файлов
    selected_files = [files[i] for i in range(len(files)) if selected_states[i]]
    return selected_files


if __name__ == "__main__":
    selected_files = curses.wrapper(main_run, dir_path=".")
    # Вернуть список выбранных файлов и директорий
    print(" ".join(selected_files))
