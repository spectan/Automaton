#SingleInstance force

F4::
Run test.ahk
Return

F5::
imageName := "log"
findImage(imageName)
Return

findImage(imageName="")
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


F7::
ExitApp
Return