#Include, %A_ScriptDir%\include\Gdip_All.ahk
;
;Image-related functions
;
;ImageSearch
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
    ;MsgBox %ret% ;Debug
    return ret
}
;Similar to the above, just searches via row for imping.
findImpItem(imageName="")
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

;Checks for Full Stamina
isFullStam() 
{
    return findImage("stamfull")
}

;Finds the row to start imping an item on
findRow()
{
    global rowY, foundY
    If (findImage("row1") = 1)
    {
        rowY = %foundY%
        ;Msgbox %rowY% row 1 ;Debug
        return 1
    }
    else if (findImage("row2") = 1)
    {
        rowY = %foundY%
        ;Msgbox %rowY% row 2 ;Debug
        return 1
    }
    else if (findImage("row3") = 1)
    {
        rowY = %foundY%
        ;Msgbox %rowY% row 3 ;Debug
        return 1
    }
    else
    {
        MsgBox couldn't find row
        ;Msgbox %rowY% ;Debug
        return 0
    }
}

;
;Location-getters
;
;Set Mouse Location
setMouseLoc()
{
    global locX, locY
    KeyWait, %setLoc%, D
    MouseGetPos, locX, locY
    ;MsgBox, x is %locX% and y is %locY% ;Debug
}


;
;Misc functions
;
;random sleep
randSleep(minSleep=300, maxSleep=500)
{
    Random, rand, minSleep, maxSleep
    Sleep, rand
}

;antimacro -- rolls to see if youre "afk"
antiRand()
{
    Random, rand, 0, 100
    If (rand > 90) 
    {
        randSleep(30000,60000)
    }
        else if (rand > 75) 
        {
        randSleep(5000,15000)
        }
        else if (rand > 50) 
        {
        randSleep(2000, 8000)
        }
        else if (rand > 0) 
        {
        randSleep(250, 750)
        }
}

;
;Inputs
;
;Use keys with delay
doKey(key)
{
    Send {%key% down}
    randSleep(15,45)
    Send {%key% up} 
}

;Left click with a delay
doClick()
{
Send {Click down}
randSleep(50, 150)
Send {Click up}
randSleep(50, 150)
}
;Right click with a delay
doRightClick()
{
Send {Click, down, right}
randSleep(50, 150)
Send {Click, up, right}
randSleep(50, 150)
}

;Locates the QL column and clicks it twice.
clickQL()
{
    MoveMouseToImageRandom("ql")
    doClick()
    randSleep(300, 500)
    doClick()
}
;
;Parsing related functions
;
;Primary parse function
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

Scriptstoppers() ;Parses the log to determine if the script should be stopped, and then alert the user.
{
    global username
    event := "C:\Users\" . A_UserName . "\wurm\players\" . username . "\logs\_Event." . A_YYYY . "-" . A_MM . ".txt"
    parseLog := parseFunc(2, event)
    carry := "not be able to carry"
    toofar := "too far away"
    nospace := "is no space"
    wallbreaks := "the wall breaks!"
    toopoor := "too poor shape"
    hitrock := "dig in the solid rock"
    ret := 0
    if parseLog contains %carry%
    {
        ret := 1
    }
    if parseLog contains %toofar%
    {
        ret := 1
    }
    if parseLog contains %nospace%
    {
        ret := 1
    }
    if parseLog contains %wallbreaks%
    {
        ret := 1
    }
    if parseLog contains %toopoor%
    {
        ret := 1
    }
    if parseLog contains %hitrock%
    {
        ret := 1
    }
    return ret
}
;gets client username
getPlayerName()
{
  WinGetActiveTitle, title
  playerName := SubStr(title, 2, InStr(title, ")") - 2)
  return playerName
}
;
;Mouse Movement Functions
;
;Incorporates the below functions to generate a random movement when moving to an image.
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
		randSleep(300, 600)
	}
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

;Generates random movement pattern
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

;Function for bezier
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
	randSleep(200, 500)
}
;
;
;IMPROVEMENT FUNCTIONS
;
;
;Masonry Imper
doMasonryImp()
{
global improve, repair, actions, locX, rowY, masonryToolbelt
Random mvmouse, 2, 16
Random mvmouseX, 2, 5
loop %actions% 
    {
    findRow()
        if (!findRow())
        {
        ;Msgbox Couldn't find the row!
        running = 0
        }
        if (findImpItem("rockshard"))
        {
        doKey(repair)
        randSleep()
        doKey(masonryToolbelt["rockshard"])
        randSleep()
        doKey(improve)
        randSleep(1000, 2000)
        ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("chisel"))
        {
        doKey(repair)
        randSleep()
        doKey(masonryToolbelt["chisel"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
    }
        While isFullStam()
        {
        Sleep 500
        }
}
;same as above but for singular items.
doSingleMasonryImp()
{
global improve, repair, actions, masonryToolbelt
loop %actions% 
    {
    findRow()
        if (!findRow())
        {
        ;Msgbox Couldn't find the row!
        running = 0
        }
        if (findImpItem("rockshard"))
        {
        doKey(repair)
        randSleep()
        doKey(masonryToolbelt["rockshard"])
        randSleep()
        doKey(improve)
        randSleep(1000, 2000)
        }
        else if (findImpItem("chisel"))
        {
        doKey(repair)
        randSleep()
        doKey(masonryToolbelt["chisel"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
    }
        While isFullStam()
        {
        Sleep 500
        }
}
;Carpentry Imper
doCarpentryImp()
{
global improve, repair, actions, locX, rowY, carpentryToolbelt
Random mvmouse, 2, 16
Random mvmouseX, 2, 5
loop %actions% 
    {
    findRow()
        if (!findRow())
        {
        ;Msgbox Couldn't find the row!
        running = 0
        }
        if (findImpItem("log"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["log"])
        randSleep()
        doKey(improve)
        randSleep(1000, 2000)
        ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("carving"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["carving"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
         ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("pelt"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["pelt"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
         ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("file"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["file"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("mallet"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["mallet"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
         ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
    }
        While isFullStam()
        {
        Sleep 500
        }
}
;same as above for single items
doSingleCarpentryImp()
{
global improve, repair, actions, carpentryToolbelt
loop %actions% 
    {
    findRow()
        if (!findRow())
        {
        ;Msgbox Couldn't find the row!
        running = 0
        }
        if (findImpItem("log"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["log"])
        randSleep()
        doKey(improve)
        randSleep(1000, 2000)
        }
        else if (findImpItem("carving"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["carving"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
        else if (findImpItem("pelt"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["pelt"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
        else if (findImpItem("file"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["file"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
        else if (findImpItem("mallet"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["mallet"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
    }
        While isFullStam()
        {
        Sleep 500
        }
}
;Tailor Imper
doTailorImp()
{
global improve, repair, actions, locX, rowY, tailorToolbelt
Random mvmouse, 2, 16
Random mvmouseX, 2, 5
loop %actions% 
    {
    findRow()
        if (!findRow())
        {
        ;Msgbox Couldn't find the row!
        running = 0
        }
        if (findImpItem("string"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["string"])
        randSleep()
        doKey(improve)
        randSleep(1000, 2000)
        ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("needle"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["needle"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
         ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("scissors"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["scissors"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
         ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("awl"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["awl"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
        else if (findImpItem("mallet"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["mallet"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
         ;MouseMove, locX + mvmouseX, rowY + mvmouse + 18 ;This is the old, straightforward method. If you have problems, uncomment this and comment the other one.
        MoveMouseHumanlike(locX + mvmouseX, rowY + mvmouse + 18)
        }
    }
        While isFullStam()
        {
        Sleep 500
        }
}
;same as above for single items
doSingleTailorImp()
{
global improve, repair, actions, tailorToolbelt
loop %actions% 
    {
    findRow()
        if (!findRow())
        {
        ;Msgbox Couldn't find the row!
        running = 0
        }
        if (findImpItem("string"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["string"])
        randSleep()
        doKey(improve)
        randSleep(1000, 2000)
        }
        else if (findImpItem("needle"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["needle"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
        else if (findImpItem("scissors"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["scissors"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
        else if (findImpItem("awl"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["awl"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
        else if (findImpItem("mallet"))
        {
        doKey(repair)
        randSleep()
        doKey(carpentryToolbelt["mallet"])
        doKey(improve)
        randSleep()
        randSleep(1000, 2000)
        }
    }
        While isFullStam()
        {
        Sleep 500
        }
}