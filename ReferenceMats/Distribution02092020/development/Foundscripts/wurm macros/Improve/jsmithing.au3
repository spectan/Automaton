#include <Misc.au3>
#include <ImageSearch.au3>

;	Instructions: Edit the amount of items to improve ($impAmount), run macro, press the SetImpColumn key (Z by default) and follow the prompts.
;	Default hotkeys: x to toggle the macro, z to set the improvement column position, alt+q to improve, alt+e to repair
;	Toolbelt order follows the tools variable. Change the files in the tools variable to make this macro work for other skills such as carpentry.
;	Make sure the blue highlighting bar is selected on something other than your improvement items or else it may cause the tool scan to fail.
;	If the macro is acting improperly try setting the improvement position again, if that consistently fails fiddle with the tolerance and search variables.
;	Setting the GUI opacity to 100% may also help.

;CHANGE THESE
global $impAmount=4 ; Set to one less than how many items you want to improve
global $impTime=2400
global $repairTime=750
   ;Keybinds
global $impKey = "!q" ; This uses special characters before the key for modifiers, for example +q is shift+q, !q is alt+q, ^q is ctrl+q.
global $repKey = "!e"
global $toggleKey = "x"
global $setKey = "z"
global $exitKey = "{ESC}"
global $beltKeys[5] = ["1", "2", "3", "4", "5"] ; Keybinds to change the active tool on the toolbelt
   ;Image Search
global $tools[5] = ["water.bmp", "hammer.bmp", "pelt.bmp", "whetstone.bmp", "iron.bmp"]
global $tolerance = 150 ; Tolerance for how different the tool scanned on your screen is compared to the image file. Default: 150
global $search = 15 ; Search area box for tool scans; improvement icons max out at 15x15. Default: 15

;DONT CHANGE THESE
global $impColumn
global $setImpColumn=0
global $inProgress=0
global $currentPosition=0
global $x1
global $y1

HotKeySet($setKey, "SetImpColumn")
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
   MsgBox(0, "", "Click on first item's improvement icon, as close to the center as possible.")
   $setImpColumn=1
EndFunc

While 1
   If _IsPressed("01") And $setImpColumn==1 Then
	  $impColumn = MouseGetPos()
	  First()
	  $setImpColumn=0
	  MsgBox(0, "", "Position set. Ready to macro. (Press " & $toggleKey & ")")
   EndIf
   If $inProgress == 1 Then
	  MouseMove($impColumn[0], $impColumn[1]+$currentPosition*16, 0)
	  $item = Search()
	  If $item == 0 Then
		 Send($beltKeys[0])
	  ElseIf $item == 1 Then
		 Send($beltKeys[1])
	  ElseIf $item == 2 Then
		 Send($beltKeys[2])
	  ElseIf $item == 3 Then
		 Send($beltKeys[3])
	  ElseIf $item == 4 Then
		 Send($beltKeys[4])
	  EndIf
	  Sleep(100)
	  MouseMove($impColumn[0], $impColumn[1]+$currentPosition*16, 0)
	  Send($impKey)
	  Send($repKey)
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
   $pixel0 = _ImageSearchArea($tools[0],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   $pixel1 = _ImageSearchArea($tools[1],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   $pixel2 = _ImageSearchArea($tools[2],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   $pixel3 = _ImageSearchArea($tools[3],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   $pixel4 = _ImageSearchArea($tools[4],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   If($pixel0 == 1) Then
	  Return 0
   EndIf
   If($pixel1 == 1) Then
	  Return 1
   EndIf
   If($pixel2 == 1) Then
	  Return 2
   EndIf
   If($pixel3 == 1) Then
	  Return 3
   EndIf
   If($pixel4 == 1) Then
	  Return 4
   EndIf
   Return -1
EndFunc

; First() attempts to scan the first icon and get a more accurate center coordinate than the user input.
; Not necessary to make the macro work; if it causes problems remove it and the call to it.
Func First()
   $mousePos = MouseGetPos()
   $pixel0 = _ImageSearchArea($tools[0],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   $pixel1 = _ImageSearchArea($tools[1],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   $pixel2 = _ImageSearchArea($tools[2],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   $pixel3 = _ImageSearchArea($tools[3],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   $pixel4 = _ImageSearchArea($tools[4],1,$mousePos[0]-$search,$mousePos[1]-$search,$mousePos[0]+$search,$mousePos[1]+$search,$x1,$y1,$tolerance)
   If $pixel0 == 1 Then
	  $impColumn[0] = $x1
	  $impColumn[1] = $y1
	  Return
   EndIf
   If $pixel1 == 1 Then
	  $impColumn[0] = $x1
	  $impColumn[1] = $y1
	  Return
   EndIf
   If $pixel2 == 1 Then
	  $impColumn[0] = $x1
	  $impColumn[1] = $y1
	  Return
   EndIf
   If $pixel3 == 1 Then
	  $impColumn[0] = $x1
	  $impColumn[1] = $y1
	  Return
   EndIf
   If $pixel4 == 1 Then
	  $impColumn[0] = $x1
	  $impColumn[1] = $y1
	  Return
   EndIf
EndFunc

Func _Exit()
   Exit
EndFunc