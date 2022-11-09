#cs ==================================================================================================

	L  O  G    R  E  A  D  E  R    T  E  S  T    S  C  R  I  P  T
	readings for nerds
	~ Dissimulo scripts

	--------------------------------------------------------------------------------------------------
	Created on 25/02/2014
	Last Modified 25/02/2014
	Version 0.1 (New Beginnings)
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

Global $playername = "Penor"
Global $user = "Tyrone"

;-----------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $file
Global $filepath
Global $running = 1
$filepath = "C:/Documents and Settings/" & $user & "/wurm/players/" & $playername & "/logs/_Event." & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"

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

Func LineRead();
	$file = FileOpen($filepath)
	$line = FileReadLine($file, -1)
	ConsoleWrite($line & @LF) ;Debug
	;If StringInStr($line, "Favor") Then
	;	ConsoleWrite($line & @LF) ;Debug
	;	$pos = StringInStr($line, "to ") + 2
	;	ConsoleWrite(String($pos) & @LF) ;Debug
	;	$faith = StringTrimLeft($line, $pos)
	;	ConsoleWrite($faith & @LF) ;Debug
	;EndIf
	FileClose($filepath)
EndFunc   ;==>LineRead

Func MainLoop()
	Switch $running
		Case 1
			LineRead()
			Sleep(500)
		Case 0
			SoundPlay('ding.wav')
			While $running == 0
				Do
					Sleep(200)
				Until $running == 1
			WEnd
		Case Else
			MsgBox(0, "Debug Msgbox", "Some shit got fucked up", 0) ;Debug
			Sleep(1000)
			_Exit()
	EndSwitch
EndFunc   ;==>MainLoop


;Main Procedure
While (1)
	MainLoop()
WEnd