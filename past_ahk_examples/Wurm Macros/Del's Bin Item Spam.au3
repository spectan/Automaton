#include<Date.au3>



; make sure you have binds set ACTIVATE using the appropriate key
$activate = "b"
$drop = "e"
$examine = "o"


$materialWeight = 24
$successWeight = 4
$failureWeight = 0
$actionLimit = 50

; set your user name and Wurm installation path here
$userName = "Hempfire"
$wurmPath = "C:\Downloads\Wurm"

Bricks()

Func Bricks()
        global $wait = 0
        global $limitReached = False
        global $materialsUsed = 0
        global $currentMaterialWeight
        OpenLogFile()
        SetRequiredPosition()

        While $limitReached = False
                WaitForStamina()

                $wait = Random(0,12,1)
                If $wait = 12 Then
                        $wait = Random(3000,6000,1)
                Else
                        $wait = Random(300,1300,1)
                EndIf
                Sleep($wait)

                MakeBrick()
        WEnd

        FileClose($logFile)
EndFunc

Func OpenLogFile()
        $fileName = $wurmPath & "\players\" & $userName & "\logs\_Event." & @YEAR & "-" & @MON & ".txt"
        global $logFile = FileOpen($fileName,0)
        If $logFile = -1 Then
                MsgBox(0, "Error","Unable to open file. Terminating script.")
                Exit
        EndIf
EndFunc

Func SetRequiredPosition()
    $actionLimit = InputBox("Crafting Macro", "Material Limit", 100)
        sleep(1000)

        $answer = MsgBox(0,"Crafting Macro","Move your mouse cursor to material in bulk storage.")
        Sleep(1000)
        global $materialBulkPosition = MouseGetPos()

        $answer = MsgBox(0,"Crafting Macro","Move your mouse cursor to the rightmost edge of your stamina bar.")
        Sleep(1000)
        Global $staminaPosition = MouseGetPos()
    global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])

        $answer = MsgBox(0,"Crafting Macro","Move your mouse cursor to material in your inventory.")
        Sleep(1000)
        global $materialInventory = MouseGetPos()

        $answer = MsgBox(0,"Crafting Macro", "Move your mouse over the material in the crafting window material input box")
        Sleep(1000)
        global $craftInput = MouseGetPos()

        $answer = MsgBox(0,"Crafting Macro","Move your mouse cursor to the create button in the crafting menu.")
        Sleep(1000)
        global $craftButton = MouseGetPos()

EndFunc

Func MakeBrick()
        $completed = False
        $attempts = 0

        MouseClick("left",$craftButton[0],$craftButton[1])

        While $completed = False
                $done = False
                Local $result = FileSetPos($logFile,0,$FILE_END)
                $delay = 0


                While $done = False
                        Sleep(40)
                        $line = FileReadLine($logFile)
                        If StringInStr($line,"You create") > 0 Then
                            $currentMaterialWeight -= $successWeight
                                If $currentMaterialWeight < $successWeight Then
                                   CycleMaterial()
                            EndIf
                                $completed = True
                                $done = True
                                sleep(100)
                        ElseIf StringInStr($line,"almost made it") > 0 Then
                            $currentMaterialWeight -= $failureWeight
                                If $currentMaterialWeight < $successWeight Then
                                   CycleMaterial()
                            EndIf
                                $completed = True
                                $done = True
                                sleep(100)
                        ElseIf StringInStr($line,"too little material") > 0 Then
                                CycleMaterial()
                            $materialsUsed = $materialsUsed +1
                                If $materialsUsed = $actionLimit Then
                                   $limtReached = True
                            EndIf
                                $done = True
                                $completed = True
                        Else
                                $delay = $delay + 1
                                If $delay > 800 Then
                                        If $attempts > 2 Then
                                                Beep()
                                                MsgBox(0,"Crafting Macro","Your last action doesn't seem to be executing.")
                                                $attempts = 0
                                        EndIf
                                        $done = True
                                        $delay = 0
                                        $attempts = $attempts + 1
                                EndIf
                        EndIf
                WEnd
        WEnd
EndFunc


Func CycleMaterial()
        $completed = False
        $attempts = 0

        While $completed = False
                Local $result = FileSetPos($logFile,0,$FILE_END)
                $delay = 0

            MouseClickDrag("left", $materialInventory[0], $materialInventory[1], $materialBulkPosition[0], $materialBulkPosition[1])
                $wait = Random(300,600,1)
                Sleep($wait)
            MouseClickDrag("left", $materialInventory[0], $materialInventory[1], $materialBulkPosition[0], $materialBulkPosition[1])
                $wait = Random(300,600,1)
                Sleep($wait)
            MouseClickDrag("left", $materialInventory[0], $materialInventory[1], $materialBulkPosition[0], $materialBulkPosition[1])
                $wait = Random(300,600,1)
                Sleep($wait)
            MouseClickDrag("left", $materialBulkPosition[0], $materialBulkPosition[1], $materialInventory[0], $materialInventory[1])
                $wait = Random(1400,2600,1)
                Sleep($wait)
                Send("1")
                $wait = Random(300,600,1)
                Sleep($wait)
                Send("{ENTER}")
                $wait = Random(300,600,1)
                Sleep($wait)
            MouseClickDrag("left", $materialInventory[0], $materialInventory[1], $craftInput[0], $craftInput[1])
                $wait = Random(300,600,1)
                Sleep($wait)


                $line = FileReadLine($logFile)
            If StringInStr($line,"You selected") > 0 Then
                   $completed = True
                   $currentMaterialWeight = $materialWeight
            EndIf

        WEnd

EndFunc

Func WaitForStamina()
        $done = False
        $wait = 0
        While $done = False
           ;0x80C080
                $coord = PixelSearch($staminaPosition[0],$staminaPosition[1],$staminaPosition[0] + 1,$staminaPosition[1] + 1,$staminaColor,3)
                If Not @error Then
                        $done = True
                        $wait = 0
                Else
                        Sleep(500)
                        $wait = $wait + 1
                        If $wait > 40 Then
                                Beep()
                                MsgBox(0,"Brick Macro","Your stamina appears to have stopped regenerating.")
                                $wait = 0
                        EndIf
                EndIf
        WEnd
 EndFunc