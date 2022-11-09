#SingleInstance force

;image you're searching for
imageName := "log"
;log string youre searching for
testvalue := "poke"

;rerun the script
F4::
Run testers.ahk
Return

;searches for designated image within 20 pixels of the cursor and displays coordinates
F5::
findImageCursor(imageName)
Return

findImageCursor(imageName="")
{
    global foundX, foundY
    MouseGetPos, mouseX, mouseY
    ret := 0
    img := A_WorkingDir . "\images\" . imageName . ".png"
    CoordMode, Pixel, Window
    ImageSearch, foundX, foundY, mouseX -20, mouseY -20, mouseX +20, mouseY +20, *TransWhite %img%
    ;ImageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransWhite %img%
    If ErrorLevel = 0
    {
        ret := 1
    }
    MsgBox %imageName%=%ret% x= %foundX% y= %foundY% ;Debug
    return ret
}
;Searches for designated image over the entire screen
F6::
findImageScreen(imageName)
Return

findImageScreen(imageName="")
{
    global foundX, foundY
    ret := 0
    img := A_WorkingDir . "\images\" . imageName . ".png"
    CoordMode, Pixel, Window
    ImageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransWhite *5 %img%
    If ErrorLevel = 0
    {
        ret := 1
    }
    MsgBox %ret% ;Debug
    return ret
}
;Tests the log parser
F7::
username := getPlayerName()
event := "C:\Users\" . A_UserName . "\wurm\players\" . username . "\logs\_Event." . A_YYYY . "-" . A_MM . ".txt"
parseLog = parseFunc(3, event)

if parseLog contains %testvalue%
    {
        ret := 1
        MsgBox % parseFunc(3, event)
    }

parseFunc(k,file)   ; Return the last k lines of file
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

getPlayerName()
{
  WinGetActiveTitle, title
  playerName := SubStr(title, 2, InStr(title, ")") - 2)
  return playerName
}

F8::
ExitApp
Return