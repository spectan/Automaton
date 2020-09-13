#include <Misc.au3>
#include <Color.au3>

global $pollRate = 1000

;DONT CHANGE THESE
global $stamLoc
global $workLoc
global $buttonLoc
global $setStam=0
global $setWork=0
global $setButton=0
global $inProgress=0
global $poz
global $poz2
global $count=0
;

HotKeySet("{z}", "SetPosition")
HotKeySet("+z", "SetPosition2")
HotKeySet("!z", "SetPosition3")
HotKeySet("x", "ToggleMacro")
HotKeySet("{ESC}", "_Exit")

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
   MsgBox(0, "", "Hold click slightly before the right edge of your stamina bar, in the middle.")
   $setStam=1
EndFunc
Func SetPosition2()
   $poz=MouseGetPos()
EndFunc
Func SetPosition3()
   $poz2=MouseGetPos()
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
		MsgBox(0, "", "Position set. Ready to macro. (Press X)")
	 EndIf
	 Sleep($pollRate)
   If $inProgress Then
	  Local $sColor = _ColorGetGreen(PixelGetColor($stamLoc[0], $stamLoc[1]))
	  Local $wColor = _ColorGetBlue(PixelGetColor($workLoc[0], $workLoc[1]))
		 If $sColor >= 75 Then
			If $wColor <= 50 Then
			   MouseMove($buttonLoc[0], $buttonLoc[1])
			   MouseClick("")
			   $count+=1
			   if $count>=10 Then
				  Sleep(250)
				  MouseClickDrag("", $poz[0], $poz[1], $poz2[0], $poz2[1])
				  Sleep(250)
				  $count=0
			   endif
			EndIf
		 EndIf
   EndIf
WEnd

Func _Exit()
Exit
EndFunc   ;==>_Exit