#SingleInstance force

#Include Gdip_All.ahk
;from: https://www.dropbox.com/s/0e9gdfetbfa8v0o/Gdip_All.ahk

FoundX := 0
FoundY := 0

MsgBox, Reloaded macro

F2::
testImageName := "archeryicon"
MoveMouseToImageRandom(testImageName)
Return

F4::
Run test.ahk
Return


F7::
ExitApp
Return

MoveMouseToImageRandom(imageName="")
{
	imageFound := GetImageCoords(imageName)
	If (imageFound[1])
	{
		imageX := imageFound[2]
		imageY := imageFound[3]
		
		imageSize := GetImageSize(imageName)
		imageWidth := imageSize[1]
		Random, imageXRand, 0, imageWidth - 4
		imageHeight := imageSize[2]
		Random, imageYRand, 0, imageHeight - 4
		
		MoveMouseHumanlike(imageX + 2 + imageXRand, imageY + 2 + imageYRand)
		SleepRandom(300, 600)
	}
}

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

RandomBezier( X0, Y0, Xf, Yf, O="" ) {
    Time := RegExMatch(O,"i)T(\d+)",M)&&(M1>0)? M1: 200
    RO := InStr(O,"RO",0) , RD := InStr(O,"RD",0)
    N:=!RegExMatch(O,"i)P(\d+)(-(\d+))?",M)||(M1<2)? 2: (M1>19)? 19: M1
    If ((M:=(M3!="")? ((M3<2)? 2: ((M3>19)? 19: M3)): ((M1=="")? 5: ""))!="")
        Random, N, %N%, %M%
    OfT:=RegExMatch(O,"i)OT(-?\d+)",M)? M1: 100, OfB:=RegExMatch(O,"i)OB(-?\d+)",M)? M1: 100
    OfL:=RegExMatch(O,"i)OL(-?\d+)",M)? M1: 100, OfR:=RegExMatch(O,"i)OR(-?\d+)",M)? M1: 100
    MouseGetPos, XM, YM
    If ( RO )
        X0 += XM, Y0 += YM
    If ( RD )
        Xf += XM, Yf += YM
    If ( X0 < Xf )
        sX := X0-OfL, bX := Xf+OfR
    Else
        sX := Xf-OfL, bX := X0+OfR
    If ( Y0 < Yf )
        sY := Y0-OfT, bY := Yf+OfB
    Else
        sY := Yf-OfT, bY := Y0+OfB
    Loop, % (--N)-1 {
        Random, X%A_Index%, %sX%, %bX%
        Random, Y%A_Index%, %sY%, %bY%
    }
    X%N% := Xf, Y%N% := Yf, E := ( I := A_TickCount ) + Time
    While ( A_TickCount < E ) {
        U := 1 - (T := (A_TickCount-I)/Time)
        Loop, % N + 1 + (X := Y := 0) {
            Loop, % Idx := A_Index - (F1 := F2 := F3 := 1)
                F2 *= A_Index, F1 *= A_Index
            Loop, % D := N-Idx
                F3 *= A_Index, F1 *= A_Index+Idx
            M:=(F1/(F2*F3))*((T+0.000001)**Idx)*((U-0.000001)**D), X+=M*X%Idx%, Y+=M*Y%Idx%
        }
        MouseMove, %X%, %Y%, 0
        Sleep, 1
    }
    MouseMove, X%N%, Y%N%, 0
    Return N+1
}

MoveMouseHumanlike(x, y, mouseTime=0)
{
	If (mouseTime = 0)
	{
		MouseGetPos, mouseX, mouseY
		a2 := (x - mouseX) ** 2
		b2 := (y - mouseY) ** 2
		c := Sqrt(a2 + b2)
		
		Random, randDist, c*.9, c*1.1
		If (randDist > 50)
		{
			mouseTime := Max(randDist, 50000/randDist)
		}
		Else
		{
			Random, mouseTime, 300, 600
		}
	}
	RandomBezier(0, 0, x, y, "T" . mouseTime . " RO P3")
	SleepRandom(200, 500)
}

SleepRandom(minSleep, maxSleep)
{
	Random, rand, %minSleep%, %maxSleep%
	Sleep, %rand%
}