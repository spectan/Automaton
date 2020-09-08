#include <Misc.au3>
#include <Color.au3>

global $stamLoc
global $workLoc
global $chestLoc
global $invLoc
global $setStam=0
global $setWork=0
global $setChest=0
global $setInv=0
global $inProgress=0

HotKeySet("{z}", "SetPosition")
HotKeySet("!z", "SetPosition2")
HotKeySet("+z", "SetPosition3")
HotKeySet("{c}", "SetPosition4")
HotKeySet("{x}", "ToggleMacro")
HotKeySet("{ESC}", "_Exit")

Func SetPosition()
   MsgBox(0, "", "Action")
   $setWork=1
EndFunc

Func SetPosition2()
   MsgBox(0, "", "Stamina")
   $setStam=1
EndFunc

Func SetPosition3()
   MsgBox(0, "", "Inventory")
   $setInv=1
EndFunc

Func SetPosition4()
   MsgBox(0, "", "Chest")
   $setChest=1
EndFunc

Func ToggleMacro()
   If $inProgress==1 Then
	  $inProgress=0
	  ;TrayTip("", "Macro stopped", 5)
   ElseIf $inProgress==0 Then
	  $inProgress=1
	  ;TrayTip("", "Macro started", 5)
   EndIf
EndFunc

While 1
   If _IsPressed("01") And $setStam==1 Then
	  $stamLoc = MouseGetPos()
	  $setStam=0
	  MsgBox(0, "", "Position set.")
   EndIf
   If _IsPressed("01") And $setWork==1 Then
	  $workLoc = MouseGetPos()
	  $setWork=0
	  MsgBox(0, "", "Position set.")
   EndIf
   If _IsPressed("01") And $setInv==1 Then
	  $invLoc = MouseGetPos()
	  $setInv=0
	  MsgBox(0, "", "Position set.")
   EndIf
   If _IsPressed("01") And $setChest==1 Then
	  $chestLoc = MouseGetPos()
	  $setChest=0
	  MsgBox(0, "", "Position set.")
   EndIf
   If $inProgress Then
	  Local $sColor = _ColorGetGreen(PixelGetColor($stamLoc[0], $stamLoc[1]))
	  Local $wColor = _ColorGetBlue(PixelGetColor($workLoc[0], $workLoc[1]))
	  If $sColor >= 75 Then
		 If $wColor <= 50 Then
			MouseClick("left",$invLoc[0],$invLoc[1],2,10)
			MouseClick("right",$chestLoc[0],$chestLoc[1])
			Sleep(250)
			MouseClick("left",$chestLoc[0]+20,$chestLoc[1]+60)
		 EndIf
	  EndIf
	  Sleep(750)
   EndIf
WEnd

Func _Exit()
Exit
EndFunc   ;==>_Exit