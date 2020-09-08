 #include <Misc.au3>
 #include <ImageSearch.au3>

    HotKeySet("{z}", "Start")
    HotKeySet("{ESC}", "_Exit")
    HotKeySet("{x}", "SetLockLocation")
   HotKeySet("{c}", "lowerright")

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
    Func _Exit()
    Exit
    EndFunc   ;==>_Exit

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
			  Send("!q")
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
			  Send("!q")
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
			  Send("!q")
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
			  Send("!q")
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
			  Send("!q")
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
              MsgBox(0, "", "upper left set")
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


			Local $log=1
			While $log=1
			$log = _ImageSearchArea("log.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $log=1 Then
			Logimp()
			Repair()
			EndIf
			WEnd

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

		 			Local $pelt=1
			While $pelt=1
			$pelt = _ImageSearchArea("pelt.bmp",1,$ulsearch[0],$ulsearch[1],$lrsearch[0],$lrsearch[1],$x1,$y1,50)
		   If $pelt=1 Then
			Polish()
			Repair()

			EndIf
			wend


       EndIf
       Sleep(10)
    WEnd