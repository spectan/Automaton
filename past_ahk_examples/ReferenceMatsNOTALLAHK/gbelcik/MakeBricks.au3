HotKeySet("{[}", "MakeBrick")
HotKeySet("{]}", "MakeBrick")
HotKeySet("{'}", "GrabShit")
HotKeySet("{,}", "Set1")
HotKeySet("{.}", "Set2")
HotKeySet("{/}", "Set3")

$handle = WinGetHandle("Wurm Online 3", "")
Global $pos1
Global $pos2
Global $pos3
Global $running=0

Func Set1()
   $pos1 = MouseGetPos()
EndFunc

Func Set2()
   $pos2 = MouseGetPos()
EndFunc

Func Set3()
   $pos3 = MouseGetPos()
EndFunc

Global $mode = 0

Func MakeMortar()
   $start = MouseGetPos()
   MouseClick("right")
   Sleep(150)
   $line = GetLine()
   If IsArray($line) Then
          MouseMove($line[0], $line[1]+3*16-8, 0)
          Sleep(150)
          MouseMove($line[0]+140, $line[1]+3*16-8, 0)
          Sleep(150)
          MouseMove($line[0]+200, $line[1]+3*16-8, 0)
          Sleep(150)
          MouseClick("left")
   EndIf
   MouseMove($start[0], $start[1],0)
EndFunc

Func TargetPractice()
   $start = MouseGetPos()
   MouseClick("right")
   Sleep(150)
   $line = GetLine()
   If IsArray($line) Then
          MouseMove($line[0], $line[1]+3*16-8, 0)
          Sleep(150)
          MouseClick("left")
   EndIf
   MouseMove($start[0], $start[1],0)
EndFunc

Func MakeChain()
   $start = MouseGetPos()
   MouseClick("right")
   Sleep(150)
   $line = GetLine()
   If IsArray($line) Then
          MouseMove($line[0], $line[1]+3*16-8, 0)
          Sleep(150)
          MouseMove($line[0]+140, $line[1]+3*16-8, 0)
          Sleep(150)
          MouseMove($line[0]+140, $line[1]+7*16-8, 0)
          Sleep(150)
          MouseMove($line[0]+200, $line[1]+7*16-8, 0)
          Sleep(150)
          MouseMove($line[0]+200, $line[1]+7*16-8+208, 0)
          Sleep(150)
          MouseClick("left")
   EndIf
   MouseMove($start[0], $start[1],0)
EndFunc

Func GrabShit()
   if $running==0 Then
          $running=1
   ElseIf $running==1 Then
          $running=0
   EndIf
EndFunc

Func MakeBrick()
   $start = MouseGetPos()
   MouseClick("right")
   Sleep(1300)
   $line = GetLine()
   If IsArray($line) Then
	  Local $random2 = Random(300, 800, 1)
          MouseMove($line[0], $line[1]+3*16-8, 0)
          Sleep($random2-51)
          MouseMove($line[0]+120, $line[1]+3*16-8, 0)
          Sleep($random2+38)
          MouseMove($line[0]+120, $line[1]+3*16-8+2*16, 0)
          Sleep(500)
          MouseMove($line[0]+200, $line[1]+3*16-8+2*16, 0)
          Sleep($random2+161)
          MouseMove($line[0]+200, $line[1]+3*16-8+2*16+2*15, 0)
          Sleep($random2)
          MouseClick("left")
   EndIf
   MouseMove($start[0], $start[1],0)
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
   if $running==1 Then
          if IsArray($pos1) And IsArray($pos2) Then
                 if $mode == 0 Then
					Local $random3 = Random(700, 1400, 1)
					Local $random4 = Random(9000, 10500, 1)
					Local $random5 = Random(200, 400, 1)
					Local $random6 = Random(200, 500, 1)
                        ;grab shard
                        MouseMove($pos1[0], $pos1[1], 5)
                        MouseDown("left")
                        Sleep(100)
                        MouseMove($pos2[0], $pos2[1], 5)
                        MouseUp("left")
                        Sleep($random3)
                        ;make brick
                        MakeBrick()
                        Sleep($random4)
                        ;drop brick
                        MouseMove($pos2[0], $pos2[1]+16, 5)
                        MouseDown("left")
                        Sleep($random5)
                        MouseMove($pos3[0], $pos3[1], 5)
                        MouseUp("left")
                        Sleep($random5)
                        ;drop shard
                        MouseMove($pos2[0], $pos2[1], 5)
                        MouseDown("left")
                        Sleep($random6)
                        MouseMove($pos3[0], $pos3[1], 5)
                        MouseUp("left")
                        Sleep(500)
                 ElseIf $mode == 1 Then
                        For $i = 1 To 10 Step 1
                           Send("{f}")
                           Sleep(6000)
                        Next
                        MouseMove($pos1[0], $pos1[1], 5)
                        MouseClick("left")
                        MouseMove($pos1[0], $pos1[1]+32, 5)
                        MouseClick("left")
                        Sleep(100)
                        MouseClick("left")
                        Sleep(100)
                        MouseMove($pos1[0], $pos1[1], 5)
                        Send("{c}")
                        Sleep(500)
                        MouseMove($pos1[0]+64, $pos1[1], 5)
                        MouseDown("left")
                        Sleep(200)
                        MouseMove($pos2[0], $pos2[1])
                        Sleep(500)
                        MouseUp("left")
                        MouseMove($pos3[0], $pos3[1], 5)
                        MouseClick("left")
                        Sleep(100)
                        MouseClick("left")
                        Sleep(1000)
                 EndIf
          EndIf
   EndIf
   Sleep(10)
WEnd