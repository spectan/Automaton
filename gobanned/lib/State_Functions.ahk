IsWhiteNameInLocal()
{
	ret := 0

	localCoords := GetImageCoords("localtab20top", , , , , "*TransBlack")
	
	If (localCoords[1])
	{
		localX1 := localCoords[2]
		localY1 := localCoords[3] + 20
		
		size := GetImageSize("localtab20top")
		
		localX2 := localCoords[2] + size[1]
		localY2 := localCoords[3] + size[2]
		
		If (ScreenSearch("whitepixel", 30, "*TransBlack", localX1, localY1, localX2, localY2))
		{
			screenshotFile := A_WorkingDir . "\screenshots\localtrigger.png"
			Run, nircmd.exe savescreenshot %screenshotFile%
			
			MoveMouseToBoundsRandom(localX1+10, localY1+30, localX2-30, localY2-30, 0, 0, 200)
			DoRightClick(50, 100)
			MoveMouseToImageRandom("copytab", , , , 0, 0, 100)
			DoLeftClick(50, 100)
			ret := 1
		}
	}
	return ret
}

IsIdle()
{
	return (!IsQueued() AND IsNotDoingAction())
}

IsBusy()
{
	return (IsQueued() OR IsDoingAction())
}

IsQueued()
{
	global isQueued
	ret := ScreenSearch("craftWindowQueue")
	isQueued := ret
	return ret
}

IsDoingAction()
{
	global isDoingAction
	ret := ScreenSearch("actionTimer2")
	isDoingAction := ret
	return ret
}

IsNotDoingAction()
{
	global isNotDoingAction
	ret := ScreenSearch("noActionTimer2")
	isNotDoingAction := ret
	return ret
}

NoSpaceToMine()
{
	ret := ScreenSearch("nospacetomine")
	return ret
}

IsFullStamina()
{
	global isFullStamina
	ret :=  ScreenSearch("fullStamina")
	isFullStamina := ret
	return ret
}

IsCraftingOpen()
{
	return ScreenSearch("craftingWindow")
}

TooHungry()
{
	return ScreenSearch("toohungry", 20) AND ScreenSearch("notfasted")
}

WallBroke()
{
	global wallBroke, progressingFromBreakSoon
	ret := ScreenSearch("wallbreak")
	If (ret)
	{
		wallBroke := 1
		progressingFromBreakSoon := 0
	}
	return ret
}

StringBroke()
{
	ret := ScreenSearch("stringbroke")
	return ret
}

ImproveRequiresItem()
{
	return ScreenSearch("improverequiresitem")
}

IsEmptyStamina()
{
	return ScreenSearch("emptystamina")
}

TooFar()
{
	return ScreenSearch("toofar")
}

Thirsty()
{
	return !ScreenSearch("enoughwater")
}

WallWillBreakSoon()
{
	return ScreenSearch("willbreaksoon")
}

CannotKeepMining()
{
	return ScreenSearch("cannotkeepmining")
}

CaveWallHovered()
{
	return ScreenSearch("cavewall", 20)
}

IsAltarHovered()
{
	return ScreenSearch("altarhovered", 20)
}

NeedConcrete()
{
	return ScreenSearch("needconcrete")
}


NoMineSpace()
{
	return ScreenSearch("nominespace")
}

RockDepleted()
{
	global rockDepleted
	ret := ScreenSearch("rockdepleted", 5, "*TransBlack")
	If (ret AND !rockDepleted)
	{
		Say("Rock depleted")
		rockDepleted := 1
	}
	return ret
}

IsHoveringTileBorder()
{
	ret := ScreenSearch("tileborderhover", 20)
	return ret
}

IsHoveringCaveFloor()
{
	ret := ScreenSearch("cavefloor", 20)
	return ret
}

IsHoveringCaveFloorFlat()
{
	ret := ScreenSearch("cavefloorflat", 20)
	return ret
}

IsSlopeDown()
{
	ret := ScreenSearch("slopedown", 20)
	return ret
}

IsSlopeUp()
{
	ret := ScreenSearch("slopeup", 20)
	return ret
}

IsTileBorderFlat()
{
	ret := ScreenSearch("tileborderflat", 20)
	return ret
}

IsTileBorderOneSlopeDown()
{
	ret := ScreenSearch("oneslopedown", 20)
	return ret
}

IsHoveringFelledTree()
{
	ret := ScreenSearch("felledtree", 20)
	return ret
}

IsHoveringTree()
{
	ret := ScreenSearch("tree", 20)
	return ret
}

IsHoveringTreeStump()
{
	ret := ScreenSearch("treestump", 20)
	return ret
}

PracticeDollHovered()
{
	return ScreenSearch("practicedolltooltip")
}

LumpCooled()
{
	return ScreenSearch("lumpcooled")
}

HasFasted()
{
	return ScreenSearch("fasted")
}

OutOfArrows()
{
	return ScreenSearch("outofarrows")
}

IsRepaired()
{
	ret := 0
	variant := 1
	
	Loop
	{
		If (ret = 1 OR variant > 3)
		{
			Break
		}
		ret := FindInLine("repaired" . variant)
		variant += 1
	}
	return ret
}

IsFourHourShutoff()
{
	global startTime, stopLoop, fourHourLimited, logout
	elapsed := A_TickCount - startTime
	If (elapsed >= 4 * 60 * 60 * 1000)
	{
		stopLoop := 1
		fourHourLimited := 1
		logout := 1
		ret := 1
	}
	Else
	{
		ret := 0
	}
	return ret
}

HasntMoved()
{
	global lastMovement
	elapsed := A_TickCount - lastMovement
	Random, randMinutes, 10, 20
	If (elapsed >= randMinutes * 60 * 1000)
	{
		ret := 1
	}
	Else
	{
		ret := 0
	}
	return ret
}