#cs ==============================================================================================

M  E  N  U    T  E  S  T
Time to fart everywhere
~ Dissimulo scripts

--------------------------------------------------------------------------------------------------
Created on 21/09/2013
Last Modified 21/09/2013
Version 0.1
--------------------------------------------------------------------------------------------------
BY RUNNING THIS SCRIPT YOU UNDERSTAND THE WURM ONLINE RULES
AND THUS THE CONSEQUENCES OF USING THIS SCRIPT (b&)
-DO NOT MACRO AROUND OTHER PEOPLE!
-DO NOT LEAVE UNATTENDED!
-DO NOT MACRO FOR LONG PERIODS!
--------------------------------------------------------------------------------------------------
Overview:
Testing Menus with the use of BMPs, and sorting out mouse movement thru the menu
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
-OCR simple text
-Mouse movement logic
--------------------------------------------------------------------------------------------------
Planned:
-Make it work
--------------------------------------------------------------------------------------------------
Version History
-0.1 (Splashing in the water)
--Trying different techniques
#ce ==============================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
;-------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle
Global $windim
Global $stonebrick=0
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions
Global $running=1

Func _Exit()
  Exit
EndFunc

Func ScriptPauser()
   if $running==0 Then
     $running=1
     TrayTip("", "Macro started", 5)
   ElseIf $running==1 Then
     $running=0
     TrayTip("", "Macro stopped", 5)
   EndIf
EndFunc

Func FindImage($bmpfilename)
;Local $stamareawidth=$windim[0]/2 ;performance shit
;Local $stamareaheight=$windim[1]/2 ;performance shit
;MsgBox(0, "Stamina Area Debug", "Width: " & $stamareawidth & ", Height: " & $stamareaheight, 0, $handle) ;Debug
$stonebrick = _ImageSearchArea($bmpfilename,0,0,0,$windim[0],$windim[1],$x1,$y1,120)

	  If $stonebrick==1 Then
		 MsgBox(0, "Debug Msgbox", $bmpfilename & " found", 0, $handle) ;Debug
		 sleep(500)
      ElseIf $stonebrick==0 Then
		 MsgBox(0, "Debug Msgbox", $bmpfilename & " not found", 0, $handle) ;Debug
		 sleep(500)
	  EndIf


EndFunc

Func Setup()
   $running=1
   $handle = WinGetHandle("Wurm Online 3")
   WinActivate($handle)
   $windim = WinGetClientSize($handle)
   ;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
   ;[0] is width, [1] is height
EndFunc







Func MainLoop()
Switch $running
   Case 1

	  FindImage('stonebricktext.bmp')
   Case 0
	  While $running==0
		 Do
			sleep(200)
		 Until $running==1
	  WEnd
   Case Else
	  MsgBox(0, "Debug Msgbox", "Some shit got fucked up", 0, $handle) ;Debug
	  sleep(1000)
	  _Exit()
EndSwitch
EndFunc



;Main Procedure
Setup()
While (1)
   MainLoop()
WEnd