#cs ==============================================================================================

	D  O  U  B  L  E    M  I  N  E  R
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 6/10/2013
	Last Modified 4/10/2015
	Version 1.2 (fucking rolf)
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Queues mines for a set number of actions, waits for stamina, and repeats ad infinitum
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
	-Wall break and full tile detection
	-Ensures a tool is equiped, pauses if not
	-Some debug/failsafes
	--------------------------------------------------------------------------------------------------
	Version History
	-0.1 (Bare Bones)
	--Cannabalized DoubleDigger
	-1.0 (Barely made it)
	--Implemented wall break detection, and tested ~2 hours
	-1.1 (GMs on my back)
	--Implemented full tile detection
	-1.2 (fucking rolf)
	--fix for names in window title
#ce ==============================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-----------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
$minebind = "{m}" ;remember to 'bind *key* mine_direction' in console
Global $actions = 2 ;set to the amount of actions wanted to be queued

;-------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $pos1
Global $pos2
Global $pos3
Global $stamina = 0
Global $wallbreak = 0
Global $nospace = 0
Global $antimacro
Global $running = 1
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions

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

Func Setup()
	$running = 1
	Opt("WinTitleMatchMode", 2)
	$handle = WinGetHandle("Wurm Online")
	WinActivate($handle)
	$windim = WinGetClientSize($handle)
	;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
	;[0] is width, [1] is height
	MouseMove(@DesktopWidth / 2 + Random(-20, 20), @DesktopHeight / 2 + Random(-20, 20), 15)
EndFunc   ;==>Setup

Func FindWallBreak()
	$wallbreak = _ImageSearchArea("wallbreaktext.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
EndFunc   ;==>FindWallBreak

Func FindNoSpace()
	$nospace = _ImageSearchArea("nospacetext.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
EndFunc   ;==>FindNoSpace

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
				$amx = _Random_Gaussian(5500,1000,1)
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
				$amx = _Random_Gaussian(13000,2500,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 50
				$amx = _Random_Gaussian(18000,3000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 60
				$amx = _Random_Gaussian(25000,4000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 70 To 71
				$amx = _Random_Gaussian(35000,5000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 80 To 81
				$amx = _Random_Gaussian(45000,6000,1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case Else
				Sleep(_Random_Gaussian(4000,1000,1))
		EndSwitch
	ElseIf $running == 0 Then
		Sleep(100)
	EndIf
EndFunc   ;==>AntiRand

Func MainLoop()
	Switch $running
		Case 1
			Local $i = 0
			FindStamina()
			If $stamina == 1 Then
				FindWallBreak()
				If $wallbreak == 0 Then
					FindNoSpace()
					If $nospace == 0 Then
						;MsgBox(0, "Debug Msgbox", "Stamina Bar full, Found at: " & $x1 & ", " & $y1, 0, $handle) ;Debug
						$stamina = 0
						Sleep(_Random_Gaussian(800,50,1))
						Do
							Send($minebind)
							$i += 1
							Sleep(_Random_Gaussian(300,15,1))
						Until $i == $actions
						Sleep(6000)
						Equipped()
						AntiRand()
					ElseIf $nospace == 1 Then
						$running = 0
						TrayTip("", "No space on tile, please reset", 5)
					EndIf
				ElseIf $wallbreak == 1 Then
					$running = 0
					TrayTip("", "Wall has broken, please reset", 5)
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
While (1)
	MainLoop()
WEnd
