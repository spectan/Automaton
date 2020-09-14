HotKeySet("{]}", "Ring")
HotKeySet("{ESC}", "_Exit")

$handle = WinWait("[CLASS:LWJGL]", "", 10)
Func _Exit()
        Exit
 EndFunc

Func Ring()
   $start = MouseGetPos()
   For $i = 0 to 5000 Step 1

   MouseClick("right")
   Sleep(50)
   $line = GetLine()
   If IsArray($line) Then
          MouseMove($line[0], $line[1]+5*16-8, 0)
          Sleep(25)
          Send("!z")
          MouseClick("left")
          Sleep(25)
          MouseMove($start[0], $start[1], 0)
   EndIf
   Next
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
   Sleep(100)
WEnd