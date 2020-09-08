#cs ==================================================================================================

	A  R  R  O  W    S  H  A  F  T    C  R  E  A  T  O  R
	why does my horse have 200 arrow shafts in it
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
	Creates arrow shafts from sfafts using find image on the log icon, and using r-click menu
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
	-BSB movement
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
HotKeySet("{]}", "BSBSetLoc") ;Sets the BSB location for arrow shaft dragging
HotKeySet("{[}", "InvSetLoc") ;Sets the Inventory location for shaft dragging
Global $shaftwithdraw = "{5}" ;How many shafts to withdraw (based on mind logic/stamina restrictions)

;-----------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $imagefound[6]
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions
Global $BSBLoc[2]
Global $BSBLocSet = 0
Global $InvLoc[2]
Global $InvLocSet = 0
Global $menu0[2]
Global $menu1[2]
Global $menu2[2]
Global $menu3[2]
Global $menu4[2]
Global $menu5[2]
Global $running = 1
Global $stamina = 0
Global $antimacro

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

Func BSBSetLoc()
	$BSBLoc = MouseGetPos()
	$BSBLocSet = 1
	TrayTip("", "BSB location has been set", 5)
EndFunc

Func InvSetLoc()
	$InvLoc = MouseGetPos()
	$InvLocSet = 1
	TrayTip("", "Inventory location has been set", 5)
EndFunc

Func SetLocations()
	If $BSBLocSet == 0 Then
		TrayTip("", "Set the BSB location (]) key", 5)
		Do
			Sleep(100)
		Until $BSBLocSet == 1
	EndIf
	If $InvLocSet == 0 Then
		TrayTip("", "Set the Inventory location ([) key", 5)
		Do
			Sleep(100)
		Until $InvLocSet == 1
	EndIf
EndFunc

Func FindStamina()
	;Local $stamareawidth=$windim[0]/2 ;performance shit
	;Local $stamareaheight=$windim[1]/2 ;performance shit
	;MsgBox(0, "Stamina Area Debug", "Width: " & $stamareawidth & ", Height: " & $stamareaheight, 0, $handle) ;Debug

	$stamina = _ImageSearchArea("stamfull.bmp", 0, 0, 0, $windim[0], $windim[1], $x1, $y1, 10)
EndFunc   ;==>FindStamina

Func Equipped()
	FindStamina()
	If $stamina == 1 Then
		TrayTip("", "Tool not equiped, pausing...", 5) ;Debug
		$running = 0
	ElseIf $stamina == 0 Then
		;MsgBox(0, "Debug Msgbox", "Tool equipped", 0, $handle) ;Debug
		Sleep(50)
	EndIf
EndFunc   ;==>Equipped

Func AntiRand() ;20/100 chance of triggering a significant wait after the stamina bar refills
	Local $amx ;Anti Macro x
	$antimacro = Ceiling(Random(100))
	While $stamina == 0
		FindStamina()
		Sleep(500)
	WEnd
	If $running == 1 Then
		Switch $antimacro
			Case 10 To 14
				$amx = Random(4100, 6900)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000) & " seconds", 5)
				Sleep($amx)
			Case 20 To 23
				$amx = Random(5400, 7600)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000) & " seconds", 5)
				Sleep($amx)
			Case 30 To 32
				$amx = Random(6300, 9800)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000) & " seconds", 5)
				Sleep($amx)
			Case 40 To 41
				$amx = Random(7500, 11500)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000) & " seconds", 5)
				Sleep($amx)
			Case 50
				$amx = Random(8600, 12200)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000) & " seconds", 5)
				Sleep($amx)
			Case 60
				$amx = Random(9500, 13500)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000) & " seconds", 5)
				Sleep($amx)
			Case 70 To 71
				$amx = Random(15500, 34500)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000) & " seconds", 5)
				Sleep($amx)
			Case 80 To 81
				$amx = Random(41500, 60500)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000) & " seconds", 5)
				Sleep($amx)
			Case Else
				Sleep(Random(1900, 4200))
		EndSwitch
	ElseIf $running == 0 Then
		Sleep(100)
	EndIf
EndFunc   ;==>AntiRand

Func FindImage($bmpfilename, ByRef $foundv, $foundx)
	;Local $stamareawidth=$windim[0]/2 ;performance shit
	;Local $stamareaheight=$windim[1]/2 ;performance shit
	;MsgBox(0, "Stamina Area Debug", "Width: " & $stamareawidth & ", Height: " & $stamareaheight, 0, $handle) ;Debug

	$imagefound[$foundx] = _ImageSearchArea($bmpfilename, 1, 0, 0, @DesktopWidth, @DesktopHeight, $foundv[0], $foundv[1], 130)

	If $imagefound[$foundx] == 1 Then
		;MsgBox(0, "Debug Msgbox", $bmpfilename & " found", 0, $handle) ;Debug
		Sleep(500)
	ElseIf $imagefound[$foundx] == 0 Then
		TrayTip("", $bmpfilename & " not found, Macro stopped", 5)
		;MsgBox(0, "Debug Msgbox", $bmpfilename & " not found", 0, $handle) ;Debug
		$running = 0
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
			FindStamina()
			If $stamina == 1 Then
				FindImage('shafticontextinv.bmp', $menu0, 0)
				If $imagefound[0] == 1 Then
					Sleep(50)
					MouseMove($menu0[0] + Random(-1, 1), $menu0[1] + Random(-1, 1), 12 + Random(-1, 1))
					MouseClick("right")
					Sleep(Random(700, 900))
					FindImage('createtext.bmp', $menu1, 1)
					If $imagefound[1] == 1 Then
						Sleep(50)
						MouseMove($menu1[0] + Random(-1, 1), $menu1[1] + Random(-1, 1), 12 + Random(-1, 1))
						Sleep(50)
						FindImage('misctext.bmp', $menu2, 2)
						If $imagefound[2] == 1 Then
							Sleep(50)
							MouseMove($menu2[0] + Random(-1, 1), $menu1[1] + Random(-1, 1), 12 + Random(-1, 1))
							MouseMove($menu2[0] + Random(-1, 1), $menu2[1] + Random(-1, 1), 12 + Random(-1, 1))
							Sleep(50)
							FindImage('arrowshafttext.bmp', $menu3, 3)
							If $imagefound[3] == 1 Then
								Sleep(50)
								MouseMove($menu3[0] + Random(-1, 1), $menu2[1] + Random(-1, 1), 12 + Random(-1, 1))
								MouseMove($menu3[0] + Random(-1, 1), $menu3[1] + Random(-1, 1), 12 + Random(-1, 1))
								Sleep(Random(120, 290))
								MouseClick("left")
								Sleep(6000)
								Equipped()
								AntiRand()
							EndIf
						EndIf
					EndIf
				ElseIf $imagefound[0] == 0 Then
					FindImage('shafticontextbsb.bmp', $menu4, 4)
					If $imagefound[4] == 1 Then
						MouseClickDrag ("left", $menu4[0] + Random(-1, 1), $menu4[1] + Random(-1, 1), $InvLoc[0] + Random(-7, 7), $InvLoc[1] + Random(-7, 7), 12 + Random(-1, 1))
						Sleep(Random(1400, 2600))
						Send($shaftwithdraw)
						Sleep(Random(800, 1600))
						Send("{enter}")
						$running = 1
						Sleep(Random(2300, 3100))
					ElseIf $imagefound[4] == 0 Then
						$running = 0
						;MsgBox(0, "Debug Msgbox", "Couldn't find BSB shafts", 0, $handle) ;Debug
					EndIf
					FindImage('arrowshafticontext.bmp', $menu5, 5)
					If $imagefound[5] == 1 Then
						MouseClickDrag ("left", $menu5[0] + Random(-1, 1), $menu5[1] + Random(-1, 1), $BSBLoc[0] + Random(-7, 7), $BSBLoc[1] + Random(-7, 7), 12 + Random(-1, 1))
						$running = 1
						Sleep(Random(1500, 1900))
					ElseIf $imagefound[5] == 0 Then
						$running = 0
						;MsgBox(0, "Debug Msgbox", "Couldn't find inventory arrow shafts", 0, $handle) ;Debug
					EndIf
				EndIf
			ElseIf $stamina == 0 Then
				Sleep(500)
			EndIf
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
SetLocations()
While (1)
	MainLoop()
WEnd