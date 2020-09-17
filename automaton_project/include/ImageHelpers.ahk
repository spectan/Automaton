;Base imagesearch function
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
    If ErrorLevel = 1 {
      Msgbox Failed to find image %imageName%
    }
    return ret
}
;Checks for Full Stamina
isFullStam() 
{
    return findImage("stamfull")
}