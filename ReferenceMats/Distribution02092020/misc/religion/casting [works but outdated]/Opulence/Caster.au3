#cs ==================================================================================================

	C  A  S  T  E  R    (  O  P  U  L  E  N  C  E  )
	blowing up corn
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
	Prays at an altar using a keybind when out of favor
	Withdraws and deposits corn from FSB
	Casts oppulence on corn
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
	-Equip your statuette
	-Ensure that the log path is correct
	-Enable faith updates in the client
	--------------------------------------------------------------------------------------------------
	Features:
	-OCR and Image detection
	-File reading
	-Randomization in mouse movements and timings
	-Anti-macro, based on Box-Muller polar transform gaussian RND
	--Normally distributed values around mean with a given standard deviation
	--------------------------------------------------------------------------------------------------
	Planned:
	-?
	--------------------------------------------------------------------------------------------------
	Version History
	-0.1 (New Beginnings)
	--Butchered from prayerscript

#ce ==================================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-----------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
HotKeySet("{]}", "FSBSetLoc") ;Sets the FSB location for corn dragging
HotKeySet("{[}", "InvSetLoc") ;Sets the Inventory location for corn dragging
HotKeySet("{\}", "AltarSetLoc")
Global $praybind = "{m}"
Global $actions = 3 ;set to the amount of actions wanted to be queued (base on mind logic and stamina use)
Global $cost = 10 ;favor cost or desired spell
Global $withdraw = 20 ;amount of corn to withdraw
Global $playername = ""
Global $user = ""

;-----------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $imagefound[4]
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions
Global $a[2] ;variable that is not needed for other functions
Global $b ;variable that is not needed for other functions
Global $FSBLoc[2]
Global $FSBLocSet = 0
Global $InvLoc[2]
Global $InvLocSet = 0
Global $AltarLoc[2]
Global $AltarLocSet = 0
Global $menu0[2] = [0, 0]
Global $menu1[2] = [0, 0]
Global $anchor[2]
Global $anchorcenter[2]
Global $anchorXY[2]
Global $running = 1
Global $stamina = 0
Global $spellcount = 0
Global $antimacro ;randomization variable
Global $file
Global $faith
Global $filepath
$filepath = "C:/Documents and Settings/" & $user & "/wurm/players/" & $playername & "/logs/_Skills." & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"

#cs
	Imagefound array [4]:
	0 - cornanchor.bmp
	1 - cornfsb.bmp
	2 - spellstext.bmp
	3 - opulencetext.bmp
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

Func _Random_Gaussian($nMean, $nSD, $iDP)
	;******************************************
	; Box-Muller polar transform gaussian RND
	;******************************************
	; $iMean = The mean of the distribution
	; $iSD = desired standard deviation
	; $iDP = data precision (d.p.)
	Do
		$nX = ((2 * Random()) - 1)
		$nY = ((2 * Random()) - 1)
		$nR = ($nX ^ 2) + ($nY ^ 2)
	Until $nR < 1
	$nGaus = ($nX * (Sqrt((-2 * (Log($nR) / $nR)))))
	Return StringFormat("%." & $iDP & "f", ($nGaus * $nSD) + $nMean)
EndFunc   ;==>_Random_Gaussian

Func FSBSetLoc()
	$FSBLoc = MouseGetPos()
	$FSBLocSet = 1
	TrayTip("", "FSB location has been set", 5)
EndFunc   ;==>FSBSetLoc

Func AltarSetLoc()
	$AltarLoc = MouseGetPos()
	$AltarLocSet = 1
	TrayTip("", "Altar location has been set", 5)
EndFunc   ;==>AltarSetLoc

Func InvSetLoc()
	$InvLoc = MouseGetPos()
	$InvLocSet = 1
	TrayTip("", "Inventory location has been set", 5)
EndFunc   ;==>InvSetLoc

Func SetLocations()
	If $InvLocSet == 0 Then
		TrayTip("", "Set the Inventory location ([) key", 5)
		Do
			Sleep(100)
		Until $InvLocSet == 1
	EndIf
	If $FSBLocSet == 0 Then
		TrayTip("", "Set the FSB location (]) key", 5)
		Do
			Sleep(100)
		Until $FSBLocSet == 1
	EndIf
	If $AltarLocSet == 0 Then
		TrayTip("", "Set the Altar location (\) key", 5)
		Do
			Sleep(100)
		Until $AltarLocSet == 1
	EndIf
EndFunc   ;==>SetLocations

Func Pray($z)
	$cm = MouseGetPos()
	If Abs($cm[0] - $AltarLoc[0]) Or Abs($cm[1] - $AltarLoc[1]) >= 10 Then
		MouseMove($AltarLoc[0] + Random(-7, 7), $AltarLoc[1] + Random(-7, 7), 14 + Random(-1, 1))
	EndIf
	Sleep(_Random_Gaussian(80, 5, 1))
	For $i = 0 to $actions - (1 + $z)
		Send($praybind)
		Sleep(_Random_Gaussian(300, 15, 1))
	Next
EndFunc   ;==>Pray

Func LineRead();
	$file = FileOpen($filepath)
	$line = FileReadLine($file, -1)
	If StringInStr($line, "Favor") Then
		;ConsoleWrite($line & @LF) ;Debug
		$pos = StringInStr($line, "to ") + 2
		;ConsoleWrite(String($pos) & @LF) ;Debug
		$faith = StringTrimLeft($line, $pos)
		ConsoleWrite($faith & @LF) ;Debug
	EndIf
	FileClose($filepath)
EndFunc   ;==>LineRead

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
				$amx = _Random_Gaussian(5000, 1000, 1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 20 To 23
				$amx = _Random_Gaussian(7000, 1200, 1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 30 To 32
				$amx = _Random_Gaussian(9000, 1500, 1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 40 To 41
				$amx = _Random_Gaussian(13000, 2000, 1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 50
				$amx = _Random_Gaussian(18000, 2500, 1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 60
				$amx = _Random_Gaussian(25000, 3000, 1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 70 To 71
				$amx = _Random_Gaussian(35000, 4000, 1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case 80 To 81
				$amx = _Random_Gaussian(45000, 5000, 1)
				TrayTip("", "Anti-Macro pause for " & Round($amx / 1000, 1) & " seconds", 5)
				Sleep($amx)
			Case Else
				Sleep(_Random_Gaussian(4000, 500, 1))
		EndSwitch
	ElseIf $running == 0 Then
		Sleep(100)
	EndIf
EndFunc   ;==>AntiRand

Func FindImage($bmpfilename, $centered, $fix1, $fiy1, $fix2, $fiy2, ByRef $foundv, $foundx)
    $imagefound[$foundx] = _ImageSearchArea($bmpfilename, $centered, $fix1, $fiy1, $fix2, $fiy2, $foundv[0], $foundv[1], 100)

	If $imagefound[$foundx] == 1 Then
	EndIf
EndFunc   ;==>FindImage

Func SpellCast()
	If $spellcount < $withdraw Then

			MouseMove($anchorcenter[$spellcount][0] + Random(-2, 2), $anchorcenter[$spellcount][1] + Random(-2, 2), 14 + Random(-1, 1))
			Sleep(_Random_Gaussian(15, 2, 1))
			MouseClick("right")
			Sleep(_Random_Gaussian(750, 20, 1))
			FindImage('spellstext.bmp', 1, 0, 0, @DesktopWidth, @DesktopHeight, $menu0, 2)
			If $imagefound[2] == 1 Then
				Sleep(_Random_Gaussian(50, 2, 1))
				MouseMove($menu0[0] + Random(-1, 1), $menu0[1] + Random(-1, 1), 14 + Random(-1, 1))
				Sleep(_Random_Gaussian(750, 20, 1))
				FindImage('opulencetext.bmp', 1, 0, 0, @DesktopWidth, @DesktopHeight, $menu1, 3)
				If $imagefound[3] == 1 Then
					Sleep(_Random_Gaussian(50, 2, 1))
					MouseMove($menu1[0] + Random(-2, 3), $menu0[1] + Random(-1, 1), 14 + Random(-1, 1))
					MouseMove($menu1[0] + Random(-1, 1), $menu1[1] + Random(-1, 1), 14 + Random(-1, 1))
					Sleep(_Random_Gaussian(170, 8, 1))
					MouseClick("left")
					$spellcount += 1
				Else
					MsgBox(0, "Debug Msgbox", "opulencetext.bmp not found", 0, $handle)
					Sleep(500)
					_Exit()
				EndIf
			Else
				MsgBox(0, "Debug Msgbox", "spellstext.bmp not found", 0, $handle)
				Sleep(500)
				_Exit()
			EndIf

	Else
		MouseMove($anchorcenter[0][0] + Random(-2, 2), $anchorcenter[0][1] + Random(-2, 2), 14 + Random(-1, 1))
		Sleep(_Random_Gaussian(80, 4, 1))
		Send("{ShiftDown}")
		Sleep(_Random_Gaussian(50, 2, 1))
		MouseClick("left")
		Sleep(_Random_Gaussian(25, 2, 1))
		MouseMove($anchorcenter[$withdraw][0] + Random(-2, 2), $anchorcenter[$withdraw][1] + Random(-2, 2), 14 + Random(-1, 1))
		Sleep(_Random_Gaussian(80, 4, 1))
		MouseClick("left")
		Sleep(_Random_Gaussian(50, 2, 1))
		Send("{ShiftUp}")
		Sleep(_Random_Gaussian(80, 4, 1))
		MouseClickDrag("left", $anchorcenter[0][0] + Random(-2, 2), $anchorcenter[0][1] + Random(-2, 2), $FSBLoc[0] + Random(-6, 6), $FSBLoc[1] + Random(-6, 6), 14 + Random(-1, 1))
		Sleep(_Random_Gaussian(950, 25, 1))
		FindImage('cornfsb.bmp', 1, 0, 0, @DesktopWidth, @DesktopHeight, $menu1, 1)
		If $imagefound[1] == 1 Then
			Sleep(_Random_Gaussian(80, 4, 1))
			MouseClickDrag("left", $menu1[0] + Random(-2, 2), $menu1[1] + Random(-2, 2), $InvLoc[0] + Random(-6, 6), $InvLoc[1] + Random(-6, 6), 14 + Random(-1, 1))
			Sleep(_Random_Gaussian(180, 9, 1))
			Send("20")
			Sleep(_Random_Gaussian(80, 5, 1))
			Send("{enter}")
			$spellcount = 0

		Else
			MsgBox(0, "Debug Msgbox", "cornfsb.bmp not found", 0, $handle)
			Sleep(500)
			_Exit()
		EndIf
	EndIf
EndFunc   ;==>SpellCast

Func AnchorSet()
	Sleep(100)
	FindImage('cornanchor.bmp', 0, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 0)
	If $imagefound[0] == 1 Then
		For $n = 0 To $withdraw - 1
			$anchor[$n][0] = $anchorXY[0]
			$anchor[$n][1] = $anchorXY[1] + $n * 16
		Next
	Else
		MsgBox(0, "Debug Msgbox", "cornanchor.bmp not found, exiting", 0, $handle) ;Debug
		Sleep(100)
		_Exit()
	EndIf
	FindImage('cornanchor.bmp', 1, 0, 0, @DesktopWidth, @DesktopHeight, $anchorXY, 0)
	If $imagefound[0] == 1 Then
		For $n = 0 To $withdraw - 1
			$anchorcenter[$n][0] = $anchorXY[0]
			$anchorcenter[$n][1] = $anchorXY[1] + $n * 16
		Next
	Else
		MsgBox(0, "Debug Msgbox", "cornanchor.bmp not found, exiting", 0, $handle) ;Debug
		Sleep(100)
		_Exit()
	EndIf
	;_ArrayDisplay($anchor) ;Debug
	;_ArrayDisplay($anchorcenter) ;Debug
	;MsgBox(0, "Debug Msgbox", "Anchor Set Initialized", 0, $handle) ;Debug
EndFunc   ;==>AnchorSet

Func Setup()
	$running = 1
	Opt("WinTitleMatchMode", 2)
	$handle = WinGetHandle("Wurm Online 3")
	WinActivate($handle)
	$windim = WinGetClientSize($handle)
	;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
	;[0] is width, [1] is height
	$file = FileOpen($filepath)
	If $file = -1 Then
		MsgBox(0, "Error", "baka")
		_Exit()
	EndIf
	FileClose($filepath)
EndFunc   ;==>Setup

Func MainLoop()
	Switch $running
		Case 1
			LineRead()
			If Number($faith) > $cost Then
				FindStamina()
				If $stamina == 1 Then
					AntiRand()
					Spellcast()
					Sleep(_Random_Gaussian(700, 30, 1))
					Pray(1)
					Sleep(_Random_Gaussian(85000, 600, 1))
				ElseIf $stamina == 0 Then
					Sleep(500)
				EndIf
			Else
				FindStamina()
				If $stamina == 1 Then
					AntiRand()
					Pray(0)
					Sleep(15000)
					Equipped()
				ElseIf $stamina == 0 Then
					Sleep(500)
				EndIf
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