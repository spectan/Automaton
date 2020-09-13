#include<Date.au3>

; this is a semi-automated macro for improving wooden items. It will not refill your food or thirst bar. If the macro beeps and opens a
; pop-up window, it means something is causing the macro to choke. Fix the problem, click OK on the window, and the macro will resume
; automatically. This macro can automatically improve a whole list of carpentry items in one go - it will simply move the mouse cursor down by one row of text
; if it fails too many improve attempts in a row, or if your log is too poor QL to improve the current item. Remember that the macro will always improve whichever
; item you are currently mousing over

; set $noToolbelt to False if you have a QL60+ toolbelt equipped, and make sure you have a mallet in slot 1,
; a carving knife in slot 2, a file in slot 3, a pelt in slot 4, and a log or stack of logs in slot 5.
; If you don't have a toolbelt of the required quality, the macro will prompt for the locations of each tool in your inventory instead
$noToolbelt = True

; make sure you have keybinds defined for the following actions and change the values according to your preference
$improve = "i"
$repair = "r"
$activate = "b"
$examine = "o"
$stop = "p"

; these are used to randomly generate the failure tolerance for improving each item. The macro will keep improving the same item until either
; it fails more times in a row than the current tolerance setting, or until it is unable to improve the item with your log QL
$minTolerance = 4
$maxTolerance = 6

; set your in-game user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

CarpentryImprovement()

Func CarpentryImprovement()
	global $damage = 0
	global $wait = 0
	global $tolerance = Random($minTolerance,$maxTolerance,1)
	OpenLogFile()
	SetRequiredPosition()
	If $noToolbelt = True Then
		SetOptionalPosition()
	EndIf

	$answer = MsgBox(0,"Carpentry Improvement Macro", "Mouse over the item to be improved and select the proper improvement tool")
	Sleep(4000)

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
	Global $logFile = FileOpen($fileName,0)
	If $logFile = -1 Then
		MsgBox(0, "Error","Unable to open file. Terminating script.")
		Exit
	EndIf
EndFunc

Func SetOptionalPosition()
	$answer = MsgBox(0,"Carpentry Improvement Macro","2. Move your mouse cursor to your mallet")
	Sleep(4000)
	Global $itemPosition1 = MouseGetPos()
	$answer = MsgBox(0,"Carpentry Improvement Macro","3. Move your mouse cursor to your carving knife")
	Sleep(4000)
	Global $itemPosition2 = MouseGetPos()
	$answer = MsgBox(0,"Carpentry Improvement Macro","4. Move your mouse cursor to your file")
	Sleep(4000)
	Global $itemPosition3 = MouseGetPos()
	$answer = MsgBox(0,"Carpentry Improvement Macro","5. Move your mouse cursor to your pelt.")
	Sleep(4000)
	Global $itemPosition4 = MouseGetPos()
	$answer = MsgBox(0,"Carpentry Improvement Macro","6. Move your mouse cursor to your log.")
	Sleep(4000)
	Global $itemPosition5 = MouseGetPos()
EndFunc

Func SetRequiredPosition()
	$answer = MsgBox(0,"Carpentry Improvement Macro","1. Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	Global $staminaPosition = MouseGetPos()
	Global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])
EndFunc

Func WaitForAction()
	$done = False
	Local $result = FileSetPos($logFile,0,$FILE_END)
	Send($improve)
	Sleep(3000)
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
				MouseMove($targetPosition[0],$targetPosition[1]+16,10)
				Sleep(200)
				Send($examine)
				$done = false
				$damage = 0
				$tolerance = Random($minTolerance,$maxTolerance,1)
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
			send($stop)
			Sleep(100)
			$targetPosition = MouseGetPos()
			MouseMove($targetPosition[0],$targetPosition[1]+16,10)
			Sleep(2000)
			FileSetPos($logFile,0,$FILE_END)
			Send($examine)
			$damage = 0
			$tolerance = Random($minTolerance,$maxTolerance,1)
			Sleep(80)
		 ElseIf StringInStr($line,"before you try") > 0 Then
			Send($repair)
			Send($improve)
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
				MsgBox(0,"Carpentry Improvement Macro","Your stamina appears to have stopped regenerating.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc