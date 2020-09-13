#include<Date.au3>

; make sure you have keybinds defined for the following actions and change the values according to your preference
$activate = "b"
$continue = "z"

; set your in-game user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

Macro()

Func Macro()
	global $wait = 0
	OpenLogFile()
	SetRequiredPosition()

	MouseMove($itemPosition[0], $itemPosition[1])
	$wait = Random(200,800,1)
	Sleep($wait)
	Send($activate)

	While 1 = 1
		WaitForStamina()

		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(3000,6000,1)
		Else
			$wait = Random(300,1300,1)
		EndIf
		Sleep($wait)

		Continue()
	WEnd

	FileClose($logFile)
EndFunc

Func OpenLogFile()
	$fileName = $wurmPath & "\players\" & $userName & "\test_logs\_Event." & @YEAR & "-" & @MON & ".txt"
	global $logFile = FileOpen($fileName,0)
	If $logFile = -1 Then
		MsgBox(0, "Error","Unable to open file. Terminating script.")
		Exit
	EndIf
EndFunc

Func SetRequiredPosition()
	$answer = MsgBox(0,"Continue Macro","1. Move your mouse cursor to the item you wish to continue.")
	Sleep(4000)
	global $targetPosition = MouseGetPos()

	$answer = MsgBox(0,"Continue Macro", "2. Move your mouse over the stack of items you will be adding.")
	Sleep(4000)
	global $itemPosition = MouseGetPos()

	$answer = MsgBox(0,"Continue Macro", "3. Move your mouse over the stack of items you will be getting more resources from.")
	Sleep(4000)
	global $resourcePosition = MouseGetPos()

	$answer = MsgBox(0,"Continue Macro","4. Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	global $staminaPosition = MouseGetPos()
    global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])
EndFunc

Func Continue()
	$completed = False
	$shardGrab = 0

	While $completed = False
		$done = False
		Local $result = FileSetPos($logFile,0,$FILE_END)
		$delay = 0

		MouseMove($targetPosition[0], $targetPosition[1])
		$wait = Random(200,800,1)
		Sleep($wait)
		Send($continue)

		While $done = False
			Sleep(40)
			$line = FileReadLine($logFile)
			If StringInStr($line,"You attach") > 0 Then
				$completed = True
				$done = True

				MouseMove($itemPosition[0], $itemPosition[1])
				$wait = Random(200,800,1)
				Sleep($wait)
				Send($activate)
			ElseIf StringInStr($line,"almost made it") > 0 Then
				$completed = True
				$done = True
			ElseIf StringInStr($line,"will not benefit") > 0 Then
				Beep()
				MsgBox(0,"Continue Macro","You are out of items to add.")
			ElseIf StringInStr($line,"create a") > 0 Then
				Beep()
				MsgBox(0,"Continue Macro","You have finished building the thing.")
			Else
				$delay = $delay + 1
				If $delay > 800 Then
					GetMoreItems()
					$attempts = 0
					$done = True
					$delay = 0
				EndIf
			EndIf
		WEnd
	WEnd
EndFunc

Func GetMoreItems()
	MouseClickDrag("left", $resourcePosition[0], $resourcePosition[1], $itemPosition[0], $itemPosition[1])
	$wait = Random(600,1200,1)
	Sleep($wait)

	MouseMove($itemPosition[0], $itemPosition[1])
	$wait = Random(200,800,1)
	Sleep($wait)
	Send($activate)
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
			If $wait > 40 Then
				Beep()
				MsgBox(0,"Brick Macro","Your stamina appears to have stopped regenerating.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc