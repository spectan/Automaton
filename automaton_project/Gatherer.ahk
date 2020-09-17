;init params
#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
#Include, %A_ScriptDir%\include\GeneralHelpers.ahk
#Include, %A_ScriptDir%\include\ImageHelpers.ahk
#Include, %A_ScriptDir%\include\ParseHelpers.ahk
running := 1

;Script Pauser
F6:: pause, toggle

F5::
TrayTip, Gatherer, Script running! F6 to toggle pause., 5
;Read the .ini file and defines necessary vars
varSaver := "Username,Repair,Mine,Actions,GatherType" ;THIS MUST BE THE SAME AS THE SAME VARIABLE DEFINED IN RUNTHISFIRST.ahk!!!! VERY IMPORTANT. NO SPACES
loop, parse, varSaver, `,
{

    IniRead, %A_LoopField%, %A_ScriptDir%\include\config.ini, Setup, % A_LoopField
}
varSaverBelt := "SlotOne,SlotTwo,SlotThree,SlotFour,SlotFive,SlotSix,SlotSeven,SlotEight" ;THIS MUST BE THE SAME AS THE SAME VARIABLE DEFINED IN RUNTHISFIRST.ahk!!!! VERY IMPORTANT. NO SPACES
loop, parse, varSaverBelt, `,
{

    IniRead, %A_LoopField%, %A_ScriptDir%\include\config.ini, Toolbelt, % A_LoopField
}
;Properly define username-auto detection
If (Username = "Auto") {
    Username := getPlayerName()
}

;Scriptstoppers specific to "Gatherer" script type
Scriptstoppers() ;Parses the log to determine if the script should be stopped, and then alert the user.
{
    event := "C:\Users\" . A_UserName . "\wurm\players\" . username . "\logs\_Event." . A_YYYY . "-" . A_MM . ".txt"
    parseLog := parseFunc(2, event)
    carry := "not be able to carry"
    toofar := "too far away"
    nospace := "is no space"
    wallbreaks := "the wall breaks!"
    hitrock := "dig in the solid rock"
    ret := 0
    if parseLog contains %carry%
    {
        ret := 1
    }
    if parseLog contains %toofar%
    {
        ret := 1
    }
    if parseLog contains %nospace%
    {
        ret := 1
    }
    if parseLog contains %wallbreaks%
    {
        ret := 1
    }
    if parseLog contains %hitrock%
    {
        ret := 1
    }
    return ret
}


;Main loop
switch GatherType {
    case "Wall-Miner":
        while running > 0 {
            If (isFullStam() = 1) {
                randSleep(300,750)
                loop %Actions% {

                }
                if (Scriptstoppers() = 1) {
                    SoundBeep 523, 800
                    running := 0
                }
                antiMacro()

            }
        }
    default: 
        Msgbox Failed to fetch Gathertype
}


;MsgBox Actions = %Actions%, Mine = %Mine%, Repair = %Repair%, Username = %Username%, Gathertype = %GatherType% ;Debug for verifying setup variables saved appropriately
;Msgbox SlotOne = %SlotOne%, SlotTwo = %SlotTwo%, SlotThree = %SlotThree%, SlotFour = %SlotFour%, SlotFive = %SlotFive%, SlotSix = %SlotSix%, SlotSeven = %SlotSeven%, SlotEight = %SlotEight% ;Debug for verifying toolbelt variables saved appropriately
Return
