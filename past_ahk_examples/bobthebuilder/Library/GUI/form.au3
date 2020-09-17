#Region ### START Koda GUI section ### Form=c:\users\zeroghj\desktop\vincent\workspace\autoit\koda\forms\form1.kxf
$Bobthebuilder = GUICreate("Bob The Builder v2.1.2", 450, 371, 259, 142)
$TabMainMen = GUICtrlCreateTab(0, 0, 433, 217)
$Main = GUICtrlCreateTabItem("Main Menu")
$ListofActivity = GUICtrlCreateCombo("ListofActivity", 16, 48, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Mining|Digging|Tracking|Fishing|Creation|Improve")
$Groupeteration = GUICtrlCreateGroup("Iteration", -10,-10,0,0)
$InputIteration = GUICtrlCreateInput("1", -10,-10,0,0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_DISABLE)
$Groupchangetool = GUICtrlCreateGroup("", -10,-10,0,0)
$Lblchangetool = GUICtrlCreateLabel("Change Tool?", -10,-10,0,0)
$RadChangeToolYes = GUICtrlCreateRadio("Yes", -10,-10,0,0)
$RadChangeToolNo = GUICtrlCreateRadio("No", -10,-10,0,0)
GUICtrlSetState(-1, $GUI_CHECKED)
$Lblchangetooleach = GUICtrlCreateLabel("Each", -10,-10,0,0)
$Inptooleach = GUICtrlCreateInput("1", -10,-10,0,0)
$LblCycles = GUICtrlCreateLabel("Cycles", -10,-10,0,0)
$BtnSetTools = GUICtrlCreateButton("SetTool", -10,-10,0,0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_DISABLE)
$GroupBulkBin = GUICtrlCreateGroup("Bulk Bin", -10,-10,0,0)
$RadBBNo = GUICtrlCreateRadio("No", -10,-10,0,0)
GUICtrlSetState(-1, $GUI_CHECKED)
$RadBBYes = GUICtrlCreateRadio("Yes", -10,-10,0,0)
$InpBBPick = GUICtrlCreateInput("Pick #", -10,-10,0,0)
$InpBBDrop = GUICtrlCreateInput("Drop #", -10,-10,0,0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_DISABLE)
$GroupImprove = GUICtrlCreateGroup("",-10,-10,0,0)
$BtnImproveSetLump = GUICtrlCreateButton("Set Lump", -10,-10,0,0)
$BtnImproveSetItems = GUICtrlCreateButton("Set Items", -10,-10,0,0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_DISABLE)
$GroupCreation = GUICtrlCreateGroup("", -10,-10,0,0)
$BtnCreationSet = GUICtrlCreateButton("Set", -10,-10,0,0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_DISABLE)
$InpCreation1 = GUICtrlCreateInput("Creation Menu 1", -10,-10,0,0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$InpCreation2 = GUICtrlCreateInput("Creation Menu 2", -10,-10,0,0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Option = GUICtrlCreateTabItem("Option")
$GroupAutoWalk = GUICtrlCreateGroup("", 29, 93, 225, 49)
$LblAutoWalk = GUICtrlCreateLabel("Auto_Walk", 37, 109, 57, 17)
$RadAutoWalkOn = GUICtrlCreateRadio("On", 101, 109, 41, 17)
$RadAutoWalkOff = GUICtrlCreateRadio("Off", 149, 109, 65, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupWater = GUICtrlCreateGroup("Drink", 29, 29, 233, 65)
$BtnWaterSet = GUICtrlCreateButton("Set Water", 45, 53, 75, 25)
$BtnWaterOff = GUICtrlCreateButton("Water Off", 125, 53, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupBeep = GUICtrlCreateGroup("Beep", 277, 29, 65, 73)
$RadBeepoff = GUICtrlCreateRadio("Off", 285, 53, 49, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$RadBeepon = GUICtrlCreateRadio("On", 285, 77, 49, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupMinimize = GUICtrlCreateGroup("Minimize", 341, 29, 65, 73)
$RadMinimizeoff = GUICtrlCreateRadio("Off", 349, 53, 49, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$RadMinimizeOn = GUICtrlCreateRadio("On", 349, 77, 49, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$limitgroup = GUICtrlCreateGroup("", 8, 216, 185, 97)
$Cycleinput = GUICtrlCreateInput("", 40, 272, 121, 21)
$RadTimeLimit = GUICtrlCreateRadio("Time Limit", 24, 240, 73, 17)
$RadCyclelimit = GUICtrlCreateRadio("Cycle Limit", 112, 240, 81, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupStopstartpointclick = GUICtrlCreateGroup("", 40, 312, 345, 57)
$BtnStartpointclick = GUICtrlCreateButton("Start", 104, 328, 75, 25)
$Btnstoppointclick = GUICtrlCreateButton("Stop", 216, 328, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupCycletime = GUICtrlCreateGroup("", 200, 240, 225, 65)
$LblCycletime = GUICtrlCreateLabel("Cycle Time", 216, 256, 56, 17)
$InpCycletime = GUICtrlCreateInput("Insert Cycle Time", 288, 256, 121, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###