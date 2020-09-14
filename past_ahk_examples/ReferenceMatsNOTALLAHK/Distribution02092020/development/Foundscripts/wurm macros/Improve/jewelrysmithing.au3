#include <Misc.au3>
#include <Color.au3>

;	Wurm General Improvement Macro
;	Instructions: Edit the amount of items to improve ($impAmount), run macro, press the SetImpColumn key (Z by default) and follow the prompts.
;	Requirements: In-game UI must be set to Classic Light 100% opaque, ImprovedImprove client mod
;	Default hotkeys
;		x: toggle the macro
;		z: set improvement column position, shift+z: set item amount, ctrl+z: set stamina bar location, alt+z: set action bar location
;		alt+q: improve, alt+e: repair
;	TODO: Eat/drink, lump/log/etc replacement, forge refueling, check if repair is needed before sending repair key, store/read positions

;CHANGE THESE
global $impAmount=15	 ; Set to one less than how many items you want to improve
   ;Keybinds
global $impKey = "!q" ; This uses special characters before the key for modifiers, for example +q is shift+q, !q is alt+q, ^q is ctrl+q.
global $repKey = "!e"
global $toggleKey = "x"
global $setKey = "z"
global $setKey2 = "^z"
global $setKey3 = "!z"
global $setKey4 = "+z"
global $exitKey = "{ESC}"

;DONT CHANGE THESE
global $impColumn
global $stamLoc
global $workLoc
global $setImpColumn=0
global $setStam=0
global $setWork=0
global $inProgress=0
global $currentPosition=0
global $x1
global $y1

HotKeySet($setKey, "SetImpColumn")
HotKeySet($setKey2, "SetStam")
HotKeySet($setKey3, "SetWork")
HotKeySet($setKey4, "SetImpAmt")
HotKeySet($toggleKey, "ToggleMacro")
HotKeySet($exitKey, "_Exit")

Func ToggleMacro()
   If $inProgress==1 Then
	  $inProgress=0
	  TrayTip("", "Macro stopped", 5)
   ElseIf $inProgress==0 Then
	  $inProgress=1
	  TrayTip("", "Macro started", 5)
   EndIf
EndFunc

Func SetImpColumn()
   MsgBox(0, "Wurm General Improvement Macro", "Click somewhere on the row of the first item.")
   $setImpColumn=1
EndFunc
Func SetStam()
   MsgBox(0, "Wurm General Improvement Macro", "Click towards the right edge of your stamina bar, midway down and after the point where lower stamina will cause your action timers to significantly increase.")
   $setStam=1
EndFunc
Func SetWork()
   MsgBox(0, "Wurm General Improvement Macro", "Click slightly before the left edge of your action timer bar, midway down.")
   $setWork=1
EndFunc
Func SetImpAmt()
   $impAmount = Number(InputBox("Wurm General Improvement Macro", "Set number of items to improve. (Actual amount - 1)", $impAmount))
EndFunc

While 1
   If _IsPressed("01") And $setImpColumn==1 Then
	  $impColumn = MouseGetPos()
	  $setImpColumn=0
	  MsgBox(0, "", "Position set. Press " & $setKey2 & ".")
   EndIf
   If _IsPressed("01") And $setStam==1 Then
	  $stamLoc = MouseGetPos()
	  $setStam=0
	  MsgBox(0, "", "Position set. Press " & $setKey3 & ".")
   EndIf
   If _IsPressed("01") And $setWork==1 Then
	  $workLoc = MouseGetPos()
	  $setWork=0
	  MsgBox(0, "", "Position set. Ready to macro. Press " & $toggleKey & ".")
   EndIf
   If $inProgress == 1 Then
	  Local $sColor = _ColorGetGreen(PixelGetColor($stamLoc[0], $stamLoc[1]))
	  Local $wColor = _ColorGetBlue(PixelGetColor($workLoc[0], $workLoc[1]))
	  If $sColor >= 75 Then
		 If $wColor <= 50 Then
			MouseMove($impColumn[0], $impColumn[1]+$currentPosition*16, 0)
			Send($impKey)
			Send($repKey)
			$currentPosition+=1
			If $currentPosition > $impAmount Then
			   $currentPosition = 0
			EndIf
		 EndIf
	  EndIf
	  Sleep(500) ; This is the macro's main delay, higher values may be more reliable but lower ones may be more efficient
   EndIf
   Sleep(5)
WEnd

Func _Exit()
   Exit
EndFunc