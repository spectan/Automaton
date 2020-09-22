ActivateToolbelt(page=0, slot=1)
{
	DoKey(page, , , , "^")
	SleepRandom(100,200)
	DoKey(slot)
	SleepRandom(100,200)
}

DoLogout()
{
	global stopLoop, logout
	
	stopLoop := 1
	logout := 1
	
	DoKey("F12")
	SleepRandom(100, 300)

	If (MoveMouseToImageRandom("logoutyes"))
	{
		SleepRandom(100, 300)
		DoClick()
	}
	Else
	{
		WinKill, Wurm Online
	}
}

DoWiggle()
{
	global lastMovement

	Random, booleanRand, 0, 1

	If (booleanRand)
	{
		DoWiggleStrafe()
	}
	Else
	{
		DoWiggleStraight()
	}
	lastMovement := A_TickCount
	
	SleepRandom(1500, 2500)
}

DoWiggleStrafe()
{
	global strafeBalance

	Random, booleanRand, 0, 1
	Random, randMove, 75, 150
	
	If (strafeBalance < 0)
	{
		DoKey("d", randMove)
		strafeBalance := strafeBalance + randMove
	}
	Else If (strafeBalance > 0)
	{
		DoKey("a", randMove)
		strafeBalance := strafeBalance - randMove
	}
	Else If (booleanRand)
	{
		DoKey("d", randMove)
		strafeBalance := strafeBalance + randMove
	}
	Else
	{
		DoKey("a", randMove)
		strafeBalance := strafeBalance - randMove
	}
}

DoWiggleStraight()
{
	global straightBalance

	Random, booleanRand, 0, 1
	Random, randMove, 75, 150
	
	If (straightBalance < 0)
	{
		DoKey("w", randMove)
		straightBalance := straightBalance + randMove
	}
	Else If (straightBalance > 0)
	{
		DoKey("s", randMove)
		straightBalance := straightBalance - randMove
	}
	Else If (booleanRand)
	{
		DoKey("w", randMove)
		straightBalance := straightBalance + randMove
	}
	Else
	{
		DoKey("s", randMove)
		straightBalance := straightBalance - randMove
	}
}

RepairActiveToolIfDamaged()
{
	ret := 0
	variant := 1
	
	Loop
	{
		If (ret[1] OR variant > 3)
		{
			Break
		}
		ret := GetImageCoords("damage" . variant)
		variant += 1
	}
	
	If (ret[1])
	{
		MouseGetPos, mouseX, mouseY
		lineTopY := 0
		If (InStr(task, "Imp") AND !impWorldObject)
		{
			lineTopY := GetItemLineTop(mouseX, mouseY)
		}
		Say("Repairing tool")
		damageX := ret[2]
		damageY := ret[3]
		damageImgWidth := 79
		Random, damageXRand, 0, damageImgWidth - 4
		damageImgHeight := 10
		Random, damageYRand, 0, damageImgHeight - 4
		
		inventoryLeftOffset := 230

		MoveMouseHumanlike(damageX + 2 + damageXRand - inventoryLeftOffset, damageY + 2 + damageYRand)
		SleepRandom(50, 200)
		DoKey("r")
		SleepRandom(200, 500)
		
		If (InStr(task, "Imp") AND !impWorldObject)
		{
			Random, randX, -2, 2
			Random, randY, 0, 15 - 3
			MoveMouseHumanlike(mouseX + randX, lineTopY + 3 + randY)
		}
		Else If (task = "Tunnel")
		{
			MouseToRandomMiddle()
			If (!CaveWallHovered())
			{
				AdvanceToCaveWall()
			}
		}
		Else If (task = "Bricker")
		{
			MoveMouseToImageRandom("createcontinuebutton")
		}
		Else
		{
			Random, randX, -8, 8
			Random, randY, -8, 8
			MoveMouseHumanlike(mouseX + randX, mouseY + randY)
		}

		WaitUntilIdle()
	}
}

TryRepair()
{
	If (!IsRepaired())
	{
		Repair()
	}
}

Repair()
{
	DoKey("r")
}

DrinkWater()
{
	global waterToolbeltPage, stopLoop, stopReason, task, impWorldObject
	MouseGetPos, mouseX, mouseY
	lineTopY := 0
	If (InStr(task, "Imp") AND !impWorldObject)
	{
		lineTopY := GetItemLineTop(mouseX, mouseY)
	}
	Say("Drinking water")
	DoKey(waterToolbeltPage, , , , "^")
	SleepRandom(100,200)
	waterFound := GetImageCoords("toolbeltwater1")
	If (!waterFound[1])
	{
		waterFound := GetImageCoords("toolbeltwater2")
	}
	If (waterFound[1])
	{
		waterX := waterFound[2]
		waterY := waterFound[3]
		toolbeltWaterWidth := 16
		Random, waterXRand, 0, toolbeltWaterWidth - 4
		toolbeltWaterHeight := 20
		Random, waterYRand, 0, toolbeltWaterHeight - 4
		
		MoveMouseHumanlike(waterX + 2 + waterYRand, waterY + 2 + waterYRand)
		SleepRandom(50, 200)
		DoRightClick()
		SleepRandom(400,600)
		WaitForRefreshing()
		If (stopLoop)
		{
			return
		}
		
		drinkFound := GetImageCoords("drink1")
		If (!drinkFound[1])
		{
			drinkFound := GetImageCoords("drink2")
			
			If (!drinkFound[1])
			{
				drinkFound := GetImageCoords("drink3")
			}
		}
		If (drinkFound[1])
		{
			drinkX := drinkFound[2]
			drinkY := drinkFound[3]
			drinkWidth := 33
			Random, drinkXRand, 0, drinkWidth - 4
			drinkHeight := 12
			Random, drinkYRand, 0, drinkHeight - 4
			
			MoveMouseHumanlike(drinkX + 2 + drinkXRand, drinkY + 2 + drinkYRand)
			SleepRandom(50, 200)
			DoSingleClick()
			SleepRandom(200, 500)
			
			If (InStr(task, "Imp") AND !impWorldObject)
			{
				Random, randX, -2, 2
				Random, randY, 0, 15 - 3
				MoveMouseHumanlike(mouseX + randX, lineTopY + 3 + randY)
			}
			Else If (task = "Tunnel")
			{
				MouseToRandomMiddle()
				If (!CaveWallHovered())
				{
					AdvanceToCaveWall()
				}
			}
			Else If (task = "Bricker")
			{
				MoveMouseToImageRandom("createcontinuebutton")
			}
			Else
			{
				Random, randX, -8, 8
				Random, randY, -8, 8
				MoveMouseHumanlike(mouseX + randX, mouseY + randY)
			}
			
			WaitUntilIdle()
		}
		Else
		{
			stopLoop := 1
			stopReason := "Water>Drink option not found"
		}
	}
	Else
	{
		stopLoop := 1
		stopReason := "Thirsty but no water found"
	}
}

Practice()
{
	global stopLoop, stopReason

	MouseToRandomMiddle()
	SleepRandom(300,500)
	DoRightClick()
	SleepRandom(400,600)
	WaitForRefreshing()
	If (stopLoop)
	{
		return
	}
	practiceFound := GetImageCoords("practice")
	If (practiceFound[1])
	{
		practiceX := practiceFound[2]
		practiceY := practiceFound[3]
		practiceWidth := 52
		Random, practiceXRand, 0, practiceWidth - 4
		practiceHeight := 12
		Random, practiceYRand, 0, practiceHeight - 4
		
		MoveMouseHumanlike(practiceX + 2 + practiceXRand, practiceY + 2 + practiceYRand)
		SleepRandom(50, 200)
		DoSingleClick()
		SleepRandom(200, 500)
		
		MouseToRandomMiddle()
	}
	Else
	{
		stopLoop := 1
		stopReason := "Practice not found"
	}
}

EatSourceSalt()
{
	onSalt := MouseIsOnImage("sourcesalticon")
	If (onSalt)
	{
		DoKey("j")
		SleepRandom(50,200)
	}
	Else
	{
		saltFound := GetImageCoords("sourcesalticon")
		If (saltFound[1])
		{
			MoveMouseToImageRandom("sourcesalticon")
		}
	}
}

AdvanceTile()
{
	global advancedTile
	SleepRandom(300, 2000)
	Random, walkTimeW, 1000, 1400
	DoKey("w", walkTimeW)
	advancedTile := 1
}

AdvanceToCaveWall()
{
	global advancedTile, stopLoop, stopReason
	SleepRandom(300, 2000)
	DoAttentionLapse()
	Send {w down}
	PlaySound("Key")
	WaitUntilCaveWallHovered()
	Send {w up}
	SleepRandom(100, 300)
	advancedTile := 1
	
	If (!CaveWallHovered())
	{
		stopLoop := 1
		stopReason := "Failed to advance to cave wall (or hit different tile)"
	}
}

AdvanceToCaveFloorNotFlat()
{
	global stopLoop, stopReason
	SleepRandom(300, 2000)
	DoAttentionLapse()
	Send {w down}
	PlaySound("Key")
	WaitUntilCaveFloorNotFlatHovered()
	Send {w up}
	SleepRandom(100, 300)
	
	If (!IsHoveringCaveFloor())
	{
		stopLoop := 1
		stopReason := "Failed to advance to cave floor not flat (or hit different tile/border)"
	}
}

AdvanceToWoodcuttable(walkTime=10)
{
	global stopLoop, stopReason
	SleepRandom(300, 2000)
	DoAttentionLapse()
	Send {w down}
	PlaySound("Key")
	walkTimeReached := WaitUntilWoodcuttableHovered(walkTime)
	Send {w up}
	SleepRandom(100, 300)
	
	If (!IsHoveringWoodcuttable() AND walkTimeReached)
	{
		stopLoop := 1
		stopReason := "Failed to advance to woodcuttable"
		return 0
	}
	
	return 1
}

ClearEventTab()
{
	global stopLoop, stopReason
	
	MouseGetPos, mouseX, mouseY
	
	If (ClickOnImage("event", "right"))
	{
		If (ClickOnImage("eventcleartab"))
		{
			ReturnMouse(mouseX, mouseY)
		}
		Else
		{
			stopLoop := 1
			stopReason := "Could not find clear event tab"
		}
	}
	Else
	{
		stopLoop := 1
		stopReason := "Could not find event tab"
	}
}

WithdrawFromBSB(imageName, transMode="*TransWhite")
{
	global stopLoop, stopReason

	DragMenuAItemXToMenuBItemY("bsbheader", imageName, "inventoryheader", "inventoryspace", transMode)
	WaitUntilRemovingItems()
	
	foundSend := FindInMenu("removingitemsheader", "bsbsendbutton")
	
	If (foundSend[1])
	{
		ClickOnImage("bsbsendbutton", "left", foundSend[2], foundSend[3])
	}
	Else
	{
		stopLoop := 1
		stopReason := "Send not found when removing items from bsb"
	}
}

MoveItemFromInventoryToCraftingWindow(item, transMode="*TransWhite", combineItems=0, side="right")
{
	stoneFound := FindInMenu("inventoryheader", item, transMode)
	
	If (stoneFound[1])
	{
		MoveMouseToImageRandom(item, stoneFound[2], stoneFound[3], transMode)
		
		sideName := "craftingwindow" . side
		craftingBox := FindImageInImage("craftingwindowbox", sideName)
		
		If (craftingBox[1])
		{
			ClickDragToBounds(craftingBox[2], craftingBox[3], craftingBox[4], craftingBox[5])
			
			If (combineItems)
			{
				MouseGetPos, mouseX, mouseY
				Random, xRand, -100, -30
				Random, yRand, 30, 100
				MoveMouseHumanlike(mouseX + xRand, mouseY + yRand)
			
				combine := FindImageInImage("craftingwindowcombine", sideName)
				
				If (combine[1])
				{
					MoveMouseToBoundsRandom(combine[2], combine[3], combine[4], combine[5])
					DoSingleClick()
				}
			}
			SleepRandom(100, 300)
		}
	}
}

DragArrowsToQuiver()
{
	global stopLoop, stopReason
	
	arrowStackFound := FindInMenu("inventoryheader", "arrowshaftstack", "*TransBlack")
	
	If (arrowStackFound[1])
	{
		MoveMouseToImageRandom("arrowshaftstack", arrowStackFound[2], arrowStackFound[3], "*TransBlack")
		
		quiverSpaceFound := FindInMenu("quiverheader", "inventoryspace")
		If (quiverSpaceFound[1])
		{
			; Click hold on arrows
			Click, Down
			SleepRandom(300, 600)
			
			; Move to quiver space
			MoveMouseToImageRandom("inventoryspace", quiverSpaceFound[2], quiverSpaceFound[3])
			
			; Release click
			Click, Up
			SleepRandom(300, 600)
		
			MouseToArcheryIcon()
		}
		Else
		{
			stopLoop := 1
			stopReason := "Can't remedy archery: no quiver space found"
		}
	}
	Else
	{
		stopLoop := 1
		stopReason := "Can't remedy archery: no arrow stack"
	}
}

StringBow()
{
	global archeryToolbeltMap, stopLoop, stopReason
	
	ActivateToolbelt(archeryToolbeltMap["string"][1], archeryToolbeltMap["string"][2])
	SleepRandom(300,600)
	
	If (ScreenSearch("toolbeltlongbow"))
	{
		bowName := "toolbeltlongbow"
	}
	Else If (ScreenSearch("toolbeltshortbow"))
	{
		bowName := "toolbeltshortbow"
	}
		
	If (MoveMouseToImageRandom(bowName))
	{
		DoRightClick()
		SleepRandom(400,600)
		WaitForRefreshing()
		If (stopLoop)
		{
			return
		}
		
		SleepRandom(300,500)
		
		If (MoveMouseToImageRandom("string"))
		{
			SleepRandom(50, 200)
			DoSingleClick()
			SleepRandom(200, 500)
			
			WaitUntilIdle()
			SleepRandom(300, 2000)
			
			ActivateToolbelt(archeryToolbeltMap["bow"][1], archeryToolbeltMap["bow"][2])
			SleepRandom(1000,2000)
			
			MouseToArcheryIcon()
		}
	}

}