#cs ==================================================================================================

	M  O  R  T  A  R    C  R  E  A  T  O  R
	easy money
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 19/12/2015
	Last Modified 19/12/2015
	Version 0.1 (New Beginnings)
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Creates mortar from sand and clay using find image on the clay icon + text
	Once all the clay is consumed, drags everything to the BSB and restarts
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
	--Butchered from BrickCreator


#ce ==================================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-----------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
HotKeySet("{]}", "BSBSetLoc") ;Sets the BSB location for dragging
HotKeySet("{[}", "InvSetLoc") ;Sets the Inventory location for dragging
Global $claywithdraw = "{2}" ;How many clay to withdraw (based on mind logic/stamina restrictions)

;-----------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $imagefound[9]
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
Global $menu6[2]
Global $menu7[2]
Global $menu8[2]
Global $running = 1
Global $stamina = 0
Global $scriptstopper = 0
Global $antimacro ;randomization variable

#cs
Imagefound array [6]:
0 - clayicontextinv.bmp (rclick menu option start)
1 - createtext.bmp (rclick menu option 1)
2 - constructiontext.bmp (rclick menu option 2)
3 - mortartext.bmp (rclick menu option 3)
4 - sandicontextbsb.bmp (sand in BSB)
5 - clayicontextbsb.bmp (clay in BSB)
6 - sandicontextinv.bmp (sand in inventory)
7 - mortaricontextinv.bmp (mortar in inventory)
8 - sandselectedicontextinv.bmp (selected sand in inventory)
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

Func BSBSetLoc()
	$BSBLoc = MouseGetPos()
	$BSBLocSet = 1
	TrayTip("", "BSB location has been set", 5)
EndFunc   ;==>BSBSetLoc

Func InvSetLoc()
	$InvLoc = MouseGetPos()
	$InvLocSet = 1
	TrayTip("", "Inventory location has been set", 5)
EndFunc   ;==>InvSetLoc

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

Func FindScriptStoppers()
	Local $doesnotcontain, $willnotfit
	$doesnotcontain = _ImageSearchArea("doesnotcontain.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
	$willnotfit = _ImageSearchArea("willnotfit.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
	If $doesnotcontain or $willnotfit == 1 Then
		$scriptstopper = 1
	Else
		$scriptstopper = 0
	EndIf
EndFunc   ;==>FindScriptStoppers

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
				FindScriptStoppers()
				If $scriptstopper = 0 Then
					FindImage('mortaricontextinv.bmp', $menu7, 7)
					If $imagefound[7] == 1 Then
						FindImage('sandselectedicontextinv.bmp', $menu8, 8)
						If $imagefound[8] == 1 Then
							MouseMove($menu8[0] + Random(-1, 1), $menu8[1] + Random(-1, 1), 15 + Random(-1, 1))
							Sleep(_Random_Gaussian(220, 15, 1))
							MouseClick("left")
							Sleep(_Random_Gaussian(220, 15, 1))
							Send("{Shiftdown}")
							Sleep(_Random_Gaussian(130, 15, 1))
							MouseClickDrag("left", $menu7[0] + Random(-2, 3), $menu7[1] + Random(-1, 1), $BSBLoc[0] + Random(-7, 7), $BSBLoc[1] + Random(-7, 7), 15 + Random(-1, 1))
							Sleep(_Random_Gaussian(80, 4, 1))
							Send("{Shiftup}")
						ElseIf $imagefound[8] == 0 Then
							$running = 0
							MsgBox(0, "Debug Msgbox", "Found Mortar in Inventory with no leftover sand, something fucked up", 0, $handle) ;Debug
							Sleep(100)
							_Exit()
						EndIf
						Sleep(_Random_Gaussian(1450, 35, 1))
					ElseIf $imagefound[7] == 0 Then
						$running = 1
						FindImage('sandicontextinv.bmp', $menu6, 6)
						If $imagefound[6] == 1 Then
							Sleep(_Random_Gaussian(50, 2, 1))
							MouseMove($menu6[0] + Random(-2, 3), $menu6[1] + Random(-1, 1), 14 + Random(-1, 1))
							Sleep(_Random_Gaussian(220, 15, 1))
							MouseClick("left")
							Sleep(_Random_Gaussian(185, 4, 1))
							MouseClick("left")
							FindImage('clayicontextinv.bmp', $menu0, 0)
							If $imagefound[0] == 1 Then
								Sleep(_Random_Gaussian(220, 15, 1))
								MouseMove($menu0[0] + Random(-2, 3), $menu0[1] + Random(-1, 1), 14 + Random(-1, 1))
								Sleep(_Random_Gaussian(220, 15, 1))
								MouseClick("right")
								Sleep(_Random_Gaussian(1150, 25, 1))
								FindImage('createtext.bmp', $menu1, 1)
								If $imagefound[1] == 1 Then
									Sleep(_Random_Gaussian(50, 2, 1))
									MouseMove($menu1[0] + Random(-1, 1), $menu1[1] + Random(-1, 1), 14 + Random(-1, 1))
									Sleep(_Random_Gaussian(130, 4, 1))
									FindImage('constructiontext.bmp', $menu2, 2)
									If $imagefound[2] == 1 Then
										Sleep(_Random_Gaussian(50, 2, 1))
										MouseMove($menu2[0] + Random(-2, 3), $menu1[1] + Random(-1, 1), 14 + Random(-1, 1))
										MouseMove($menu2[0] + Random(-1, 1), $menu2[1] + Random(-1, 1), 14 + Random(-1, 1))
										Sleep(_Random_Gaussian(110, 4, 1))
										FindImage('mortartext.bmp', $menu3, 3)
										If $imagefound[3] == 1 Then
											Sleep(_Random_Gaussian(50, 2, 1))
											MouseMove($menu3[0] + Random(-1, 1), $menu2[1] + Random(-1, 1), 14 + Random(-1, 1))
											MouseMove($menu3[0] + Random(-1, 1), $menu3[1] + Random(-1, 1), 14 + Random(-1, 1))
											Sleep(_Random_Gaussian(220, 15, 1))
											MouseClick("left")
											Sleep(19000)
											Equipped()
											Do
												FindStamina()
												Sleep(500)
											Until $stamina == 1
											AntiRand()
											Sleep(_Random_Gaussian(50, 2, 1))
											FindImage('clayicontextinv.bmp', $menu0, 0)
											If $imagefound[0] == 1 Then
												Sleep(_Random_Gaussian(220, 15, 1))
												MouseMove($menu0[0] + Random(-2, 3), $menu0[1] + Random(-1, 1), 14 + Random(-1, 1))
												Sleep(_Random_Gaussian(220, 15, 1))
												MouseClick("right")
												Sleep(_Random_Gaussian(1150, 25, 1))
												FindImage('createtext.bmp', $menu1, 1)
												If $imagefound[1] == 1 Then
													Sleep(_Random_Gaussian(50, 2, 1))
													MouseMove($menu1[0] + Random(-1, 1), $menu1[1] + Random(-1, 1), 14 + Random(-1, 1))
													Sleep(_Random_Gaussian(130, 4, 1))
													FindImage('constructiontext.bmp', $menu2, 2)
													If $imagefound[2] == 1 Then
														Sleep(_Random_Gaussian(50, 2, 1))
														MouseMove($menu2[0] + Random(-2, 3), $menu1[1] + Random(-1, 1), 14 + Random(-1, 1))
														MouseMove($menu2[0] + Random(-1, 1), $menu2[1] + Random(-1, 1), 14 + Random(-1, 1))
														Sleep(_Random_Gaussian(110, 4, 1))
														FindImage('mortartext.bmp', $menu3, 3)
														If $imagefound[3] == 1 Then
															Sleep(_Random_Gaussian(50, 2, 1))
															MouseMove($menu3[0] + Random(-1, 1), $menu2[1] + Random(-1, 1), 14 + Random(-1, 1))
															MouseMove($menu3[0] + Random(-1, 1), $menu3[1] + Random(-1, 1), 14 + Random(-1, 1))
															Sleep(_Random_Gaussian(220, 15, 1))
															MouseClick("left")
															Sleep(19000)
															Equipped()
															AntiRand()
														EndIf
													EndIf
												EndIf
											ElseIf $imagefound[0] == 0 Then
												$running = 0
												MsgBox(0, "Debug Msgbox", "Couldn't find Inventory Clay", 0, $handle) ;Debug
												Sleep(100)
												_Exit()
											EndIf
										EndIf
									EndIf
								EndIf
							ElseIf $imagefound[0] == 0 Then
								$running = 0
								MsgBox(0, "Debug Msgbox", "Couldn't find Inventory Clay", 0, $handle) ;Debug
								Sleep(100)
								_Exit()
							EndIf
						ElseIf $imagefound[6] == 0 Then
							$running = 1
							FindImage('sandicontextbsb.bmp', $menu4, 4)
							If $imagefound[4] == 1 Then
								MouseClickDrag("left", $menu4[0] + Random(-2, 3), $menu4[1] + Random(-1, 1), $InvLoc[0] + Random(-6, 6), $InvLoc[1] + Random(-6, 6), 14 + Random(-1, 1))
								Sleep(_Random_Gaussian(1350, 30, 1))
								Send(1)
								Sleep(_Random_Gaussian(1100, 30, 1))
								Send("{enter}")
								$running = 1
								Sleep(_Random_Gaussian(1700, 60, 1))
							ElseIf $imagefound[4] == 0 Then
								$running = 0
								MsgBox(0, "Debug Msgbox", "Couldn't find BSB sand", 0, $handle) ;Debug
								Sleep(100)
								_Exit()
							EndIf
							FindImage('clayicontextbsb.bmp', $menu5, 5)
							If $imagefound[5] == 1 Then
								MouseClickDrag("left", $menu5[0] + Random(-2, 3), $menu5[1] + Random(-1, 1), $InvLoc[0] + Random(-6, 6), $InvLoc[1] + Random(-6, 6), 14 + Random(-1, 1))
								Sleep(_Random_Gaussian(1350, 30, 1))
								Send($claywithdraw)
								Sleep(_Random_Gaussian(1100, 30, 1))
								Send("{enter}")
								$running = 1
								Sleep(_Random_Gaussian(1700, 60, 1))
							ElseIf $imagefound[5] == 0 Then
								$running = 0
								MsgBox(0, "Debug Msgbox", "Couldn't find BSB clay", 0, $handle) ;Debug
								Sleep(100)
								_Exit()
							EndIf
						EndIf
					EndIf
				Else
					$running = 0
					TrayTip("", "Stopped by one of the script stoppers, please reset", 5)
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