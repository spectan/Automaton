;init params
#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1
#Include, %A_ScriptDir%\include\GeneralHelpers.ahk
#Include, %A_ScriptDir%\include\ImageHelpers.ahk
#Include, %A_ScriptDir%\include\ParseHelpers.ahk
running := 1

;Script Pauser
F6:: 
pause, toggle

F5::
;TrayTip, Gatherer, Script running! F6 to toggle pause., 5
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
    parseUsername := getPlayerName()
} else {
    parseUsername := Username
}

;Scriptstoppers specific to "Gatherer" script type
Scriptstoppers() { ;Parses the log to determine if the script should be stopped, and then alert the user.
    event := "C:\Users\" . A_UserName . "\wurm\players\" . parseUsername . "\logs\_Event." . A_YYYY . "-" . A_MM . ".txt"
    parseLog := parseFunc(2, event)
    switch parseLog {
        case parseLog contains "not be able to carry": return 1
        case parseLog contains "too far away": return 1
        case parseLog contains "is no space": return 1
        case parseLog contains "the wall breaks!": return 1
        case parseLog contains "dig in the solid rock": return 1
        default: return 0
    }
}

randSleep(170,320)
doClick()

;Main loop
switch GatherType {
    case "Wall Miner":
        while running > 0 {
            If (isFullStamBMP()) {
                randSleep(1500,750)
                loop %Actions% {
                    doKey(Mine)
                    randSleep(170,320)
                }
                ;Scriptstoppers()
                sleep, 10000
                antiMacro()
            } else {
                randSleep(40,80)
            }
        }
    default: 
        Msgbox Failed to fetch Gathertype
}


;MsgBox Actions = %Actions%, Mine = %Mine%, Repair = %Repair%, Username = %Username%, Gathertype = %GatherType% ;Debug for verifying setup variables saved appropriately
;Msgbox SlotOne = %SlotOne%, SlotTwo = %SlotTwo%, SlotThree = %SlotThree%, SlotFour = %SlotFour%, SlotFive = %SlotFive%, SlotSix = %SlotSix%, SlotSeven = %SlotSeven%, SlotEight = %SlotEight% ;Debug for verifying toolbelt variables saved appropriately
Return
