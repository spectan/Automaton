#include <Misc.au3>
#include <Color.au3>

global $stamLoc
global $workLoc
global $tileLoc
global $stamLoc1
global $workLoc1
global $setStam=0
global $setWork=0
global $setStam1=0
global $setWork1=0
global $setTile=0
global $inProgress=0
global $count=0


HotKeySet("{z}", "SetPosition")
HotKeySet("!z", "SetPosition2")
HotKeySet("+z", "SetPosition3")
HotKeySet("{c}", "SetPosition4")
HotKeySet("!c", "SetPosition5")
HotKeySet("{x}", "ToggleMacro")
HotKeySet("{ESC}", "_Exit")

Func SetPosition()
   MsgBox(0, "", "Inventory")
   $setStam=1
EndFunc

Func SetPosition2()
   MsgBox(0, "", "Pile")
   $setWork=1
EndFunc

Func SetPosition3()
   MsgBox(0, "", "Tile")
   $setTile=1
EndFunc

Func SetPosition4()
   MsgBox(0, "", "Stamina")
   $setStam1=1
EndFunc

Func SetPosition5()
   MsgBox(0, "", "Action")
   $setWork1=1
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
   If _IsPressed("01") And $setTile==1 Then
	  $tileLoc = MouseGetPos()
	  $setTile=0
	  MsgBox(0, "", "Position set.")
   EndIf
   If _IsPressed("01") And $setWork1==1 Then
	  $workLoc1 = MouseGetPos()
	  $setWork1=0
	  MsgBox(0, "", "Position set.")
   EndIf
   If _IsPressed("01") And $setStam1==1 Then
	  $stamLoc1 = MouseGetPos()
	  $setStam1=0
	  MsgBox(0, "", "Position set.")
   EndIf
   If $inProgress Then
	  Local $sColor = _ColorGetGreen(PixelGetColor($stamLoc1[0], $stamLoc1[1]))
	  Local $wColor = _ColorGetBlue(PixelGetColor($workLoc1[0], $workLoc1[1]))
	  If $sColor >= 75 Then
		 If $wColor <= 50 Then
			MouseMove($tileLoc[0],$tileLoc[1])
			Send("!f")
		 EndIf
	  EndIf
	  MouseClickDrag("", $stamLoc[0], $stamLoc[1], $workLoc[0], $workLoc[1])
	  $count+=1
	  Sleep(5500)
   EndIf
WEnd

Func _Exit()
Exit
EndFunc   ;==>_Exit