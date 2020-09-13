;init params
#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
#Include, %A_ScriptDir%\include\helpers.ahk

F7::
;Read the .ini file and defines necessary vars
varSaver := "Username,Repair,MineDig,Actions,GatherType" ;THIS MUST BE THE SAME AS THE SAME VARIABLE DEFINED IN RUNTHISFIRST.ahk!!!! VERY IMPORTANT. NO SPACES
loop, parse, varSaver, `,
{

    IniRead, %A_LoopField%, %A_ScriptDir%\include\config.ini, Setup, % A_LoopField
}

;Properly define username-auto detection
If (Username = "Auto") {
    Username := getPlayerName()
}

MsgBox Actions = %Actions%, MineDig = %MineDig%, Repair = %Repair%, Username = %Username%, Gathertype = %GatherType% ;Debug for verifying variables saved appropriately
Return
