;THE BIG IMPER
;
;Ensure your game is set to the new UI -- Dark Edition at 90% scale and 100% opacity for minimal errors.
;SETUP
;

;init params
#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
#Include, %A_ScriptDir%\include\helpers.ahk

;Starts GUI
F4::
;added comments so this isn't a fucking word bubble

I_Icon = %A_ScriptDir%\include\peepo.ico
ICON [I_Icon]
if I_Icon <>
IfExist, %I_Icon%
	Menu, Tray, Icon, %I_Icon% 

;Style and Layout
Gui, Font, s32 Bold Underline, Arial
Gui, Add, Text, x56 y8 w410 h69, A U T O M A T O N
Gui, Font
Gui, Add, Picture, x528 y18 w399 h361, %A_ScriptDir%\include\peepo.jpg
Gui, Add, Button, x16 y360 w80, Ok
Gui, Add, Tab3, x16 y80 w492 h271, Setup|Mode|Breaks|Config|Info
;Tab 1
Gui, Tab, 1
;Column One
Gui, Add, Text, x40 y120 w400 h13, Use the latest UI with scaling set at 90`% and opacity set at 100`% ;needed to escape the percent sign
Gui, Add, Text, x40 y140 w120 h13, Username:
Gui, Add, ComboBox, x40 y+10 w120 vUsername, Auto
Gui, Add, Text, x40 y+10 w120 h13, Improve Bind:
Gui, Add, Edit, x40 y+5 w120 h21 vImprove 0x10, i ;only allows lowercase letters
Gui, Add, Text, x40 y+10 w120 h13, Repair Bind:
Gui, Add, Edit, x40 y+5 w120 h21 vRepair 0x10, r ;only allows lowercase letters
Gui, Add, Text, x40 y+10 w120 h13, Number of Actions:
Gui, Add, Edit, x40 y+5 w27 h21 vActions 0x2000, 3 ;only allows numbers
;Column Two
Gui, Add, Text, x240 y140 w150 h13, MineForward/DigtoPile bind:
Gui, Add, Edit, x240 y+5 w150 h21 vMineDig 0x10, m ;only allows lowercase letters
;Tab 2
Gui, Tab, 2

Gui, Add, Text, x40 y120 w400 h13, Script Mode (Pick One):
Gui, Add, DropDownList, x40 y140 w120 h21 r6 gSMode vScriptMode Sort, Improving|Gathering|World Interaction

Gui, Add, Text, x40 y170 w400 h13 vImpTypeText Hidden, Improvement Type (Pick One):
Gui, Add, DropDownList, x40 y190 w120 h21 r6 vImpType Sort Hidden, Carpentry|Cloth Tailoring|Leatherworking|Masonry|Smithing|Pottery
Gui, Add, Text, x40 y170 w400 h13 vGatherTypeText Hidden, Gathering Type (Pick One):
Gui, Add, DropDownList, x40 y190 w120 h21 r6 vGatherType Sort Hidden, Wall-Miner/Dig to Pile|

Gui, Add, Text, x40 y220 w400 h13 vImpStyleText Hidden, Improvement Style (Pick One):
Gui, Add, DropDownList, x40 y240 w120 h21 r3 vImpStyle Sort Hidden, Pile of Same Items|Singular Item|World Item
;Tab 3
Gui, Tab, 3
Gui, Add, CheckBox, x40 y120 w400 h13 vAutismMode gAutism, Autism Mode
Gui, Add, GroupBox, x40 y140 w400 h100 vContainerBox
Gui, Add, Text, x60 y170 w21 h13 vTesting, Testing
;need to add some sort of way to disable everything in container if autismmode is checked
;im thinking you can set a short medium and long break in ms
;Tab 4
Gui, Tab, 4
;need to check out ini files, save curent selections and stuff to a file, and load configs back out again
;Tab 5
Gui, Tab, 5
Gui, Add, Text, x40 y120 w400 h13, Version: 0.10
Gui, Add, Text, x40 y140 w400 h13, Updated: 13/09/2020
Gui, Add, Text, x40 y160 w400 h13, Created: 1/09/2020
Gui, Add, Text, x40 y180 w400 h13, Brought to you by: ???, Spectan, Dissimulo
Gui, Add, Text, x40 y200 w400 h13, Fuck Retro *dab*, fuck Keenan *dab*, fuck Enki *dab*, free the homie
Gui, Show, w950 h400, Wurm RSI Assistant
Return

;SCRIPT MODE inside the GUI -- For example, if you set the mode to "Improving" you will now be able to select your improvement mode like carpentry and style like pile-imper.
SMode:
GuiControlGet, ScriptMode
if (ScriptMode = "Improving") {
    GuiControl, Show Enable, ImpTypeText
    GuiControl, Show Enable, ImpType
    GuiControl, Hide Disable, GatherTypeText
    GuiControl, Hide Disable, GatherType
    GuiControl, Show Enable, ImpStyleText
    GuiControl, Show Enable, ImpStyle
}
if (ScriptMode = "Gathering") {
    GuiControl, Hide Disable, ImpTypeText
    GuiControl, Hide Disable, ImpType
    GuiControl, Show Enable, GatherTypeText
    GuiControl, Show Enable, GatherType
    GuiControl, Hide Disable, ImpStyleText
    GuiControl, Hide Disable, ImpStyle
}
if (ScriptMode = "World Interaction") {
    GuiControl, Hide Disable, ImpTypeText
    GuiControl, Hide Disable, ImpType
    GuiControl, Hide Disable, GatherTypeText
    GuiControl, Hide Disable, GatherType
    GuiControl, Hide Disable, ImpStyleText
    GuiControl, Hide Disable, ImpStyle
}

Autism:
GuiControlGet, AutismMode
if (AutismMode = 1) {
    GuiControl, Disable, Testing
} 
else {
    GuiControl, Enable, Testing
}
Return


GuiClose:
ExitApp
Return
ButtonOK:
GuiEscape:
Gui, Submit
;Saves all .ini settings
;Could possibly set it up so each tab is under a different section, but was too lazy.
varSaver := "Username,Improve,Repair,MineDig,Actions,ImpType,GatherType,ImpStyle" ;THIS MUST BE THE SAME IN EVERY SCRIPT THAT WILL READ THIS INI!!!! VERY IMPORTANT. NO SPACES
loop, parse, varSaver, `,
    IniWrite, % %A_LoopField%, %A_ScriptDir%\include\config.ini, Setup, % A_LoopField
Return


;MsgBox Actions = %Actions%, Improve = %Improve%, Repair = %Repair%, Username = %Username%, ImproveType = %ImpType%, ImproveMode = %ImpStyle% ;Debug for verifying variables saved appropriately
;END OF SETUP
;


F5::
;Launches script based on setting
If (ScriptMode = "Improving") {
    Run Imper.ahk
}

If (ScriptMode = "Gathering") {
    Run Gatherer.ahk
}
/*
If (ScriptMode = "World Interaction") {
    Run WorldInt.ahk
}




;Toolbelt Selector, set by the GUI.
;Toolbelts (need to add a better way to configure this in the future)
;need to look into .ini files, a toolbelt setup tab linked to the ini, and the second toolbelt setup for water food and lockpicks
Toolbelt := 0
;implemented switch statement, needs AHK [v1.1.31+] to work
switch ImpType 
{
    case "Carpentry":
        Toolbelt := {"log": 1, "carving": 2, "pelt": 3, "file": 4, "mallet": 5}
    case "Cloth Tailoring":
        Toolbelt := {"string": 1, "needle": 2, "scissors": 3, "water": 4}
    case "Leatherworking":
        Toolbelt := {"leather": 1, "needle": 2, "lknife": 3, "mallet": 4, "awl": 5}
    case "Masonry":
        Toolbelt := {"rockshard": 1, "chisel": 2}
    case "Smithing":
        Toolbelt := {"lump": 1, "hammer": 2, "pelt": 3, "whetstone": 4, "water": 5}
    case "Pottery":
        Toolbelt := {"clay": 1, "shaper": 2, "spatula": 3, "hand": 4, "water": 5}
    default:
        MsgBox, Some shit got fucked up
}
;Debug for testing array properly assigns to the variable

For index, value in Toolbelt
    MsgBox % "Item " index " is '" value "'"
*/

F6::
Run RUNTHISFIRST.ahk ;test run

Return

F12::
ExitApp