#include<Date.au3>

; This is an automated macro for digging clay, dirt, tar, or sand. It has options for automatically dumping whatever you dig into a container once your inventory
; is full. It can also be used to alternately dig and drop a dirt so you can grind your digging skill perpetually for stat gains

; set $dropItems to True if you want to drop the items you dig into a container when your inventory is full or overweight. You should probably keep this set to True
; set $combineItems to True if you want to combine them into a single lump first before dropping. This should be set to True when digging clay or tar in bulk
; set $grindingMode to True if you want to grind up your digging skill without. This will drop each dirt immediately after digging it
$dropItems = True
$combineItems = True
$grindingMode = False

; make sure you have keybinds defined for the following actions and change the values according to your preference
$dig = "f"
$repair = "r"
$activate = "b"
$combine = "t"
$drop = "e"

; set your in-game user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

Digging()

Func Digging()
	OpenLogFile()
	SetRequiredPosition()
	If $dropItems = True Then
		SetOptionalPosition()
	EndIf

	$repair = Random(30,50,1)
	$food = Random(60,120,1)

	$answer = MsgBox(0,"Digging Macro", "Mouse over the ground tile with your shovel activated.")
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
	$answer = MsgBox(0,"Digging Macro","1. Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	Global $staminaPosition = MouseGetPos()
    Global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])
	$answer = MsgBox(0,"Digging Macro","2. Move your mouse cursor to your shovel")
	Sleep(4000)
	Global $pickaxePosition = MouseGetPos()
	$answer = MsgBox(0,"Digging Macro","3. Move your mouse cursor to your water.")
	Sleep(4000)
	Global $waterPosition = MouseGetPos()
	$answer = MsgBox(0,"Digging Macro","4. Move your mouse cursor to your food.")
	Sleep(4000)
	Global $foodPosition = MouseGetPos()
EndFunc

Func SetOptionalPosition()
	$answer = MsgBox(0,"Digging Macro","5. Move your mouse cursor to where the icon of the item you dig will be.")
	Sleep(4000)
	Global $itemPosition = MouseGetPos()
	$answer = MsgBox(0,"Digging Macro","6. Move your mouse cursor to the container you want to drop things in.")
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
			If $wait > 40 Then
				Beep()
				MsgBox(0,"Digging Macro","Your stamina appears to have stopped regenerating.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc

Func WaitForAction()
	$done = False
	Local $result = FileSetPos($logFile,0,$FILE_END)
	Send($dig)
	Sleep(3000)
	$wait = 0
	While $done = False
		Sleep(40)
		$line = FileReadLine($logFile)
		If StringInStr($line,"dig a hole") > 0 Then
			$done = True
		ElseIf StringInStr($line,"you hit rock") > 0 Then
			Beep()
			MsgBox(0,"Digging Macro","You've hit the rock layer.")
			$wait = 0
			$done = True
		ElseIf StringInStr($line,"need to drop") > 0 Or StringInStr($line,"may not carry") > 0 Then
			If $dropItems = True Then
				$targetPosition = MouseGetPos()
				If $combineItems = True Then
					MouseMove($itemPosition[0] - 16, $itemPosition[1])
					Sleep(120)
					MouseClick("left")
					Sleep(120)
					MouseMove($itemPosition[0], $itemPosition[1] + 32)
					Sleep(120)
					Send($activate)
					Sleep(120)
					MouseMove($itemPosition[0] - 16, $itemPosition[1])
					Sleep(120)
					MouseClick("left")
					Sleep(120)
					MouseMove($itemPosition[0], $itemPosition[1])
					Sleep(120)
					Send($combine)
					$wait = Random(400,800,1)
					Sleep ($wait)
				EndIf
				MouseClickDrag("left", $itemPosition[0], $itemPosition[1], $dropPosition[0], $dropPosition[1])
				$wait = Random(400,800,1)
				Sleep ($wait)
				MouseMove($pickaxePosition[0], $pickaxePosition[1])
				Sleep(80)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				$done = True
			Else
				Beep()
				MsgBox(0,"Digging Macro","You've reached your carrying limit.")
				$wait = 0
				$done = True
			EndIf
		Else
			$wait = $wait + 1
			If $wait > 1150 Then
				Beep()
				MsgBox(0,"Digging Macro","Your last action doesn't seem to be executing.")
				$wait = 0
				$done = True
			EndIf
		EndIf
	 WEnd

	 If $grindingMode = True Then
		 $targetPosition = MouseGetPos()
		 MouseMove($itemPosition[0] - 16, $itemPosition[1])
		 Sleep(220)
		 Send($drop)
		 Sleep(220)
		 MouseMove($targetPosition[0],$targetPosition[1],10)
     EndIf
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
	Sleep(80)
	Send($repair)
	MouseMove($targetPosition[0],$targetPosition[1],0)
	Sleep(80)
EndFunc