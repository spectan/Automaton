#include<Date.au3>

; this is a fully-automated macro for improving smithing items. This macro can automatically improve a whole list of metal items in one go - it will simply move the mouse cursor down by one row of text
; if it fails too many improve attempts in a row, or if your lump is too poor QL to improve the current item. Remember that the macro will always improve whichever item you are currently
; mousing over, so you can manually move the mouse to improve different items while the macro is still running. This macro will cycle out your iron lumps
; automatically when they cool down, and will examine the forge periodically and fuel it automatically when it gets low on fuel. This macro will
; also automatically eat and drink, but it's a little unreliable and may require tweaking some of the definitions. This macro wil begin by eating, drinking, and refueling the forge, so make sure it's able
; to do all 3 of these tasks first before you go AFK. Tweak the foodOffset, waterOffset, and burnOffset definitions if the macro is selecting the wrong options from the right-click menu

; this macro is a little complicated to set up, but when done properly it can run for several hours without any user input.
; 1. Keep a small barrel full of water in your inventory. Buckets are too small and will run out quickly
; 2. Put a big stack of woodscraps in your inventory. I recommend reorganizing your inventory so that your woodscraps are the 2nd to last item listed. I also recommend combining the scraps into units of about 10kg
; 3. Make sure you have a stack of heated metal lumps visible in your forge window. When the lump in your inventory cools down it will be dropped in the forge and the first lump in the forge will be picked up to replace it
; 4. Make sure all the items you want to improve are listed together in the forge window. I recommend ordering them before the iron lumps you'll use for improving

; make sure you have binds set for IMPROVE, REPAIR, and ACTIVATE using the appropriate keys
$improve = "i"
$repair = "r"
$activate = "b"
$examine = "o"
$stop = "p"

; these are used to randomly generate the failure tolerance for improving each item. The macro will keep improving the same item until either
; it fails more times in a row than the current tolerance setting, or until it is unable to improve the item with your iron lump, at which point
; the mouse cursor will move down by a row of text and the macro will continue improving the new item.
$minTolerance = 4
$maxTolerance = 5

; these values control which rows of the right-click menus will be clicked on when attempt to automatically eat and drink and refuel the forge.
; if the macro is clicking the "rename" command instead of the "eat" or "drink" command then you will need to tweak these
; values until it works. Owning a pet will mess with the number of options on the right-click menus and probably require
; you to change these values
$foodOffset = 5
$waterOffset = 6
$burnOffset = 8

; set your in-game user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

ForgeGod()

Func ForgeGod()
	global $damage = 0
	global $wait = 0
	global $tolerance = Random($minTolerance,$maxTolerance,1)
	global $fuelCheck = Random(20,40,1)
	global $recheck = True
	OpenLogFile()
	SetRequiredPosition()

	$answer = MsgBox(0,"Forge God Macro", "Mouse over the item to be improved and select the proper improvement tool")
	Sleep(4000)

	Eat()
	CheckForgeFuel()

	While 1 = 1
		WaitForAction()
		WaitForStamina()

		$fuelCheck = $fuelCheck - 1
		If $fuelCheck = 0 Then
		    CheckForgeFuel()
	    EndIf

		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(3000,6000,1)
		Else
			$wait = Random(200,1300,1)
		EndIf
		Sleep($wait)
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

Func SetRequiredPosition()
	$answer = MsgBox(0,"Forge God Macro","1. Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	Global $staminaPosition = MouseGetPos()
	global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])

	$answer = MsgBox(0,"Forge God Macro","2. Move your mouse cursor to your food.")
	Sleep(4000)
	Global $foodPosition = MouseGetPos()

    $answer = MsgBox(0,"Forge God Macro","3. Move your mouse cursor to your hammer.")
	Sleep(4000)
	Global $itemPosition1 = MouseGetPos()

	$answer = MsgBox(0,"Forge God Macro","4. Move your mouse cursor to your whetstone.")
	Sleep(4000)
	Global $itemPosition2 = MouseGetPos()

	$answer = MsgBox(0,"Forge God Macro","5. Move your mouse cursor to your water.")
	Sleep(4000)
	Global $itemPosition3 = MouseGetPos()

	$answer = MsgBox(0,"Forge God Macro","6. Move your mouse cursor to your pelt.")
	Sleep(4000)
	Global $itemPosition4 = MouseGetPos()

	$answer = MsgBox(0,"Forge God Macro","7. Move your mouse cursor to your iron lump.")
	Sleep(4000)
	Global $itemPosition5 = MouseGetPos()

    $answer = MsgBox(0,"Forge God Macro","8. Move your mouse cursor to the first iron lump in your forge.")
	Sleep(4000)
	Global $lumpDepotPosition = MouseGetPos()

    $answer = MsgBox(0,"Forge God Macro","9. Move your mouse cursor to your fuel stack.")
	Sleep(4000)
	Global $fuelPosition = MouseGetPos()

	$answer = MsgBox(0,"Forge God Macro","10. Move your mouse cursor to your forge.")
	Sleep(4000)
	Global $forgePosition = MouseGetPos()
EndFunc

Func WaitForAction()
	$done = False
	Local $result = FileSetPos($logFile,0,$FILE_END)
	If $recheck Then
	   Send($examine)
	   $recheck = False
    Else
	   Send($improve)
    EndIf
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
		ElseIf StringInStr($line,"by a hammer") > 0 Then
			$done = True
			$damage = 0

			 $targetPosition = MouseGetPos()
			 MouseMove($itemPosition1[0],$itemPosition1[1],0)
			 Sleep(50)
			 Send($activate)
			 MouseMove($targetPosition[0],$targetPosition[1],0)
			 Sleep(50)
		ElseIf StringInStr($line,"with a whetstone") > 0 Then
			$done = True
			$damage = 0

			 $targetPosition = MouseGetPos()
			 MouseMove($itemPosition2[0],$itemPosition2[1],0)
			 Sleep(50)
			 Send($activate)
			 MouseMove($targetPosition[0],$targetPosition[1],0)
			 Sleep(50)
		ElseIf StringInStr($line,"dipping it in water") > 0 Then
			$done = True
			$damage = 0

			 $targetPosition = MouseGetPos()
			 MouseMove($itemPosition3[0],$itemPosition3[1],0)
			 Sleep(50)
			 Send($activate)
			 MouseMove($targetPosition[0],$targetPosition[1],0)
			 Sleep(50)
		ElseIf StringInStr($line,"with a pelt") > 0 Then
			$done = True
			$damage = 0

			 $targetPosition = MouseGetPos()
			 MouseMove($itemPosition4[0],$itemPosition4[1],0)
			 Sleep(50)
			 Send($activate)
			 MouseMove($targetPosition[0],$targetPosition[1],0)
			 Sleep(50)
		ElseIf StringInStr($line,"with a lump") > 0 Then
			$done = True
			$damage = 0

			 $targetPosition = MouseGetPos()
			 MouseMove($itemPosition5[0],$itemPosition5[1],0)
			 Sleep(50)
			 Send($activate)
			 MouseMove($targetPosition[0],$targetPosition[1],0)
			 Sleep(50)
		ElseIf StringInStr($line,"some more lump") > 0 Then
			$done = True
			$damage = 0

			 $targetPosition = MouseGetPos()
			 MouseMove($itemPosition5[0],$itemPosition5[1],0)
			 Sleep(50)
			 Send($activate)
			 MouseMove($targetPosition[0],$targetPosition[1],0)
			 Sleep(50)
		ElseIf StringInStr($line,"be glowing hot") > 0 Then
			GetNewLump()
			$done = True
		ElseIf StringInStr($line,"need more water") > 0 Then
			Beep()
			MsgBox(0,"Forge God Macro","You've run out of water for tempering.")
			$done = True
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
			Sleep(1000)
			Send($improve)
			Sleep(80)
		ElseIf StringInStr($line,"cannot improve") > 0 Then
			Send($examine)
			Sleep(80)
		Else
			$wait = $wait + 1
			If $wait > 800 Then
				Send($examine)
			    Sleep(80)
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc

Func GetNewLump()
    $targetPosition = MouseGetPos()
	MouseMove($itemPosition5[0], $itemPosition5[1], 10)
	Sleep(1000)
	MouseClickDrag("left", $itemPosition5[0], $itemPosition5[1], $lumpDepotPosition[0], $lumpDepotPosition[1], 10)
	Sleep(2000)
	MouseClickDrag("left", $lumpDepotPosition[0], $lumpDepotPosition[1], $itemPosition5[0], $itemPosition5[1], 10)
	Sleep(2000)
	Send($activate)
	Sleep(1000)
	MouseMove($targetPosition[0], $targetPosition[1], 10)
EndFunc

Func CheckForgeFuel()
    $done = False
	Local $result = FileSetPos($logFile,0,$FILE_END)
	$targetPosition = MouseGetPos()
	MouseMove($forgePosition[0],$forgePosition[1],10)
	Sleep(2000)
	Send($examine)
	Sleep(2000)
	$wait = 0
	While $done = False
		Sleep(40)
		$line = FileReadLine($logFile)
		If StringInStr($line,"burns steadily") > 0 Then
		    $fuelCheck = Random(20, 40, 1)
			$done = True
		 ElseIf StringInStr($line,"with wild flames") > 0 Then
			$fuelCheck = Random(10, 20, 1)
			$done = True
		 ElseIf StringInStr($line,"starting to fade") > 0 Then
			MouseMove($fuelPosition[0],$fuelPosition[1],10)
			Sleep(1000)
			Send($activate)
			Sleep(1000)

			MouseMove($forgePosition[0],$forgePosition[1],10)
			Sleep(2000)
			MouseClick("right")
			Sleep(1000)
			local $currentPosition = MouseGetPos()
			MouseMove($currentPosition[0] + 40, $currentPosition[1] + 8 + 16 * $burnOffset, 10)
			Sleep(1000)
			MouseClick("left")
			Sleep(1000)

			$fuelCheck = 1
			$done = True
	    ElseIf StringInStr($line,"few flames still") > 0 Then
			MouseMove($fuelPosition[0],$fuelPosition[1],10)
			Sleep(1000)
			Send($activate)
			Sleep(1000)

			MouseMove($forgePosition[0],$forgePosition[1],10)
			Sleep(2000)
			MouseClick("right")
			Sleep(1000)
			local $currentPosition = MouseGetPos()
			MouseMove($currentPosition[0] + 40, $currentPosition[1] + 8 + 16 * $burnOffset, 10)
			Sleep(1000)
			MouseClick("left")
			Sleep(1000)

			$fuelCheck = 1
			$done = True
	    ElseIf StringInStr($line,"glowing coals") > 0 Then
			MouseMove($fuelPosition[0],$fuelPosition[1],10)
			Sleep(1000)
			Send($activate)
			Sleep(1000)

			MouseMove($forgePosition[0],$forgePosition[1],10)
			Sleep(2000)
			MouseClick("right")
			Sleep(1000)
			local $currentPosition = MouseGetPos()
			MouseMove($currentPosition[0] + 40, $currentPosition[1] + 8 + 16 * $burnOffset, 10)
			Sleep(1000)
			MouseClick("left")
			Sleep(1000)

			$fuelCheck = 1
			$done = True
		EndIf
	 WEnd

	 MouseMove($targetPosition[0],$targetPosition[1],10)
	 Sleep(1000)
	 MouseClick("left")
     Sleep(100)
	 $recheck = True
EndFunc

Func Eat()
	$targetPosition = MouseGetPos()

	MouseMove($foodPosition[0], $foodPosition[1])
	MouseClick("right")
	$wait = Random(2000,4000,1)
	Sleep ($wait)
	MouseMove($foodPosition[0] + 40, $foodPosition[1] + 16 * $foodOffset)
	$wait = Random(500,2000,1)
	Sleep ($wait)
	MouseClick("left")
    Sleep(3000)
	Send("{Enter}")
	Sleep(1000)
	MouseClick("left")
	Sleep(100)

	MouseMove($itemPosition3[0], $itemPosition3[1])
	MouseClick("right")
	$wait = Random(2000,4000,1)
	Sleep ($wait)
	MouseMove($itemPosition3[0] + 40, $itemPosition3[1] + 16 * $waterOffset)
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
			If $wait > 20 Then
				Eat()
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc