#cs ==============================================================================================

	D  o  u  b  l  e    L  e  v  e  l  e  r
	thanks tich
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 4/08/2014
	Last Modified 4/08/2014
	Version 0.1 (aaaahhhh)
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Levels, waits for full inv message, then drops dirt
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
	-Stamina Bar Checker (ensures Stamina bar is full before queing actions)
	-Anti Macro, randomized stepped sleeps (gives the amount of seconds paused as a tray tip)
	-Pausing
	-Ensures a tool is equiped, pauses if not
	-Some debug/failsafes
	--------------------------------------------------------------------------------------------------
	Planned:
	-More debug/failsafes
	-Using Image Search:
	--Combat tab recognition
	--"Full inventory" detection (as a failsafe)
	--PM detection
	-Optimization
	--Smaller search areas
	-Rolfs 'Soon^TM' (chance of happening from most to least)
	--GUI menu (if needed)
	--Setting the Wurm Client as the main screen for optimization (less are for image searching, etc)
	--Porting Simba SRL OCR functions
	--------------------------------------------------------------------------------------------------
	Version History
	-0.1 (New BBeginnings)
	--Ported from DoubleDigger
#ce ==============================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
HotKeySet("{]}", "BSBSetLoc") ;Sets the BSB location for dirt dragging
HotKeySet("{[}", "RclickSetLoc") ;Sets the location for rclick

;-------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $imagefound[6]
Global $pos1
Global $pos2
Global $pos3
Global $BSBLoc[2]
Global $BSBLocSet = 0
Global $RclickLoc[2]
Global $RclickLocSet = 0
Global $menu0[2]
Global $menu1[2]
Global $menu2[2]
Global $stamina = 0
Global $antimacro
Global $running = 1
Global $eventstopper
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions

#cs
Imagefound array [6]:
0 - Leveltext.bmp (rclick menu option 1)
1 - dirticontextinv.bmp
2 - Dirtdoesnttext.bmp (event message)
3 - Toofarawaytext.bmp (event message)
4 - Groundisflattext.bmp (event message)
5 - Hittherocktext.bmp (event message)
#ce

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
EndFunc   ;==>BSBSetLoc

Func RclickSetLoc()
	$RclickLoc = MouseGetPos()
	$RclickLocSet = 1
	TrayTip("", "Right-click location has been set", 5)
EndFunc   ;==>InvSetLoc

Func SetLocations()
	If $BSBLocSet == 0 Then
		TrayTip("", "Set the BSB location (]) key", 5)
		Do
			Sleep(100)
		Until $BSBLocSet == 1
	EndIf
	If $RclickLocSet == 0 Then
		TrayTip("", "Set the right-click location ([) key", 5)
		Do
			Sleep(100)
		Until $RclickLocSet == 1
	EndIf
EndFunc   ;==>SetLocations

Func Setup()
	$running = 1
	Opt("WinTitleMatchMode", 2)
	$handle = WinGetHandle("Wurm Online 3")
	WinActivate($handle)
	$windim = WinGetClientSize($handle)
	;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
	;[0] is width, [1] is height
	MouseMove(@DesktopWidth / 2, @DesktopHeight / 2, 15)
EndFunc   ;==>Setup

Func FindStamina()
	;Local $stamareawidth=$windim[0]/2 ;performance shit
	;Local $stamareaheight=$windim[1]/2 ;performance shit
	;MsgBox(0, "Stamina Area Debug", "Width: " & $stamareawidth & ", Height: " & $stamareaheight, 0, $handle) ;Debug

	$stamina = _ImageSearchArea("stamfull.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 10)
EndFunc   ;==>FindStamina

Func _Random_Gaussian($nMean,$nSD,$iDP)
;******************************************
; Box-Muller polar transform gaussian RND
;******************************************
; $iMean = The mean of the distribution
; $iSD = desired standard deviation
; $iDP = data precision (d.p.)
    Do
        $nX = ((2 * Random()) - 1)
        $nY = ((2 * Random()) - 1)
        $nR = ($nX^2) + ($nY^2)
    Until $nR < 1
    $nGaus = ($nX * (Sqrt((-2 * (Log($nR) / $nR)))))
    Return StringFormat("%." & $iDP & "f",($nGaus * $nSD) + $nMean)
EndFunc

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
				$amx = _Random_Gaussian(5000,1000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 20 To 23
				$amx = _Random_Gaussian(7000,1200,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 30 To 32
				$amx = _Random_Gaussian(9000,1500,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 40 To 41
				$amx = _Random_Gaussian(13000,2000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 50
				$amx = _Random_Gaussian(18000,2500,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 60
				$amx = _Random_Gaussian(25000,3000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 70 To 71
				$amx = _Random_Gaussian(35000,4000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 80 To 81
				$amx = _Random_Gaussian(45000,5000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case Else
				Sleep(_Random_Gaussian(3000,500,1))
		EndSwitch
	ElseIf $running == 0 Then
		Sleep(100)
	EndIf
EndFunc   ;==>AntiRand

Func FindImage($bmpfilename, ByRef $foundv, $foundx)
	$imagefound[$foundx] = _ImageSearchArea($bmpfilename, 1, 0, 0, @DesktopWidth, @DesktopHeight, $foundv[0], $foundv[1], 130)

	If $imagefound[$foundx] == 1 Then
		Sleep(500)
	ElseIf $imagefound[$foundx] == 0 Then
		$running = 0
	EndIf
EndFunc   ;==>FindImage

Func FindEventStoppers()
	Local $dirtdoesnt, $toofaraway, $groundisflat, $hittherock
	$dirtdoesnt = _ImageSearchArea("Dirtdoesnttext.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
	$toofaraway = _ImageSearchArea("Toofarawaytext.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
	$groundisflat = _ImageSearchArea("Groundisflattext.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
	$hittherock = _ImageSearchArea("Hittherocktext.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)

	If $toofaraway or $groundisflat or $dirtdoesnt or $hittherock == 1 Then
		$eventstopper = 1
	Else
		$eventstopper = 0
	EndIf
EndFunc   ;==>FindEventStoppers


Func MainLoop()
	Switch $running
		Case 1
			FindStamina()
			If $stamina == 1 Then
				$stamina = 0
				FindEventStoppers()
				If $eventstopper = 0 Then
					FindImage('dirticontextinv.bmp', $menu1, 1)
					If $imagefound[1] == 1 Then
						MouseClickDrag("left", $menu1[0] + Random(-2, 3), $menu1[1] + Random(-1, 1), $BSBLoc[0] + Random(-7, 7), $BSBLoc[1] + Random(-7, 7), 14 + Random(-1, 1))
						Sleep(_Random_Gaussian(950, 35, 1))
					ElseIf $imagefound[1] = 0 Then
						$running = 1
						MouseMove($RclickLoc[0] + Random(-3, 3), $RclickLoc[1] + Random(-3, 3), 14 + Random(-1, 1))
						Sleep(_Random_Gaussian(220, 15, 1))
						MouseClick("right")
						Sleep(_Random_Gaussian(950, 25, 1))
						FindImage('leveltext.bmp', $menu0, 0)
						If $imagefound[0] == 1 Then
							Sleep(_Random_Gaussian(70, 2, 1))
							MouseMove($menu0[0] + Random(-3, 3), $menu0[1] + Random(-1, 1), 14 + Random(-1, 1))
							Sleep(_Random_Gaussian(220, 15, 1))
							MouseClick("left")
							Sleep(10000)
							Equipped()
							AntiRand()
						ElseIf $imagefound[0] == 0 Then
							MsgBox(0, "Debug Msgbox", "Some shit got fucked up", 0, $handle) ;Debug
							Sleep(1000)
						EndIf
					EndIf
				Else
					$running = 0
					TrayTip("", "Stopped by one of the event stoppers, please reset", 5)
				EndIf
			ElseIf $stamina == 0 Then
				;MsgBox(0, "Debug Msgbox", "Stamina Bar not full/found", 0, $handle) ;Debug
				Sleep(500)
			EndIf
		Case 0
			SoundPlay('ding.wav')
			While $running == 0
				Do
					Sleep(100)
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
