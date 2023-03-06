import curses
import curses.textpad
import sys
from pathlib import Path


class Screen(object):
    UP = -1
    DOWN = 1

    def __init__(self, items: list[str]):
        """Initialize the screen window
        Attributes
            window: A full curses screen window
            width: The width of `window`
            height: The height of `window`
            max_lines: Maximum visible line count for `result_window`
            top: Available top line position for current page (used on scrolling)
            bottom: Available bottom line position for whole pages (as length of items)
            current: Current highlighted line number (as window cursor)
            page: Total page count which being changed corresponding to result of a query (starts from 0)
            ┌--------------------------------------┐
            |1. Item                               |
            |--------------------------------------| <- top = 1
            |2. Item                               |
            |3. Item                               |
            |4./Item///////////////////////////////| <- current = 3
            |5. Item                               |
            |6. Item                               |
            |7. Item                               |
            |8. Item                               | <- max_lines = 7
            |--------------------------------------|
            |9. Item                               |
            |10. Item                              | <- bottom = 10
            |                                      |
            |                                      | <- page = 1 (0 and 1)
            └--------------------------------------┘
        Returns
            None
        """
        self.window = None
        #
        self.width = 0
        self.height = 0
        #
        self.init_curses()
        #
        self.items = [f"[ ] {x}" for x in items]
        #
        self.max_lines = curses.LINES
        self.top = 0
        self.bottom = len(self.items)
        self.current = 0
        self.page = self.bottom // self.max_lines
        # Список выбранных элементов
        self.selected_states = [False] * len(items)

    def init_curses(self):
        """Инициализации curses"""
        self.window = curses.initscr()
        self.window.keypad(True)

        curses.noecho()
        curses.cbreak()

        curses.start_color()
        curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
        curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_CYAN)
        curses.init_pair(3, curses.COLOR_YELLOW, curses.COLOR_BLACK)

        self.current = curses.color_pair(2)

        self.height, self.width = self.window.getmaxyx()
        ###
        # Установить стили
        # Цвет фона
        curses.init_color(0, 0, 0, 0)
        ##
        # Скрываем курсор
        curses.curs_set(0)

    def run(self):
        """Продолжайте запускать TUI до тех пор, пока не будете прерваны"""
        try:
            self.input_stream()
        except KeyboardInterrupt:
            pass
        finally:
            curses.reset_shell_mode()
            curses.endwin()
        ###
        # Включение отображения курсора
        curses.curs_set(1)
        # Список выбранных файлов и папок
        return self.selected_states

    def input_stream(self):
        """Ожидание ввода и запуск соответствующего метода в соответствии с типом ввода"""
        while True:
            self.display()
            #
            ch = self.window.getch()
            # Вверх
            if ch == curses.KEY_UP:
                self.scroll(self.UP)
            # Вниз
            elif ch == curses.KEY_DOWN:
                self.scroll(self.DOWN)
            # На предыдущею страницу
            elif ch == curses.KEY_LEFT:
                self.paging(self.UP)
            # На следующею страницу
            elif ch == curses.KEY_RIGHT:
                self.paging(self.DOWN)
            # Выбор элемента
            elif ch in (ord(" "), ord("\n")):
                self.selected_states[
                    self.top + self.current
                ] = not self.selected_states[self.top + self.current]
            # Выход их программы
            elif ch in (curses.ascii.ESC, ord("q")):
                break

    def scroll(self, direction):
        """Прокрутка окна при нажатии клавиш со стрелками вверх/вниз"""
        # next cursor position after scrolling
        next_line = self.current + direction

        # Up direction scroll overflow
        # current cursor position is 0, but top position is greater than 0
        if (direction == self.UP) and (self.top > 0 and self.current == 0):
            self.top += direction
            return
        # Down direction scroll overflow
        # next cursor position touch the max lines, but absolute position of max lines could not touch the bottom
        if (
            (direction == self.DOWN)
            and (next_line == self.max_lines)
            and (self.top + self.max_lines < self.bottom)
        ):
            self.top += direction
            return
        # Scroll up
        # current cursor position or top position is greater than 0
        if (direction == self.UP) and (self.top > 0 or self.current > 0):
            self.current = next_line
            return
        # Scroll down
        # next cursor position is above max lines, and absolute position of next cursor could not touch the bottom
        if (
            (direction == self.DOWN)
            and (next_line < self.max_lines)
            and (self.top + next_line < self.bottom)
        ):
            self.current = next_line
            return

    def paging(self, direction):
        """Подкачка окна при нажатии клавиш со стрелками влево/вправо"""
        current_page = (self.top + self.current) // self.max_lines
        next_page = current_page + direction
        # The last page may have fewer items than max lines,
        # so we should adjust the current cursor position as maximum item count on last page
        if next_page == self.page:
            self.current = min(self.current, self.bottom % self.max_lines - 1)

        # Page up
        # if current page is not a first page, page up is possible
        # top position can not be negative, so if top position is going to be negative, we should set it as 0
        if (direction == self.UP) and (current_page > 0):
            self.top = max(0, self.top - self.max_lines)
            return
        # Page down
        # if current page is not a last page, page down is possible
        if (direction == self.DOWN) and (current_page < self.page):
            self.top += self.max_lines
            return

    def display(self):
        """Отображать элементы в окне"""
        self.window.erase()
        for idx, item in enumerate(self.items[self.top : self.top + self.max_lines]):
            # Выделить выделенные файлы и папки
            if self.selected_states[self.top + idx]:
                item = item.replace("[ ]", "[X]")
            # Выделите текущую строку курсора
            if idx == self.current:
                self.window.addstr(idx, 0, item, curses.color_pair(2))
            else:
                # Папка
                if item.endswith("/"):
                    self.window.addstr(idx, 0, item, curses.color_pair(3))
                # Файл
                else:
                    self.window.addstr(idx, 0, item, curses.color_pair(1))
        self.window.refresh()


def main():
    # Путь к папке
    _path = sys.argv[1]
    # Список файлов в папке
    list_dir = list(Path(_path).glob("*"))
    # Преобразованный список файлов и папок. У папок в конце добавиться слеш
    items_from_tui = [f"{x.name}/" if x.is_dir() else f"{x.name}" for x in list_dir]
    ###
    # Запустить TUI
    screen = Screen(items_from_tui)
    res = screen.run()
    ###
    # Обработка выбранных файлов и папок
    f = [str(list_dir[i].name) for i in range(len(list_dir)) if res[i]]
    print(" ".join(f))


if __name__ == "__main__":
    main()
