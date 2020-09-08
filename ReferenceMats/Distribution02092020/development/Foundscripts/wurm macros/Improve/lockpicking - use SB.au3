 #include <Misc.au3>
 #include <ImageSearch.au3>
  HotKeySet("{PAUSE}", "TogglePause")
    HotKeySet("{z}", "Start")
    HotKeySet("{ESC}", "_Exit")
    HotKeySet("{x}", "SetLockLocation")
   HotKeySet("{c}", "lowerright")
   HotKeySet("{v}", "randomitem")
   HotKeySet("{b}", "lumplocationinv")
   HotKeySet("{n}", "lumplocationforge")
   HotKeySet("{m}", "settimer")
    $handle = WinGetHandle("Wurm Online", "")   

  Global $Paused
    Global $running=0
	global $randomspot=0
    Global $ulsearch=0
	Global $lrsearch=0
    Global $setlockLoc=0
	global $lowerrightvar=0
	global $x1
	global $y1
	global $xx
	global $yy
 global $randombs
   global $inventory=0
   global $forge=0
   global $invlocation=0
   global $forgelocation=0
   global $getiron=0
   global $timerr=0
   global $length
   global $lengthms=30000
   global $sleepticker=0
    Func _Exit()
    Exit
    EndFunc   ;==>_Exit
 
   Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Script is "Paused"',0,0)
    WEnd
    ToolTip("")
 EndFunc
 
 Func settimer()
$timerr=1
 EndFunc
 
 Func Drink()
   			mousemove($waterloc[0],$waterloc[1],2)
			sleep(100)
    $start = MouseGetPos()
       MouseClick("right")
       Sleep(1000)
       $line = GetLine()
       If IsArray($line) Then
		  Local $random2 = Random(200, 400, 1)
              MouseMove($line[0], $line[1]+40, 0)
              Sleep($random2+61)
              MouseClick("left")
       EndIf
       MouseMove($start[0], $start[1],0)
       Sleep(250)
	EndFunc
	
   Func lumplocationinv()
	  MsgBox(0, "", "loc of first lockpick")
	 $inventory=1 
  EndFunc
  
  Func lumplocationforge()
		  MsgBox(0, "", "water")
$forge=1
EndFunc
  
  
    Func SetLockLocation()
       MsgBox(0, "", "upper left skilltab")
       $setlockLoc=1
    EndFunc
	
	 Func lowerright()
       MsgBox(0, "", "lowerright skilltab")
       $lowerrightvar=1
    EndFunc
	
		 Func randomitem()
       MsgBox(0, "", "click on the door")
       $randombs=1
    EndFunc
 


    Func Improveiron()
				MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{1}")
			 Sleep(75)
			  Send("{i}")
			  				  sleep(50)
			  Send("{r}")
			  sleep(100)
			   mousemove($randomspot[0],$randomspot[1],2)
			   sleep(25)
			   mouseclick("left")
			  sleep(Random(8500, 9000))
		   EndFunc
		   
   Func checktimer()
	  Local $time = TimerDiff($timer)
	  if $time > $lengthms Then
		 Exit
	  EndIf
   EndFunc
   
   func Lockpick()
	  	  MouseMove($invlocation[0], $invlocation[1], 5)
	  MouseClick("left")
	  Sleep(100)
	  MouseClick("left")
	  sleep(200)
			   mousemove($randomspot[0],$randomspot[1],2)
			   sleep(100)
	  MouseClick("right")
   Sleep(1000)
   $line = GetLine()
   If IsArray($line) Then
	  		  Local $random2 = Random(200, 400, 1)
               MouseMove($line[0], $line[1]+40, 0)
              Sleep($random2+61)
              MouseClick("left")
          Sleep($random2)
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
 
    While (1)
	          if _IsPressed("01") And $setlockLoc==1 Then
              $ulsearch = MouseGetPos()
              $setlockLoc=0
			  Beep(1400, 500)
		   EndIf
		   
		     if _IsPressed("01") And $lowerrightvar==1 Then
			  $lrsearch = MouseGetPos()
              $lowerrightvar=0
			  Beep(1400, 500)
		   EndIf
		 if _IsPressed("01") And $randombs==1 Then
			  $randomspot = MouseGetPos()
              $randombs=0
			  Beep(1400, 500)
		   EndIf
		   		 if _IsPressed("01") And $inventory==1 Then
			  $invlocation = MouseGetPos()
              $inventory=0
			  Beep(1400, 500)
		   EndIf
		   		 if _IsPressed("01") And $forge==1 Then
			  $waterloc = MouseGetPos()
              $forge=0
			  Beep(1400, 500)
		   EndIf
		   
       if $running==1 Then
							  Beep(1400, 500)  
		global $timer = TimerInit()
		local $wait=1
	While $wait=1
	   	  Local $time = TimerDiff($timer)
		  if $time > 610000 Then
			 
			   Local $picksearch=1
			Local $startpicking=1
			While $startpicking=1
			   sleep(8000)
			   if $sleepticker=0 Then
				  Send("{Enter}")
				  sleep(100)
				  				  Send("/fsleep")
								  sleep(100)
								  				  Send("{Enter}")
												  sleep(50)
				  $sleepticker=1
				  sleep(300)
			   EndIf
			   
			   Lockpick()
			   sleep(26000)
			$picksearch = _ImageSearchArea("lockpicking.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $picksearch=1 Then
           $startpicking=0
		   $wait=0
		   sleep(100)
		   Drink()
		   if $sleepticker=2 Then
				  Send("{Enter}")
				  sleep(100)
				  				  Send("/fsleep")
								  sleep(100)
								  				  Send("{Enter}")
												  sleep(50)
												  						   $sleepticker=0
						   EndIf

		   if $sleepticker=1 Then
			  $sleepticker=2
		   EndIf
		   
		   
		   sleep(100)
		 
			EndIf
		 WEnd
		 
				   EndIf

			WEnd

		  		 
       EndIf
       Sleep(10)
    WEnd