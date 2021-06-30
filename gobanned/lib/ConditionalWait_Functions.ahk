WaitUntilCaveWallHovered()
{
	loopStartTime := A_TickCount
	caveWallHovered := CaveWallHovered()
	While (!caveWallHovered AND (A_TickCount - loopStartTime < 3000))
	{
		Random, rand, 25, 75
		Sleep, rand
		caveWallHovered := CaveWallHovered()
	}
	SleepRandom(100, 300)
}

WaitUntilRemovingItems()
{
	loopStartTime := A_TickCount
	removingItems := ScreenSearch("removingitemsheader")
	While (!removingItems AND (A_TickCount - loopStartTime < 10000))
	{
		Random, rand, 25, 75
		Sleep, rand
		removingItems := ScreenSearch("removingitemsheader")
	}
	SleepRandom(100, 300)
}

WaitUntilCaveFloorNotFlatHovered()
{
	loopStartTime := A_TickCount
	caveFloorHovered := IsHoveringCaveFloor()
	caveFloorFlatHovered := IsHoveringCaveFloorFlat()
	caveWallHovered := CaveWallHovered()
	
	caveFloorNotFlatHovered := caveFloorHovered AND !caveFloorFlatHovered
	While (!caveFloorNotFlatHovered AND !caveWallHovered AND (A_TickCount - loopStartTime < 3000))
	{
		Random, rand, 25, 75
		Sleep, rand
		caveFloorFlatHovered := IsHoveringCaveFloorFlat()
		caveFloorHovered := IsHoveringCaveFloor()
		caveWallHovered := CaveWallHovered()
		
		caveFloorNotFlatHovered := caveFloorHovered AND !caveFloorFlatHovered
	}
	SleepRandom(100, 300)
}

WaitUntilWoodcuttableHovered(waitTime=10)
{
	loopStartTime := A_TickCount
	waitTimeRecached := 0
	
	hoveringFelledTree := IsHoveringFelledTree()
	hoveringBush := IsHoveringBush()
	hoveringTree := IsHoveringTree()
	hoveringStump := IsHoveringTreeStump()
	
	woodcuttableHovered := !hoveringStump AND (hoveringBush OR hoveringFelledTree OR hoveringTree)
	While (!woodcuttableHovered AND (A_TickCount - loopStartTime < waitTime*1000))
	{
		Random, rand, 10, 25
		Sleep, rand
		
		hoveringFelledTree := IsHoveringFelledTree()
		hoveringBush := IsHoveringBush()
		hoveringTree := IsHoveringTree()
		hoveringStump := IsHoveringTreeStump()
	
		woodcuttableHovered := !hoveringStump AND (hoveringBush OR hoveringFelledTree OR hoveringTree)
	}
	
	If (!woodcuttableHovered)
	{
		waitTimeReached := 1
	}

	return waitTimeReached
}

WaitUntilForgeHasGlowingIronLumps()
{
	global stopLoop, stopReason
	loopStartTime := A_TickCount
	
	Say("Waiting for forge")
	forgeHasGlowingIronLumps := ForgeHasGlowingIronLumps()
	
	While (!stopLoop AND !forgeHasGlowingIronLumps AND (A_TickCount - loopStartTime < 5 * 60 * 1000))
	{
		Random, rand, 25, 75
		Sleep, rand
		forgeHasGlowingIronLumps := ForgeHasGlowingIronLumps()
	}
	SleepRandom(100, 300)
}

WaitUntilInventoryHasItem(itemName, transMode="*TransWhite")
{
	global stopLoop, stopReason
	loopStartTime := A_TickCount
	timeout := 5000
	
	itemFound := FindInMenu("inventoryheader", itemName, transMode)
	
	While (!itemFound[1] AND (A_TickCount - loopStartTime < timeout))
	{
		Random, rand, 25, 75
		Sleep, rand
		itemFound := FindInMenu("inventoryheader", itemName, transMode)
	}
	
	If (A_TickCount - loopStartTime >= timeout)
	{
		stopLoop := 1
		stopReason := "Inventory lacked item " . itemName . " after " . timeout . "ms"
	}
	SleepRandom(100, 300)
}

WaitForRefreshing()
{
	global stopLoop, 
	loopStartTime := A_TickCount
	refr := ScreenSearch("refr")
	ing := ScreenSearch("ing")
	While ((refr OR ing) AND (A_TickCount - loopStartTime < 30000))
	{
		Random, rand, 25, 75
		Sleep, rand
		refr := ScreenSearch("refr")
		ing := ScreenSearch("ing")
	}
	If (A_TickCount - loopStartTime >= 30000)
	{
		stopLoop := 1
		stopReason := "Refreshing for over 30s"
	}
	SleepRandom(100, 300)
}

WaitUntilIdle(maxPreWait=2000)
{
	SleepRandom(300, maxPreWait)
	isIdle := IsIdle()
	While (!isIdle)
	{
		isIdle := isIdle()
	}
	SleepRandom(100, 300)
}

WaitUntilFullStamina(maxPreWait=2000)
{
	SleepRandom(300, maxPreWait)
	isFullStamina := IsFullStamina()
	While (!isFullStamina)
	{
		isFullStamina := IsFullStamina()
	}
	SleepRandom(100, 300)
}

WaitUntilFasted()
{
	loopStartTime := A_TickCount
	fasted := HasFasted()
	While (!fasted AND (A_TickCount - loopStartTime < 2*60*1000))
	{
		Random, rand, 25, 75
		Sleep, rand
		fasted := HasFasted()
	}
	SleepRandom(100, 300)
}