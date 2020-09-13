#include<Date.au3>

; set this to true and it will combine your raw materials before using them. If in doubt, set it to true
$combineItems = True

; set your user name and Wurm installation path here
$userName = "Summerrose"
$wurmPath = "H:\Program Files\Wurm"

ItemSpam()

Func ItemSpam()
	global $wait = 0
	OpenLogFile()
	SetRequiredPosition()

	While 1 = 1
		WaitForStamina()

		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(3000,6000,1)
		Else
			$wait = Random(300,1300,1)
		EndIf
		Sleep($wait)

		MakeItem()
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
   	$answer = MsgBox(0,"Trash Spam Macro","Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	global $staminaPosition = MouseGetPos()
	global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])

	$answer = MsgBox(0,"Trash Spam Macro","Move your mouse cursor to the raw material combine button on the crafting GUI")
	Sleep(4000)
	global $slotPosition = MouseGetPos()

    $answer = MsgBox(0,"Trash Spam  Macro","Move your mouse cursor to the create button on the crafting GUI with the desired item selected on the righthand menu.")
	Sleep(4000)
	global $createPosition = MouseGetPos()

    $answer = MsgBox(0,"Trash Spam Macro","Move your mouse cursor to the raw material in your item pile")
	Sleep(4000)
	global $depotPosition = MouseGetPos()

    $answer = MsgBox(0,"Trash Spam Macro","Move your mouse cursor to the trash bin window")
	Sleep(4000)
	global $trashPosition = MouseGetPos()

	$answer = MsgBox(0,"Trash Spam Macro","Move your mouse cursor to the raw material in your inventory")
	Sleep(4000)
	global $materialPosition = MouseGetPos()
EndFunc

Func MakeItem()
	$completed = False
	$attempts = 0
	$fuckups = 0

	While $completed = False
		$done = False
		Local $result = FileSetPos($logFile,0,$FILE_END)
		$delay = 0

		MouseMove($createPosition[0], $createPosition[1])
		Sleep(40)
		MouseClick("left")

		While $done = False
			Sleep(40)
			$line = FileReadLine($logFile)
			If StringInStr($line,"You create") > 0 Then
				$completed = True
				$done = True
			ElseIf StringInStr($line,"almost made it") > 0 Then
				$completed = True
				$done = True
			ElseIf StringInStr($line,"too little material") > 0 Then
				GetMoreMaterials()
				$done = True
			ElseIf StringInStr($line,"too low") > 0 Then
				GetMoreMaterials()
				$done = True
			ElseIf StringInStr($line,"inventory is full") > 0 Then
				GetMoreMaterials()
				$done = True
			ElseIf StringInStr($line,"You start") > 0 Then
				Sleep(5000)
			Else
				$delay = $delay + 1
				If $delay > 500 Then
					If $attempts > 1 Then
						$fuckups = $fuckups + 1
						If $fuckups > 1 Then
							Beep()
							MsgBox(0,"Trash Spam Macro","You are out of raw materials.")
							$fuckups = 0
						EndIf
						GetMoreMaterials()
						$done = True
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

Func WaitForMessage($message, $timeout)
   Local $result = FileSetPos($logFile,0,$FILE_END)
   $delay = 0

   While $delay * 40 < $timeout
   Sleep(40)
   $line = FileReadLine($logFile)
	  If StringInStr($line,$message) > 0 Then
		 return True
	  Else
		 $delay = $delay + 1
	  EndIf
   WEnd
EndFunc

Func GetMoreMaterials()
	 MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $depotPosition[0], $depotPosition[1], 20)
	 $wait = Random(500,1500,1)
	 Sleep($wait)
     MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $trashPosition[0], $trashPosition[1], 20)
	 $wait = Random(500,1500,1)
	 Sleep($wait)

	 MouseClickDrag("left", $depotPosition[0], $depotPosition[1], $materialPosition[0], $materialPosition[1], 20)
	 $wait = Random(1000,2000,1)
	 Sleep($wait)

     If $combineItems > 0 Then
		MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $slotPosition[0] - 40, $slotPosition[1] - 16, 20)
		$wait = Random(1600,3200,1)
		Sleep($wait)
		MouseMove($slotPosition[0], $slotPosition[1])
		Sleep(200)
		MouseClick("left")
	 EndIf

     MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $slotPosition[0] - 40, $slotPosition[1] - 16, 20)
	 $wait = Random(800,1600,1)
	 Sleep($wait)
EndFunc

Func WaitForStamina()
	$done = False
	$wait = 0
	While $done = False
		$coord = PixelSearch($staminaPosition[0],$staminaPosition[1],$staminaPosition[0] + 1,$staminaPosition[1] + 1,$staminaColor,30)
		If Not @error Then
			$done = True
			$wait = 0
		Else
			Sleep(500)
			$wait = $wait + 1
			If $wait > 40 Then
				Beep()
				MsgBox(0,"Trash Spam Macro","Your stamina appears to have stopped regenerating.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc