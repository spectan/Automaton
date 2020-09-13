#include<Date.au3>

; this is a semi-automated macro for improving smithing items. It will not refill your food or thirst bar, reheat metal lumps,
; or change improvement targets on its own. If the macro beeps and opens a pop-up window, it means something is causing the macro
; to choke. Fix the problem, click OK on the window, and the macro will resume automatically. If it beeps without a window, then
; you're failing to improve the same item multiple times in a row, and should probably change improvement targets to something of
;  lower QL. Remember that the macro will always improve whichever item you are currently mousing over

; set $noToolbelt to False if you have a QL60+ toolbelt equipped, and make sure you have a mallet in slot 1,
; a leather knife in slot 2, a needle in slot 3, a awl in slot 4, and leather in slot 5.
; If you don't have a toolbelt of the required quality, the macro will prompt for the locations of each tool in your inventory instead
$noToolbelt = True

; make sure you have binds set for IMPROVE, REPAIR, and ACTIVATE using the appropriate keys
$improve = "i"
$repair = "r"
$activate = "b"
$examine = "o"
$stop = "p"

; these are used to randomly generate the failure tolerance for improving each item. The macro will keep improving the same item until either
; it fails more times in a row than the current tolerance setting, or until it is unable to improve the item with your iron lump
$minTolerance = 4
$maxTolerance = 5

; set your user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

LeatherImprovement()

Func LeatherImprovement()
	global $damage = 0
	global $wait = 0
	global $tolerance = Random($minTolerance,$maxTolerance,1)
	OpenLogFile()
	SetRequiredPosition()
	If $noToolbelt = True Then
		SetOptionalPosition()
	EndIf

	$answer = MsgBox(0,"Cloth Tailoring Macro", "Mouse over the item to be improved and select the proper improvement tool")
	Sleep(4000)

	While 1 = 1
		WaitForStamina()
		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(3000,6000,1)
		Else
			$wait = Random(500,1300,1)
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
	$answer = MsgBox(0,"Cloth Tailoring Macro","Move your mouse cursor to your scissors")
	Sleep(4000)
	Global $itemPosition1 = MouseGetPos()
	$answer = MsgBox(0,"Cloth Tailoring Macro","Move your mouse cursor to your needle.")
	Sleep(4000)
	Global $itemPosition2 = MouseGetPos()
	$answer = MsgBox(0,"Cloth Tailoring Macro","Move your mouse cursor to your water.")
	Sleep(4000)
	Global $itemPosition3 = MouseGetPos()
	$answer = MsgBox(0,"Cloth Tailoring Macro","Move your mouse cursor to your cloth string")
	Sleep(4000)
	Global $itemPosition4 = MouseGetPos()
EndFunc

Func SetRequiredPosition()
	$answer = MsgBox(0,"Cloth Tailoring Macro","Move your mouse cursor to the rightmost edge of your stamina bar.")
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
				MouseMove($targetPosition[0],$targetPosition[1]+16,0)
				Sleep(80)
				Send($examine)
				$done = false
				$damage = 0
				$tolerance = Random($minTolerance,$maxTolerance,1)
				Sleep(80)
			EndIf
		ElseIf StringInStr($line,"with a scissors") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("1")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition1[0],$itemPosition1[1],0)
				Sleep(80)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(80)
			EndIf
		ElseIf StringInStr($line,"with an iron needle") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("2")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition2[0],$itemPosition2[1],0)
				Sleep(80)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(80)
			EndIf
		ElseIf StringInStr($line,"must be washed") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("3")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition3[0],$itemPosition3[1],0)
				Sleep(80)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(80)
			EndIf
		ElseIf StringInStr($line,"with a string") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("4")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition4[0],$itemPosition4[1],0)
				Sleep(80)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(80)
			EndIf
		ElseIf StringInStr($line,"some more string") > 0 Then
			$done = True
			$damage = 0
			If $noToolbelt = False Then
				Send("4")
			Else
				$targetPosition = MouseGetPos()
				MouseMove($itemPosition4[0],$itemPosition4[1],0)
				Sleep(80)
				Send($activate)
				MouseMove($targetPosition[0],$targetPosition[1],0)
				Sleep(80)
			EndIf
		ElseIf StringInStr($line,"too poor shape") > 0 Then
			$targetPosition = MouseGetPos()
			MouseMove($targetPosition[0],$targetPosition[1]+16,0)
			Sleep(80)
			Send($examine)
			$damage = 0
			$tolerance = Random($minTolerance,$maxTolerance,1)
			Sleep(80)
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
			Sleep(3000)
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
				MsgBox(0,"Cloth Tailoring Macro","Your last action doesn't seem to be executing.")
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
				MsgBox(0,"Cloth Tailoring Macro","Your stamina appears to have stopped regenerating.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc