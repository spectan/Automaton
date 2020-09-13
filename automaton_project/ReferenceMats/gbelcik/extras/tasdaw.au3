HotKeySet("x", "ToggleMacro")
global $inProgress=0
global $count=0

Func ToggleMacro()
   If $inProgress==1 Then
	  $inProgress=0
	  TrayTip("", "Macro stopped", 5)
   ElseIf $inProgress==0 Then
	  $inProgress=1
	  TrayTip("", "Macro started", 5)
   EndIf
EndFunc

While 1=1
   If $inProgress Then
	  If $count>=28 Then
		 Send("+g")
		 $count=0
	  EndIf
	  Send("u")
	  $count+=1
	  Sleep(45000)
   EndIf
WEnd