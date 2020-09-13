import yaml


class Recipe:
    def __init__(self, data):
        # print(data)
        self.name = list(data.keys())[0]
        self.steps = self._parse_steps(data[self.name])
        self.index = 0

        return

    def _parse_steps(self, steps):
        ret = []

        for step in steps.keys():
            ret.append(Step(step, steps[step]))

        return ret

    def next(self):
        """
        Returns current step and increments step index
        """
        ret = self.get_current_step()

        self.index += 1

        if self.index == len(self.steps):
            self.index = 0

        return ret

    def get_current_step(self):
        return self.steps[self.index]


class Step:
    def __init__(self, name, data):
        # print(data)
        self.name = name
        # print(self.name)
        self.action = data.get("action")
        self.params = data.get("params")
        self.wait = data.get("wait")
        self.timeout = data.get("timeout")
