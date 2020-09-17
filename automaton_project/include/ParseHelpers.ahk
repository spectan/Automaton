;Gets the playername from the Wurm window
getPlayerName()
{
  WinActivate, Wurm Online
  WinGetActiveTitle, title
  playerName := SubStr(title, 2, InStr(title, ")") - 2)
  return playerName
}

;Parses the specified file and returns the last k lines
parseFunc(k,file) 
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