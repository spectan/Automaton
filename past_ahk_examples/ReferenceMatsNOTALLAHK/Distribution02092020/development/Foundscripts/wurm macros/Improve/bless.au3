#include <Misc.au3>
#include <ImageSearch.au3>
#include <Color.au3>
;	log file knife pelt mallet
;CHANGE THESE
global $impAmount=9
global $impTime=15000
global $repairTime=0
global $x1
global $y1
;

;DONT CHANGE THESE
global $impColumn
global $setImpColumn=0
global $stamLoc
global $setStam=0
global $inProgress=0
global $currentPosition=0
;

HotKeySet("{z}", "SetImpColumn")
HotKeySet("!z", "SetPosition")
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

Func SetImpColumn()
   MsgBox(0, "", "Click on first item's improvement icon, as close to the center as possible.")
   $setImpColumn=1
EndFunc
Func SetPosition()
   MsgBox(0, "", "Hold click slightly before the right edge of your stamina bar, in the middle.")
   $setStam=1
EndFunc

While 1
    If _IsPressed("01") And $setImpColumn==1 Then
		$impColumn = MouseGetPos()
		$setImpColumn=0
		MsgBox(0, "", "set faith")
	 EndIf
    If _IsPressed("01") And $setStam==1 Then
		$stamLoc = MouseGetPos()
		$setStam=0
		MsgBox(0, "", "Position set. Ready to macro. (Press X)")
	 EndIf
   If $inProgress == 1 Then
	  Local $sColor = _ColorGetBlue(PixelGetColor($stamLoc[0], $stamLoc[1]))
	  If $sColor >= 150 Then
		 MouseMove($impColumn[0], $impColumn[1]+$currentPosition*16, 0)
		 MouseClick("right")
		 Sleep(100)
		 Local $search = _ImageSearch("spells.bmp",1,$x1,$y1,150)
		 If $search == 1 Then
			MouseMove($x1,$y1)
		 EndIf
		 Sleep(100)
		 $search = _ImageSearch("opulence.bmp",1,$x1,$y1,50)
		 If $search == 1 Then
			MouseMove($x1,MouseGetPos(1))
			Sleep(100)
			MouseMove($x1,$y1)
		 EndIf
		 MouseClick("left")
		 Sleep(20000)
		 $currentPosition+=1
		 If $currentPosition > $impAmount Then
			$currentPosition = 0
		 EndIf
	  EndIf
	  Sleep(1000)
   EndIf
WEnd

Func _Exit()
Exit
EndFunc   ;==>_Exit