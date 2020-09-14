#include<Date.au3>

$mine = "h"
$combine = "t"
$activate = "b"
$repair = "r"

; set your user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

Mining()

Func Mining()
	OpenLogFile()
	SetRequiredPosition()

	$repair = Random(30,50,1)
	$food = Random(60,120,1)

	$answer = MsgBox(0,"Mining Macro", "Mouse over the rock wall in front of you with your pickaxe activated.")
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
			$food = Random(50,100,1)
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
	$answer = MsgBox(0,"Mining Macro","Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	Global $staminaPosition = MouseGetPos()
    Global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])

	$answer = MsgBox(0,"Mining Macro","Move your mouse cursor to your pickaxe.")
	Sleep(4000)
	Global $pickaxePosition = MouseGetPos()

	$answer = MsgBox(0,"Mining Macro","Move your mouse cursor to your water.")
	Sleep(4000)
	Global $waterPosition = MouseGetPos()

	$answer = MsgBox(0,"Mining Macro","Move your mouse cursor to your food.")
	Sleep(4000)
	Global $foodPosition = MouseGetPos()

    $answer = MsgBox(0,"Item Spam Macro","Move your mouse cursor to the bulk storage bin window")
	Sleep(4000)
	global $depotPosition = MouseGetPos()

	$answer = MsgBox(0,"Item Spam Macro","Move your mouse cursor to the ore in your item pile")
	Sleep(4000)
	global $materialPosition = MouseGetPos()

		$answer = MsgBox(0,"Item Spam Macro","Move your mouse cursor to where the ore will be in your inventory")
	Sleep(4000)
	global $inventoryPosition = MouseGetPos()
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
			    Eat()
				Sleep(3000)
				$staminaColor = PixelGetColor($staminaPosition[0]-100,$staminaPosition[1])
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc

Func WaitForAction()
	$done = False
	Local $result = FileSetPos($logFile,0,$FILE_END)
	Send($mine)
	Sleep(3000)
	$wait = 0
	While $done = False
		Sleep(40)
		$line = FileReadLine($logFile)
		If StringInStr($line,"You mine some") > 0 Then
			$done = True
		ElseIf StringInStr($line,"cannot keep mining") > 0 Then
			Beep()
			MsgBox(0,"Mining Macro","This wall cannot be mined further.")
			$done = True
		ElseIf StringInStr($line,"no space") > 0 Then
			StashTheOre()
			$done = True
		ElseIf StringInStr($line,"wall breaks") > 0 Or StringInStr($line,"too hard to") > 0 Then
			$done = True
			Beep()
			MsgBox(0,"Mining Macro","The vein has been broken.")
			$wait = Random(1,1500,1)
			Sleep($wait)
		Else
			$wait = $wait + 1
			If $wait > 1150 Then
				Beep()
				MsgBox(0,"Mining Macro","Your last action doesn't seem to be executing.")
				$wait = 0
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
	MouseMove($foodPosition[0] + 40, $foodPosition[1] + 96)
	$wait = Random(500,2000,1)
	Sleep ($wait)
	MouseClick("left")
    Sleep(3000)
	Send("{Enter}")
	Sleep(1000)
	MouseClick("left")
	Sleep(100)

	MouseMove($waterPosition[0], $waterPosition[1])
	MouseClick("right")
	$wait = Random(2000,4000,1)
	Sleep ($wait)
	MouseMove($waterPosition[0] + 40, $waterPosition[1] + 96)
	$wait = Random(500,2000,1)
	Sleep ($wait)
	MouseClick("left")
    Sleep(3000)
	Send("{Enter}")
	Sleep(1000)
	MouseClick("left")
	$wait = Random(4000,8000,1)
	Sleep ($wait)

	MouseMove($targetPosition[0],$targetPosition[1],0)
 EndFunc

Func Repair()
	$targetPosition = MouseGetPos()
	MouseMove($pickaxePosition[0],$pickaxePosition[1],10)
	Sleep(200)
	Send($repair)
	Sleep(200)
	MouseMove($targetPosition[0],$targetPosition[1],10)
	Sleep(200)
 EndFunc

Func StashTheOre()
   $targetPosition = MouseGetPos()

   MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $inventoryPosition[0], $inventoryPosition[1], 20)
   $wait = Random(500,1500,1)
   Sleep($wait)

   Send($activate)
   Sleep(200)
   Send($combine)

      $wait = Random(500,1500,1)
   Sleep($wait)

   MouseClickDrag("left", $inventoryPosition[0], $inventoryPosition[1], $depotPosition[0], $depotPosition[1], 20)
   $wait = Random(500,1500,1)
   Sleep($wait)

   MouseMove($targetPosition[0],$targetPosition[1],10)
	Sleep(200)

		$targetPosition = MouseGetPos()
	MouseMove($pickaxePosition[0],$pickaxePosition[1],1)
	Sleep(400)
	Send($repair)
	Send($activate)
	Sleep(400)
	MouseMove($targetPosition[0],$targetPosition[1],1)
	Sleep(400)
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

   return False
EndFunc