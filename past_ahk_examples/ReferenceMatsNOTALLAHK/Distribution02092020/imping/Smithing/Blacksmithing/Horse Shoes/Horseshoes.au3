#cs ==================================================================================================

	H  O  R  S  E    S  H  O  E    I  M  P  E  R
	rare shoes to go fast
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 2/01/2016
	Last Modified 2/01/2016
	Version 0.1 (fantastics where)
	--------------------------------------------------------------------------------------------------
	BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
	AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
	-DO NOT MACRO AROUND OTHER PEOPLE!
	-DO NOT LEAVE UNATTENDED!
	-DO NOT MACRO FOR LONG PERIODS!
	--------------------------------------------------------------------------------------------------
	Overview:
	Improves Horse Shoes
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
	-A decent amount of items you want imped of the same kind exactly (15+ recommended)
	--------------------------------------------------------------------------------------------------
	Features:
	-Stamina Bar Checker (ensures Stamina bar is full before queing actions)
	-Anti Macro, normally distributed sleeps (gives the amount of seconds paused as a tray tip)
	-Pausing
	-Ensures a tool is equiped, pauses if not
	-Toolbelt use
	-Repairing
	-QL resorting (imps lowest items)
	-Lump heat alerter
	-Some debug/failsafes
	--------------------------------------------------------------------------------------------------
	Smithing Stoppers:
	If your script stops due to the smithing stopper message, check the following:
	- Lump heat (switch/heat lump)
	- Item heat (forge fuel)
	- Lump material
	- Tempering water amount
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
	--Smaller search areas (Partially Done)
	-Rolfs 'Soon^TM' (chance of happening from most to least likely)
	--GUI menu (if needed)
	--Setting the Wurm Client as the main screen for optimization (less are for image searching, etc)
	--Porting Simba SRL OCR functions
	--------------------------------------------------------------------------------------------------
	Version History
	-0.1 (Bare Bones)
	--Ported over imping framework

#ce ==================================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-----------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
$improvebind = "{i}" ;remember to 'bind *key* improve' in console
$repairbind = "{r}" ;remember to 'bind *key* repair' in console
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
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions
Global $a[2] ;variable that is not needed for other functions
Global $m ;variable that is not needed for other functions
Global $n ;variable that is not needed for other functions
Global $fix1 ;variable that is not needed for other functions
Global $fix2 ;variable that is not needed for other functions
Global $fiy1 ;variable that is not needed for other functions
Global $fiy2 ;variable that is not needed for other functions
Global $imagefound[10] ;Array for 'image', with x and y co-ordinate
Global $anchor[$actions][2] ;anchor, top left corner
Global $anchorcenter[$actions][2] ;anchor, center
Global $anchorXY[2] ;variable x y for anchor
Global $anchordamage[2] ;Array for damage tab dimensions
Global $anchorimprove[2] ;Array for i tab dimensions
Global $smithingstopper = 0


#cs
	Imagefound array [10]:
	- [0] QLtab.bmp
	- [1] Itab.bmp
	- [2] Zerodamagetext.bmp
	- [3] horseshoeicontext.bmp
	- [4] hammericon.bmp ;toolbelt slot 1
	- [5] whetstoneicon.bmp ;toolbelt slot 2
	- [6] pelticon.bmp ;toolbelt slot 3
	- [7] watericon.bmp ;toolbelt slot 4
	- [8] lumpicon.bmp ;toolbelt slot 5
	- [9] damagetab.bmp


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
	FindImage('QLtab.bmp', 1, 0, 0, @DesktopWidth,@DesktopHeight, $a, 0)
	If $imagefound[0] == 1 Then
		Sleep(_Random_Gaussian(50,5,1))
		MouseMove($a[0] + Random(-4, 4), $a[1] + Random(-4, 4), 13 + Random(-1, 1))
		For $m = 0 to $QLclicks - 1
		Sleep(_Random_Gaussian(200,30,1))
		MouseClick("left")
		Next
		Sleep(_Random_Gaussian(200,30,1))
	Else
		MsgBox(0, "Debug Msgbox", "QLtab.bmp not found, exiting", 0, $handle) ;Debug
        Sleep(100)
        _Exit()
	EndIf
EndFunc   ;==>Resort

Func FindDamage()
	Local $repaired = 0
	For $m = 0 to $actions - 1
		FindImage('ZeroDamageText.bmp', 1, $anchordamage[0], $anchor[$m][1], $anchordamage[1], $anchor[$m][1] + 16, $a, 2)
		Sleep(_Random_Gaussian(50,5,1))
		If $imagefound[2] == 1 Then
			Sleep(_Random_Gaussian(50,5,1))
		Else
			Sleep(_Random_Gaussian(150,25,1))
			MouseMove($anchorcenter[$m][0] + Random(-2, 2), $anchorcenter[$m][1] + Random(-1, 3), 13 + Random(-1, 1))
			Sleep(_Random_Gaussian(200,30,1))
			Send($repairbind)
			Sleep(_Random_Gaussian(200,30,1))
			$repaired =+ 1
		EndIf
	Next
	If $repaired <> 0 Then
		Sleep(_Random_Gaussian(1200,120,1) * $repaired)
	Else
		Sleep(_Random_Gaussian(50,5,1))
	EndIf
EndFunc   ;==>FindDamage

Func FindStamina()
    $stamina = _ImageSearchArea("stamfull.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 10)
EndFunc   ;==>FindStamina

Func FindImage($bmpfilename, $centered, $fix1, $fiy1, $fix2, $fiy2, ByRef $foundv, $foundx)
    $imagefound[$foundx] = _ImageSearchArea($bmpfilename, $centered, $fix1, $fiy1, $fix2, $fiy2, $foundv[0], $foundv[1], 30)

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
	FindImage('horseshoeicontext.bmp', 0, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 3)
	If $imagefound[3] == 1 Then
		For $n = 0 to $actions - 1
			$anchor[$n][0] = $anchorXY[0]
			$anchor[$n][1] = $anchorXY[1] + $n * 16
		Next
	Else
		MsgBox(0, "Debug Msgbox", "horseshoeicontext.bmp not found, exiting", 0, $handle) ;Debug
        Sleep(100)
        _Exit()
	EndIf
	FindImage('horseshoeicontext.bmp', 1, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 3)
	If $imagefound[3] == 1 Then
		For $n = 0 to $actions - 1
			$anchorcenter[$n][0] = $anchorXY[0]
			$anchorcenter[$n][1] = $anchorXY[1] + $n * 16
		Next
	Else
		MsgBox(0, "Debug Msgbox", "horseshoeicontext.bmp not found, exiting", 0, $handle) ;Debug
        Sleep(100)
        _Exit()
	EndIf
	FindImage('damagetab.bmp', 0, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 9)
	If $imagefound[9] == 1 Then
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

Func FindSmithingStoppers()
	Local $glowinghot, $toolittlematerial, $toolittlewater, $requiresan
	$glowinghot = _ImageSearchArea("glowinghot.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
	$toolittlematerial = _ImageSearchArea("toolittlematerial.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
	$toolittlewater = _ImageSearchArea("toolittlewater.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)
	$requiresan = _ImageSearchArea("requiresan.bmp", 0, 0, 0, @DesktopWidth, @DesktopHeight, $x1, $y1, 30)

	If $glowinghot or $toolittlematerial or $toolittlewater or $requiresan = 1 Then
		$smithingstopper = 1
	Else
		$smithingstopper = 0
	EndIf

EndFunc   ;==>FindSmithingStoppers


;=========================================Main Loop====================================================

Func MainLoop()
	Switch $running
		Case 1
			FindStamina()
			If $stamina == 1 Then
				;MsgBox(0, "Debug Msgbox", "Stamina Found", 0, $handle) ;Debug
				FindSmithingStoppers()
				If $smithingstopper = 0 Then
					FindDamage()
					Resort(2)
					AnchorSet()
					For $m = 0 To $actions - 1
						FindImage('hammericon.bmp', 1, $anchorimprove[0], $anchor[$m][1], $anchorimprove[1], $anchor[$m][1]+ 17, $a, 4)
						Sleep(50)
						If $imagefound[4] == 1 Then
							Sleep(50)
							MouseMove($anchorcenter[$m][0] + Random(-4, 4), $anchorcenter[$m][1] + Random(-2, 2), 14 + Random(-1, 1))
							Sleep(_Random_Gaussian(200, 30, 1))
							Toolbelt(1)
							Sleep(_Random_Gaussian(200, 30, 1))
							Send($improvebind)
							Sleep(_Random_Gaussian(120, 30, 1))
						Else
							FindImage('whetstoneicon.bmp', 1, $anchorimprove[0], $anchor[$m][1], $anchorimprove[1], $anchor[$m][1]+ 17, $a, 5)
							If $imagefound[5] == 1 Then
								Sleep(50)
								MouseMove($anchorcenter[$m][0] + Random(-4, 4), $anchorcenter[$m][1] + Random(-2, 2), 14 + Random(-1, 1))
								Sleep(_Random_Gaussian(200, 30, 1))
								Toolbelt(2)
								Sleep(_Random_Gaussian(200, 30, 1))
								Send($improvebind)
								Sleep(_Random_Gaussian(120, 30, 1))
							Else
								FindImage('pelticon.bmp', 1, $anchorimprove[0], $anchor[$m][1], $anchorimprove[1], $anchor[$m][1] + 17, $a, 6)
								If $imagefound[6] == 1 Then
									Sleep(50)
									MouseMove($anchorcenter[$m][0] + Random(-4, 4), $anchorcenter[$m][1] + Random(-2, 2), 14 + Random(-1, 1))
									Sleep(_Random_Gaussian(200, 30, 1))
									Toolbelt(3)
									Sleep(_Random_Gaussian(200, 30, 1))
									Send($improvebind)
									Sleep(_Random_Gaussian(120, 30, 1))
								Else
									FindImage('watericon.bmp', 1, $anchorimprove[0], $anchor[$m][1], $anchorimprove[1], $anchor[$m][1] + 17, $a, 7)
									If $imagefound[7] == 1 Then
										Sleep(50)
										MouseMove($anchorcenter[$m][0] + Random(-4, 4), $anchorcenter[$m][1] + Random(-2, 2), 14 + Random(-1, 1))
										Sleep(_Random_Gaussian(200, 30, 1))
										Toolbelt(4)
										Sleep(_Random_Gaussian(200, 30, 1))
										Send($improvebind)
										Sleep(_Random_Gaussian(120, 30, 1))
									Else
										FindImage('lumpicon.bmp', 1, $anchorimprove[0], $anchor[$m][1], $anchorimprove[1], $anchor[$m][1] + 17, $a, 8)
										If $imagefound[8] == 1 Then
											Sleep(50)
											MouseMove($anchorcenter[$m][0] + Random(-4, 4), $anchorcenter[$m][1] + Random(-2, 2), 14 + Random(-1, 1))
											Sleep(_Random_Gaussian(200, 30, 1))
											Toolbelt(5)
											Sleep(_Random_Gaussian(200, 30, 1))
											Send($improvebind)
											Sleep(_Random_Gaussian(120, 30, 1))
										Else
											MsgBox(0, "Debug Msgbox", "Some shit got fucked up", 0, $handle) ;Debug
											$running = 0
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						Sleep(_Random_Gaussian(150, 30, 1))
					Next
					Sleep(10000)
					Equipped()
					AntiRand()
				Else
					$running = 0
					TrayTip("", "Stopped by one of the smithing stoppers, please reset", 5)
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
			Sleep(100)
			_Exit()
	EndSwitch
EndFunc   ;==>MainLoop

;Main Procedure
Setup()
AnchorSet()
While (1)
	MainLoop()
WEnd