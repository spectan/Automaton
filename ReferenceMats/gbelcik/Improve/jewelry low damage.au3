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
			  sleep(Random(12500, 13000))
		   EndFunc
		   
   Func checktimer()
	  Local $time = TimerDiff($timer)
	  if $time > $lengthms Then
		 Exit
	  EndIf
   EndFunc
   
 
 Func Hammer()
				MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{3}")
			 Sleep(75)
			  Send("{i}")
			  				  sleep(50)
			  Send("{r}")
			  sleep(100)
			   mousemove($randomspot[0],$randomspot[1],2)
			   sleep(25)
			   mouseclick("left")
			  sleep(Random(9000, 9500))
		   EndFunc
		   
   Func Whetstone()
			MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{2}")
			 Sleep(75)
			  Send("{i}")
			  				  sleep(50)
			  Send("{r}")
			 sleep(100)
			   mousemove($randomspot[0],$randomspot[1],2)
			   sleep(25)
			   mouseclick("left")
			  sleep(Random(8000, 9000))
			 EndFunc
			 
	Func Temper()		 
			MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{5}")
			 Sleep(75)
			  Send("{i}")
			  				  sleep(50)
			  Send("{r}")
			  sleep(100)
			   mousemove($randomspot[0],$randomspot[1],2)
			   sleep(25)
			   mouseclick("left")
			  sleep(Random(14000, 15000))
			EndFunc
   
   Func Polish()
	  			MouseMove($x1, $y1, 20)
			 MouseClick("left")
			 sleep(50)
			 Send("{4}")
			 Sleep(75)
			  Send("{i}")
			  				  sleep(50)
			  Send("{r}")
			  sleep(100)
			   mousemove($randomspot[0],$randomspot[1],2)
			   sleep(25)
			   mouseclick("left")
			  sleep(Random(8000, 8500))
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
			 sleep(25)
			   mouseclick("left")
			sleep(4000)
			
			EndIf
			
		 EndFunc
		 
	Func Getiron()
		  MouseMove($forgelocation[0], $forgelocation[1], 5)
		  sleep(50)
		  MouseDown("left")
		  sleep(50)
		  MouseMove($invlocation[0], $invlocation[1], 5)
		  sleep(50)
		  MouseUp("left")
		  sleep(1000)
	   EndFunc
	   
   Func DropIron()
          MouseMove($invlocation[0], $invlocation[1], 5)
		  sleep(50)
		  MouseDown("left")
		  sleep(50)
		 MouseMove($forgelocation[0], $forgelocation[1], 5)
		  sleep(50)
		  MouseUp("left")
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
       if _IsPressed("01") And $setlockLoc==1 Then
              $ulsearch = MouseGetPos()
              $setlockLoc=0
			  Beep(1400, 500)
		   EndIf

			if $timerr==1 Then
		   $length = InputBox("HOW LONG TO RUN", "How many minutes to run? *TOOLBELT ORDER* 1=ore, 2=whetstone, 3=hammer, 4=polish, 5=water *BIND* I Improve/Finish and R repair *Z Starts*", 30)
	  $lengthms = $length * 60 * 1000
		global $timer = TimerInit()	
		 $timerr=0
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
			  $forgelocation = MouseGetPos()
              $forge=0
			  Beep(1400, 500)
       EndIf
       if $running==1 Then
			Local $iron=1
			$getiron=0
			While $iron=1
			$iron = _ImageSearchArea("gold.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $iron=1 Then
			If $getiron=0 Then
			GetIron()
			$getiron=1
			EndIf
			Improveiron()
			checktimer()
			EndIf
			WEnd
		  DropIron()
		  
		    Local $hammer=1
			While $hammer=1
			$hammer = _ImageSearchArea("hammer.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $hammer=1 Then
			Hammer()
			checktimer()
			EndIf
			WEnd
			
			Local $whetstone=1
			While $whetstone=1
			$whetstone = _ImageSearchArea("whetstone.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $whetstone=1 Then
			Whetstone()
			checktimer()
			EndIf
			wend
			
			Local $pelt=1
			While $pelt=1
			$pelt = _ImageSearchArea("pelt.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $pelt=1 Then
			Polish()
			checktimer()
			EndIf
			wend
			
			Local $water=1
			While $water=1
			$water = _ImageSearchArea("water.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $water=1 Then
			Temper()
		    checktimer()
			EndIf
			wend
		 
       EndIf
       Sleep(10)
    WEnd