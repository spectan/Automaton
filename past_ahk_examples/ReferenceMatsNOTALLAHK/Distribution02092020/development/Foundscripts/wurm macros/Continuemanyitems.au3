 #include <Misc.au3>
 
    HotKeySet("{[}", "MakeLock")
    HotKeySet("{z}", "Start")
    HotKeySet("{ESC}", "_Exit")
    HotKeySet("{x}", "Shafts")
   HotKeySet("{c}", "Heads")
    $handle = WinGetHandle("Wurm Online", "")
 Global $attach
 Global $finish
    Global $running=0
    Global $shaftLoc
	 Global $headLoc
    Global $shaft=0
	  Global $head=0
 Global $finishloc
    Func _Exit()
    Exit
    EndFunc   ;==>_Exit
 
    Func Shafts()
       MsgBox(0, "", "click on item used to improve")
       $shaft=1
    EndFunc
	
	    Func Heads()
       MsgBox(0, "", "Click on first item in list")
       $head=1
    EndFunc
 
    Func continue()
	  MouseMove($shaftloc[0], $shaftloc[1], 5)
	  MouseClick("left")
	  Sleep(100)
	  MouseClick("left")
	  sleep(200)
	  MouseMove($headloc[0], $headloc[1], 5)
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
       if _IsPressed("01") And $shaft==1 Then
              $shaftloc = MouseGetPos()
              $shaft=0
              MsgBox(0, "", "shaft loc loaded")
			  endif
			         if _IsPressed("01") And $head==1 Then
              $headloc = MouseGetPos()
              $head=0
              MsgBox(0, "", "head loc loaded")
       EndIf
       if $running==1 Then
		  Do
		   $attach = InputBox("attach", "How many components to attach per unfinished in list?", 10)
		Until Not StringRegExp($attach, '[:alpha:]')
		  Do
		   $finish = InputBox("howmanyitems", "how many items are you finishing?", 10)
		Until Not StringRegExp($finish, '[:alpha:]')
				 $finishloc = $headloc
		for $c = 1 to $finish step 1

		 
		  For $i = 1 To $attach Step 1
		  Local $random = Random(7000, 7500, 1)
	  MouseMove($shaftloc[0], $shaftloc[1], 5)
	  MouseClick("left")
	  Sleep(100)
	  MouseClick("left")
	  sleep(200)
	  MouseMove($finishloc[0], $finishloc[1], 5)
	  MouseClick("right")
   Sleep(1000)
   $line = GetLine()
   If IsArray($line) Then
	  		  Local $random2 = Random(200, 400, 1)
               MouseMove($line[0], $line[1]+40, 0)
              Sleep($random2+61)
              MouseClick("left")
          Sleep($random2)
              Sleep($random)

		   EndIf

		   Next
		   		 $finishloc[1] = $finishloc[1]+16
		   next
		   Exit
       EndIf
       Sleep(10)
    WEnd