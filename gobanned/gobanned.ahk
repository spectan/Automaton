#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1

#Include %A_ScriptDir%/lib
#Include Gdip_All.ahk
#Include Image_Functions.ahk
#Include State_Functions.ahk
#Include Input_Functions.ahk
#Include Utility_Functions.ahk
#Include DoTask_Functions.ahk
#Include DoRemedy_Functions.ahk
#Include IngameAction_Functions.ahk
#Include ConditionalWait_Functions.ahk

;Configuration
;Task options are: SingleClick, MultiClick, SingleKey, MultiKey, MasonryImp, SmithingImp, CarpentryImp, Tunnel, PracticeDoll, SurfaceMineFlat, Archery, LevelCaveFloor, ActionBell, ClothTailoringImp, Woodcutting, DigClayToBSB, Bricker, KeyMoulds, Mortar, ContinueBrickWall
task := "ContinueBrickWall"
maxQueue := 3
actionKey := "T"

;Settings
attentiveMode := 1
impArrowMode := 0
impWorldObject := 0
tunnelDirection := 0
woodcuttingWalk := 0
usingChopTool := 1
optionalRepairEnabled := 1
drinkWaterEnabled := 1

;End options
woodcuttingWalkTime := 20
tunnelLimit := 0
alarmOnlyMode := 0
enableLogout := 0
enableFourHourLimit := 0
whiteNameAlarmEnabled := 0
alarm := 1 ;keep on so you know when macro stops


;Toolbelt configs - Enter each tool as tool: [page,slot]
smithingToolbeltMap := {"ironlump": [1,1], "water": [2,1], "pelt": [3,1], "whetstone": [4,1], "hammer": [5,1]}
masonryToolbeltMap := {"rockshard": [6,1], "chisel": [7,1]}
leatherworkingToolbeltMap := {}
carpentryToolbeltMap := {"log": [1,2], "carvingKnife": [2,2], "pelt": [3,1], "file": [3,2], "mallet": [4,2]}
clothtailoringToolbeltMap := {"stringofcloth": [5,2], "needle": [6,2], "scissors": [7,2], "water": [2,1]}
archeryToolbeltMap := {"bow": [8,1], "string": [8,2]}
waterToolbeltPage := 2

;Probably remove
enableWiggle := 0 ;danger, may be a giveaway that you're macroing

;Globals
stopLoop := 0
fourHourLimited := 0
isFullStamina = 0
isQueued = 0
isDoingAction = 0
isNotDoingAction = 0
strafeBalance := 0
straightBalance := 0
impXBalance := 0
previousTaskAttemptWorked := 1
actionFinished := 1
remedyUsed := 0
secondChance := 0
actionInitiated := 0
logout := 0
stopReason := ""
wallBroke := 0
minesPerformed := 0
didTunnelRemedy := 0
advancedTile := 0
tilesMined := 0
queueFinished := 0
FoundX := 0
FoundY := 0
progressingFromBreakSoon := 0
surfaceMineX := 0
surfaceMineY := 0
wasDoingAction := 0
severeAlarmPlaying := 0


; need to refactor activatetoolbelt to take the tool name and toolbelt map so we can keep track of the currently active tool
activeTool := ""


Run, nircmd.exe setappvolume "WurmLauncher64.exe" .26
MsgBox, 0, , 
	(LTrim
	Macro loaded: %task%
	
	INSTRUCTIONS: 
	   -Press F2 to test a function
	   -Press F4 to relaunch macro
	   -Press F5 to begin macroing
	   -Press F7 to exit macro
	)


;F2 Hotkey for testing functions
F2::
	global stopLoop, stopReason, smithingToolbeltMap
	ret := ScreenSearch("continuebutton")
	MoveMouseToCraftingButton()
	
	MsgBox, continuefound=%ret% %stopLoop% %stopReason%
Return

F5::
Macro1:
Say("Start")
global stopLoop, whiteNameAlarmEnabled, woodcuttingWalk, wasDoingAction, carpentryToolbeltMap, drinkWaterEnabled, stopReason, surfaceMineX, surfaceMineY, optionalRepairEnabled, progressingFromBreakSoon, queueFinished, lastHadStamina, alarmOnlyMode, wallBroke, maxQueue, tilesMined, advancedTile, minesPerformed, didTunnelRemedy, logout, startTime, fourHourLimited, previousTaskAttemptWorked, actionFinished, archeryToolbeltMap, remedyUsed, alarm, secondChance, actionInitiated, enableLogout, enableWiggle
global isFullStamina, isQueued, isDoingAction, isNotDoingAction ;debug variables

startTime := A_TickCount
lastCheckedForge := 0
lastMovement := A_TickCount - (9 * 60 * 1000) ;first move is at earliest 1m after start
lastHadStamina := startTime

If (impArrowMode)
{
	carpentryToolbeltMap := {"log": [1,2]}
}

WinActivate, Wurm Online
Sleep, 333

If (whiteNameAlarmEnabled AND IsWhiteNameInLocal())
{
	SevereAlarm("LOCAL", Clipboard)
}

If (alarmOnlyMode)
{
	Run, nircmd.exe setappvolume focused 0
}
Else
{
	Run, nircmd.exe setappvolume focused .26
}

Sleep, 333

If (!IsCraftingOpen())
{
	DoKey("u")
}

;ClearEventTab()

If (task = "Tunnel")
{
	MouseToRandomMiddle()
	If (!CaveWallHovered())
	{
		DoSingleClick()
	}
}

If (task = "LevelCaveFloor")
{
	MouseToRandomMiddle()
	If (!IsHoveringCaveFloor())
	{
		DoSingleClick()
	}
}

If (task = "Woodcutting" AND woodcuttingWalk)
{
	MouseToRandomBottomMiddle()
	If (!IsHoveringWoodcuttable())
	{
		DoSingleClick()
	}
}

If (task = "ActionBell")
{
	drinkWaterEnabled := 0
	optionalRepairEnabled := 0
	logout := 0
	tunnelLimit := 0
}

If (task = "SurfaceMineFlat")
{
	DoSingleClick()
	MouseToRandomMiddle(5)
	If (!IsHoveringTileBorder())
	{
		Loop 5
		{
			MouseGetPos, mouseX, mouseY
			Random, randX, -10, 10
			Random, randY, -10, 10
			MoveMouseHumanlike(mouseX + randX - 50, mouseY + randY)
			If (IsHoveringTileBorder())
			{
				break
			}
		}
	}
	If (!IsHoveringTileBorder())
	{
		stopLoop := 1
		stopReason := "SurfaceMineFlat could not find tile border on start"
	}
	Else
	{
		MouseGetPos, mouseX, mouseY
		surfaceMineX := mouseX
		surfaceMineY := mouseY
	}
}

If (task = "Archery")
{
	ActivateToolbelt(archeryToolbeltMap["bow"][1], archeryToolbeltMap["bow"][2])
}

Loop
{
	If (stopLoop = 1)
	{
		Break
	}
    IfWinActive, Wurm Online
    {
		If (whiteNameAlarmEnabled AND IsWhiteNameInLocal())
		{
			SevereAlarm("LOCAL", Clipboard)
		}
		
		If (IsActionBlocked())
		{
			stopLoop := 1
			stopReason := "Clear the area"
		}
	
		If (task = "LevelCaveFloor" AND NoSpaceToMine())
		{
			stopLoop := 1
			stopReason := "No space to mine"
		}
		
		If (IsEmptyStamina())
		{
			DoKey("Esc", , maxQueue)
		}
		
		If (!stopLoop AND IsIdle())
		{
			actionFinished := 1
		}
		
		If (IsDoingAction())
		{
			wasDoingAction := 1
		}
		
		If (IsIdle() AND wasDoingAction)
		{
			wasDoingAction := 0
			If (task = "ActionBell")
			{
				PlaySound("Ding")
			}
		}
		
		If (!stopLoop AND actionFinished AND IsFullStamina() AND !IsBusy() AND IsIdle() AND !queueFinished)
		{
			queueFinished := 1
		}
		
		If (!stopLoop AND task = "Tunnel")
		{
			If (tilesMined >= tunnelLimit AND tunnelLimit > 0)
			{
				stopLoop := 1
				stopReason := "Tunnel limit of " . tunnelLimit . " reached"
				SleepRandom(300, 2000)
				DoKey("Esc", , maxQueue)
			}
			If (NoMineSpace())
			{
				stopLoop := 1
				stopReason := "No space to mine, ground is full"
			}
			If (IsFullStamina() OR IsBusy() OR !IsIdle())
			{
				lastHadStamina := A_TickCount
			}
			Else If (!stopLoop AND !remedyUsed AND actionFinished AND (A_TickCount - lastHadStamina) > 60*1000)
			{
				RemedyTunnelIntoWater()
			}
			If (minesPerformed > 0 AND !WallBroke() AND WallWillBreakSoon() AND minesPerformed < 45)
			{
				Say("Wall will break soon")
				minesPerformed := 45
				progressingFromBreakSoon := 1
			}
			If (minesPerformed > 0 AND !WallBroke() AND (RockDepleted() OR (!progressingFromBreakSoon AND CannotKeepMining())) AND minesPerformed < 54)
			{
				minesPerformed := 54
			}
			If (!stopLoop AND queueFinished AND WallBroke() AND !CaveWallHovered())
			{
				MouseToRandomMiddle()
				If (!CaveWallHovered())
				{
					AdvanceToCaveWall()
				}
			}
		}
		
		If (!stopLoop AND queueFinished AND Thirsty() AND drinkWaterEnabled)
		{
			DrinkWater()
		}

		;do action attempt
		If (queueFinished AND !IsFourHourShutoff() AND !(logout = 1) AND !stopLoop AND (task != "ActionBell"))
		{
			If (previousTaskAttemptWorked = 1)
			{
				If (task = "Tunnel")
				{
					; On crossing of 10s threshhold
					If ((minesPerformed > 50) OR (minesPerformed >= (minesPerformed // 10)*10) AND (minesPerformed < ((minesPerformed // 10)*10+maxQueue)) AND (minesPerformed >= 10))
					{
						Say(minesPerformed)
					}
				}
				previousTaskAttemptWorked := 0
				If (enableWiggle = 1 AND HasntMoved()) ;move occasionally
				{
					DoWiggle()
				}
				SleepRandom(300, 2000) ;human reaction time to stamina refilling = 300, 2000
				DoAttentionLapse()
				If (optionalRepairEnabled)
				{
					RepairActiveToolIfDamaged()
				}
				DoConfiguredTask()
				SleepRandom(300, 2000)
				actionFinished := 0
				queueFinished := 0
				actionInitiated := 1
			}
			Else If (remedyUsed = 0)
			{
				DoConfiguredTaskRemedy(1) ;1 to make second chance available
			}
			Else if (remedyUsed = 1 AND secondChance = 1)
			{
				DoConfiguredTaskRemedy(0)
			}
			Else
			{
				stopLoop := 1
				If (stopReason = "")
				{
					stopReason := "Action failed to start and remedy didn't work (or reason unknown)"
				}
			}
		}
		Else ;couldnt do an action attempt
		{
			;reset state if current is working
			If ((actionInitiated = 1) AND (!IsFullStamina() OR IsDoingAction() OR !IsNotDoingAction()))
			{
				;PlaySound("Ding")
				previousTaskAttemptWorked := 1
				remedyUsed := 0
				secondChance := 0
				actionInitiated := 0
				
				If (task = "Tunnel")
				{
					If (wallBroke AND advancedTile)
					{
						minesPerformed := 0
						wallBroke := 0
						advancedTile := 0
						didTunnelRemedy := 0
						rockDepleted := 0
						tilesMined += 1
						PlaySound("Ding")
					}
					minesPerformed += maxQueue
				}
			}
			;MsgBox, isFullStamina=%isFullStamina%, isQueued=%isQueued%, isDoingAction=%isDoingAction%, isNotDoingAction=%isNotDoingAction%
		}
		
		Sleep, 1000 ;reduce polling rate to once per second = 1000
		
		If (stopLoop OR logout)
		{
			TakeScreenshot("endscreen")
		}
		
		If (stopLoop = 1)
		{
			If (alarm = 1)
			{
				alarmOnlyMode := 1
				PlaySound("Alarm")
			}
			If (enableLogout = 1)
			{
				logout := 1
			}
		}
		
		If (logout = 1)
		{
			SleepRandom(300, 2000) ;some randomization before logout = 300, 2000
			DoLogout()
		}
    }
}

Run, nircmd.exe setappvolume focused .26
elapsed := (A_TickCount - startTime)/1000/60
MsgBox, 0, , 
	(LTrim
		Macro ended: %task%
			stopReason=%stopReason%
			elapsed=%elapsed% minutes
			previousTaskAttemptWorked=%previousTaskAttemptWorked%
			remedyUsed=%remedyUsed%
			secondChance=%secondChance%
			
			stopLoop=%stopLoop%
			logout=%logout%
			fourHourLimited=%fourHourLimited%
			tilesMined=%tilesMined%
	)
Return
;End of F5

F4::
Run gobanned.ahk
Return

SevereAlarmThread:
	global severeAlarmPlaying
	If (severeAlarmPlaying)
	{
		PlaySound("Snake")
		Sleep, 900
	}
return

F7::
ExitApp
