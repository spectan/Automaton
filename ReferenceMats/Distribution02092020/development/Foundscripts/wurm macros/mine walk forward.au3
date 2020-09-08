HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("{b}", "SetDirtLocation")
HotKeySet("{n}", "SetDropLocation")
HotKeySet("{m}", "Start")

Global $Dig_Amount
Global $Paused
Global $pos1 ; Dirt Location
Global $pos2 ; Drop Location
Global $pos3 ; Dirt random
Global $pos4 ; Drop Random
Global $running=0


 Func SetDirtLocation()
       $pos1 = MouseGetPos()
   EndFunc

    Func SetDropLocation()
       $pos2 = MouseGetPos()
   EndFunc



   Func Dig()
	  Local $digpause = Random(30000, 32000, 1)
	   Sleep(10)
	   Send("{k}")
	   	   Sleep(10)
	   Send("{k}")

	   Sleep($digpause)
   EndFunc

   Func Drop()
	   MouseMove($pos1[0], $pos1[1], 5)
	   MouseDown("left")
	   Sleep(100)
	   MouseMove($pos2[0], $pos2[1], 5)
	   MouseUp("left")
	   Sleep(100)
	EndFunc

 Func Start()
       if $running==0 Then
              $running=1
              TrayTip("", "Macro started", 5)
       ElseIf $running==1 Then
              $running=0
              TrayTip("", "Macro stopped", 5)
       EndIf
   EndFunc

Local $i = 0
While (1)
	if $running==1 Then
		
	for $i = 1 to 5 Step 1
	   
                           Dig()
						   
						Next
						sleep(50)
							   Send("{x}")
							   sleep(5000)
							   	   Send("{x}")
								   sleep(100)
EndIf
Sleep(10)
	WEnd

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Script is "Paused"',0,0)
    WEnd
    ToolTip("")
	EndFunc

Func Terminate()
    Exit 0
EndFunc