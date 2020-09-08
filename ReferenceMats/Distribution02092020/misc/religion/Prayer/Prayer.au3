#cs ==================================================================================================

	P  R  A  Y  E  R
	mushrooms and iron coins
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 25/02/2014
	Last Modified 25/02/2014
	Version 0.1 (New Beginnings)
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Prays at an altar using a keybind
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
	-Font anti-aliasing turned off
	--------------------------------------------------------------------------------------------------
	Features:
	-OCR and Image detection
	-Randomization in mouse movements and timings
	-Anti-macro, based on Box-Muller polar transform gaussian RND
	--Normally distributed values around mean with a given standard deviation
	--------------------------------------------------------------------------------------------------
	Planned:
	-drinking?
	--------------------------------------------------------------------------------------------------
	Version History
	-0.1 (New Beginnings)
	--Butchered from Destroyer

#ce ==================================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-----------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
HotKeySet("{]}", "PraySetLoc") ;Sets the location of the Object to be bashed
HotKeySet("{[}", "Pray") ;Manual pray hotkey
Global $praybind = "{m}"
Global $actions = 3 ;set to the amount of actions wanted to be queued (base on mind logic and stamina use)

;-----------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions
Global $a[2] ;variable that is not needed for other functions
Global $b ;variable that is not needed for other functions
Global $running = 1
Global $stamina = 0
Global $antimacro ;randomization variable

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

Func Pray()
    Sleep(_Random_Gaussian(80, 5, 1))
    $i = 0
	Do
		send($praybind)
		$i += 1
		Sleep(_Random_Gaussian(325, 15, 1))
	Until $i == $actions
EndFunc   ;==>Pray

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
								Sleep(_Random_Gaussian(4000,500,1))
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
	Opt("WinTitleMatchMode", 2)
	$handle = WinGetHandle("Wurm Online 3")
	WinActivate($handle)
	$windim = WinGetClientSize($handle)
	MouseMove(@DesktopWidth / 2 + Random(-20, 20), @DesktopHeight / 2 + Random(-20, 20), 15)
	;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
	;[0] is width, [1] is height
EndFunc   ;==>Setup

Func MainLoop()
		Switch $running
				Case 1
						FindStamina()
						If $stamina == 1 Then
						   AntiRand()
						   Pray()
						   Sleep(15000)
						   Equipped()
						ElseIf $stamina == 0 Then
								Sleep(500)
						EndIf
				Case 0
						SoundPlay('ding.wav')
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