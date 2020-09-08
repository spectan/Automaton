#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include lib\ocr
#include OCR.ahk
#include %A_ScriptDir%

#include config.ahk
#include debug.ahk
#include inventory.ahk
#include crafting.ahk
#include assets.ahk


Drink()
{
    ImageSearch x, y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, % "*TransBlack *40 " . Assets.TEXTIMG_WATER
    if (x) {
        MouseMove x, y
        MouseClick right
        Sleep % LAG_FACTOR*500
        ImageSearch x, y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, % Assets.TEXT_DRINK
        if (x) {
            MouseMove x, y
            MouseClick
        }
    }
}

^e::
	inv := new Inventory()
	inv.Expand()
return

^f::
    KeyWait LButton
return

^d::
    Drink()
return
