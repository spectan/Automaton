 #include <Misc.au3>
 
    HotKeySet("{[}", "MakeLock")
    HotKeySet("{z}", "Start")
    HotKeySet("{ESC}", "_Exit")
    HotKeySet("{x}", "SetLockLocation")
 
    $handle = WinGetHandle("Wurm Online", "")
 
    Global $running=0
    Global $lockLoc
    Global $setlockLoc=0
 
    Func _Exit()
    Exit
    EndFunc   ;==>_Exit
 
    Func SetLockLocation()
       MsgBox(0, "", "Click on the small anvil")
       $setlockLoc=1
    EndFunc
 
    Func MakeLock()
       $start = MouseGetPos()
       MouseClick("right")
       Sleep(1000)
       $line = GetLine()
       If IsArray($line) Then
		  Local $random2 = Random(200, 400, 1)
              MouseMove($line[0], $line[1]+40, 0)
              Sleep($random2+61)
              MouseMove($line[0]+150, $line[1]+40, 0)
              Sleep($random2-33)
			  MouseMove($line[0]+250, $line[1]+40, 0)
			  sleep($random2+85)
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
              MsgBox(0, "", "Position set. Ready to micro your macro! (press z)")
       EndIf
       if $running==1 Then
		  Local $random = Random(9000, 13000, 1)
		  Local $random2 = Random(25000, 25200, 1)
              MouseMove($lockLoc[0], $lockLoc[1], 0)
              MakeLock()
			                MakeLock()
              Sleep($random2)
       EndIf
       Sleep(10)
    WEnd