;Digger or Miner
;SETUP
;config
;This is your desired number of actions per iteration
actions := 2 
;MsgBox The value of actions is %actions% ;Debug
;Your bind for whatever, digging, mining
bind := "m" 
;MsgBox The value of bind is %bind% ;Debug
;Used for grabbing location of mouse
setLoc := "9" 
;MsgBox The value of setLoc is %bind% ;Debug
running = 1
;Run condition, used for breaking the loop if something goes wrong, ala wall breakage.

;Your characters name, for log parsing.
username := getPlayerName()
;end of config, don't touch anything else.
;


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

#Include, %A_ScriptDir%\include\helpers.ahk

;Variables
;findImage variables
foundX := 0
foundY := 0 
;MsgBox The value of x is %foundX% and value of y is %foundY% ;Debug
;setMouseLoc variables
locX := 0
locY := 0
;MsgBox The value of x is %locX% and value of y is %locY% ;Debug

Random, rand, 0, 60000
;
;END OF SETUP
;


;Main Loop
F5::
global bind, actions, locX, locY, foundX, setLoc, running
WinActivate, Wurm Online
Sleep, 333
setMouseLoc()
;MsgBox %bind% %actions% %locx% %locy%
while running > 0 
{
    Sleep 333
    if (isFullStam() = 1)
        {
        randSleep(250,750)
        loop %actions%
            {
            doKey(bind)
            randSleep(300,750)
            }
        if (Scriptstoppers() = 1)
            {
            SoundBeep 523, 800
            running = 0
            }
        antiRand()
        Sleep 15000
        }
}
;Rerun/exit binds
F6::
Run DigOrMine.ahk
Return

F12::
ExitApp