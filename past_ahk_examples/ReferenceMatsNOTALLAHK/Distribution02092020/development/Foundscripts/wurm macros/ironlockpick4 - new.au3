 #include <Misc.au3>
 
    HotKeySet("{[}", "MakeLock")
    HotKeySet("{z}", "Start")
    HotKeySet("{ESC}", "_Exit")
    HotKeySet("{x}", "SetLockLocation")
	 HotKeySet("{c}", "altarlocation")
	 	 HotKeySet("{v}", "altaropen")
		 	 	 HotKeySet("{b}", "lockpick")
 
    $handle = WinGetHandle("Wurm Online", "")
 
    Global $running=0
    Global $lockLoc
	    Global $truealtarloc
		    Global $openaltarloc
    Global $setlockLoc=0
	 Global $altarLoc=0
	 Global $altaropen=0
	 global $pickloc=0
	 global $truepickloc
 
    Func _Exit()
    Exit
 EndFunc   ;==>_Exit
 
 Func altaropen()
		       MsgBox(0, "", "Click on the open altar")
	       $altaropen=1
 EndFunc
 
 func lockpick()
		       MsgBox(0, "", "Click on the lockpicks")
	       $pickloc=1	
	EndFunc
 Func altarlocation()
	       MsgBox(0, "", "Click on the altar")
	       $altarLoc=1	
 EndFunc
 
 
    Func SetLockLocation()
       MsgBox(0, "", "Click on the small anvil")
       $setlockLoc=1
    EndFunc
	
    Func Sacrafice()
   MouseMove($truepickloc[0], $truepickloc[1],0)
   Sleep(75)
   Mousedown("Left")
   sleep(50)
   Mousemove($openaltarloc[0], $openaltarloc[1],0)
   sleep(50)
   mouseup("Left")
   sleep(1000)
   Mousemove($truealtarloc[0], $truealtarloc[1],0)
   sleep(100)
          MouseClick("right")
       Sleep(2000)
       $line = GetLine()
       If IsArray($line) Then
              MouseMove($line[0], $line[1]+128, 0)
              Sleep(200)
              MouseClick("left")
		   EndIf
		   Sleep(35000)
		   
	EndFunc
	
	
	
    Func MakeLock()
       $start = MouseGetPos()
       MouseClick("right")
       Sleep(25)
       $line = GetLine()
       If IsArray($line) Then
              MouseMove($line[0], $line[1]+40, 0)
              Sleep(200)
              MouseMove($line[0]+180, $line[1]+40, 0)
              Sleep(200)
              MouseMove($line[0]+180, $line[1]+54, 0)
              Sleep(200)
              MouseMove($line[0]+300, $line[1]+54, 0)
              Sleep(200)
              MouseMove($line[0]+300, $line[1]+100, 50)
              Sleep(500)
              MouseClick("left")
       EndIf
       MouseMove($start[0], $start[1],0)
       Sleep(250)
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
              $lockLoc = MouseGetPos()
              $setlockLoc=0
              MsgBox(0, "", "Position set.")
		   EndIf
		          if _IsPressed("01") And $altarLoc==1 Then
              $truealtarloc = MouseGetPos()
              $altarLoc=0
              MsgBox(0, "", "Position set.")
		   EndIf
		          if _IsPressed("01") And $altaropen==1 Then
              $openaltarloc = MouseGetPos()
              $altaropen=0
              MsgBox(0, "", "Position set.")
			  EndIf
			  		          if _IsPressed("01") And $pickloc==1 Then
              $truepickloc = MouseGetPos()
              $pickloc=0
              MsgBox(0, "", "Position set.")
       EndIf
       if $running==1 Then
		  For $i = 0 To 14 Step 1
		  Local $random = Random(32000, 33000, 1)
		  Local $random2 = Random(9000, 10000, 1)
              MouseMove($lockLoc[0], $lockLoc[1], 0)
              MakeLock()
              Sleep($random2)
              MouseMove($lockLoc[0], $lockLoc[1], 0)
              MakeLock()
			  MouseMove($lockLoc[0], $lockLoc[1], 0)
              MakeLock()
			  sleep(7000)
			  MouseMove($lockLoc[0], $lockLoc[1], 0)
			  MakeLock()
			  sleep(500)
			  MouseMove($lockLoc[0], $lockLoc[1], 0)
              MakeLock()
			  Sleep(5000)
			  MouseMove($lockLoc[0], $lockLoc[1], 0)
			  MakeLock()
              Sleep($random)

		   Next
		   			  Sacrafice()
       EndIf
       Sleep(10)
    WEnd