import sched, time
import threading
import psutil
from easyhid import Enumeration
from datetime import datetime


def split(arr, size):
     arrs = []
     while len(arr) > size:
         pice = arr[:size]
         arrs.append(pice)
         arr   = arr[size:]
     arrs.append(arr)
     return arrs


class BaseScreen():
    def __init__(self):
        self.dirty_ = False
        self.screen_ = None

    def dirty(self):
        return self.dirty_

    def screen(self):
        self.dirty_ = False
        return self.screen_

    def updateScreen(self, screen):
        self.screen_ = screen
        self.dirty_ = True

    def textLine(self, text):
        return text.ljust(21)

    def blankLine(self):
        return ''.ljust(21)

    def barGraph(self, title, perc):
        total = 21 - len(title) - 1
        used = round(perc/100.0 * total)
        return self.textLine('%s|%s' % (title, "\u0008" * used))


class TestScreen(BaseScreen):
    def __init__(self):
        super(TestScreen, self).__init__()

    def name(self):
        return "TestScreen"

    def run(self):
        while(True):
            self.updateScreen(b'123456789012345678901234567890123456789012345678901234567890123456789012345678901234')
            time.sleep(60)


class DateTimeScreen(BaseScreen):
    def __init__(self):
        super(DateTimeScreen, self).__init__()

    def name(self):
        return "DateTimeScreen"

    def run(self):
        while(True):
            now = datetime.now()
            dateStr = now.strftime('%a %-d %b %Y')
            timeStr = now.strftime('%H:%M')
            self.updateScreen(bytearray(self.textLine(dateStr) + self.textLine(timeStr) + self.blankLine() * 2, encoding = 'utf8'))
            time.sleep(5)

class PerfScreen(BaseScreen):
    def __init__(self):
         super(PerfScreen, self).__init__()

    def name(self):
        return "PerfScreen"

    def run(self):
        while(True):
             cpu = psutil.cpu_percent()
             mem = psutil.virtual_memory()
             dsk = psutil.disk_usage('/')
             self.updateScreen(bytearray(self.barGraph('cpu', cpu) +
                                         self.barGraph('mem', mem.percent) +
                                         self.barGraph('dsk', dsk.percent) +
                                         self.blankLine(),
                                         encoding='utf8'))
             time.sleep(5)

class HidDisplay():

    KEYBOARD_UPDATE_INTERVAL = 1
    KEYBOARD_NAME = 'Crkbd'
    KEYBOARD_INTERFACE = 1

    def __init__(self):
        self.screens_ = [
            DateTimeScreen(),
            PerfScreen()
        ]
        self.screenIdx_ = 0
        self.keyboard_ = None
        self.screenLastUpdate_ = None

    def currentScreen(self):
        return self.screens_[self.screenIdx_]

    def showDevices(self):
        connected = Enumeration()
        connected.show()

    def connectKeyboard(self):
        connected = Enumeration()
        devices = connected.find(product=self.KEYBOARD_NAME, interface=self.KEYBOARD_INTERFACE)
        if len(devices) == 0:
            raise RuntimeError("Unable to find keyboard with product_id=%s and interface_id=%d" % (self.KEYBOARD_NAME, self.KEYBOARD_INTERFACE))
        self.keyboard_ = devices[0]
        self.keyboard_.open()
        print('Keyboard connection established')

        # On the initial connection write our special sequence
        # 1st byte - 1 to indicate a new connection
        # 2nd byte - number of screens available to the keyboard
        self.keyboard_.write(bytearray([1, len(self.screens_)]))
        print('Sent connection string')
        time.sleep(1)

    def readFromKeyboard(self):
        if not self.keyboard_:
            return
        data = self.keyboard_.read(size=32, timeout=50)
        if data:
            idx = data[0]
            # Check for valid screen index
            if idx >= 1 and idx <= len(self.screens_):
                print('Keyboard requested screen index', self.screenIdx_)
                self.screenIdx_ = idx - 1
                # Force screen update
                self.sendToKeyboard(self.currentScreen().screen())

    def sendToKeyboard(self, screen):
        # If there is no change just quit early
        if not screen or self.screenLastUpdate_ == screen:
            return

        self.screenLastUpdate_ = screen

        # Split the bytearray into 4 lines that we will send one at a time.
        # This prevents us from hitting the 32 length limit
        lines = split(screen, 21)
        for line in lines:
            length = self.keyboard_.write(line)
            print('Sent', length, 'bytes, data:', line)
            time.sleep(0.15)

    def updateKeyboardScreen(self):
        # If the keyboard is connected and we have a valid screen send the data
        # to the keyboard
        if self.keyboard_ and self.currentScreen().dirty():
            self.sendToKeyboard(self.currentScreen().screen())

    def updateKeyboard(self, s):
        if not self.keyboard_:
           self.connectKeyboard()
        self.readFromKeyboard()
        self.updateKeyboardScreen()
        s.enter(self.interval, 1, self.updateKeyboard, (s,))

    def run(self, interval=None):
        self.interval = interval or self.KEYBOARD_UPDATE_INTERVAL

        # Start screen threads
        for s in self.screens_:
            print('Starting', s.name())
            t = threading.Thread(target=s.run)
            t.start()

        # Start keyboard update loop (in main thread)
        s = sched.scheduler(time.time, time.sleep)
        s.enter(self.interval, 1, self.updateKeyboard, (s,))
        s.run()

hid = HidDisplay()
# hid.showDevices()
hid.run()

