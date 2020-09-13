#include<Date.au3>

; this is a semi-automated macro for improving smithing items. It will not refill your food or thirst bar, reheat metal lumps,
; or change improvement targets on its own. If the macro beeps and opens a pop-up window, it means something is causing the macro
; to choke. Fix the problem, click OK on the window, and the macro will resume automatically. If it beeps without a window, then
; you're failing to improve the same item multiple times in a row, and should probably change improvement targets to something of
;  lower QL. Remember that the macro will always improve whichever item you are currently mousing over

; set $noToolbelt to False if you have a QL60+ toolbelt equipped, and make sure you have a hammer in slot 1,
; a whetstone in slot 2, a source of water in slot 3, a pelt in slot 4, and a glowing hot metal lump in slot 5.
; If you don't have a toolbelt of the required quality, the macro will prompt for the locations of each tool in your inventory instead
$noToolbelt = True

; make sure you have binds set for IMPROVE, REPAIR, and ACTIVATE using the appropriate keys
$improve = "i"
$repair = "r"
$activate = "b"
$examine = "o"
$stop = "p"

; set your user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

WarDoll()

Func WarDoll()
   global $damage = 0
   global $wait = 0
   global $tolerance = Random(3,4,1)
   OpenLogFile()
   SetRequiredPosition()
   If $noToolbelt = True Then
	  SetOptionalPosition()
   EndIf

   $answer = MsgBox(0,"War Doll Macro", "Mouse over the item to be improved and select the proper improvement tool")
   Sleep(4000)

   global $didTheWarDoll = False
   While 1 = 1

	  $damage = 0
	  While $damage < $tolerance
		 WaitForStamina()
		 $wait = Random(0,12,1)
		 If $wait = 12 Then
			$wait = Random(3000,6000,1)
		 Else
			$wait = Random(200,1300,1)
		 EndIf
		 Sleep($wait)
		 ImproveAndRepair()
		 $didTheWarDoll = False
	  WEnd

	  $targetPosition = MouseGetPos()
	  MouseMove($itemPosition1[0],$itemPosition1[1],0)
	  Sleep(50)
	  Send($activate)
	  MouseMove($targetPosition[0],$targetPosition[1],0)
	  Sleep(50)

	  $practiceCount = 0
	  $maxPracticeCount = Random(4,8,1)
	  while $practiceCount < $maxPracticeCount
		 DoTheWarDoll()
		 WaitForStamina()
		 $practiceCount = $practiceCount + 1
	  WEnd
	  $didTheWarDoll = True

   WEnd

	FileClose($logFile)
EndFunc

Func OpenLogFile()
	$fileName = $wurmPath & "\players\" & $userName & "\test_logs\_Event." & @YEAR & "-" & @MON & ".txt"
	Global $logFile = FileOpen($fileName,0)
	If $logFile = -1 Then
		MsgBox(0, "Error","Unable to open file. Terminating script.")
		Exit
	EndIf
EndFunc

Func SetOptionalPosition()
	$answer = MsgBox(0,"Carpentry Improvement Macro","Move your mouse cursor to your mallet")
	Sleep(4000)
	Global $itemPosition1 = MouseGetPos()
	$answer = MsgBox(0,"Carpentry Improvement Macro","Move your mouse cursor to your carving knife")
	Sleep(4000)
	Global $itemPosition2 = MouseGetPos()
	$answer = MsgBox(0,"Carpentry Improvement Macro","Move your mouse cursor to your file")
	Sleep(4000)
	Global $itemPosition3 = MouseGetPos()
	$answer = MsgBox(0,"Carpentry Improvement Macro","Move your mouse cursor to your pelt.")
	Sleep(4000)
	Global $itemPosition4 = MouseGetPos()
	$answer = MsgBox(0,"Carpentry Improvement Macro","Move your mouse cursor to your log.")
	Sleep(4000)
	Global $itemPosition5 = MouseGetPos()
EndFunc

Func SetRequiredPosition()
	$answer = MsgBox(0,"War Doll Macro","Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	Global $staminaPosition = MouseGetPos()
	global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])

    $answer = MsgBox(0,"War Doll Macro","Move your mouse cursor over your weapon.")
	Sleep(4000)
	Global $weaponPosition = MouseGetPos()

	$answer = MsgBox(0,"Mining Macro","Move your mouse cursor to your water.")
	Sleep(4000)
	Global $waterPosition = MouseGetPos()
	$answer = MsgBox(0,"Mining Macro","Move your mouse cursor to your food.")
	Sleep(4000)
	Global $foodPosition = MouseGetPos()
EndFunc

Func ImproveAndRepair()
	$done = False
	Local $result = FileSetPos($logFile,0,$FILE_END)
	if $didTheWarDoll > 0 Then
		Send("examine")
	Else
		Send($improve)
	EndIf
	Sleep(3000)
	$wait = 0
	$damage = 0
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
				$tolerance = Random(3,4,1)
				Sleep(50)
			EndIf
		ElseIf StringInStr($line,"use a mallet") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("1")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition1[0],$itemPosition1[1],0)
				Sleep(50)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(50)
			EndIf
		ElseIf StringInStr($line,"notches") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("2")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition2[0],$itemPosition2[1],0)
				Sleep(50)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(50)
			EndIf
		ElseIf StringInStr($line,"use a file") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("3")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition3[0],$itemPosition3[1],0)
				Sleep(50)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(50)
			EndIf
		ElseIf StringInStr($line,"with a pelt") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("4")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition4[0],$itemPosition4[1],0)
				Sleep(50)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(50)
			EndIf
		ElseIf StringInStr($line,"with a log") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("5")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition5[0],$itemPosition5[1],0)
				Sleep(50)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(50)
			EndIf
		ElseIf StringInStr($line,"some more log") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("5")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition5[0],$itemPosition5[1],0)
				Sleep(50)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(50)
			EndIf
		ElseIf StringInStr($line,"too poor shape") > 0 Then
			$done = True
			$damage = 420
			Sleep(50)
	    ElseIf StringInStr($line,"already") > 0 Then
			Send($examine)
			Sleep(80)
	    ElseIf StringInStr($line,"before you try") > 0 Then
			Send($repair)
			Sleep(10000)
			Send($examine)
		ElseIf StringInStr($line,"cannot improve") > 0 Then
			Send($examine)
			Sleep(80)
		Else
			$wait = $wait + 1
			If $wait > 800 Then
				Beep()
				MsgBox(0,"Carpentry Improvement Macro","Your last action doesn't seem to be executing.")
				$wait = 0
			EndIf
		EndIf
	WEnd
 EndFunc

Func DoTheWarDoll()
   $targetPosition = MouseGetPos()
   MouseClick("right")
   Local $wait = Random(100,600,1)
   Sleep ($wait)
   MouseMove($targetPosition[0]+48,$targetPosition[1]+122,0)
   Sleep(500)
   Local $result = FileSetPos($logFile,0,$FILE_END)
   Sleep(120)
   MouseClick("left")
   Sleep(1000)
   Send("{Enter}")
   Sleep(2000)
   MouseClick("left")
   MouseMove($targetPosition[0],$targetPosition[1],10)

   $wait = 0
   $begun = False
   While $begun = False
	  Sleep(40)
	  $line = FileReadLine($logFile)
	  If StringInStr($line,"You try to") > 0 Then
		 $begun = True
	  ElseIf StringInStr($line,"far") > 0 Then
		 Beep()
		 MsgBox(0,"War Doll Macro","You are too far away from the doll.")
	  Else
		 $wait = $wait + 1
		 If $wait > 200 Then
			$targetPosition = MouseGetPos()
			MouseClick("right")
			$wait = Random(100,500,1)
			Sleep ($wait)
			MouseMove($targetPosition[0]+48,$targetPosition[1]+122,0)
			Sleep(120)
			Local $result = FileSetPos($logFile,0,$FILE_END)
			Sleep(60)
			MouseClick("left")
			Sleep(1000)
		    Send("{Enter}")
		    Sleep(2000)
		    MouseClick("left")
			MouseMove($targetPosition[0],$targetPosition[1],10)
			$wait = 0
		 EndIf
	  EndIf
   WEnd

   Local $damaged = False
   While $damaged = False
	  $done = False
	  Local $result = FileSetPos($logFile,0,$FILE_END)
	  While $done = False
		 Sleep(40)
		 $line = FileReadLine($logFile)
		 If StringInStr($line,"You cut a") > 0 Then
			$done = True
		 EndIf
	  WEnd

	  $wait = Random(200,800,1)
	  Sleep ($wait)
	  Local $result = FileSetPos($logFile,0,$FILE_END)
	  Send($examine)

	  $examinedOkay = False
	  While $examinedOkay = False
		 Sleep(40)
		 $line = FileReadLine($logFile)
		 If StringInStr($line,"mansized") > 0 Then
			$examinedOkay = True
			$line = StringTrimRight($line,1)
			Local $examineStrings = StringSplit($line,":")
			If StringIsFloat($examineStrings[5]) < 1 Then
			   If $examineStrings[5] > 40.1 Then
				  $damaged = True
			   EndIf
			EndIf
		 EndIf
	  WEnd
   WEnd

   Sleep(40)
   Send($stop)
   $wait = Random(200,800,1)
   Sleep ($wait)
   Send($repair)
   $wait = Random(200,800,1)
   Sleep ($wait)
   $targetPosition = MouseGetPos()
   MouseMove($weaponPosition[0],$weaponPosition[1],0)
   Sleep(50)
   Send($repair)
   MouseMove($targetPosition[0],$targetPosition[1],0)
   Sleep(50)

   Local $result = FileSetPos($logFile,0,$FILE_END)
   Sleep(60)
   $wait = 0
   $begun = False
   While $begun = False
	  Sleep(40)
	  $line = FileReadLine($logFile)
	  If StringInStr($line,"You repair") > 0 Then
		 $begun = True
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
				Sleep(10000)
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc