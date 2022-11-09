#NoEnv
SetWorkingDir %A_ScriptDir%
#Include, %A_ScriptDir%\include\Gdip_All.ahk

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
    return ret
}
;Checks for Full Stamina
isFullStam() 
{
    return findImage("stamfull")
}

findImageBMP(imageName="")
{
    global foundX, foundY
    ret := 0
    img := A_WorkingDir . "\images\" . imageName . ".bmp"
    CoordMode, Pixel, Window
    ImageSearch, foundX, foundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransWhite *5 %img%
    If ErrorLevel = 0
    {
        ret := 1
    }
    return ret
}

isFullStamBMP() 
{
    return findImageBMP("stamfull")
}

findItem(imageName="")
{
    global foundX, foundY, locX, rowY
    ret := 0
    img := A_WorkingDir . "\images\" . imageName . ".png"
    CoordMode, Pixel, Window
    ImageSearch, foundX, foundY, locX, rowY, locX +400, rowY +18, *TransWhite *5 %img%
    If ErrorLevel = 0
    {
        ret := 1
    }
    ;MsgBox improve locX = %locX% rowY = %rowY% %ret% ;Debug
    return ret
}
;Finds the size of an image
GetImageSize(imageName="")
{
	imagefile := A_WorkingDir . "\images\" . imageName . ".png"
	GDIPToken := Gdip_Startup()
	pBM := Gdip_CreateBitmapFromFile(imagefile)
	W:= Gdip_GetImageWidth(pBM)
	H:= Gdip_GetImageHeight(pBM)
	Gdip_DisposeImage(pBM)
	Gdip_Shutdown(GDIPToken)
	ret := []
	ret[1] := W
	ret[2] := H
	return ret
}

;Gets the image coords of an image.
GetImageCoords(imageName="")
{
	global FoundX, FoundY
	ret := []
	ret[1] := 0
	ret[2] := 0
	ret[3] := 0
	If (ScreenSearch(imageName, 5, "*TransWhite"))
	{
		ret[1] := 1
		ret[2] := FoundX
		ret[3] := FoundY
	}
	return ret
}

;Searches the screen for an image
ScreenSearch(imageName, variance=5, trans="")
{
	global FoundX, FoundY
	img := A_WorkingDir . "\images\" . imageName . ".png"
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, 0, 0, 1920, 1080, %trans% *%variance% %img%
	If ErrorLevel = 0
	{
		ret := 1
	}
	Else
	{
		ret := 0
	}
	return ret
}