#include config.ahk
#include assets.ahk

class Inventory
{
    IsOpen()
    {
        ImageSearch x, y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, % Assets.TEXT_INVENTORY
        return (x && y)
    }

    Open()
    {
        Send {f3}
    }

    Expand()
    {
        if (!this.IsOpen()) {
            this.Open()
            Sleep % LAG_FACTOR*500
        }

        ImageSearch x, y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, % Assets.TEXT_INVENTORY

        if (x) {
            MouseMove x, y, 5
            MouseMove 0, 25, 5, R
            MouseClick right
            Sleep % LAG_FACTOR*500
            ImageSearch x, y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, % "*40 " . Assets.TEXT_EXPAND_ALL
            if (x) {
                MouseMove x, y, 5
                MouseClick
            }
        }
    }
}
