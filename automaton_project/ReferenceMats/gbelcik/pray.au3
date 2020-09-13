#include <Misc.au3>
#include <Color.au3>

global $pollRate = 30000

;DONT CHANGE THESE
global $inProgress=0
;

HotKeySet("{x}", "ToggleMacro")
HotKeySet("{ESC}", "_Exit")

Func ToggleMacro()
   If $inProgress==1 Then
          $inProgress=0
          ;TrayTip("", "Macro stopped", 5)
   ElseIf $inProgress==0 Then
          $inProgress=1
          ;TrayTip("", "Macro started", 5)
   EndIf
EndFunc

Sleep(2000)

While 1
                   Send("+g")
         Sleep($pollRate)


WEnd

Func _Exit()
Exit
EndFunc   ;==>_Exit