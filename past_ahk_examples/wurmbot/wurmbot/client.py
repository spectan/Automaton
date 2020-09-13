import yaml
import Recipe as rcp
import pyautogui as pag
import keyboard as kb
import time
import random

class WurmBot:
    def __init__(self):
        self.actions = {"click": self._click, "press": self._press}
        self.waits = {
            "rested": self._is_rested,
            "fatigued": self._is_fatigued,
            "idle": self._is_idle,
            "busy": self._is_busy,
        }

        print("Loading configs...")
        with open(f"config/ui.yml", "r") as stream:
            self.config = yaml.safe_load(stream)
        self.frame = None
        self.verbose = False
        return

    def load(self, recipe):
        print(f"Loading recipe...")
        with open(f"recipes/{recipe}.yml", "r") as stream:
            data = yaml.safe_load(stream)

        self.recipe = rcp.Recipe(data)
        print(f"Recipe {self.recipe.name} loaded successfully!")
        return True

    def run(self, iterations, verbose=False):
        self.verbose = verbose
        time.sleep(5)
        for i in range(iterations * len(self.recipe.steps)):
            step = self.recipe.next()
            self._print_step(step)
            if step.action:
                self.act(step.action, step.params)
                time.sleep(1)
            elif step.wait:
                self.wait(step.wait, step.timeout)

            time.sleep(0.1)
        return True

    def act(self, action, params):
        return self.actions[action](params)

    def wait(self, conditions, timeout):
        started = time.time()

        done = False
        while done == False:
            self._update_frame()
            results = []
            for condition in conditions:
                if timeout and (time.time() - started) > timeout:
                    return False
                results.append(self.waits[condition]())
            if False in results:
                time.sleep(0.5)
            else:
                done = True

        return True

    def _click(self, params):
        dX = random.randint(-5, 5)
        dY = random.randint(-5, 5)
        for i in range(0, len(params), 2):
            x = params[i] + dX
            y = params[i+1] + dY
            pag.moveTo(x, y, duration=0.3)
            pag.click()

        return True

    def _press(self, params):
        for p in params:
            kb.send(p)

        return True

    def _is_rested(self):
        pos = tuple(self.config["rested"]["pos"])
        color = self._get_rgb(self.config["rested"]["color"])
        pixel = self.frame.getpixel(pos)
        return pixel == color

    def _is_fatigued(self):
        pos = tuple(self.config["fatigued"]["pos"])
        color = self._get_rgb(self.config["fatigued"]["color"])
        pixel = self.frame.getpixel(pos)
        return pixel == color

    def _is_idle(self):
        pos = tuple(self.config["idle"]["pos"])
        color = self._get_rgb(self.config["idle"]["color"])
        pixel = self.frame.getpixel(pos)
        return pixel == color

    def _is_busy(self):
        pos = tuple(self.config["busy"]["pos"])
        color = self._get_rgb(self.config["busy"]["color"])
        pixel = self.frame.getpixel(pos)

        return pixel == color

    def _get_rgb(self, rgbInt):
        blue = rgbInt & 255
        green = (rgbInt >> 8) & 255
        red = (rgbInt >> 16) & 255

        return red, green, blue

    def _update_frame(self):
        self.frame = pag.screenshot(region=(0, 0, 1920, 1080))
        return True

    def _print_step(self, step):
        print(">", step.name)
        if self.verbose:
            print("  - action", step.action)
            print("  - params:", step.params)
            print("  - wait:", step.wait)
            print("  - timeout:" f"{step.timeout}s")

        return
