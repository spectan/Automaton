DoConfiguredTaskRemedy(giveChance=0)
{
	global task, secondChance, remedyUsed, previousTaskAttemptWorked, impWorldObject, stopLoop, stopReason
	
	remedyUsed := 1
	secondChance := giveChance
	
	If (TooHungry())
	{
		Say("Too Hungry")
		previousTaskAttemptWorked := 1
		secondChance := 1
		WaitUntilFasted()
		return
	}
	
	If (InStr(task, "Imp") AND !impWorldObject)
	{
		If (ImproveRequiresItem() AND !InStr(task, "Smithing"))
		{
			stopLoop := 1
			stopReason := "Improve requires item"
			return
		}
		previousTaskAttemptWorked := 1
		RemedyImp()
		If ((giveChance = 1) OR HasItemBelow())
		{
			secondChance := 1
		}
		Else
		{
			secondChance := 0
		}
	}
	Else If (InStr(task, "Tunnel"))
	{
		previousTaskAttemptWorked := 1
		RemedyTunnel()
	}
	Else If (InStr(task, "SurfaceMineFlat"))
	{
		previousTaskAttemptWorked := 1
		RemedySurfaceMineFlat()
	}
	Else If (InStr(task, "Archery"))
	{
		previousTaskAttemptWorked := 1
		secondChance := 0
		RemedyArchery()
	}
	Else If (task = "LevelCaveFloor")
	{
		previousTaskAttemptWorked := 1
		secondChance := 0
		RemedyLevelCaveFloor()
	}
	Else If (task = "Bricker")
	{
		previousTaskAttemptWorked := 1
		secondChance := 0
		RemedyBricker()
	}
	Else If (task = "KeyMoulds")
	{
		previousTaskAttemptWorked := 1
		secondChance := 0
		RemedyKeyMoulds()
	}
	Else If (task = "Mortar")
	{
		previousTaskAttemptWorked := 1
		secondChance := 0
		RemedyMortar()
	}
	Else
	{
		stopLoop := 1
		stopReason := "Previous action failed, no remedy configured"
	}
	
}

RemedyMortar()
{
	; deposit mortar
	DragMenuAItemXToMenuBItemY("inventoryheader", "mortartransblack", "bsbheader", "inventoryspace", "*TransBlack", 0)

	; pull clay from bsb if <10kg
	foundClay := FindInMenu("inventoryheader", "clay")
	If (!foundClay[1] OR MenuAHasLessThan10KgOfItemX("inventoryheader", "clay"))
	{
		WithdrawFromBSB("clay", , 30)
		withdrewClay := 1
	}
	
	; pull sand from bsb if <10kg
	foundSand := FindInMenu("inventoryheader", "sandtransblack", "*TransBlack")
	If (!foundSand[1] OR MenuAHasLessThan10KgOfItemX("inventoryheader", "sandtransblack", "*TransBlack"))
	{
		WithdrawFromBSB("sandtransblack", "*TransBlack", 3)
		withdrewSand := 1
	}
	
	; put in window and combine
	If (withdrewClay)
	{
		MoveItemFromInventoryToCraftingWindow("clay", "*TransWhite", 1, "right")
	}
	If (withdrewSand)
	{
		MoveItemFromInventoryToCraftingWindow("sandtransblack", "*TransBlack", 1, "left")
	}
}

RemedyKeyMoulds()
{
	; move moulds to altar
	DragMenuAItemXToMenuBItemY("inventoryheader", "keymouldtransblack", "altarheader", "inventoryspace", "*TransBlack", 0)
	
	; pull clay from bsb
	foundClay := FindInMenu("inventoryheader", "clay")
	If (!foundClay[1] OR MenuAHasLessThan10KgOfItemX("inventoryheader", "clay"))
	{
		WithdrawFromBSB("clay")
		
		; move inventory clay to craftingwindowright box and combine
		MoveItemFromInventoryToCraftingWindow("clay", "*TransWhite", 1, "right")
	}
	
	; sacrifice key moulds (position altar below crafting window create button)
	MoveMouseToImageRandom("createcontinuebutton")
	
	foundSaccableMoulds := FindInMenu("altarheader", "keymouldtransblack", "*TransBlack")
	If (foundSaccableMoulds[1])
	{
		Say("Sacking moulds")
		Random, xRand, -50, 50
		Random, yRand, 175, 200
		MouseGetPos, mouseX, mouseY
		MoveMouseHumanlike(mouseX + xRand, mouseY + yRand)
		DoKey("B")
		SleepRandom(300, 2000)
		WaitUntilIdle()
	}
}

RemedyBricker()
{
	; move bricks to bsb
	DragMenuAItemXToMenuBItemY("inventoryheader", "stonebricktransblack", "bsbheader", "inventoryspace", "*TransBlack", 0)
	
	; pull stone from bsb
	WithdrawFromBSB("stoneshardtransblack", "*TransBlack")
	
	; move inventory stone to craftingwindowright box and combine
	MoveItemFromInventoryToCraftingWindow("stoneshardtransblack", "*TransBlack", 1, "right")
}

RemedyArchery()
{
	global stopLoop, stopReason, archeryToolbeltMap
	
	If (StringBroke())
	{
		Say("String broke.")
		
		StringBow()
	}
	Else If (OutOfArrows())
	{
		Say("Out of arrows.")
		
		DragArrowsToQuiver()
	}
	Else
	{
		ActivateToolbelt(archeryToolbeltMap["bow"][1], archeryToolbeltMap["bow"][2])
		SleepRandom(1000, 3000)
		MouseToArcheryIcon()
	}
}

RemedySurfaceMineFlat()
{
	global surfaceMineX, surfaceMineY, stopLoop, stopReason
	
	DoSingleClick()
	currentX := surfaceMineX
	currentY := surfaceMineY
	Loop 5
	{
		MouseGetPos, mouseX, mouseY
		Random, randX, -10, 10
		Random, randY, -10, 10
		MoveMouseHumanlike(mouseX + randX, mouseY + randY - 50)
		
		MouseGetPos, mouseX, mouseY
		currentX := mouseX
		currentY := mouseY
		
		If (IsHoveringTileBorder())
		{
			break
		}
	}
	If (!IsHoveringTileBorder())
	{
		stopLoop := 1
		stopReason := "RemedySurfaceMineFlat could not find tile border"
	}
	Else
	{
		MouseGetPos, mouseX, mouseY
		surfaceMineX := mouseX
		surfaceMineY := mouseY
	}
}

RemedyTunnelIntoWater()
{
	global stopLoop, stopReason, enableLogout, logout, lastHadStamina, actionFinished, queueFinished
	stopLoop := 1
	stopReason := "You mined into water, logging out to avoid detection (60s no stam)"
	If (enableLogout)
	{
		logout := 1
	}
	
	;Disabled backing up because it seems like an easy way to get caught as obvious macroing
	
	;Say("BackUp")
	;SleepRandom(300, 2000)
	;DoAttentionLapse()
	;lastHadStamina := A_TickCount
	;actionFinished := 0
	;queueFinished := 0
	;BackUp()
	;SleepRandom(10*1000, 14*1000)
}

RemedyImp()
{
	global impXBalance, task, lastCheckedForge
	
		
	itemLineTopY := GetItemLineTop()
	
	MouseGetPos, mouseX, mouseY
	Random, yRand, 0, 15 - 3
	Random, xRand, -16, 16
	
	If (task = "SmithingImp")
	{
		lumpCooled := LumpCooled()		
		improveRequiresItem := ImproveRequiresItem()
		tooPoorShape := MaterialIsTooPoorShape()
		
		inventoryGlowingLumpFound := FindInMenu("inventoryheader", "ironlumpglowinghottransblack", "*TransBlack")
		
		; On a failed action, check for fuel if lump cooled or if it's been a random # minutes 15-30
		Random, randFuelInterval, 15, 30
		readyForFuelCheck := (A_TickCount - lastCheckedForge) > randFuelInterval * 60 * 1000
	
		If ((lumpCooled OR readyForFuelCheck) AND !IsForgeBurningSteadily())
		{
			FuelForgeWithLogFromBSB()
			
			If (!ForgeHasIronLumps())
			{
				stopLoop := 1
				stopReason := "Forge has no iron lumps"
				return
			}
			Else If (!ForgeHasGlowingIronLumps())
			{
				WaitUntilForgeHasGlowingIronLumps()
				
				; Additional 1-2m wait to let lump heat up some more
				SleepRandom(1 * 60 * 1000, 2 * 60 * 1000)
			}
		}
		
		If ((lumpCooled OR improveRequiresItem) AND !inventoryGlowingLumpFound[1])
		{
			ReplaceIronLumpFromForge()
		}
	
		If (!tooPoorShape)
		{
			itemLineTopY -= 18
		}
	}
	
	If (impXBalance < -16)
	{
		Random, xRand, 0, 16
	}
	If (impXBalance > 16)
	{
		Random, xRand, -16, 0
	}
	MoveMouseHumanlike(mouseX + xRand, itemLineTopY + 18 + 3 + yRand)
	impXBalace += xRand
}

RemedyLevelCaveFloor()
{
	If (TooFar())
	{
		AdvanceTile()
	}
}

RemedyTunnel()
{
	global minesPerformed, rockDepleted, didTunnelRemedy, stopLoop, maxQueue, tunnelDirection, secondChance, remedyUsed, previousTaskAttemptWorked
	
	remedyUsed := 1
	
	If (WallBroke() OR TooFar())
	{
		secondChance := 1
		AdvanceTile()
	}
	Else If (minesPerformed > 54 + 2 * maxQueue)
	{
		stopLoop := 1
		stopReason := "Unable to advance tunnel"
	}
	Else If (minesPerformed > 54 + 1 * maxQueue)
	{
		tunnelDirection := 0
		Loop %maxQueue%
		{
			SleepRandom(300, 2000)
			Say("Mining up")
			DoKey("PgUp")
			WaitUntilIdle()
			If (WallBroke())
			{
				MouseToRandomMiddle()
				If (!CaveWallHovered())
				{
					AdvanceToCaveWall()
				}
				Else
				{
					AdvanceTile()
				}
				rockDepleted := 0
				previousTaskAttemptWorked := 1
				Break
			}
		}
	}	
	Else If (minesPerformed > 54 + 0 * maxQueue)
	{
		tunnelDirection := 0
		Loop %maxQueue%
		{
			SleepRandom(300, 2000)
			Say("Mining down")
			DoKey("PgDn")
			WaitUntilIdle()
			If (WallBroke())
			{
				MouseToRandomMiddle()
				If (!CaveWallHovered())
				{
					AdvanceToCaveWall()
				}
				Else
				{
					AdvanceTile()
				}
				rockDepleted := 0
				previousTaskAttemptWorked := 1
				Break
			}
		}
	}
	Else If (didTunnelRemedy)
	{
		stopLoop := 1
		stopReason := "Unable to advance tunnel"
	}
	didTunnelRemedy := 1
}