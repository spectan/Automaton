#cs ==============================================================================================

D  o  u  b  l  e    D  i  g  g  e  r
The Tryfean Tar Excavator
~ Dissimulo scripts

--------------------------------------------------------------------------------------------------
Created on 17/09/2013
Last Modified 20/09/2013
Version 0.1 (Bare Bones)
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
-More debug/failsafes
-Using Image Search:
--Combat tab recognition
--"Full inventory" detection (as a failsafe)
--PM detection
-Optimization
--Smaller search areas
--Tweaked sleep times
-Rolfs 'Soon^TM' (chance of happening from most to least)
--GUI menu (if needed)
--Testing OCR to gauge compatability with wurm
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
#ce ==============================================================================================

#include <Misc.au3>
#include <ImageSearch.au3>

;-------------------------------------------------------------------------------------------------
;Modify THESE:
HotKeySet("{;}", "ScriptPauser") ;pauses the program
HotKeySet("{ESC}", "_Exit") ;terminates the program
$digbind = "{m}" ;remember to 'bind *key* dig' in console
Global $actions=5 ;set to the amount of actions wanted to be queued

;-------------------------------------------------------------------------------------------------
;Don't touch anything from here on out
Global $handle 
Global $windim
Global $pos1
Global $pos2
Global $pos3
Global $stamina=0
Global $antimacro
Global $running=1
Global $x1 ;variable that is not needed for other functions
Global $y1 ;variable that is not needed for other functions

Func GetLine() ;not needed in this digging shit
   $pos = MouseGetPos()
   $samp = $pos
   For $i = 0 To 48 Step 1
          $samp[0] = $pos[0]+32
          $samp[1] = $pos[1]+$i
          $s0 = PixelGetColor($samp[0], $samp[1], $handle)
          If $s0 == 0xFFFFFF Then
                 $s1 = PixelGetColor($samp[0]+1, $samp[1], $handle)
                 If $s1 == 0xFFFFFF Then
                        $s2 = PixelGetColor($samp[0]+2, $samp[1], $handle)
                        $s3 = PixelGetColor($samp[0]+3, $samp[1], $handle)
                        If $s2 == 0xFFFFFF AND $s3 == 0xFFFFFF Then
                        $line = $samp
                        ExitLoop
                 EndIf
                 EndIf
          EndIf
          $line = 0
   Next
   Return $line
EndFunc

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

Func Setup()
   $running=1
   $handle = WinGetHandle("Wurm Online 3")
   WinActivate($handle)
   $windim = WinGetClientSize($handle)
   ;MsgBox(0, "Active window's client size is:", "Width: " & $windim[0] & ", Height: " & $windim[1], 0, $handle) ;Debug
   ;[0] is width, [1] is height
   MouseMove(@DesktopWidth/2, @DesktopHeight/2, 15)
EndFunc

Func FindStamina()
;Local $stamareawidth=$windim[0]/2 ;performance shit
;Local $stamareaheight=$windim[1]/2 ;performance shit
;MsgBox(0, "Stamina Area Debug", "Width: " & $stamareawidth & ", Height: " & $stamareaheight, 0, $handle) ;Debug

$stamina = _ImageSearchArea("stamfull.bmp",0,0,0,$windim[0],$windim[1],$x1,$y1,10)   
EndFunc

Func Equipped()
  FindStamina()
	  If $stamina==1 Then
		 TrayTip("", "Tool not equiped, pausing...", 5) ;Debug
		 $running=0
      ElseIf $stamina==0 Then
		 ;MsgBox(0, "Debug Msgbox", "Tool equipped", 0, $handle) ;Debug
		 sleep(50)
	  EndIf
EndFunc	  

Func AntiRand() ;20/100 chance of triggering a significant wait after the stamina bar refills
Local $amx ;Anti Macro x  
If $running==1 Then
   Switch $antimacro
	  Case 10 to 14
		 While $stamina==0 
			FindStamina()
			sleep(200)
		 WEnd
		 $amx = Random(4500, 6500)
		 TrayTip("", "Anti-Macro pause for " & round($amx/1000) & " seconds", 5)
		 Sleep($amx)
	  Case 20 to 23
		 While $stamina==0 
			FindStamina()
			sleep(200)
		 WEnd
		 $amx = Random(5500, 7500)
		 TrayTip("", "Anti-Macro pause for " & round($amx/1000) & " seconds", 5)
		 Sleep($amx)
	  Case 30 to 32
		 While $stamina==0 
			FindStamina()
			sleep(200)
		 WEnd
		 $amx = Random(6500, 9500)
		 TrayTip("", "Anti-Macro pause for " & round($amx/1000) & " seconds", 5)
		 Sleep($amx)
	  Case 40 to 41
		 While $stamina==0 
			FindStamina()
			sleep(200)
		 WEnd
		 $amx = Random(7500, 11500)
		 TrayTip("", "Anti-Macro pause for " & round($amx/1000) & " seconds", 5)
		 Sleep($amx)
	  Case 50
		 While $stamina==0 
			FindStamina()
			sleep(200)
		 WEnd
		 $amx = Random(8500, 12500)
		 TrayTip("", "Anti-Macro pause for " & round($amx/1000) & " seconds", 5)
		 Sleep($amx)
	  Case 60
		 While $stamina==0 
			FindStamina()
			sleep(200)
		 WEnd
		 $amx = Random(9500, 13500)
		 TrayTip("", "Anti-Macro pause for " & round($amx/1000) & " seconds", 5)
		 Sleep($amx)
	  Case 70 to 71
		 While $stamina==0 
			FindStamina()
			sleep(200)
		 WEnd
		 $amx = Random(15500, 34500)
		 TrayTip("", "Anti-Macro pause for " & round($amx/1000) & " seconds", 5)
		 Sleep($amx)
	  Case 80 to 81
		 While $stamina==0 
			FindStamina()
			sleep(200)
		 WEnd
		 $amx = Random(41500, 60500)
		 TrayTip("", "Anti-Macro pause for " & round($amx/1000) & " seconds", 5)
		 Sleep($amx)
	  Case Else
		 Sleep(Random(2000, 3500))
   EndSwitch
ElseIf $running==0 Then
   Sleep(100)
EndIf   
EndFunc 

Func MainLoop()
Switch $running
   Case 1
	  Local $i=0
	  FindStamina()
	  If $stamina==1 Then
		 ;MsgBox(0, "Debug Msgbox", "Stamina Bar full, Found at: " & $x1 & ", " & $y1, 0, $handle) ;Debug
		 $stamina=0
		 Sleep(Random(500) + 1000)
		 Do
			Send($digbind)
			$i += 1
			Sleep(random(250, 350))
		 Until $i == $actions
		 Sleep(6000)
		 Equipped()
		 $antimacro=Ceiling(Random(100))
		 AntiRand()
      ElseIf $stamina==0 Then
		 ;MsgBox(0, "Debug Msgbox", "Stamina Bar not full/found", 0, $handle) ;Debug
		 sleep(500)
	  EndIf
   Case 0
	  While $running==0
		 Do
			sleep(100)
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
