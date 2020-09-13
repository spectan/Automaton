#include<Date.au3>

$chop = "g"
$examine = "o"
$repair = "r"

; set your user name and Wurm installation path here
$userName = "Summerrose"
$wurmPath = "C:\Downloads\Wurm"

Woodcutting()

Func Woodcutting()
	OpenLogFile()
	SetRequiredPosition()

	$repair = Random(30,50,1)
	$food = Random(60,120,1)

	$answer = MsgBox(0,"Woodcutting Macro", "Mouse over the ground while looking down with your hatchet activated.")
	Sleep(4000)

	While 1 = 1
		LookForTree()
		WaitForAction()

		$repair = $repair - 1
		$food = $food - 1
		If $repair = 0 Then
			Repair()
			$repair = Random(10,30,1)
		EndIf
		If $food = 0 Then
			Eat()
			$food = Random(20,40,1)
		EndIf
	WEnd
EndFunc

Func OpenLogFile()
	$fileName = $wurmPath & "\players\" & $userName & "\logs\_Event." & @YEAR & "-" & @MON & ".txt"
	Global $logFile = FileOpen($fileName,0)
	If $logFile = -1 Then
		MsgBox(0, "Error","Unable to open file. Terminating script.")
		Exit
	EndIf
EndFunc

Func SetRequiredPosition()
	$answer = MsgBox(0,"Woodcutting Macro","Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	Global $staminaPosition = MouseGetPos()
	global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])
	$answer = MsgBox(0,"Woodcutting Macro","Move your mouse cursor to your hatchet")
	Sleep(4000)
	Global $pickaxePosition = MouseGetPos()
	$answer = MsgBox(0,"Woodcutting Macro","Move your mouse cursor to your water.")
	Sleep(4000)
	Global $waterPosition = MouseGetPos()
	$answer = MsgBox(0,"Woodcutting Macro","Move your mouse cursor to your food.")
	Sleep(4000)
	Global $foodPosition = MouseGetPos()
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
				MsgBox(0,"Woodcutting Macro","Your stamina appears to have stopped regenerating.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc

Func LookForTree()
	$completed = False

	Send("{w down}")

	While $completed = False
		$done = False
		$delay = 0
		$margin = Random(5,12,1)

		Local $result = FileSetPos($logFile,0,$FILE_END)
		Sleep(30)
		Send($chop)

		While $done = False
			Sleep(40)
			$line = FileReadLine($logFile)
			If StringInStr($line,"You start to cut") > 0 Then
				$completed = True
				$done = True
			Else
				$delay = $delay + 1
				If $delay > $margin Then
					$done = True
				EndIf
			EndIf
		WEnd
	WEnd

	Send("{w up}")
EndFunc

Func WaitForAction()
	$completed = False

	While $completed = False
		$done = False
		Local $result = FileSetPos($logFile,0,$FILE_END)
		Send($chop)
		Sleep(3000)
		$wait = 0
		While $done = False
			Sleep(40)
			$line = FileReadLine($logFile)
			If StringInStr($line,"You chip away") > 0 Then
				$done = True
			ElseIf StringInStr($line,"You cut down") > 0 Then
				$completed = True
				$done = True
			Else
				$wait = $wait + 1
				If $wait > 1150 Then
					$completed = True
					$done = True
				EndIf
			EndIf
		WEnd

		WaitForStamina()
		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(4000,7000,1)
		Else
			$wait = Random(1,1500,1)
		EndIf
		Sleep($wait)
	WEnd
EndFunc

Func Eat()
	$targetPosition = MouseGetPos()

	MouseMove($foodPosition[0], $foodPosition[1])
	MouseClick("right")
	$wait = Random(2000,4000,1)
	Sleep ($wait)
	MouseMove($foodPosition[0] + 10, $foodPosition[1] + 84)
	$wait = Random(500,2000,1)
	Sleep ($wait)
	MouseClick("left")

	MouseMove($waterPosition[0], $waterPosition[1])
	MouseClick("right")
	$wait = Random(2000,4000,1)
	Sleep ($wait)
	MouseMove($waterPosition[0] + 10, $waterPosition[1] + 84)
	$wait = Random(500,2000,1)
	Sleep ($wait)
	MouseClick("left")
	$wait = Random(4000,8000,1)
	Sleep ($wait)

	MouseMove($targetPosition[0],$targetPosition[1],0)
EndFunc

Func Repair()
	$targetPosition = MouseGetPos()
	MouseMove($pickaxePosition[0],$pickaxePosition[1],0)
	Sleep(80)
	Send($repair)
	MouseMove($targetPosition[0],$targetPosition[1],0)
	Sleep(80)
EndFunc