 #include <Misc.au3>
 #include <ImageSearch.au3>
 
    HotKeySet("{[}", "MakeLock")
    HotKeySet("{z}", "Start")
    HotKeySet("{ESC}", "_Exit")
    HotKeySet("{x}", "SetLockLocation")
   HotKeySet("{c}", "lowerright")
   HotKeySet("{v}", "randomitem")
      HotKeySet("{m}", "bsb")
	    HotKeySet("{b}", "oarloca")
	  HotKeySet("{n}", "pluslocation")
	  	  HotKeySet("{w}", "waterlocation")
 
    $handle = WinGetHandle("Wurm Online", "")
 Global $oar=0
 Global $oarloc
    Global $running=0
	global $randomspot=0
    Global $ulsearch=0
	Global $lrsearch=0
    Global $setlockLoc=0
	global $lowerrightvar=0
	global $x1
	global $y1
 global $randombs
   global $inventory=0
   global $forge=0
   global $invlocation=0
   global $forgelocation=0
 global $xx
 global $yy
       Global $bsb=0
	          Global $water=0
			  global $waterloc
	  Global $bsbloc
	  global $plus=0
	  global $plusloc
	  
	 	  	Func waterlocation()
	          MsgBox(0, "", "water")
		 $water=1
	  EndFunc 
	  
	  	Func bsb()
	          MsgBox(0, "", "item in bsb")
		 $bsb=1
	  EndFunc
	  
	  Func oarloca()
       MsgBox(0, "", "inventory oar location")
       $oar=1
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
	
		  Func pluslocation()
       MsgBox(0, "", "plussign")
       $plus=1
    EndFunc
	
    Func _Exit()
    Exit
    EndFunc   ;==>_Exit
 
 		Func Drop()
	                           MouseMove($oarloc[0], $oarloc[1], 5)
                        MouseDown("left")
                        Sleep(250)
                        MouseMove($bsbloc[0], $bsbloc[1], 5)
                        MouseUp("left")
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
			  sleep(Random(7000, 7500))
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
			  sleep(Random(10300, 10500))
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
			  sleep(Random(7000, 7500))
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

func clickplus()
  mousemove($plusloc[0],$plusloc[1],2) 
   Sleep(100)
    MouseClick("left")
	sleep(1000)
	
   EndFunc
 Func Getfrombsb()
                          MouseMove($bsbloc[0], $bsbloc[1], 5)
                        MouseDown("left")
                        Sleep(100)
							  MouseMove($oarloc[0], $oarloc[1], 5)
							  Sleep(100)
							  MouseUp("left")
							  sleep(2500)
									Send("{3}")
									sleep(250)
									Send("{0}")
									sleep(250)
							  	   Send("{Enter}")
								   sleep(1000)
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
	          if _IsPressed("01") And $plus==1 Then
              $plusloc = MouseGetPos()
              $plus=0
              MsgBox(0, "", "plus loc loaded")
		   endif
		   
		   	          if _IsPressed("01") And $oar==1 Then
              $oarloc = MouseGetPos()
              $oar=0
              MsgBox(0, "", "oar loc loaded")
		   endif
		   
		   		   	          if _IsPressed("01") And $water==1 Then
              $waterloc = MouseGetPos()
              $water=0
              MsgBox(0, "", "water loc loaded")
		   endif
		   
       if _IsPressed("01") And $setlockLoc==1 Then
              $ulsearch = MouseGetPos()
              $setlockLoc=0
              MsgBox(0, "", "upper left set")
		   EndIf
			if _IsPressed("01") And $bsb==1 Then
              $bsbloc = MouseGetPos()
              $bsb=0
              MsgBox(0, "", "bsb loc loaded")
			  EndIf
		     if _IsPressed("01") And $lowerrightvar==1 Then
			  $lrsearch = MouseGetPos()
              $lowerrightvar=0
              MsgBox(0, "", "lower right set")
		   EndIf
		 if _IsPressed("01") And $randombs==1 Then
			  $randomspot = MouseGetPos()
              $randombs=0
              MsgBox(0, "", "random spot set")
		   EndIf
		   		 if _IsPressed("01") And $inventory==1 Then
			  $invlocation = MouseGetPos()
              $inventory=0
              MsgBox(0, "", "inventory location set")
		   EndIf
		   		 if _IsPressed("01") And $forge==1 Then
			  $forgelocation = MouseGetPos()
              $forge=0
              MsgBox(0, "", "forge location set")
       EndIf
       if $running==1 Then
		  


		  Getfrombsb()
		  sleep(500)
		  clickplus()
		  
		  
		    Local $carving=1
			While $carving=1
			$carving = _ImageSearchArea("carving.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $carving=1 Then
			Carving()
			Repair()
			EndIf
			WEnd
			
			Local $file=1
			While $file=1
			$file = _ImageSearchArea("file.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $file=1 Then
			File()
			Repair()
			EndIf
			wend
			
			Local $mallet=1
			While $mallet=1
			$mallet = _ImageSearchArea("mallet.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $mallet=1 Then
			Mallet()
			Repair()
			EndIf
		 wend
		 

		Drop()
sleep(500)


		 
       EndIf
       Sleep(10)
    WEnd