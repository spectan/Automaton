;Shoots arrowshafts at archery target.
;
;v1 - Barebones 8/1/2020
;
;SETUP
;config
actions := 2 
;MsgBox The value of actions is %actions% ;Debug
bind := "i" 
;MsgBox The value of bind is %bind% ;Debug
running = 1
;Run condition, used for breaking the loop if something goes wrong, ala wall breakage.
SetDefaultMouseSpeed, 100

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
targetX := 0
targetY := 0 
;MsgBox The value of x is %target% and value of y is %targetY% ;Debug

;END OF SETUP

doArchery() 
{
    global actions, bind
    loop %actions%
    {
    doKey(bind)
    randSleep(50,125)
    }
	Sleep 25000
}

;Main Loop
global targetX, targetY
F5::
WinActivate, Wurm Online
Sleep, 333
while running > 0 
{
    Sleep 333
    if (!findImage("practice")) ;Checks if you selected something other than the target by mistake.
    {
        running = 0
        SoundPlay, %A_WorkingDir%\include\ding.wav
        break
    }
    if (isFullStam() = 1)
        {
        ;findPracticeIcon()
        ;Msgbox targetX is %targetX% and targetY is %targetY%
        doArchery()
        ;antiRand()
        }
    ;break statements
    if (findImage("noarrows") = 1) ;Checks if you run out of arrow shafts to shoot.
    {
        running = 0
        SoundPlay, %A_WorkingDir%\include\ding.wav
    }
    if (findImage("stringbreak") = 1) ;Checks if your string breaks.
    {
        running = 0
        SoundPlay, %A_WorkingDir%\include\ding.wav
    }
}
;Rerun/exit binds
F6::
Run ArcheryTarget.ahk
Return

F12::
ExitApp