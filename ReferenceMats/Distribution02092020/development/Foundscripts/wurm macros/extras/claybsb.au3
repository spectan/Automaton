#include <Misc.au3>
#include <Color.au3>

global $pollRate = 1000

;DONT CHANGE THESE
global $loc[10]
global $bools[5]
global $count=0
global $inProgress=0
;

HotKeySet("{z}", "SetPosition")
HotKeySet("+z", "SetTile")
HotKeySet("!z", "SetBSB")
HotKeySet("^z", "SetInv")
HotKeySet("{x}", "ToggleMacro")
HotKeySet("{ESC}", "_Exit")

Func LoadSavedConfig()
   $loc[0] = IniRead("positions.ini", "positions", "stamX", -1)
   $loc[1] = IniRead("positions.ini", "positions", "stamY", -1)

   $loc[2] = IniRead("positions.ini", "positions", "actionX", -1)
   $loc[3] = IniRead("positions.ini", "positions", "actionY", -1)

   $loc[4] = IniRead("positions.ini", "positions", "invX", -1)
   $loc[5] = IniRead("positions.ini", "positions", "invY", -1)

   $loc[6] = IniRead("positions.ini", "positions", "bsbX", -1)
   $loc[7] = IniRead("positions.ini", "positions", "bsbY", -1)

   $loc[8] = IniRead("positions.ini", "positions", "tileX", -1)
   $loc[9] = IniRead("positions.ini", "positions", "tileY", -1)
EndFunc

LoadSavedConfig()

Func ToggleMacro()
   If $inProgress==1 Then
	  $inProgress=0
	  TrayTip("", "Macro stopped", 5)
   ElseIf $inProgress==0 Then
	  $inProgress=1
	  TrayTip("", "Macro started", 5)
   EndIf
EndFunc

Func SetPosition()
   MsgBox(0, "", "Hold click slightly before the right edge of your stamina bar.")
   $bools[0] = 1
EndFunc
Func SetInv()
   $loc[4] = MouseGetPos(0)
   $loc[5] = MouseGetPos(1)
   MsgBox(0, "", "Inventory position set.")
EndFunc
Func SetBSB()
   $loc[6] = MouseGetPos(0)
   $loc[7] = MouseGetPos(1)
   MsgBox(0, "", "BSB position set.")
EndFunc
Func SetTile()
   Set(8, 9, "tileX", "tileY", 4, 5)
   MsgBox(0, "", "Tile position set.")
EndFunc

Func Set($a, $b, $c, $d, $e, $f)
   $loc[$a] = MouseGetPos(0)
   $loc[$b] = MouseGetPos(1)
   IniWrite("positions.ini", "positions", $c, $loc[$a])
   IniWrite("positions.ini", "positions", $d, $loc[$b])
   $bools[$e] = 0
   If $f<5 Then
	  $bools[$f] = 1
   EndIf
EndFunc

While 1
   If _IsPressed("01") And $bools[0]==1 Then
	  Set(0, 1, "stamX", "stamY", 0, 1)
	  MsgBox(0, "", "Position set. Now hold click slightly before the left edge of your action timer bar.")
   EndIf
   If _IsPressed("01") And $bools[1]==1 Then
	  Set(2, 3, "actionX", "actionY", 1, 2)
	  MsgBox(0, "", "Position set. Now hold click on the item to drop in your inventory.")
   EndIf
   If _IsPressed("01") And $bools[2]==1 Then
	  Set(4, 5, "invX", "invY", 2, 3)
	  MsgBox(0, "", "Position set. Now hold click somewhere in the BSB.")
   EndIf
   If _IsPressed("01") And $bools[3]==1 Then
	  Set(6, 7, "bsbX", "bsbY", 3, 4)
	  MsgBox(0, "", "Position set. Final step: place your mouse over the tile and press Shift + Z, then press X to toggle the macro.")
   EndIf

   Sleep($pollRate)

   If $inProgress Then
	  Local $sColor = _ColorGetGreen(PixelGetColor($loc[0], $loc[1]))
	  Local $wColor = _ColorGetBlue(PixelGetColor($loc[2], $loc[3]))
	  If $sColor >= 75 Then
		 If $wColor <= 50 Then
			MouseMove($loc[8], $loc[9], 10)
			Send("!r")
			Send("!r")
			$count+=1
			Sleep(100)
			If $count>=5 Then
			   MouseClickDrag("", $loc[4], $loc[5], $loc[6], $loc[7])
			   $count=0
			   Sleep(100)
			EndIf
		 EndIf
	  EndIf
   EndIf
WEnd

Func _Exit()
   Exit
EndFunc