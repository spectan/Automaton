IsWhiteNameInLocal()
{
	ret := 0
	WinGetActiveTitle, title
	
	; Since this is only looking for a white pixel, it could false positive
	; when switching windows unless you only check it in the Wurm Online window
	If (InStr(title, "Wurm Online"))
	{
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
				
				MoveMouseToImageRandom("total", localX1, localY1, "*TransBlack", 0, 0, 200)
				DoRightClick(50, 100)
				MoveMouseToImageRandom("copytab", , , , 0, 0, 100)
				DoLeftClick(50, 100)
				ret := 1
			}
		}
	}
	return ret
}

IsForgeBurningSteadily()
{
	global stopLoop, stopReason, lastCheckedForge
	
	Say("Checking forge")
	ret := 0

	forgeCoords := GetMenuCoords2("forgeheader")
	
	If (forgeCoords[1])
	{
		forgeCenterX := (forgeCoords[2] + forgeCoords[4])/2
		forgeBottomY := forgeCoords[5]
		
		MouseToRandomAreaAroundPoint(forgeCenterX, forgeBottomY + 50, 50, 20)
		SleepRandom(300, 500)
		lastCheckedForge := A_TickCount
		DoKey("y")
		SleepRandom(300, 500)
		
		If (ScreenSearch("aforge", , "*TransBlack"))
		{
			ret := ScreenSearch("forgeburnssteadily")
		}
		Else
		{
			stopLoop := 1
			stopReason := "IsForgeBurningSteadily could not find forge examine"
			ret := 1
		}
	}
	Else
	{
		stopLoop := 1
		stopReason := "IsForgeBurningSteadily could not find forge coords"
	}
	
	return ret
}

ForgeHasIronLumps()
{
	ret := 0
	
	If (ScreenSearch("forgeheader"))
	{
		forgeLumpsFound := FindInMenu("forgeheader", "ironlumptransblack", "*TransBlack")
		
		ret := forgeLumpsFound[1]
	}
	Else
	{
		stopLoop := 1
		stopReason := "Forge was not open when looking for iron lumps"
	}
	return ret
}

ForgeHasGlowingIronLumps()
{
	ret := 0
	
	If (ScreenSearch("forgeheader"))
	{
		forgeLumpsFound := FindInMenu("forgeheader", "ironlumptransblack", "*TransBlack")
		forgeGlowingLumpsFound := FindInMenu("forgeheader", "ironlumpglowinghottransblack", "*TransBlack")
		
		ret := forgeLumpsFound[1] AND forgeGlowingLumpsFound[1]
	}
	Else
	{
		stopLoop := 1
		stopReason := "Forge was not open when looking for glowing iron lumps"
	}
	return ret
}

IsItemGlowingHot(itemName, leftX=0, topY=0, transMode="*TransWhite")
{
	itemImageSize := GetImageSize(itemName)
	itemGlowing := GetImageCoords("glowinghot", leftX, topY, leftX + itemImageSize[1], topY + itemImageSize[2])
	
	If (itemGlowing[1])
	{
		return 1
	}
	Else
	{
		return 0
	}
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

YouHitRock()
{
	ret := ScreenSearch("youhitrock")
	return ret
}

AlreadyFlat()
{
	ret := ScreenSearch("alreadyflat")
	return ret
}

BorderIsFlatHere()
{
	ret := ScreenSearch("borderisflathere")
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

MaterialIsTooPoorShape()
{
	return ScreenSearch("toopoorshape")
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

TooFarSpam()
{
	return ScreenSearch("toofarspam")
}

IsActionBlocked()
{
	return ScreenSearch("clearthearea")
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

NotStrongEnoughForMoreDirt()
{
	ret := ScreenSearch("notstrongenoughformoredirt")
	return ret
}

TooLitteredWithItems()
{
	ret := ScreenSearch("toolitteredwithitems")
	return ret
}

NeedDirtToLevel()
{
	ret := ScreenSearch("ifyoucarriedsome")
	return ret
}

FlatHovered()
{
	ret := ScreenSearch("flathover", 20)
	return ret
}

DoesntFit()
{
	ret := ScreenSearch("doesntfit")
	return ret
}

IsStrayDirtHovered()
{
	ret := ScreenSearch("dirthover", 20) AND !ScreenSearch("pileofdirthover", 20)
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

IsHoveringBush()
{
	ret := ScreenSearch("bush", 20)
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

IsHoveringCuttableTree()
{
	ret :=  !IsHoveringTreeStump() AND (IsHoveringTree() OR IsHoveringBush()) 
	return ret
}

IsHoveringWoodcuttable()
{
	ret := IsHoveringFelledTree() OR IsHoveringCuttableTree()
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

NeedWater()
{
	return ScreenSearch("needwater")
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
	global startTime, stopLoop, stopReason, fourHourLimited, logout, enableFourHourLimit
	elapsed := A_TickCount - startTime
	If (enableFourHourLimit AND elapsed >= 4 * 60 * 60 * 1000)
	{
		stopLoop := 1
		stopReason := "Four hour limit reached"
		fourHourLimited := 1
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