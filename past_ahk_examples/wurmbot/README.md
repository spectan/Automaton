# WurmBot

## Color botting made easy for Wurm

### About

This project aims to make it easy for users to automate tasks in Wurm (Online & Unlimited). Users create Recipes that the bot loads and executes for you. Since Recipes are just YAML files they make it easy for users to pick up and learn.

### Setup

1. Installing Dependencies
    * `pip install -r requirements.txt`
2. Ensure Wurm setup properly
    * Running in windowed mode (**not windowed fullscreen, but actually windowed**)
    * Make sure status bars window is locked
    * Make sure event/action bar window is locked
3. Configure ui.yml (in the config folder)
    * Stamina
        * Rested - Top right green pixel in stamina bar
        * Fatigued - Top left dark pixel in stamina bar
    * Action
        * Idle - Top left dark pixel in action bar
        * Busy - Top left blue pixel in action bar

### Example
Open a terminal in the folder where `client.py` is located. You can run a recipe like so:

```python wurmbot.py MineBuddy 10```

The above command runs the MineBuddy Recipe 10 times before stopping. The general syntax for running WurmBot is

```python wurmbot.py <RECIPE_WITHOUT_EXTENSION> <ITERATIONS>```
