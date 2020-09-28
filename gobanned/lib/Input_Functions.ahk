DoSingleClick()
{
	DoClick()
}

DoMultiClick()
{
	global maxQueue
	DoClick(maxQueue)
}

DoSingleKey()
{
	global actionKey
	DoKey(actionKey)
}

DoMultiKey()
{
	global actionKey, maxQueue
	DoKey(actionKey, 0, maxQueue)
}

DoKey(key, duration=0, nTimes=1, maxDelay=300, modifier="")
{
	hasDuration := duration
	Loop, %nTimes%
	{
		If (!hasDuration)
		{
			Random, duration, 25, 100
		}
		Send %modifier%{%key% down}
		PlaySound("Key")
		Sleep, %duration%
		Send %modifier%{%key% up}
		SleepRandom(100, maxDelay)
	}
}

DoClick(nTimes=1, duration=0, maxDelay=300)
{
	hasDuration := duration
	Loop, %nTimes%
	{
		If (!hasDuration)
		{
			Random, duration, 25, 100
		}
		Send {Click down}
		PlaySound("Click1")
		Sleep, %duration%
		Send {Click up}
		SleepRandom(100, maxDelay)
	}
}

DoLeftClick(minSleep=100, maxSleep=300)
{
	Random, duration, 25, 100
	Click, down
	PlaySound("Click1")
	Sleep, %duration%
	Click, up
	SleepRandom(minSleep, maxSleep)
}

DoDoubleClick(minSleep=100, maxSleep=300)
{
	Click, down
	PlaySound("Click1")
	SleepRandom(25, 100)
	Click, up
	SleepRandom(50, 150)
	Click, down
	PlaySound("Click1")
	SleepRandom(25, 100)
	Click, up
	SleepRandom(minSleep, maxSleep)
}

DoRightClick(minSleep=100, maxSleep=300)
{
	Random, duration, 25, 100
	Click, down, right
	PlaySound("Click1")
	Sleep, %duration%
	Click, up, right
	SleepRandom(minSleep, maxSleep)
}

MoveMouseToCraftingButton()
{
	; Only one of these if checks will succeed
	
	If (ScreenSearch("createbutton") AND !MouseIsOnImage("createbutton"))
	{
		MoveMouseToImageRandom("createbutton")
	}
	If (ScreenSearch("continuebutton") AND !MouseIsOnImage("continuebutton"))
	{
		MoveMouseToImageRandom("continuebutton")
	}
}

MouseToRandomAreaAroundPoint(midX, midY, xRadius=20, yRadius=20)
{
	Random, randX, -1*xRadius, xRadius
	Random, randY, -1*yRadius, yRadius
	MoveMouseHumanlike(midX + randX, midY + randY)
}

MouseToRandomMiddle(radius=20)
{
	Random, randX, -1*radius, radius
	Random, randY, -1*radius, radius
	midX := 1920/2
	midY := 1080/2
	MoveMouseHumanlike(midX + randX, midY + randY)
}

MouseToRandomBottomMiddle(radius=20)
{
	; Mouse to random middle 3/4 down
	Random, randX, -1*radius, radius
	Random, randY, -1*radius, radius
	midX := 1920/2
	midY := 1080/4*3
	MoveMouseHumanlike(midX + randX, midY + randY)
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

StoreMouse()
{
	global storedMouseX, storedMouseY
	
	MouseGetPos, mX, mY
	
	storedMouseX := mX
	storedMouseY := mY
}

ReturnMouse(mouseX=0, mouseY=0)
{
	global task, storedMouseX, storedMouseY
	
	; TODO: it may be better to use stored mouse coords to prevent missed clicks
	
	If (mouseX = 0 OR mouseY = 0)
	{
		MouseToRandomMiddle()
	}
	Else If (InStr(task, "Imp") AND !impWorldObject)
	{
		Random, randX, -2, 2
		Random, randY, -2, 2
		MoveMouseHumanlike(mouseX + randX, mouseY + randY)
	}
	Else If (task = "Tunnel")
	{
		MouseToRandomMiddle()
		If (!CaveWallHovered())
		{
			AdvanceToCaveWall()
		}
	}
	Else
	{
		Random, randX, -8, 8
		Random, randY, -8, 8
		MoveMouseHumanlike(mouseX + randX, mouseY + randY)
	}
	
	storedMouseX := 0
	storedMouseY := 0
}

MouseToArcheryIcon()
{
	global stopLoop, stopReason
	If (ScreenSearch("archeryicon", , "*TransWhite"))
	{
		MoveMouseToImageRandom("archeryicon")
	}
	Else
	{
		stopLoop := 1
		stopReason := "Can't remedy archery: no archery icon"
	}
}

MoveMouseToImageRandom(imageName="", preFoundX=0, preFoundY=0, transMode="*TransWhite", minSleep=300, maxSleep=600, mouseTime=0)
{
	global stopLoop, stopReason

	imageFound := []
	imageFound[1] := 1
	imageFound[2] := preFoundX
	imageFound[3] := preFoundY
	
	If (preFoundX = 0 OR preFoundY = 0)
	{
		imageFound := GetImageCoords(imageName, Max(0, preFoundX-1), Max(0,preFoundY-1), , , transMode)
	}
	
	If (imageFound[1])
	{
		imageX := imageFound[2]
		imageY := imageFound[3]
		
		additionalDown := 0
		
		; To avoid dragging into inventory group if random y is top edge
		If (imageName = "inventoryspace")
		{
			additionalDown := 18
		}
		
		imageSize := GetImageSize(imageName)
		imageWidth := imageSize[1]
		Random, imageXRand, 0, imageWidth - 4
		imageHeight := imageSize[2]
		Random, imageYRand, 0, imageHeight - 4 - additionalDown
		
		MoveMouseHumanlike(imageX + 2 + imageXRand, imageY + 2 + imageYRand + additionalDown, mouseTime)
		SleepRandom(minSleep, maxSleep)
		
		return 1
	}
	Else
	{
		stopLoop := 1
		stopReason := "Could not find " . imageName . " for random move"
		
		return 0
	}
}

MoveMouseToBoundsRandom(x1, y1, x2, y2, minSleep=300, maxSleep=600, mouseTime=0)
{
	leftX := x1
	topY := y1
	
	width := x2 - x1
	Random, xRand, 0, width - 4
	height := y2 - y1
	Random, yRand, 0, height - 4
	
	MoveMouseHumanlike(leftX + 2 + xRand, topY + 2 + yRand, mouseTime)
	SleepRandom(minSleep, maxSleep)
	
	return 1
}

ClickDragToBounds(x1, y1, x2, y2)
{
	Click, Down
	SleepRandom(200, 400)
	MoveMouseToBoundsRandom(x1, y1, x2, y2)
	SleepRandom(200, 400)
	Click, Up
	SleepRandom(200, 400)
}

ClickOnImage(imagename="", leftOrRight="left", preFoundX=0, preFoundY=0, transMode="*TransWhite")
{
	If (MoveMouseToImageRandom(imageName, preFoundX, preFoundY, transMode))
	{
		If (leftOrRight = "right")
		{
			DoRightClick()
			WaitForRefreshing()
			If (stopLoop)
			{
				return 0
			}
			return 1
		}
		Else
		{
			DoLeftClick()
			return 1
		}
	}
	return 0
}

DragMenuAItemXToMenuBItemY(menuA="", itemX="", menuB="", itemY="inventoryspace", itemXTransMode="*TransBlack", failOnNotFound=1)
{
	global stopLoop, stopReason
	
	; Store mouse
	; mouse pos
	
	itemXFound := FindInMenu(menuA, itemX, itemXTransMode)
	
	If (itemXFound[1])
	{
		MoveMouseToImageRandom(itemX, itemXFound[2], itemXFound[3], itemXTransMode)
		
		itemYFound := FindInMenu(menuB, itemY)

		If (itemYFound[1])
		{
			
			; Click hold
			Click, Down
			SleepRandom(300, 600)
			
			; Move to ItemY
			MoveMouseToImageRandom(itemY, itemYFound[2], itemYFound[3])
			
			; Release click
			Click, Up
			SleepRandom(300, 600)
		
		
			; Return mouse
			; MouseToArcheryIcon()
		}
		Else
		{
			If (failOnNotFound)
			{
				stopLoop := 1
				stopReason := "Failed DragMenuAItemXToMenuBItemY: no " . itemY . " found"
			}
		}
	}
	Else
	{
		If (failOnNotFound)
		{
			stopLoop := 1
			stopReason := "Failed DragMenuAItemXToMenuBItemY: no " . itemX . " found"
		}
	}
}