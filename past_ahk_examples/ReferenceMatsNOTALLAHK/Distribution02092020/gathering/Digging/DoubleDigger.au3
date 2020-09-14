#cs ==============================================================================================

	D  o  u  b  l  e    D  i  g  g  e  r
	The Tryfean Tar Excavator
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 17/09/2013
	Last Modified 24/3/2015
	Version 1.5 (too lazy to get up)
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Queues digs for a set number of actions, waits for stamina, and repeats ad infinitum
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
	-Either dig until inventory full, or dig for a random number of cycles (like 6 to 8)
	--Currently you have to watch script pretty closely)
	-More debug/failsafes
	-Using Image Search:
	--Mouse hover text (Tar)
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
	-0.05 (Babbys first code)
	--Image Detection Working
	-0.09 (Send 100 keypresses in 1 second)
	-- Figured out Loops
	-0.1 (Bare Bones)
	--Anti-Macro, Cases, basicly the barebones done
	--As this version is barebones, all other scripts will probably be based off of this
	--All this comment section completed
	-1.0 (DoubleDoubleDigger)
	--Added Box-Muller polar transform gaussian RND
	--Cannabalized improvements from ArrowShaftCreator
	--Heavily tested ~20 hours +
	-1.5 (too lazy to get up)
	--Added automatic tar to BSB dragging
#ce ==============================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
HotKeySet("{]}", "BSBSetLoc") ;Sets the BSB location for tar dragging
HotKeySet("{[}", "DigSetLoc") ;Sets the Dig location for digging
$digbind = "{m}" ;remember to 'bind *key* dig' in console
Global $actions = 4 ;set to the amount of actions wanted to be queued

;-------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $BSBLoc[2]
Global $BSBLocSet = 0
Global $DigLoc[2]
Global $DigLocSet = 0
Global $pos1
Global $pos2
Global $pos3
Global $menu5[2]
Global $imagefound[1]
Global $stamina = 0
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

Func BSBSetLoc()
	$BSBLoc = MouseGetPos()
	$BSBLocSet = 1
	TrayTip("", "BSB location has been set", 5)
EndFunc   ;==>BSBSetLoc

Func DigSetLoc()
	$DigLoc = MouseGetPos()
	$DigLocSet = 1
	TrayTip("", "Dig location has been set", 5)
EndFunc   ;==>InvSetLoc

Func SetLocations()
	If $BSBLocSet == 0 Then
		TrayTip("", "Set the BSB location (]) key", 5)
		Do
			Sleep(100)
		Until $BSBLocSet == 1
	EndIf
	If $DigLocSet == 0 Then
		TrayTip("", "Set the Dig location ([) key", 5)
		Do
			Sleep(100)
		Until $DigLocSet == 1
	EndIf
EndFunc   ;==>SetLocations

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

Func MainLoop()
	Switch $running
		Case 1
			Local $i = 0
			FindStamina()
			If $stamina == 1 Then
				FindImage('tarinventory.bmp', $menu5, 0)
				If $imagefound[0] == 1 Then
					MouseClickDrag("left", $menu5[0] + Random(-2, 3), $menu5[1] + Random(-1, 1), $BSBLoc[0] + Random(-7, 7), $BSBLoc[1] + Random(-7, 7), 14 + Random(-1, 1))
					Sleep(_Random_Gaussian(80, 4, 1))
				ElseIf $imagefound[0] == 0 Then
					$running = 1
				EndIf
				;MsgBox(0, "Debug Msgbox", "Stamina Bar full, Found at: " & $x1 & ", " & $y1, 0, $handle) ;Debug
				$stamina = 0
				Sleep(_Random_Gaussian(800,50,1))
				MouseMove($DigLoc[0] + Random(-7, 7), $DigLoc[1] + Random(-7, 7), 14 + Random(-1, 1))
				Sleep(_Random_Gaussian(120, 6, 1))
				Do
					Send($digbind)
					$i += 1
					Sleep(_Random_Gaussian(340,15,1))
				Until $i == $actions
				Sleep(6000)
				Equipped()
				AntiRand()
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
			SoundPlay('ding.wav')
			MsgBox(0, "Debug Msgbox", "Some shit got fucked up", 0, $handle) ;Debug
			Sleep(100)
			_Exit()
	EndSwitch
EndFunc   ;==>MainLoop

;Main Procedure
Setup()
SetLocations()
While (1)
	MainLoop()
WEnd
