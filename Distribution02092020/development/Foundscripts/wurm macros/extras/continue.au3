#include <Misc.au3>
#include <Color.au3>

global $pollRate = 1000

;DONT CHANGE THESE
global $stamLoc
global $workLoc
global $buttonLoc
global $invLoc
global $BSBLoc
global $CISLoc
global $CSLoc
global $comLoc
global $count=0
global $setStam=0
global $setInv=0
global $setBSB=0
global $setCIS=0
global $setCS=0
global $setCom=0
global $count=0
global $setWork=0
global $setButton=0
global $inProgress=0
;

HotKeySet("{z}", "SetPosition")
HotKeySet("!z", "SetPosition1")
HotKeySet("+z", "SetPosition2")
HotKeySet("{c}", "SetPosition3")
HotKeySet("!c", "SetPosition4")
HotKeySet("+c", "SetPosition5")
HotKeySet("{x}", "ToggleMacro")
HotKeySet("{ESC}", "_Exit")

Func ToggleMacro()
   If $inProgress==1 Then
	  $inProgress=0
	  ;TrayTip("", "Macro stopped", 5)
   ElseIf $inProgress==0 Then
	  $inProgress=1
	  ;TrayTip("", "Macro started", 5)
   EndIf
EndFunc

Func SetPosition()
   MsgBox(0, "", "Hold click slightly before the right edge of your stamina bar, in the middle.")
   $setStam=1
EndFunc
Func SetPosition1()
   MsgBox(0, "", "Source Material")
   $setInv=1
EndFunc
Func SetPosition2()
   MsgBox(0, "", "BSB")
   $setBSB=1
EndFunc
Func SetPosition3()
   MsgBox(0, "", "Creation Item Stack")
   $setCIS=1
EndFunc
Func SetPosition4()
   MsgBox(0, "", "Crafting Square")
   $setCS=1
EndFunc
Func SetPosition5()
   MsgBox(0, "", "Combine")
   $setCom=1
EndFunc

While 1
    If _IsPressed("01") And $setStam==1 Then
		$stamLoc = MouseGetPos()
		$setStam=0
		$setWork=1
		MsgBox(0, "", "Position set. Now hold click slightly before the left edge of your action timber bar, in the middle.")
	 EndIf
    If _IsPressed("01") And $setWork==1 Then
		$workLoc = MouseGetPos()
		$setWork=0
		$setButton=1
		MsgBox(0, "", "Position set. Now hold click your continue/create button.")
	 EndIf
    If _IsPressed("01") And $setButton==1 Then
		$buttonLoc = MouseGetPos()
		$setButton=0
		MsgBox(0, "", "Position set. Press alt Z")
	 EndIf
    If _IsPressed("01") And $setInv==1 Then
		$invLoc = MouseGetPos()
		$setInv=0
		MsgBox(0, "", "Position set. Press shift Z")
	 EndIf
    If _IsPressed("01") And $setBSB==1 Then
		$BSBLoc = MouseGetPos()
		$setBSB=0
		MsgBox(0, "", "Position set. Press C")
	 EndIf
    If _IsPressed("01") And $setCIS==1 Then
		$CISLoc = MouseGetPos()
		$setCIS=0
		MsgBox(0, "", "Position set. Press alt C")
	 EndIf
    If _IsPressed("01") And $setCS==1 Then
		$CSLoc = MouseGetPos()
		$setCS=0
		MsgBox(0, "", "Position set. Press shift C")
	 EndIf
    If _IsPressed("01") And $setCom==1 Then
		$comLoc = MouseGetPos()
		$setCom=0
		MsgBox(0, "", "Position set. Ready to macro (Press X)")
	 EndIf
	 Sleep($pollRate)
   If $inProgress Then
	  Local $sColor = _ColorGetGreen(PixelGetColor($stamLoc[0], $stamLoc[1]))
	  Local $wColor = _ColorGetBlue(PixelGetColor($workLoc[0], $workLoc[1]))
	 If $sColor >= 75 Then
		 If $wColor <= 50 Then
			If $count>=60 Then
			   MouseClickDrag("", $CISLoc[0], $CISLoc[1], $BSBLoc[0], $BSBLoc[1])
			   Sleep(250)
			   MouseClickDrag("", $invLoc[0], $invLoc[1], $BSBLoc[0], $BSBLoc[1])
			   Sleep(250)
			   MouseClickDrag("", $BSBLoc[0], $BSBLoc[1], $invLoc[0], $invLoc[1])
			   Sleep(1000)
			   Send("40") ;amount you want to pull from bsb
			   Send("{ENTER}")
			   Sleep(500)
			   MouseClickDrag("", $invLoc[0], $invLoc[1], $CSLoc[0], $CSLoc[1])
			;  MouseMove($comLoc[0], $comLoc[1])
			;  Sleep(250)
			;  MouseClick("")
			;  Sleep(1000)
			  $count=0
			EndIf
		   MouseMove($buttonLoc[0], $buttonLoc[1])
		   MouseClick("")
		   If Mod($count,10) = 0 And $count>0 Then
			   MouseClickDrag("", $CISLoc[0], $CISLoc[1], $BSBLoc[0], $BSBLoc[1])
			EndIf
			$count+=1
		 EndIf
	 EndIf
   EndIf
WEnd

Func _Exit()
Exit
EndFunc   ;==>_Exit