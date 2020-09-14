#include<Date.au3>

$repair = "r"

; set your user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

Mining()

Func Mining()
	OpenLogFile()
	SetRequiredPosition()

	$repair = Random(3,9,1)

	$answer = MsgBox(0,"Smash Macro", "Mouse over the thing to smash with your axe or maul activated")
	Sleep(4000)

	While 1 = 1
		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(4000,7000,1)
		Else
			$wait = Random(1,1500,1)
		EndIf
		Sleep($wait)
		WaitForAction()
		$repair = $repair - 1
		If $repair = 0 Then
			Repair()
			$repair = Random(3,9,1)
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
	$answer = MsgBox(0,"Smash Macro","Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	Global $staminaPosition = MouseGetPos()
    Global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])

	$answer = MsgBox(0,"Smash Macro","Move your mouse cursor to your axe or maul")
	Sleep(4000)
	Global $pickaxePosition = MouseGetPos()
EndFunc

Func WaitForAction()
	Local $startPosition = MouseGetPos()
	MouseClick("right")
	Sleep(1000)
	MouseMove($startPosition[0] + 64, $startPosition[1] + 62, 10)
	Sleep(200)
	MouseClick("left")
	Sleep(3000)
	MouseMove($startPosition[0], $startPosition[1])
	$wait = 0
EndFunc

Func Repair()
	$targetPosition = MouseGetPos()
	MouseMove($pickaxePosition[0],$pickaxePosition[1],0)
	Sleep(200)
	Send($repair)
	Sleep(200)
	MouseMove($targetPosition[0],$targetPosition[1],0)
	Sleep(200)
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