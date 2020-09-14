;Worldimper
;SETUP
;config
;MsgBox The value of actions is %actions% ;Debug
improve := "i" 
repair := "u"
;MsgBox The value of improve is %improve% and the value of repair is %repair% ;Debug
;Used for grabbing location of mouse
setLoc := "9" 
;MsgBox The value of setLoc is %bind% ;Debug
;Toolbelt arrays, update accordingly.
masonryToolbelt := {"rockshard": 1, "chisel": 2}
;carpentryToolbelt := {"log": 1, "carving": 2, "pelt": 3, "file": 4, "mallet": 5} 
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
running = 1
;Run condition, used for breaking the loop if something goes wrong, ala wall breakage.
;
;END OF SETUP
;

;These are your improvement functions.
doMasonryWorldImp()
{
    global username, improve, repair, locX, locY, masonryToolbelt
    event := "C:\Users\" . A_UserName . "\wurm\players\" . username . "\logs\_Event." . A_YYYY . "-" . A_MM . ".txt"
    parseLog := parseFunc(15, event)
    chisel := "with a stone chisel"
    rockshard := "some stone shards"
    doingaction := 0
    doKey(repair)
    randSleep()
    ;doClick()
    ;doClick()
    if parseLog contains %chisel%
    {
        doKey(masonryToolbelt["chisel"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
    }
    if parseLog contains %rockshard%
    {
        doKey(masonryToolbelt["rockshard"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
    }
    else
    {
        doKey(masonryToolbelt["rockshard"])
        doKey(improve)
	doKey(masonryToolbelt["chisel"])
        doKey(improve)
        randSleep()
    }
}
/*
doCarpentryWorldImp()
{
    global username, improve, repair, locX, locY, masonryToolbelt
    event := "C:\Users\" . A_UserName . "\wurm\players\" . username . "\logs\_Event." . A_YYYY . "-" . A_MM . ".txt"
    parseLog := parseFunc(25, event)
}
*/

;Main Loop
F5::
global improve, repair, actions, locX, locY, foundX, setLoc
random, randX, 1, 8
random, randY, 1, 8
WinActivate, Wurm Online
Sleep, 333
;This gets the initial examine
setMouseLoc()
MouseMove, locX + randX, locY + randY
;MsgBox improve bind is %improve%, repair bind is %repair%, saved mouse coords are %locx% %locy%
while running > 0 
{
    Sleep 333
    if (isFullStam() = 1)
        {
            doMasonryWorldImp()
            ;doCarpentryWorldImp()
        if (Scriptstoppers() = 1)
            {
            SoundBeep 523, 800
            running = 0
            }
        Sleep 15000
        antiRand()
        }
}
;Rerun/exit binds
F6::
Run WorldImper.ahk
Return

F12::
ExitApp