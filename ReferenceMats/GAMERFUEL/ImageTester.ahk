findImage(imageName="")
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

F5::
findImage("rockshard")

F6::
Run ImageTester.ahk
Return

F12::
ExitApp