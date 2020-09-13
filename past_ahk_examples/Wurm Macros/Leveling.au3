#include<Date.au3>


; make sure you have keybinds defined for the following actions and change the values according to your preference
$repair = "r"
$level = "l"

; set your in-game user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

Digging()

Func Digging()
        OpenLogFile()
        SetRequiredPosition()

        $repair = Random(30,50,1)
        $food = Random(60,120,1)

        $answer = MsgBox(0,"Leveling Macro", "Mouse over the ground tile to level with your shovel activated.")
        Sleep(4000)

        While 1 = 1
                WaitForStamina()
                $wait = Random(0,12,1)
                If $wait = 12 Then
                        $wait = Random(4000,7000,1)
                Else
                        $wait = Random(1,1500,1)
                EndIf
                Sleep($wait)
            Send($level)
                WaitForAction()
                $repair = $repair - 1
                $food = $food - 1
                If $repair = 0 Then
                        Repair()
                        $repair = Random(20,40,1)
                EndIf
                If $food = 0 Then
                        Eat()
                        $food = Random(60,120,1)
                EndIf
        WEnd
EndFunc

Func OpenLogFile()
        $fileName = $wurmPath & "\players\" & $userName & "\test_logs\_Event." & @YEAR & "-" & @MON & ".txt"
        Global $logFile = FileOpen($fileName,0)
        If $logFile = -1 Then
                MsgBox(0, "Error","Unable to open file. Terminating script.")
                Exit
        EndIf
EndFunc

Func SetRequiredPosition()
        $answer = MsgBox(0,"Leveling Macro","1. Move your mouse cursor to the rightmost edge of your stamina bar.")
        Sleep(4000)
        Global $staminaPosition = MouseGetPos()
    Global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])
        $answer = MsgBox(0,"Leveling Macro","2. Move your mouse cursor to your shovel")
        Sleep(4000)
        Global $pickaxePosition = MouseGetPos()
        $answer = MsgBox(0,"Leveling Macro","3. Move your mouse cursor to your water.")
        Sleep(4000)
        Global $waterPosition = MouseGetPos()
        $answer = MsgBox(0,"Leveling Macro","4. Move your mouse cursor to your food.")
        Sleep(4000)
        Global $foodPosition = MouseGetPos()
    $answer = MsgBox(0,"Leveling Macro","5. Move your mouse cursor to where the icon of the item you dig will be.")
        Sleep(4000)
        Global $itemPosition = MouseGetPos()
        $answer = MsgBox(0,"Leveling Macro","6. Move your mouse cursor to the container you want to drop things in.")
        Sleep(4000)
        Global $dropPosition = MouseGetPos()
EndFunc

Func WaitForStamina()
        $done = False
        $wait = 0
        While $done = False
                $coord = PixelSearch($staminaPosition[0],$staminaPosition[1],$staminaPosition[0] + 1,$staminaPosition[1] + 1,$staminaColor,25)
                If Not @error Then
                        $done = True
                        $wait = 0
                Else
                        Sleep(500)
                        $wait = $wait + 1
                        If $wait > 200 Then
                                Beep()
                                $wait = 0
                        EndIf
                EndIf
        WEnd
EndFunc

Func WaitForAction()
        $done = False
        Local $result = FileSetPos($logFile,0,$FILE_END)
        Sleep(3000)
        $wait = 0
        While $done = False
                Sleep(40)
                $line = FileReadLine($logFile)
                If StringInStr($line,"You use a dirt") > 0 Then
                        $wait = 0
                        FileSetPos($logFile,0,$FILE_END)
                        GetMoreDirt()
                ElseIf StringInStr($line,"You assemble some dirt") > 0 Then
                        $wait = 0
                        DumpSomeDirt()
                        FileSetPos($logFile,0,$FILE_END)
                 ElseIf StringInStr($line,"cannot carry") > 0 Then
                        $wait = 0
                        $done = True
                        DumpSomeDirt()
                 ElseIf StringInStr($line,"if you had") > 0 Then
                        $wait = 0
                        $done = True
                        GetMoreDirt()
                 ElseIf StringInStr($line,"must rest") > 0 Then
                        $wait = 0
                        $done = True
                 ElseIf StringInStr($line,"rock") > 0 Then
                        Beep()
                        MsgBox(0,"Digging Macro","You've hit the rock layer.")
                        $wait = 0
                        $done = True
                 ElseIf StringInStr($line,"flat") > 0 Then
                        Beep()
                        MsgBox(0,"Digging Macro","You've finished leveling the tile.")
                        $wait = 0
                        $done = True
                Else
                        $wait = $wait + 1
                        If $wait > 2000 Then
                                $wait = 0
                                $done = True
                        EndIf
                EndIf
         WEnd
EndFunc

Func Eat()
        $targetPosition = MouseGetPos()

        MouseMove($foodPosition[0], $foodPosition[1])
        MouseClick("right")
        $wait = Random(2000,4000,1)
        Sleep ($wait)
        MouseMove($foodPosition[0] + 40, $foodPosition[1] + 88)
        $wait = Random(500,2000,1)
        Sleep ($wait)
        MouseClick("left")
    Sleep(2000)
        Send("{Enter}")
        Sleep(1000)
        MouseClick("left")
        Sleep(100)

        MouseMove($waterPosition[0], $waterPosition[1])
        MouseClick("right")
        $wait = Random(2000,4000,1)
        Sleep ($wait)
        MouseMove($waterPosition[0] + 40, $waterPosition[1] + 88)
        $wait = Random(500,2000,1)
        Sleep ($wait)
        MouseClick("left")
    Sleep(2000)
        Send("{Enter}")
        Sleep(1000)
        MouseClick("left")
        $wait = Random(4000,8000,1)
        Sleep ($wait)

        MouseMove($targetPosition[0],$targetPosition[1],0)
 EndFunc

Func Repair()
        $targetPosition = MouseGetPos()
        MouseMove($pickaxePosition[0],$pickaxePosition[1],0)
        Sleep(250)
        Send($repair)
        MouseMove($targetPosition[0],$targetPosition[1],0)
        Sleep(250)
 EndFunc

 Func GetMoreDirt()
    $targetPosition = MouseGetPos()
    MouseMove($dropPosition[0], $dropPosition[1])
        $wait = Random(200,500,1)
        Sleep ($wait)

        MouseClickDrag("left", $dropPosition[0], $dropPosition[1], $itemPosition[0], $itemPosition[1], 20)
    $wait = Random(200,500,1)
        Sleep ($wait)

    Sleep(1000)
    Send("{Enter}")
        Sleep(500)

        Sleep(300)
        MouseClick("left")
        Sleep(300)

        MouseMove($targetPosition[0], $targetPosition[1])
        Sleep(250)
 EndFunc

 Func DumpSomeDirt()
        $targetPosition = MouseGetPos()

    MouseMove($itemPosition[0], $itemPosition[1])
        $wait = Random(200,500,1)
        Sleep ($wait)

        MouseClickDrag("left", $itemPosition[0], $itemPosition[1], $dropPosition[0], $dropPosition[1], 20)
    $wait = Random(200,500,1)
        Sleep ($wait)

        MouseMove($targetPosition[0], $targetPosition[1])
        Sleep(250)
 EndFunc