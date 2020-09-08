#cs ==================================================================================================

	S  H  A  F  T    C  R  E  A  T  O  R
	Work this shaft baby
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 27/09/2013
	Last Modified 27/09/2013
	Version 0.1
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Creates shafts from logs using find image on the log icon, and using r-click menu
	--------------------------------------------------------------------------------------------------
	This script is made for AutoIt v3, can be downloaded at:
	-http://www.autoitscript.com/site/autoit/downloads/
	Requires the ImageSearch dll, can be found at:
	-http://www.autoitscript.com/forum/topic/65748-image-search-library/
	-Extract the .zip to wherever this script has been saved
	--------------------------------------------------------------------------------------------------
	Setup:
	-Cient skin should be Ironwood
	-Opacity set to 100%
	-Font anti-aliasing turned off (once OCR is implemented)
	--------------------------------------------------------------------------------------------------
	Features:
	-OCR simple text
	-Mouse movement logic
	--------------------------------------------------------------------------------------------------
	Planned:
	-Make it work
	--------------------------------------------------------------------------------------------------
	Version History
	-0.1 (Splashing in the water)
	--Trying different techniques
#ce ==================================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-----------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program

;-----------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $imagefound = 0
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions
Global $menu0[2]
Global $menu1[2]
Global $menu2[2]
Global $menu3[2]
Global $running = 1

Func _Exit()
	Exit
EndFunc   ;==>_Exit

Func ScriptPauser()
	If $running == 0 Then
		$running = 1
		TrayTip("", "Macro started", 5)
	ElseIf $running == 1 Then
		$running = 0
		TrayTip("", "Macro stopped", 5)
	EndIf
EndFunc   ;==>ScriptPauser

Func FindImage($bmpfilename, ByRef $foundv)
	;Local $stamareawidth=$windim[0]/2 ;performance shit
	;Local $stamareaheight=$windim[1]/2 ;performance shit
	;MsgBox(0, "Stamina Area Debug", "Width: " & $stamareawidth & ", Height: " & $stamareaheight, 0, $handle) ;Debug

	$imagefound = _ImageSearchArea($bmpfilename, 1, 0, 0, $windim[0], $windim[1], $foundv[0], $foundv[1], 120)

	If $imagefound == 1 Then
		;MsgBox(0, "Debug Msgbox", $bmpfilename & " found", 0, $handle) ;Debug
		Sleep(500)
	ElseIf $imagefound == 0 Then
		MsgBox(0, "Debug Msgbox", $bmpfilename & " not found", 0, $handle) ;Debug
		$running=0

	EndIf
EndFunc   ;==>FindImage

Func Setup()
	$running = 1
	$handle = WinGetHandle("Wurm Online 3")
	WinActivate($handle)
	$windim = WinGetClientSize($handle)
	;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
	;[0] is width, [1] is height
EndFunc   ;==>Setup

Func MainLoop()
	Switch $running
		Case 1
			Sleep(200)
			FindImage('rockshardimg.bmp', $menu0)
			Sleep(50)
			MouseMove($menu0[0], $menu0[1], 15)
			MouseClick("right")
			Sleep(500)
			FindImage('createtext.bmp', $menu1)
			Sleep(50)
			MouseMove($menu1[0], $menu1[1], 15)
			Sleep(50)
			FindImage('misctext.bmp', $menu2)
			Sleep(50)
			MouseMove($menu2[0], $menu1[1], 15)
			MouseMove($menu2[0], $menu2[1], 15)
			Sleep(50)
			FindImage('stonebricktext.bmp', $menu3)
			Sleep(50)
			MouseMove($menu3[0], $menu2[1], 15)
			MouseMove($menu3[0], $menu3[1], 15)
			Sleep(2000)
		Case 0
			While $running == 0
				Do
					Sleep(200)
				Until $running == 1
			WEnd
		Case Else
			MsgBox(0, "Debug Msgbox", "Some shit got fucked up", 0, $handle) ;Debug
			Sleep(1000)
			_Exit()
	EndSwitch
EndFunc   ;==>MainLoop

;Main Procedure
Setup()
While (1)
	MainLoop()
WEnd