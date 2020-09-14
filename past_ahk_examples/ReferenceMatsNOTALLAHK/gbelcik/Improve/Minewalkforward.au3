 #include <Misc.au3>
 #include <ImageSearch.au3>
 
    HotKeySet("{[}", "MakeLock")
    HotKeySet("{z}", "Start")
    HotKeySet("{ESC}", "_Exit")
    HotKeySet("{c}", "SetLockLocation")
   HotKeySet("{v}", "lowerright")
    HotKeySet("{b}", "lumplocationforge")

    $handle = WinGetHandle("Wurm Online", "")
 Global $Dig_Amount
Global $Paused
Global $pos1 ; Dirt Location
Global $pos2 ; Drop Location
Global $pos3 ; Dirt random
Global $pos4 ; Drop Random
Global $running=0
    Global $running=0
	global $randomspot=0
    Global $ulsearch=0
	Global $lrsearch=0
    Global $setlockLoc=0
	global $lowerrightvar=0
	global $x1
	global $y1
	   global $forge=0
 global $randombs
   global $inventory=0
   global $forge=0
   global $invlocation=0
   global $forgelocation=0
 global $xx
 global $yy
   global $getiron=0
   
    Func _Exit()
    Exit
    EndFunc   ;==>_Exit
     Func GetLine()
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
	
Func Drink()
       $start = MouseGetPos()
	   sleep(10)
   			mousemove($waterloc[0],$waterloc[1],2)
			sleep(100)
       MouseClick("right")
       Sleep(1000)
       $line = GetLine()
       If IsArray($line) Then
		  Local $random2 = Random(200, 400, 1)
              MouseMove($line[0], $line[1]+72, 0)
              Sleep($random2+93)
              MouseClick("left")
       EndIf
       MouseMove($start[0], $start[1],0)
       Sleep(250)
	EndFunc
	
   Func lumplocationinv()
	  MsgBox(0, "", "Location where lump will be in inventory")
	 $inventory=1 
  EndFunc
  
  Func lumplocationforge()
		  MsgBox(0, "", "Location where lump will be in forge")
$forge=1
EndFunc
  
  
    Func SetLockLocation()
       MsgBox(0, "", "upper left")
       $setlockLoc=1
    EndFunc
	
	 Func lowerright()
       MsgBox(0, "", "lowerright")
       $lowerrightvar=1
    EndFunc
	
		 Func randomitem()
       MsgBox(0, "", "click on a random item to move the blue bullshit")
       $randombs=1
    EndFunc
 
    Func Logimp()
				MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{1}")
			 Sleep(75)
			  Send("{i}")
			  sleep(100)
			mousemove($randomspot[0],$randomspot[1],2)
			sleep(50)
			   mouseclick("left")
			  sleep(Random(13000, 14000))
    EndFunc
 
 Func Carving()
				MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{3}")
			 Sleep(75)
			  Send("{i}")
			  sleep(100)
			mousemove($randomspot[0],$randomspot[1],2)
			sleep(50)
			   mouseclick("left")
			  sleep(Random(7000, 8000))
		   EndFunc
		   
   Func File()
			MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{2}")
			 Sleep(75)
			  Send("{i}")
			 sleep(100)
			mousemove($randomspot[0],$randomspot[1],2)
			sleep(50)
			   mouseclick("left")
			  sleep(Random(9500, 10000))
			 EndFunc
			 
   
   Func Polish()
	  			MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{5}")
			 Sleep(75)
			  Send("{i}")
			  sleep(100)
			mousemove($randomspot[0],$randomspot[1],2)
			sleep(50)
			   mouseclick("left")
			  sleep(Random(10000, 10500))
			EndFunc
			
			 Func Mallet()
				MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{4}")
			 Sleep(75)
			  Send("{i}")
			  sleep(100)
			mousemove($randomspot[0],$randomspot[1],2)
			sleep(50)
			   mouseclick("left")
			  sleep(Random(7000, 8000))
		   EndFunc
		   
		   Func Repair()
			local $repair=1
			$repair = _ImageSearchArea("repair.bmp",1,$x1-200,$y1-15,$x1,$y1+15,$xx,$yy,50)
			If $repair=0 Then
				MouseMove($x1, $y1, 20)
				 sleep(50)
				  MouseClick("left")
				  sleep(50)
			  Send("{r}")
			  sleep(75)
			  mousemove($randomspot[0],$randomspot[1],2)
			sleep(50)
			   mouseclick("left")
			sleep(4000)
			
			EndIf
			
			EndFunc


  Func Dig()
	  Local $digpause = Random(22000, 23000, 1)
	   Sleep(10)
	   Send("{k}")
	   	   Sleep(10)
	   Send("{k}")

	   Sleep($digpause)
			Local $iron=0
			$iron = _ImageSearchArea("wallbreak.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $iron=1 Then
			  Drink()
						sleep(4000)
							   Send("{x}")
							   sleep(5000)
							   	   Send("{x}")
								   sleep(100)
			EndIf
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
 
 
    While (1)
	   		   		 if _IsPressed("01") And $forge==1 Then
			  $waterloc = MouseGetPos()
              $forge=0
			  Beep(1400, 500)
		   EndIf
       if _IsPressed("01") And $setlockLoc==1 Then
              $ulsearch = MouseGetPos()
              $setlockLoc=0
              MsgBox(0, "", "upper left set")
		   EndIf
		     if _IsPressed("01") And $lowerrightvar==1 Then
			  $lrsearch = MouseGetPos()
              $lowerrightvar=0
              MsgBox(0, "", "lower right set")
		   EndIf
	
       if $running==1 Then
Sleep(10)		
Dig()
sleep(10)

       EndIf
       Sleep(10)
    WEnd