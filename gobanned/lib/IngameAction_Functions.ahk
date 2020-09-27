ActivateToolbelt(page, slot)
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
			MoveMouseToCraftingButton()
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
				MoveMouseToCraftingButton()
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

PutColdLumpsInForge()
{
	global stopLoop, stopReason
	
	done := 0
	lineTopY := 0
	lumpOffset := 0
	lineHeight := 18

	ironLumpImageSize := GetImageSize("ironlumptransblack")
	inventorySpaceSize := GetImageSize("inventoryspace")
	
	foundFirstLump := FindInMenu("inventoryheader", "ironlumptransblack", "*TransBlack")
	
	If (foundFirstLump[1])
	{
		MouseToRandomAreaAroundPoint(foundFirstLump[2] - 100, foundFirstLump[3] - 100)
	
		groupBoxFound := FindCoordsInLine("groupboxtransblack", foundFirstLump[3], foundFirstLump[2]-20, "*TransBlack")
		
		If (groupBoxFound[1])
		{
			ironLumpBelow := GetImageCoords("ironlumpicontransblack", foundFirstLump[2], foundFirstLump[3] + ironLumpImageSize[2], , , "*TransBlack")
			
			If (!ironLumpBelow[1])
			{
				; Group is collapsed, expand first
				
				MoveMouseToImageRandom("groupboxtransblack", groupBoxFound[2], groupBoxFound[3], "*TransBlack")
				DoLeftClick()
				
				MouseGetPos, mouseX, mouseY
				MouseToRandomAreaAroundPoint(mouseX - 100, mouseY - 100)
			}
			
			; Move search coords down to first non-group lump
			lineTopY := foundFirstLump[3] - 1 + lineHeight
		}
		Else
		{
			lineTopY := foundFirstLump[3] - 1
		}
		
		While(!done)
		{
			currentLumpFound := GetImageCoords("ironlumptransblack", foundFirstLump[2], lineTopY + lumpOffset * lineHeight, , , "*TransBlack")
			
			If (currentLumpFound[1])
			{
				If (IsItemGlowingHot("ironlumptransblack", currentLumpFound[2], currentLumpFound[3], "*TransBlack"))
				{
					lumpOffset += 1
				}
				Else
				{
					; Put in forge
					forgeSpace := FindInMenu("forgeheader", "inventoryspace")
					
					If (forgeSpace[1])
					{
						forgeSpaceX1 := forgeSpace[2]
						forgeSpaceY1 := forgeSpace[3] + 18 ;18 down to avoid dragging into a container
						forgeSpaceX2 := forgeSpace[2] + inventorySpaceSize[1]
						forgeSpaceY2 := forgeSpace[3] + inventorySpaceSize[2]
						
						MoveMouseToBoundsRandom(currentLumpFound[2], currentLumpFound[3], currentLumpFound[2] + ironLumpImageSize[1], currentLumpFound[3] + ironLumpImageSize[2])
						ClickDragToBounds(forgeSpaceX1, forgeSpaceY1, forgeSpaceX2, forgeSpaceY2)
						SleepRandom(300, 500)
					}
					Else
					{
						stopLoop := 1
						stopReason := "Not enough empty space in forge to put cold lumps"
						done := 1
						return 0
					}
				}
			}
			Else
			{
				; no more lumps found
				done := 1
			}
		}
	}
	
	return 1
}

ReplaceIronLumpFromForge()
{
	global stopLoop, stopReason, smithingToolbeltMap
	DragMenuAItemXToMenuBItemY("forgeheader", "ironlumpglowinghottransblack", "inventoryheader", "inventoryspace", "*TransBlack", 1)
	PutColdLumpsInForge()
	
	hasGlowingIronLump := FindInMenu("inventoryheader", "ironlumpglowinghottransblack", "*TransBlack")
	
	If (hasGlowingIronLump[1])
	{
		AssignInventoryItemToToolbeltPageAndSlot("ironlumpglowinghottransblack", smithingToolbeltMap["ironlump"][1], smithingToolbeltMap["ironlump"][2], "*TransBlack")
	}
	Else
	{
		stopLoop := 1
		stopReason := "Failed to replace glowing hot iron lump in inventory"
	}
}

FuelForgeWithLogFromBSB()
{
	global stopLoop, stopReason

	WithdrawFromBSB("logstransblack", "*TransBlack", 1)
	
	foundLogs := FindInMenu("inventoryheader", "logstransblack", "*TransBlack")
	If (foundLogs[1])
	{
		MoveMouseToImageRandom("logstransblack", foundLogs[2], foundLogs[3], "*TransBlack")
		SleepRandom(300, 500)
		DoDoubleClick()
		
		If (!FindInLine("activepixel"))
		{
			stopLoop := 1
			stopReason := "Failed to activate log for refueling"
			return
		}
		
		forgeCoords := GetMenuCoords2("forgeheader")
		
		If (forgeCoords[1])
		{
			forgeCenterX := (forgeCoords[2] + forgeCoords[4])/2
			forgeBottomY := forgeCoords[5]
			
			MouseToRandomAreaAroundPoint(forgeCenterX, forgeBottomY + 50, 50, 20)
			
			DoRightClick()
			WaitForRefreshing()
			SleepRandom(300, 500)
			MoveMouseToImageRandom("burn")
			DoLeftClick()
		}
		Else
		{
			stopLoop := 1
			stopReason := "FuelForgeWithLogFromBSB failed to find forge coords"
		}
	}
	Else
	{
		stopLoop := 1
		stopReason := "FuelForgeWithLogFromBSB failed to withdraw logs"
	}
}

AssignInventoryItemToToolbeltPageAndSlot(itemName, page, slot, transMode="*TransWhite")
{
	global stopLoop, stopReason

	foundItem := FindInMenu("inventoryheader", itemName, transMode)
	
	If (foundItem[1])
	{
		DoKey(page, , , , "^")
		SleepRandom(100,200)
		
		slotWidth := 35
		slotOffset := (slotWidth + 2) * (slot-1)
		
		toolbeltCoords := GetImageCoords("toolbeltstart")
		
		If (toolbeltCoords[1])
		{
			toolbeltStartSize := GetImageSize("toolbeltstart")
		
			toolbeltSlotX1 := toolbeltCoords[2] + toolbeltStartSize[1] + slotOffset
			toolbeltSlotY1 := toolbeltCoords[3]
			toolbeltSlotX2 := toolbeltSlotX1 + slotWidth
			toolbeltSlotY2 := toolbeltSlotY1 + toolbeltStartSize[2]
			
			MoveMouseToImageRandom(itemName, foundItem[2], foundItem[3], transMode)
			ClickDragToBounds(toolbeltSlotX1 + 2, toolbeltSlotY1 + 2, toolbeltSlotX2 - 2, toolbeltSlotY2 - 2)
			
			MoveMouseToImageRandom("toolbeltstart")
			DoRightClick()
			WaitForRefreshing()
			MoveMouseToImageRandom("savetoolbelt")
			DoLeftClick()
		}
		Else
		{
			stopLoop := 1
			stopReason := "AssignInventoryItemToToolbeltPageAndSlot failed: toolbelt not found"
		}
	}
	Else
	{
		stopLoop := 1
		stopReason := "AssignInventoryItemToToolbeltPageAndSlot failed: " . itemName . " not found"
	}
	SleepRandom(100,200)
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

WithdrawFromBSB(imageName, transMode="*TransWhite", quantity=0)
{
	global stopLoop, stopReason

	DragMenuAItemXToMenuBItemY("bsbheader", imageName, "inventoryheader", "inventoryspace", transMode)
	WaitUntilRemovingItems()
	
	foundSend := FindInMenu("removingitemsheader", "bsbsendbutton")
	
	If (foundSend[1])
	{
		If (quantity)
		{
			TypeInput(quantity)
		}
	
		ClickOnImage("bsbsendbutton", "left", foundSend[2], foundSend[3])
	}
	Else
	{
		stopLoop := 1
		stopReason := "Send not found when removing items from bsb"
	}
}

WithdrawFromSmallCrate(imageName, transMode="*TransWhite", quantity=0)
{
	global stopLoop, stopReason

	DragMenuAItemXToMenuBItemY("smallcrateheader", imageName, "inventoryheader", "inventoryspace", transMode)
	WaitUntilRemovingItems()
	
	foundSend := FindInMenu("removingitemsheader", "bsbsendbutton")
	
	If (foundSend[1])
	{
		If (quantity)
		{
			TypeInput(quantity)
		}
	
		ClickOnImage("bsbsendbutton", "left", foundSend[2], foundSend[3])
	}
	Else
	{
		stopLoop := 1
		stopReason := "Send not found when removing items from small crate"
	}
}

WithdrawFromAnywhere(imageName, transMode="*TransWhite")
{
	global stopLoop, stopReason
	
	pileItemFound := FindInMenu("pileheader", imageName, transMode)
	smallCrateItemFound := FindInMenu("smallcrateheader", imageName, transMode)
	; TODO: large crate
	;largeCrateItemFound := FindInMenu("largecrateheader", imageName, transMode)
	bsbItemFound := FindInMenu("bsbheader", imageName, transMode)
	
	If (pileItemFound[1])
	{
		DragMenuAItemXToMenuBItemY("pileheader", imageName, "inventoryheader", "inventoryspace", transMode)
	}
	Else if (smallCrateItemFound[1])
	{
		WithdrawFromSmallCrate(imageName, transMode)
	}
	; TODO: large crate
	Else if (bsbItemFound[1])
	{
		WithdrawFromBSB(imageName, transMode)
	}
	Else
	{
		stopLoop := 1
		stopReason := "WithdrawFromAnywhere did not find any " . imageName
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