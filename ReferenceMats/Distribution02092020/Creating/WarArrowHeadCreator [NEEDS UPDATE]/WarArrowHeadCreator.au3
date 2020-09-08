#cs ==================================================================================================

	W  A  R    A  R  R  O  W    H  E  A  D    C  R  E  A  T  O  R
	buying rare small anvil with 90+ woa pst
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 8/07/2015
	Last Modified 8/07/2015
	Version 0.1 (unneeded version update)
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Creates bricks from shards using find image on the shard icon + text
	Once all the shards are consumed, gets more shards, and BSBs bricks
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
	-Mouse movement logic
	-BSB withdrawl and storage
	-Randomization in mouse movements and timings
	-Anti-macro, based on Box-Muller polar transform gaussian RND
	--Normally distributed values around mean with a given standard deviation
	--------------------------------------------------------------------------------------------------
	Planned:
	Ensure that main loop logic is sound, re implement failsafes where applicable
	--------------------------------------------------------------------------------------------------
	Version History
	-0.1 (New Beginnings)
	--Butchered from Arrow Creator
	-0.8 (chip chip)
	--tested and fixed comments etc

#ce ==================================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-----------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
HotKeySet("{]}", "CoolSetLoc") ;Sets the container in forge location for cooling

;-----------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $imagefound[6]
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions
Global $CoolLoc[2]
Global $CoolLocSet = 0
Global $menu0[2]
Global $menu1[2]
Global $menu2[2]
Global $menu3[2]
Global $menu4[2]
Global $menu5[2]
Global $running = 1
Global $stamina = 0
Global $antimacro ;randomization variable

#cs
Imagefound array [6]:
0 - glowinglump.bmp (rclick menu option start)
1 - createtext.bmp (rclick menu option 1)
2 - constructiontext.bmp (rclick menu option 2)
3 - bricktext.bmp (rclick menu option 3)
4 - shardicontextbsb.bmp (shard in BSB)
5 - brickicontext.bmp (brick in inventory)
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

Func CoolSetLoc()
	$CoolLoc = MouseGetPos()
	$CoolLocSet = 1
	TrayTip("", "Cooling location has been set", 5)
EndFunc   ;==>BSBSetLoc

Func SetLocations()
	If $CoolLocSet == 0 Then
		TrayTip("", "Set the Cooling location (]) key", 5)
		Do
			Sleep(100)
		Until $CoolLocSet == 1
	EndIf
EndFunc   ;==>SetLocations

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
				Sleep(_Random_Gaussian(3000,500,1))
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
		;TrayTip("", $bmpfilename & " not found, Macro stopped", 5)
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
	;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
	;[0] is width, [1] is height
EndFunc   ;==>Setup

Func MainLoop()
	Switch $running
		Case 1
			FindStamina()
			If $stamina == 1 Then
				ConsoleWrite("Stamina Found" & @CRLF)
				FindImage('glowinglump.bmp', $menu5, 0)
				If $imagefound[0] == 1 Then
					ConsoleWrite("Smithing stopper Found" & @CRLF)
					$running = 0
					MsgBox(0, "Debug Msgbox", "Lumps not glowing, please reset", 0, $handle) ;Debug
					Sleep(100)
				ElseIf $imagefound[0] == 0 Then
					ConsoleWrite("Smithing stopper not Found" & @CRLF)
					$running = 1
					FindImage('wararrowheadicontextinv.bmp', $menu4, 1)
					If $imagefound[1] == 1 Then
						ConsoleWrite("Arrow head Found" & @CRLF)
						MouseClickDrag("left", $menu4[0] + Random(-2, 3), $menu4[1] + Random(-1, 1), $CoolLoc[0] + Random(-3, 3), $CoolLoc[1] + Random(-1, 1), 14 + Random(-1, 1))
						Sleep(_Random_Gaussian(1850, 55, 1))
					ElseIf $imagefound[1] == 0 Then
						ConsoleWrite("Arrow head not Found" & @CRLF)
						$running = 1
						FindImage('lumpicontextinv.bmp', $menu0, 2)
						If $imagefound[2] == 1 Then
							Sleep(_Random_Gaussian(50, 2, 1))
							MouseMove($menu0[0] + Random(-2, 3), $menu0[1] + Random(-1, 1), 14 + Random(-1, 1))
							Sleep(_Random_Gaussian(220, 15, 1))
							MouseClick("right")
							Sleep(_Random_Gaussian(950, 25, 1))
							FindImage('createtext.bmp', $menu1, 1)
							If $imagefound[1] == 1 Then
								Sleep(_Random_Gaussian(50, 2, 1))
								MouseMove($menu1[0] + Random(-1, 1), $menu1[1] + Random(-1, 1), 14 + Random(-1, 1))
								Sleep(_Random_Gaussian(130, 4, 1))
								FindImage('weaponheadtext.bmp', $menu2, 2)
								If $imagefound[2] == 1 Then
									Sleep(_Random_Gaussian(50, 2, 1))
									MouseMove($menu2[0] + Random(-2, 3), $menu1[1] + Random(-1, 1), 14 + Random(-1, 1))
									MouseMove($menu2[0] + Random(-1, 1), $menu2[1] + Random(-1, 1), 14 + Random(-1, 1))
									Sleep(_Random_Gaussian(110, 4, 1))
									FindImage('wararrowheadtext.bmp', $menu3, 3)
									If $imagefound[3] == 1 Then
										Sleep(_Random_Gaussian(50, 2, 1))
										MouseMove($menu3[0] + Random(-1, 1), $menu2[1] + Random(-1, 1), 14 + Random(-1, 1))
										MouseMove($menu3[0] + Random(-1, 1), $menu3[1] + Random(-1, 1), 14 + Random(-1, 1))
										Sleep(_Random_Gaussian(220, 15, 1))
										MouseClick("left")
										Sleep(12000)
										Equipped()
										AntiRand()
									EndIf
								EndIf
							EndIf
						ElseIf $imagefound[2] == 0 Then
							$running = 0
							MsgBox(0, "Debug Msgbox", "Inventory Lumps not found, please reset", 0, $handle) ;Debug
							Sleep(100)
						EndIf
					EndIf
				EndIf
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
SetLocations()
While (1)
	MainLoop()
WEnd