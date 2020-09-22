DoConfiguredTask()
{
	global task
	Do%task%()
}

DoBricker()
{
	DoCreation()
}

DoKeyMoulds()
{
	DoCreation()
}

DoCreation()
{
	If (!MouseIsOnImage("createcontinuebutton"))
	{
		MoveMouseToImageRandom("createcontinuebutton")
	}
	
	DoSingleClick()
}

DoDigClayToBSB()
{
	global maxQueue

	If (MenuAHasMoreThan100KgOfItemX("pileheader", "clay") OR MenuAHasMoreThan100KgOfItemX("inventoryheader", "clay"))
	{
		;Roll to move clay at a random number of clay above 100kg at 1/3 chance per action queue
		Random, rand, 0, 2
		If (rand = 0)
		{
			Say("Moving clay")
			DragMenuAItemXToMenuBItemY("pileheader", "clay", "bsbheader", "inventoryspace", "*TransWhite", 0)
			DragMenuAItemXToMenuBItemY("inventoryheader", "clay", "bsbheader", "inventoryspace", "*TransWhite", 0)
		}
	}
	DoKey("c", , maxQueue)
}

DoWoodcutting()
{
	global previousTaskAttemptWorked, maxQueue, woodcuttingWalk, stopLoop, stopReason, woodcuttingWalkTime
	
	If (TooFarSpam())
	{
		stopLoop := 1
		stopReason := "Woodcutting was continually too far to act"
		return
	}
	
	If (TooFar())
	{
		; Walk forward some
		If (woodcuttingWalk AND !TooFarSpam())
		{
			MouseToRandomBottomMiddle()
		}
		Else
		{
			Say("Move closer")
		}
	}
	
	SleepRandom(100,300)
	
	If (!IsHoveringWoodcuttable())
	{
		; Walk forward until tree
		If (woodcuttingWalk)
		{
			If (!AdvanceToWoodcuttable(woodcuttingWalkTime))
			{
				return
			}
		}
		Else
		{
			PlaySound("Ding")
		}
	}
	
	SleepRandom(100,300)

	If (IsHoveringFelledTree())
	{
		DoKey("S", , maxQueue)
	}
	Else if (IsHoveringCuttableTree())
	{
		DoKey("W", , maxQueue)
	}
	
	previousTaskAttemptWorked := 1
	SleepRandom(100,300)
}

DoPracticeDoll()
{
	MouseToRandomMiddle()
	SleepRandom(300, 600)
	If (!PracticeDollHovered())
	{
		DoSingleClick()
		SleepRandom(300, 600)
	}
	DoKey("r")
	SleepRandom(5000, 10000)
	WaitUntilIdle()
	SleepRandom(300, 2000)
	Practice()
}

DoArchery()
{
	If (ScreenSearch("archeryicon", , "*TransWhite") AND !MouseIsOnImage("archeryicon"))
	{
		MouseToArcheryIcon()
	}
	If (MouseIsOnImage("archeryicon"))
	{
		DoClick(3)
	}
}

DoSurfaceMineFlat()
{
	global stopLoop, stopReason
	If (IsHoveringTileBorder() AND IsSlopeDown() AND !IsTileBorderFlat() AND !IsSlopeUp())
	{
		If (IsTileBorderOneSlopeDown())
		{
			DoKey("v")
		}
		Else
		{
			DoKey("v", , 2)
		}
	}
	Else if (IsHoveringTileBorder() AND IsTileBorderFlat() AND !IsSlopeDown() AND !IsSlopeUp())
	{
		stopLoop := 1
		stopReason := "Tile border is flat"
	}
	Else if (IsHoveringTileBorder() AND IsSlopeUp() AND !IsTileBorderFlat() AND !IsSlopeDown())
	{
		stopLoop := 1
		stopReason := "Tile border is sloped up"
	}
	Else
	{
		stopLoop := 1
		stopReason := "Surface mining and mouse lost the border"
	}
}

DoLevelCaveFloor()
{
	global stopLoop, stopReason
	
	If (NeedConcrete())
	{
		stopLoop := 1
		stopReason := "Tried to level cave floor but needed concrete"
		return
	}
	
	If (!IsHoveringCaveFloor())
	{
		MouseToRandomMiddle()
		If (!IsHoveringCaveFloor())
		{
			DoSingleClick()
		}
	}
	If (IsHoveringCaveFloor())
	{
		If (IsHoveringCaveFloorFlat())
		{
			AdvanceToCaveFloorNotFlat()
			SleepRandom(1000, 3000)
		}

		
		If (!stopLoop AND IsHoveringCaveFloor())
		{
			DoKey("C")
		}
	}
	Else
	{
		stopLoop := 1
		stopReason := "Tried to level cave floor but was not hovered"
	}
}

DoTunnel()
{
	global maxQueue, minesPerformed, tunnelDirection, didTunnelRemedy
	
	key := "End"
	If (tunnelDirection < 0)
	{
		key := "PgDn"
	}
	Else If (tunnelDirection > 0)
	{
		key := "PgUp"
	}
	
	If (minesPerformed > 54 + 0 * maxQueue)
	{
		RemedyTunnel()
	}
	Else
	{
		RepairActiveToolIfDamaged()
		
		If (!CaveWallHovered())
		{
			MouseToRandomMiddle()
			DoSingleClick()
		}
		
		DoKey(key, , maxQueue)
		didTunnelRemedy := 0
	}
}

DoSmithingImp()
{
	global smithingToolbeltMap, stopLoop, stopReason
	
	impItemsString := ""
	
	for key, value in smithingToolbeltMap
	{
		impItemsString .= key . ","
	}

	impItem := GetImpItem(impItemsString)
	
	If (impItem != "none")
	{
		TryRepair()
		ActivateToolbelt(smithingToolbeltMap[impItem][1], smithingToolbeltMap[impItem][2])
		DoKey("t")
	}
}

DoCarpentryImp()
{
	global carpentryToolbeltMap
	
	impItemsString := ""
	
	for key, value in carpentryToolbeltMap
	{
		impItemsString .= key . ","
	}

	impItem := GetImpItem(impItemsString)
	
	If (impItem != "none")
	{
		TryRepair()
		ActivateToolbelt(carpentryToolbeltMap[impItem][1], carpentryToolbeltMap[impItem][2])
		DoKey("t")
	}
}

DoClothTailoringImp()
{
	global clothtailoringToolbeltMap
	
	toolbeltMap := clothtailoringToolbeltMap
	impItemsString := ""
	
	for key, value in toolbeltMap
	{
		impItemsString .= key . ","
	}

	impItem := GetImpItem(impItemsString)
	
	If (impItem != "none")
	{
		TryRepair()
		ActivateToolbelt(toolbeltMap[impItem][1], toolbeltMap[impItem][2])
		DoKey("t")
	}
}

DoMasonryImp()
{
	global masonryToolbeltMap, impWorldObject
	
	impItemsString := ""
	
	for key, value in masonryToolbeltMap
	{
		impItemsString .= key . ","
	}

	impItem := "none"
	If (!impWorldObject)
	{
		impItem := GetImpItem(impItemsString)
	}
	
	If (impItem != "none")
	{
		TryRepair()
		ActivateToolbelt(masonryToolbeltMap[impItem][1], masonryToolbeltMap[impItem][2])
		DoKey("t")
	}
	Else if (impWorldObject = 1)
	{
		DoKey("r")
		ActivateToolbelt(masonryToolbeltMap["rockshard"][1], masonryToolbeltMap["rockshard"][2])
		DoKey("t")
		ActivateToolbelt(masonryToolbeltMap["chisel"][1], masonryToolbeltMap["chisel"][2])
		DoKey("t")
	}
}