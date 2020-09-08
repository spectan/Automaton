#include <Misc.au3>
#include <Color.au3>
#include <ImageSearch.au3>

;	Wurm General Improvement Macro
;	Instructions: Run macro, press the SetPosition key and follow the prompts. Press Shift+Z to change the amount of items.
;	Requirements: In-game UI must be set to Classic Light 100% opaque, ImprovedImprove client mod, ImageSearch and icon files, replacement UI background2.png
;	Default hotkeys
;		x: toggle the macro
;		z: set positions, shift+z: set item amount, alt+z: set first item to mouseposition
;		alt+q: improve, alt+e: repair
;	TODO: Lump/log/etc replacement, forge refueling

;CHANGE THESE
global $eatdrink=1		; Set to 0 to turn off automatic eating/drinking
global $impAmount=0
global $maxCount=1000		; After this many improve/repairs, eat and drink
global $pollRate=750	; Milliseconds between each loop, 500 is a safe value.
   ;Keybinds
global $impKey = "!q" ; This uses special characters before the key for modifiers, for example +q is shift+q, !q is alt+q, ^q is ctrl+q.
global $repKey = "!e"
global $toggleKey = "x"
global $setKey = "z"
global $setKey2 = "!z"
global $setKey3 = "+z"
global $exitKey = "{ESC}"

;DONT CHANGE THESE
global $loc[6]
global $bools[5]=[0,0,0,0,0]
global $currentPosition=0
global $count=0

HotKeySet($setKey, "SetPosition")
HotKeySet($setKey2, "SetImpCol")
HotKeySet($setKey3, "SetImpAmt")
HotKeySet($toggleKey, "ToggleMacro")
HotKeySet($exitKey, "_Exit")

Func LoadSavedConfig()
   $loc[0] = IniRead("positions.ini", "positions", "stamX", -1)
   $loc[1] = IniRead("positions.ini", "positions", "stamY", -1)
   $loc[2] = IniRead("positions.ini", "positions", "actionX", -1)
   $loc[3] = IniRead("positions.ini", "positions", "actionY", -1)
   $loc[4] = IniRead("positions.ini", "positions", "itemX", -1)
   $loc[5] = IniRead("positions.ini", "positions", "itemY", -1)
   $impAmount = IniRead("positions.ini", "positions", "impAmount", -1)
EndFunc

LoadSavedConfig()

Func ToggleMacro()
   $bools[3] = ($bools[3]) ? 0 : 1
   TrayTip("", "Macro " & (($bools[3]) ? "started" : "stopped"), 5)
EndFunc

Func SetPosition()
   MsgBox(0, "Wurm General Improvement Macro", "Click somewhere on the row of the first item.")
   $bools[0]=1
EndFunc
Func SetImpCol()
   $loc[4] = MouseGetPos(0)
   $loc[5] = MouseGetPos(1)
   IniWrite("positions.ini", "positions", "itemX", $loc[4])
   IniWrite("positions.ini", "positions", "itemY", $loc[5])
   MsgBox(0, "Wurm General Improvement Macro", "Improvement column set.")
EndFunc
Func SetImpAmt()
   $impAmount = Number(InputBox("Wurm General Improvement Macro", "Set number of items to improve.", $impAmount+1)) - 1
   IniWrite("positions.ini", "positions", "impAmount", $impAmount)
EndFunc

Func EatDrink($actionX, $actionY)
   Local $files[2] = ['meal', 'waterfull']
   For $i = 1 to 2
	  $bools[4]=1
	  Local $x, $y
	  Local $search = _ImageSearch($files[$i-1] & '.bmp', 10, $x, $y, 0)
	  Local $search1 = _ImageSearch($files[$i-1] & 'blue.bmp', 10, $x, $y, 0)
	  Local $search2 = _ImageSearch($files[$i-1] & 'light.bmp', 10, $x, $y, 0)
	  If $search==1 Or $search1==1 Or $search2==1 Then
		 MouseClick("right", $x, $y)
		 Sleep(1000)
		 Local $search3 = _ImageSearch('drink.bmp', 50, $x, $y, 0)
		 Local $search4 = _ImageSearch('eat.bmp', 50, $x, $y, 0)
		 If $search3==1 Or $search4==1 Then
			MouseClick("", $x, $y)
		 EndIf
		 Sleep(1000)
		 While $bools[4]==1
			Local $wColor = _ColorGetBlue(PixelGetColor($actionX, $actionY))
			If $wColor <=50 Then
			   $bools[4]=0
			EndIf
			Sleep(500)
		 WEnd
	  EndIf
	  Sleep(1000)
   Next
EndFunc

Func Set($arrayX, $arrayY, $nameX, $nameY, $boolOld, $boolNew)
   $loc[$arrayX] = MouseGetPos(0)
   $loc[$arrayY] = MouseGetPos(1)
   IniWrite("positions.ini", "positions", $nameX, $loc[$arrayX])
   IniWrite("positions.ini", "positions", $nameY, $loc[$arrayY])
   $bools[$boolOld] = 0
   If $boolNew<3 Then
	  $bools[$boolNew] = 1
   EndIf
EndFunc

While 1
   If _IsPressed("01") And $bools[1]==1 Then
	  Set(0, 1, "stamX", "stamY", 1, 2)
	  MsgBox(0, "", "Position set. Click slightly before the left edge of your action timer bar.")
   EndIf
   If _IsPressed("01") And $bools[2]==1 Then
	  Set(2, 3, "actionX", "actionY", 2, 3)
	  MsgBox(0, "", "Position set. Press " & $toggleKey & " to begin.")
   EndIf
   If _IsPressed("01") And $bools[0]==1 Then
	  Set(4, 5, "itemX", "itemY", 0, 1)
	  MsgBox(0, "", "Position set. Click towards the right edge of your stamina bar after the point where lower stamina will cause your action timers to significantly increase.")
   EndIf
   If $bools[3] == 1 Then
	  Local $sColor = _ColorGetGreen(PixelGetColor($loc[0], $loc[1]))
	  Local $wColor = _ColorGetBlue(PixelGetColor($loc[2], $loc[3]))
	  If $sColor >= 75 Then
		 If $wColor <= 50 Then
			If $count>=$maxCount And $eatdrink==1 Then
			   EatDrink($loc[2], $loc[3])
			   $count=0
			   ToggleMacro()
			EndIf
			MouseMove($loc[4], $loc[5]+$currentPosition*16)
			Send($impKey)
			;	Send($repKey)
			$count+=1
			$currentPosition+=1
			If $currentPosition > $impAmount Then
			   $currentPosition = 0
			EndIf
		 EndIf
	  EndIf
	  Sleep($pollRate)
   EndIf
   Sleep(5)
WEnd

Func _Exit()
   Exit
EndFunc