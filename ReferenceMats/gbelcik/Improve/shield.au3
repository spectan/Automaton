#include <Misc.au3>
#include <Color.au3>
#include <ImageSearch.au3>

global $pollRate = 600000

;DONT CHANGE THESE
global $actLoc
global $watLoc
global $shiLoc
global $setAct=0
global $setWat=0
global $setShi=0
global $inProgress=0
global $t=0
;

HotKeySet("{z}", "SetPosition")
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
   MsgBox(0, "", "Water")
   $setWat=1
EndFunc

Func EatDrink($actionX, $actionY)
   Local $files[2] = ['meal', 'waterfull']
   For $i = 1 to 2
	  $t=1
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
		 While $t==1
			Local $wColor = _ColorGetBlue(PixelGetColor($actionX, $actionY))
			If $wColor <=50 Then
			   $t=0
			EndIf
			Sleep(500)
		 WEnd
	  EndIf
	  Sleep(1000)
   Next
EndFunc

While 1
    If _IsPressed("01") And $setWat==1 Then
		$watLoc = MouseGetPos()
		$setWat=0
		$setShi=1
		MsgBox(0, "", "Position set. Shield")
	 EndIf
    If _IsPressed("01") And $setShi==1 Then
		$shiLoc = MouseGetPos()
		$setShi=0
		$setAct=1
		MsgBox(0, "", "Position set. Action")
	 EndIf
    If _IsPressed("01") And $setAct==1 Then
		$actLoc = MouseGetPos()
		$setAct=0
		MsgBox(0, "", "Position set. Go")
	 EndIf
   If $inProgress Then
	  EatDrink($actLoc[0], $actLoc[1])
	  MouseMove($shiLoc[0], $shiLoc[1])
	  Sleep(250)
	  Send("!e")
	  Sleep($pollRate)
   EndIf
WEnd

Func _Exit()
Exit
EndFunc   ;==>_Exit