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

;GUI and Config
;Starts GUI
F4::
;GUI Layout

I_Icon = %A_ScriptDir%\include\peepo.ico
ICON [I_Icon]
if I_Icon <>
IfExist, %I_Icon%
	Menu, Tray, Icon, %I_Icon% 

Gui, Font, s32 Bold Underline, Arial
Gui, Add, Text, x56 y8 w410 h69, B  I  G    I  M  P  E  R
Gui, Font
Gui, Add, Picture, x528 y18 w399 h361, %A_ScriptDir%\include\peepo.jpg
Gui, Add, Button, x16 y360 w80 gButtonOK, OK
Gui, Add, Tab3, x16 y80 w492 h271, Setup|Mode|Breaks|Config|Info
Gui, Tab, 1
Gui, Add, Text, x40 y120 w400 h13, Use the latest UI with scaling set at 90`% and opacity set at 100`% ;needed to escape the percent sign
Gui, Add, Text, x40 y150 w120 h13, Username:
Gui, Add, ComboBox, x40 y170 w120 vUsername, Auto Detect
Gui, Add, Text, x40 y200 w120 h13, Improve Bind:
Gui, Add, Edit, x40 y220 w120 h21 vImprove 0x10, i ;only allows lowercase letters
Gui, Add, Text, x40 y250 w120 h13, Repair Bind:
Gui, Add, Edit, x40 y270 w120 h21 vRepair 0x10, r ;only allows lowercase letters
Gui, Add, Text, x40 y300 w120 h13, Number of Actions:
Gui, Add, Edit, x40 y320 w27 h21 vActions 0x2000, 3 ;only allows numbers
Gui, Tab, 2
Gui, Add, Text, x40 y120 w400 h13, Improvement Type (Pick One):
Gui, Add, DropDownList, x40 y140 w120 h21 r6 vImpType Choose1 Sort, Carpentry|Cloth Tailoring|Leatherworking|Masonry|Smithing|Pottery
Gui, Add, Text, x40 y170 w400 h13, Improvement Mode (Pick One):
Gui, Add, DropDownList, x40 y190 w120 h21 r3 vImpMode Choose2 Sort, Pile of Same Items|Singular Item|World Item
Gui, Tab, 3
Gui, Add, CheckBox, x40 y120 w400 h13 vAutismMode gAutism, Autism Mode
Gui, Add, GroupBox, x40 y140 w400 h100 vContainerBox
Gui, Add, Text, x60 y170 w21 h13 vTesting, Testing
;need to add some sort of way to disable everything in container if autismmode is checked
;im thinking you can set a short medium and long break in ms
Gui, Tab, 4
;need to check out ini files, save curent selections and stuff to a file, and load configs back out again
Gui, Tab, 5
Gui, Add, Text, x40 y120 w400 h13, Version: 0.1
Gui, Add, Text, x40 y140 w400 h13, Updated: 9/09/2020
Gui, Add, Text, x40 y160 w400 h13, Created: 1/09/2020
Gui, Add, Text, x40 y180 w400 h13, Brought to you by: ???, ???, Dissimulo
Gui, Add, Text, x40 y200 w400 h13, Fuck Retro *dab*, fuck Keenan *dab*, fuck Enki *dab*, free my homies
Gui, Show, w950 h400, Wurm RSI Assistant
Return

Autism:
GuiControlGet, AutismMode
if (AutismMode = 1) {
    GuiControl, Disable, Testing
} 
else {
    GuiControl, Enable, Testing
}
Return

ButtonOK:
IniWrite, Username, %A_ScriptDir%\include\config.ini, GUI Settings, Username
Return

GuiClose:
ExitApp
Return
GuiEscape:
Gui, Submit  ; Saves the contents above to the variables specified.
;MsgBox Actions = %Actions%, Improve = %Improve%, Repair = %Repair%, Username = %Username%, ImproveType = %ImpType%, ImproveMode = %ImpMode% ;Debug for verifying variables saved appropriately
Return ;This will be ExitApp, just return for ease of testing.

;END OF SETUP
;

F5::
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

F6::
Run Imper.ahk
Return

F12::
ExitApp