#include config.ahk
#include assets.ahk

class Crafting
{
    IsOpen()
    {
        ImageSearch x, y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, % Assets.TEXT_CRAFTING
        return (x && y)
    }

    Open()
    {
        Send b
    }
    
    MoveToHand()
    {
        if (!this.IsOpen()) {
            this.Open()
            Sleep % LAG_FACTOR * 500
        }

        ImageSearch x, y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, % Assets.IMG_CRAFTINGHAND
        MouseMove % x + 8, y + 8, 5
    }
    
    DragToSlot(slot="left")
    {
        offset_x := slot = "left" ? 35 : 195
        offset_y := 16

        MouseClick Left, 0, 0, 1, 0, D, R
        this.MoveToHand()
        MouseGetPos x, y
        MouseMove % x + offset_x, y + offset_y
        MouseClick Left, 0, 0, 1, 0, U, R
    }
}
