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
	woodcuttableHovered := IsHoveringWoodcuttable()
	While (!woodcuttableHovered AND (A_TickCount - loopStartTime < waitTime*1000))
	{
		Random, rand, 10, 25
		Sleep, rand
		woodcuttableHovered := IsHoveringWoodcuttable()
	}
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