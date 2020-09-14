;Imps grindstones, pretty self explanatory.
;
;v1.5 - Added humanlike mouse movement, screen capture coords for QL clicking.
;v1 - Barebones
;
;SETUP
;config
actions := 2 
;MsgBox The value of actions is %actions% ;Debug
improve := "i" 
repair := "u"
;MsgBox The value of improve is %improve% and the value of repair is %repair% ;Debug
masonryToolbelt := {"rockshard": 1, "chisel": 2} 
;This defines your toolbelt slots and hits the corresponding button. 
setLoc := "9" 
;MsgBox The value of setLoc is %bind% ;Debug
running = 1
;Run condition, used for breaking the loop if something goes wrong, ala wall breakage.
;Your characters name, for log parsing.
username := getPlayerName()
;end of config, don't touch anything else.

;init
#NoEnv
SetWorkingDir %A_ScriptDir%
;CoordMode, Mouse, Window
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
;SetControlDelay 1
;SetWinDelay 0
;SetKeyDelay -1
;SetMouseDelay -1
;SetBatchLines -1

;includes
#Include, %A_ScriptDir%\include\helpers.ahk

;Variables
;findImage variables
foundX := 0
foundY := 0 
;MsgBox The value of x is %foundX% and value of y is %foundY% ;Debug
;setMouseLoc variables
locX := 0
locY := 0
originalY := 0
;MsgBox The value of x is %locX%, originalY is %originalY% and value of y is %locY% ;Debug
;rowXY variables
rowX := 0
rowY := 0
;MsgBox The value of x is %rowX% and value of y is %rowY% ;Debug
qlX := 0
qlY := 0
;MsgBox The value of qlX is %rowX% and value of qlY is %rowY% ;Debug

;END OF SETUP


;Main Loop
global originalY, locY, locX
Random mvmouse, 2, 16
Random mvmouseX, 2, 5
F5::
WinActivate, Wurm Online
Sleep, 333
setMouseLoc()
originalY := locY
;MsgBox %bind% %actions% %locx% %locy%
while running > 0 
{
    Sleep 333
    if (isFullStam() = 1)
        {
        ;MsgBox STAMINA FOUND ;Debug
        randSleep(250,750)
        doSingleMasonryImp()
        randSleep(500,1000)
        if (Scriptstoppers() = 1)
            {
            SoundBeep 523, 800
            running = 0
            }
        antiRand()
        }
}
;Rerun/exit binds
F6::
Run SingleMasonryImper.ahk
Return

F12::
ExitApp