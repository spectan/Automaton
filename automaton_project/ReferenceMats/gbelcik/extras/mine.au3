#include <Misc.au3>
#include <Color.au3>

global $pollRate = 500

;DONT CHANGE THESE
global $stamLoc
global $maxCount=350
global $workLoc
global $setStam=0
global $setWork=0
global $count=0
global $inProgress=0
;

HotKeySet("{z}", "SetPosition")
HotKeySet("{x}", "ToggleMacro")
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

While 1
    If $count>=$maxCount Then
	   ToggleMacro()
	   Beep(500, 1000)
	   $count=0
   EndIf
    If _IsPressed("01") And $setStam==1 Then
		$stamLoc = MouseGetPos()
		$setStam=0
		$setWork=1
		MsgBox(0, "", "Position set. Now hold click slightly before the left edge of your action timber bar, in the middle.")
	 EndIf
    If _IsPressed("01") And $setWork==1 Then
		$workLoc = MouseGetPos()
		$setWork=0
		MsgBox(0, "", "Position set. Ready to macro. (Press X)")
	 EndIf
	 Sleep($pollRate)
   If $inProgress Then
	  Local $sColor = _ColorGetGreen(PixelGetColor($stamLoc[0], $stamLoc[1]))
	  Local $wColor = _ColorGetBlue(PixelGetColor($workLoc[0], $workLoc[1]))
	  If $sColor >= 75 Then
		 If $wColor <= 50 Then
		   Send("{f}") ; change f to your mining bind and the # to how many times you want to send it
		   Sleep(250) ; uncomment these lines to keep moving forward
		   If Mod($count, 5) == 0 Then
			  Send("{w down}")
			  Sleep(500)
			  Send("{w up}")
		   EndIf
		   $count+=1
		 EndIf
	  EndIf
   EndIf
WEnd

Func _Exit()
Exit
EndFunc   ;==>_Exit