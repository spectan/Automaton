#include <Misc.au3>
#include <ImageSearch.au3>
;	log file knife pelt mallet
;CHANGE THESE
global $impAmount=19
global $impTime=3000
global $repairTime=1000
global $x1
global $y1
;

;DONT CHANGE THESE
global $impColumn
global $setImpColumn=0
global $inProgress=0
global $currentPosition=0
;

HotKeySet("{z}", "SetImpColumn")
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

While 1
    If _IsPressed("01") And $setImpColumn==1 Then
		$impColumn = MouseGetPos()
		$setImpColumn=0
		MsgBox(0, "", "Position set. Ready to macro. (Press X)")
	 EndIf
   If $inProgress == 1 Then
	  MouseMove($impColumn[0], $impColumn[1]+$currentPosition*16, 0)
	  $item = Search()
	  If $item == 0 Then
		 Send("{1}")
	  ElseIf $item == 1 Then
		 Send("{2}")
	  ElseIf $item == 2 Then
		 Send("{3}")
	  ElseIf $item == 3 Then
		 Send("{4}")
	  ElseIf $item == 4 Then
		 Send("{5}")
	  EndIf
	  Sleep(100)
	  MouseMove($impColumn[0], $impColumn[1]+$currentPosition*16, 0)
	  Send("!q")
	  Send("!e")
	  Sleep($impTime+$repairTime)
	  $currentPosition+=1
	  If $currentPosition > $impAmount Then
		 $currentPosition = 0
	  EndIf
	  Sleep(50)
   EndIf
	 Sleep(5)
WEnd

Func Search()
   $mousePos = MouseGetPos()
   $sampleSize = 8
   $pixel0 = _ImageSearchArea("log.bmp",1,$mousePos[0]-15,$mousePos[1]-10,$mousePos[0]+15,$mousePos[1]+10,$x1,$y1,150) ;log
   $pixel1 = _ImageSearchArea("file.bmp",1,$mousePos[0]-15,$mousePos[1]-10,$mousePos[0]+15,$mousePos[1]+10,$x1,$y1,150) ;file
   $pixel2 = _ImageSearchArea("carving.bmp",1,$mousePos[0]-15,$mousePos[1]-10,$mousePos[0]+15,$mousePos[1]+10,$x1,$y1,150) ;knife
   $pixel3 = _ImageSearchArea("pelt.bmp",1,$mousePos[0]-15,$mousePos[1]-10,$mousePos[0]+15,$mousePos[1]+10,$x1,$y1,150) ;pelt
   $pixel4 = _ImageSearchArea("mallet.bmp",1,$mousePos[0]-15,$mousePos[1]-10,$mousePos[0]+15,$mousePos[1]+10,$x1,$y1,150) ;mallet
   if($pixel0 == 1) Then
	  ;MouseMove($x1,$y1,0)
	 ; MsgBox(0,"","Water")
	  Return 0
	  Endif
   if($pixel1 == 1) Then
	  ;MouseMove($x1,$y1,0)
	  ;MsgBox(0,"","Hammer")
	  Return 1
	  Endif
   if($pixel2 == 1) Then
	  ;MouseMove($x1,$y1,0)
	 ; MsgBox(0,"","Pelt")
	  Return 2
	  Endif
   if($pixel3 == 1) Then
	  ;MouseMove($x1,$y1,0)
	  ;MsgBox(0,"","Whetstone")
	  Return 3
	  Endif
   if($pixel4 == 1) Then
	  ;MouseMove($x1,$y1,0)
	  ;MsgBox(0,"","Lump")
	  Return 4
	  Endif
   Return -1
EndFunc

Func _Exit()
Exit
EndFunc   ;==>_Exit