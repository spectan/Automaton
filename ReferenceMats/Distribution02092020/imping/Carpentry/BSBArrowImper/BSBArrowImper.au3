#cs ==================================================================================================

	B  S  B    A  R  R  O  W    I  M  P  E  R
	they call me warrior
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 25/06/2015
	Last Modified 25/06/2015
	Version 0.1 (Bare Bones)
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Takes war arrows out of a BSB, imps the carving knife arrows, and puts them back in
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
	-Toolbelt with as many slots as required
	-A decent amount of items you want imped of the same kind exactly in the BSB (like 200+)
	-Carving knife in toolbelt slot 1
	--------------------------------------------------------------------------------------------------
	Features:
	-Stamina Bar Checker (ensures Stamina bar is full before queing actions)
	-Anti Macro, normally distributed sleeps (gives the amount of seconds paused as a tray tip)
	-Pausing
	-Ensures a tool is equiped, pauses if not
	-Toolbelt use
	-Repairing
	-QL resorting (imps lowest items)
	-Some debug/failsafes
	--------------------------------------------------------------------------------------------------
	Planned:
	-Implement toolbelt check on startup
	-Too little material message
	-Sleep timings
	-Using Mouse3 and Mouse4 buttons
	-More debug/failsafes
	-Using Image Search:
	--Combat tab recognition
	--PM detection
	-Optimization
	-Rolfs 'Soon^TM' (chance of happening from most to least likely)
	--GUI menu (if needed)
	--Setting the Wurm Client as the main screen for optimization (less are for image searching, etc)
	--Porting Simba SRL OCR functions
	--------------------------------------------------------------------------------------------------
	Version History
	-0.1 (Bare Bones)
	--Modified imping Framework
#ce ==================================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-----------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
$improvebind = "{i}" ;remember to 'bind *key* improve' in console
HotKeySet("{]}", "BSBSetLoc") ;Sets the BSB location for arrow shaft dragging
HotKeySet("{[}", "InvSetLoc") ;Sets the Inventory location for shaft dragging
Global $actions = 4 ;set to the amount of actions wanted to be queued (base on mind logic and stamina use)

;-----------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $prev = 0
Global $handle
Global $windim
Global $stamina = 0
Global $antimacro
Global $running = 1
Global $centered
Global $foundv
Global $foundx
Global $BSBLoc[2]
Global $BSBLocSet = 0
Global $InvLoc[2]
Global $InvLocSet = 0
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions
Global $a[2] ;variable that is not needed for other functions
Global $m ;variable that is not needed for other functions
Global $n ;variable that is not needed for other functions
Global $fix1 ;variable that is not needed for other functions
Global $fix2 ;variable that is not needed for other functions
Global $fiy1 ;variable that is not needed for other functions
Global $fiy2 ;variable that is not needed for other functions
Global $imagefound[9] ;Array for 'image', with x and y co-ordinate
Global $anchor[$actions][2] ;anchor, top left corner
Global $anchorcenter[$actions][2] ;anchor, center
Global $anchorXY[2] ;variable x y for anchor
Global $anchordamage[2] ;Array for damage tab dimensions
Global $anchorimprove[2] ;Array for i tab dimensions

#cs
	Imagefound array [9]:
	- [0] QLtab.bmp
	- [1] Itab.bmp
	- [2] Zerodamagetext.bmp
	- [3] anchorimage.bmp
	- [4] damagetab.bmp
	- [5] arrowicontextinv.bmp (anchor set)
	- [6] arrowicontextbsb.bmp (arrow in BSB)
	- [7] carvingknifeicon.bmp (improving icon)
	- [8] maxinv.bmp (failsafe)
#ce

; ======================================General Functions=============================================

Func Setup()
    $running = 1
	Opt("WinTitleMatchMode", 2)
	$handle = WinGetHandle("Wurm Online 3")
    WinActivate($handle)
    $windim = WinGetClientSize($handle)
    ;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
    ;[0] is width, [1] is height
    MouseMove(@DesktopWidth / 2 + Random(-20, 20), @DesktopHeight / 2 + Random(-20, 20), 15)
	;MsgBox(0, "Debug Msgbox", "Setup Initialized", 0, $handle) ;Debug
EndFunc   ;==>Setup

Func ScriptPauser()
    If $running == 0 Then
        $running = 1
        TrayTip("", "Macro started", 5)
    ElseIf $running == 1 Then
        $running = 0
        TrayTip("", "Macro stopped", 5)
    EndIf
EndFunc   ;==>ScriptPauser

Func _Exit()
    Exit
EndFunc   ;==>_Exit

Func _Random_Gaussian($nMean,$nSD,$iDP) ;Normal distribution for wait times
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
EndFunc    ;==>_Random_Gaussian

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
                $amx = _Random_Gaussian(5500,2000,1)
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
                $amx = _Random_Gaussian(18000,300,1)
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

Func Resort($QLclicks)
	FindImage('Itab.bmp', 1, 0, 0, @DesktopWidth,@DesktopHeight, $a, 0)
	If $imagefound[1] == 1 Then
		Sleep(_Random_Gaussian(50,5,1))
		MouseMove($a[0] + 5 + Random(-2, 2), $a[1] + 4 + Random(-2, 2), 13 + Random(-1, 1))
		For $m = 0 to $QLclicks - 1
			Sleep(_Random_Gaussian(200,30,1))
			MouseClick("left")
		Next
		Sleep(_Random_Gaussian(200,30,1))
	Else
		MsgBox(0, "Debug Msgbox", "Itab.bmp not found, exiting", 0, $handle) ;Debug
        Sleep(100)
        _Exit()
	EndIf
EndFunc   ;==>Resort

Func FindStamina()
    $stamina = _ImageSearchArea("stamfull.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 10)
EndFunc   ;==>FindStamina

Func FindImage($bmpfilename, $centered, $fix1, $fiy1, $fix2, $fiy2, ByRef $foundv, $foundx)
    $imagefound[$foundx] = _ImageSearchArea($bmpfilename, $centered, $fix1, $fiy1, $fix2, $fiy2, $foundv[0], $foundv[1], 80)

    If $imagefound[$foundx] == 1 Then
        ;MsgBox(0, "Debug Msgbox", $bmpfilename & " found", 0, $handle) ;Debug
        Sleep(500)
    ElseIf $imagefound[$foundx] == 0 Then
        ;TrayTip("", $bmpfilename & " not found, Macro stopped", 5)
        ;MsgBox(0, "Debug Msgbox", $bmpfilename & " not found", 0, $handle) ;Debug
        ;$running = 0
    EndIf
EndFunc   ;==>FindImage

Func AnchorSet()
	Sleep(100)
	FindImage('arrowicontextinv.bmp', 0, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 5)
	If $imagefound[5] == 1 Then
		For $n = 0 to $actions - 1
			$anchor[$n][0] = $anchorXY[0]
			$anchor[$n][1] = $anchorXY[1] + $n * 16
		Next
	Else
		MsgBox(0, "Debug Msgbox", "arrowicontextinv.bmp not found, exiting", 0, $handle) ;Debug
        Sleep(100)
        _Exit()
	EndIf
	FindImage('arrowicontextinv.bmp', 1, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 5)
	If $imagefound[5] == 1 Then
		For $n = 0 to $actions - 1
			$anchorcenter[$n][0] = $anchorXY[0]
			$anchorcenter[$n][1] = $anchorXY[1] + $n * 16
		Next
	Else
		MsgBox(0, "Debug Msgbox", "arrowicontextinv.bmp not found, exiting", 0, $handle) ;Debug
        Sleep(100)
        _Exit()
	EndIf
	FindImage('damagetab.bmp', 0, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 4)
	If $imagefound[4] == 1 Then
			$anchordamage[0] = $anchorXY[0] ;x1
			$anchordamage[1] = $anchorXY[0] + 32 ;x2
	Else
		MsgBox(0, "Debug Msgbox", "damagetab.bmp not found, exiting", 0, $handle) ;Debug
        Sleep(100)
        _Exit()
	EndIf
	FindImage('itab.bmp', 0, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 1)
	If $imagefound[1] == 1 Then
			$anchorimprove[0] = $anchorXY[0] ;x1
			$anchorimprove[1] = $anchorXY[0] + 21 ;x2
	Else
		MsgBox(0, "Debug Msgbox", "itab.bmp not found, exiting", 0, $handle) ;Debug
        Sleep(100)
        _Exit()
	EndIf
	;_ArrayDisplay($anchor) ;Debug
	;_ArrayDisplay($anchorcenter) ;Debug
	;MsgBox(0, "Debug Msgbox", "Anchor Set Initialized", 0, $handle) ;Debug
EndFunc   ;==>AnchorSet

Func Toolbelt($slot)
	If $slot == $prev Then
		Sleep(_Random_Gaussian(50,3,1))
	Else
		Sleep(_Random_Gaussian(50,5,1))
		Send($slot)
		$prev = $slot
		Sleep(_Random_Gaussian(300,30,1))
	EndIf
EndFunc   ;==>Toolbelt


;====================================Specific Functions================================================
;Planned Functions like lump reheater, and BSB funtionality will go here


;=========================================Main Loop====================================================

Func MainLoop()
	Switch $running
		Case 1
			FindStamina()
			If $stamina == 1 Then
				FindImage('arrowicontextinv.bmp', 0, 0, 0, @DesktopWidth, @DesktopHeight, $a, 5)
				Sleep(50)
				If $imagefound[5] == 1 Then
					MouseMove($a[0] - 7 + Random(-2, 2), $a[1] + 9 + Random(-2, 2), 13 + Random(-1, 1))
					Sleep(_Random_Gaussian(200,30,1))
					MouseClick("left")
					Sleep(_Random_Gaussian(200,30,1))
					Resort(2)
					For $m = 0 To $actions - 1
						FindImage('carvingknifeicon.bmp', 1, $anchorimprove[0], $anchor[$m][1] + 16, $anchorimprove[1], $anchor[$m][1] + 33, $a, 7)
						Sleep(50)
						If $imagefound[7] == 1 Then
							Sleep(50)
							MouseMove($anchorcenter[$m][0] + 16 + Random(-3, 3), $anchorcenter[$m][1] + 16 + Random(-2, 2), 13 + Random(-1, 1))
							Sleep(_Random_Gaussian(200, 30, 1))
							Toolbelt(1)
							Sleep(_Random_Gaussian(200, 30, 1))
							Send($improvebind)
							Sleep(_Random_Gaussian(160, 30, 1))
						ElseIf $imagefound[7] == 0 Then
							MsgBox(0, "Debug Msgbox", "carvingknifeicon.bmp not found", 0, $handle) ;Debug
							$running = 0
						EndIf
						Sleep(_Random_Gaussian(150, 30, 1))
					Next
					Sleep(10000)
					Equipped()
					AntiRand()
					FindImage('arrowicontextinv.bmp', 1, 0, 0, @DesktopWidth, @DesktopHeight, $a, 5)
					If $imagefound[5] == 1 Then
						MouseClickDrag("left", $a[0] + Random(-1, 1), $a[1] + Random(-1, 1), $BSBLoc[0] + Random(-7, 7), $BSBLoc[1] + Random(-7, 7), 12 + Random(-1, 1))
						$running = 1
						Sleep(_Random_Gaussian(3400, 110, 1))
					ElseIf $imagefound[5] == 0 Then
						Sleep(50)
						$running = 0
						MsgBox(0, "Debug Msgbox", "Something got really fucked up", 0, $handle) ;Debug
					EndIf
				ElseIf $imagefound[5] == 0 Then
					FindImage('maxinv.bmp', 0, 0, 0, @DesktopWidth, @DesktopHeight, $a, 8)
					Sleep(50)
					If $imagefound[8] == 1 Then
						$running = 0
						MsgBox(0, "Debug Msgbox", "Didn't BSB arrows, please reset", 0, $handle) ;Debug
					ElseIf $imagefound[8] == 0 Then
						FindImage('arrowicontextbsb.bmp', 1, 0, 0, @DesktopWidth, @DesktopHeight, $a, 6)
						If $imagefound[6] == 1 Then
							MouseClickDrag("left", $a[0] + Random(-1, 1), $a[1] + Random(-1, 1), $InvLoc[0] + Random(-7, 7), $InvLoc[1] + Random(-7, 7), 12 + Random(-1, 1))
							Sleep(_Random_Gaussian(2250, 80, 1))
							Send("{enter}")
							$running = 1
							Sleep(_Random_Gaussian(2700, 120, 1))
						ElseIf $imagefound[6] == 0 Then
							$running = 0
							MsgBox(0, "Debug Msgbox", "Couldn't find BSB arrows", 0, $handle) ;Debug
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
AnchorSet()
While (1)
	MainLoop()
WEnd