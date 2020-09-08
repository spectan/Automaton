#SingleInstance force

F4::
Run, parsetest.ahk
return

F5::
event := "c:\users\sammy\wurm\players\grudgebearer\logs\_Event.2020-08.txt"
testvalue := "nigger"
testparse = Tail(3, event)


if (Tail(3, event) contains %testvalue%)
{
MsgBox % Tail(3, event)
}
return

Tail(k,file)   ; Return the last k lines of file
{
   Loop Read, %file%
   {
      i := Mod(A_Index,k)
      L%i% = %A_LoopReadLine%
   }
   L := L%i%
   Loop % k-1
   {
      IfLess i,1, SetEnv i,%k%
      i--      ; Mod does not work here
      L := L%i% "`n" L
   }
   Return L
}




F7::
ExitApp
Return