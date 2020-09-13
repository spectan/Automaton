#include<Date.au3>

; make sure you have keybinds defined for the following actions and change the values according to your preference
$improve = "i"
$repair = "r"
$activate = "b"
$examine = "o"
$stop = "p"

; these are used to randomly generate the failure tolerance for improving each item. The macro will keep improving the same item until either
; it fails more times in a row than the current tolerance setting, or until it is unable to improve the item with your rock shard QL
$minTolerance = 5
$maxTolerance = 6

; set your in-game user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

Masonry()

Func Masonry()
	global $damage = 0
	global $wait = 0
	global $tolerance = Random($minTolerance,$maxTolerance,1)
	OpenLogFile()
	SetRequiredPosition()

	While 1 = 1
		WaitForStamina()
		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(3000,6000,1)
		Else
			$wait = Random(200,1300,1)
		EndIf
		Sleep($wait)
		WaitForAction()
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
	$answer = MsgBox(0,"Masonry Macro","1. Move your mouse cursor to your chisel")
	Sleep(4000)
	global $itemPosition1 = MouseGetPos()
	$answer = MsgBox(0,"Masonry Macro","2. Move your mouse cursor to your rock shards")
	Sleep(4000)
	global $itemPosition2 = MouseGetPos()
	$answer = MsgBox(0,"Masonry Macro","3. Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	global $staminaPosition = MouseGetPos()
	global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])
	$answer = MsgBox(0,"Masonry Macro", "4. Stamina bar location is recorded. Now mouse over the first item to be improved with the first improvement tool activated.")
	Sleep(4000)
EndFunc

Func WaitForAction()
	$done = False
	Local $result = FileSetPos($logFile,0,$FILE_END)
	Send($improve)
	$wait = 0
	While $done = False
		Sleep(40)
		$line = FileReadLine($logFile)
		If StringInStr($line,"You damage") > 0 Then
			$wait = Random(0,12,1)
			If $wait = 12 Then
				$wait = Random(1000,4000,1)
				Sleep($wait)
			EndIf
			Send($repair)
			$done = True
			$damage = $damage + 1
			If $damage > $tolerance Then
				$targetPosition = MouseGetPos()
				MouseMove($targetPosition[0],$targetPosition[1]+16,0)
				Sleep(50)
				Send($examine)
				$done = false
				$damage = 0
				$tolerance = Random($minTolerance,$maxTolerance,1)
				Sleep(50)
			EndIf
		ElseIf StringInStr($line,"with a stone chisel") > 0 Then
			$done = True
			$damage = 0
			$targetPosition = MouseGetPos()
			MouseMove($itemPosition1[0],$itemPosition1[1],0)
			Sleep(50)
			Send($activate)
			MouseMove($targetPosition[0],$targetPosition[1],0)
			Sleep(50)
		ElseIf StringInStr($line,"with a rock shards") > 0 Then
			$done = True
			$damage = 0
			$targetPosition = MouseGetPos()
			MouseMove($itemPosition2[0],$itemPosition2[1],0)
			Sleep(50)
			Send($activate)
			MouseMove($targetPosition[0],$targetPosition[1],0)
			Sleep(50)
		ElseIf StringInStr($line,"some more rock shards") > 0 Then
			$done = True
			$damage = 0
		ElseIf StringInStr($line,"too poor shape") > 0 Then
			$targetPosition = MouseGetPos()
			MouseMove($targetPosition[0],$targetPosition[1]+16,0)
			Sleep(50)
			Send($examine)
			$damage = 0
			$tolerance = Random($minTolerance,$maxTolerance,1)
			Sleep(50)
	    ElseIf StringInStr($line,"after improving you will start improving") > 0 Then
			send($stop)
			Sleep(100)
			send($stop)
			Sleep(100)
			send($stop)
			Sleep(100)
			$targetPosition = MouseGetPos()
			MouseMove($targetPosition[0],$targetPosition[1]+16,0)
			Sleep(80)
			Send($examine)
			$damage = 0
			$tolerance = Random($minTolerance,$maxTolerance,1)
			Sleep(80)
		ElseIf StringInStr($line,"cannot improve") > 0 Then
			Send($examine)
			Sleep(80)
		Else
			$wait = $wait + 1
			If $wait > 800 Then
				Beep()
				MsgBox(0,"Masonry Macro","Your last action doesn't seem to be executing.")
				$wait = 0
			EndIf
		EndIf
	WEnd
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
				MsgBox(0,"Masonry Macro","Your stamina appears to have stopped regenerating.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc