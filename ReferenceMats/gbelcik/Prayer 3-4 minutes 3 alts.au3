HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("{x}", "SetDirtLocation")
HotKeySet("{c}", "SetDropLocation")
HotKeySet("{v}", "three")
HotKeySet("{z}", "Start")

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
	
	    Func three()
       $pos3 = MouseGetPos()
   EndFunc



   Func Dig()
	  Local $digpause = Random(22000, 23000, 1)
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
			   MouseMove($pos1[0], $pos1[1], 5)
	   MouseClick("left")
	   				   			   	   	   Sleep(random(100,300))
				    MouseMove($pos1[0]+3, $pos1[1]+3, 5)
	   	   Sleep(random(100,300))
		   	   Send("{p}")
			   	   	   Sleep(random(100,300))
		   	   Send("{p}")
			   	   	   Sleep(random(100,300))
		   	   Send("{p}")
			   sleep(random(1000,2000))
			   	   MouseMove($pos2[0], $pos2[1], 5)
				   mouseclick("left")
				   			   	   	   Sleep(random(100,300))
				    MouseMove($pos2[0]+3, $pos2[1]+3, 5)
				   	   	   Sleep(random(100,300))
						    	   Send("{p}")
			   	   	   Sleep(random(100,300))
		   	   Send("{p}")
			   	   	   Sleep(random(100,300))
		   	   Send("{p}")
			   				   			   	   	   Sleep(random(100,300))
				    MouseMove($pos3[0]+3, $pos3[1]+3, 5)
				   	   	   Sleep(random(100,300))
						    	   Send("{p}")
			   	   	   Sleep(random(100,300))
		   	   Send("{p}")
			   	   	   Sleep(random(100,300))
		   	   Send("{p}")
			   Sleep(random(120000,180000))
			   
						   

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