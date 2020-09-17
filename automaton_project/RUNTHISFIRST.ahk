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

F4::
;Starts GUI
;Toolbelt presets for use within the GUI, they have to be located before the script!
carpTools = |mallet|pelt|log|carvingknife|file
smithTools = |whetstone|pelt|hammer|water|lump
clothTools = |scissors|string|needle|water
lwTools = |needle|awl|leatherknife|mallet|leather
masonTools = |rockshard|chisel
potteryTools = |clayshaper|clay ;what fucking tools does this use
miscTools = |chest|satchel|bow|meal|water

I_Icon = %A_ScriptDir%\include\peepo.ico
ICON [I_Icon]
if I_Icon <>
IfExist, %I_Icon%
	Menu, Tray, Icon, %I_Icon% 

;Style and Layout
;Should try to keep as much of the GUI dependent on an initial coordinate, it makes adding things much easier! The exception to this would be columns, read in Tab 1
;Another exception would be hidden buttons/fields, you'd want the hidden fields to have the same coordinates.
Gui, Font, s32 Bold Underline, Arial
Gui, Add, Text, x56 y8 w410 h69, A U T O M A T O N
Gui, Font
Gui, Add, Picture, x528 y18 w399 h361, %A_ScriptDir%\include\peepo.jpg
Gui, Add, Button, x16 y360 w80, Ok
Gui, Add, Text, x+10 y365, Hit Ok to start, F5 to run afterwards, F12 is emergency stop/restart.
Gui, Add, Tab3, x16 y80 w492 h271, Setup|Mode|Breaks|Config|Info
;Tab 1 - General UI config
Gui, Tab, 1
Gui, Add, Text, x40 y120 w400 h13, Use the latest UI with scaling set at 90`% and opacity set at 100`% ;needed to escape the percent sign
;Column One -- The start of each column should be a persistent coordinate and separated! Everything else should be coordinate dependent on the top row of the column!
Gui, Add, Text, x40 y140 w120 h13, Username:
Gui, Add, ComboBox, x40 y+10 w120 vUsername, Auto
Gui, Add, Text, x40 y+10 w120 h13, Improve Bind:
Gui, Add, Edit, x40 y+5 w120 h21 vImprove 0x10, i ;only allows lowercase letters
Gui, Add, Text, x40 y+10 w120 h13, Repair Bind:
Gui, Add, Edit, x40 y+5 w120 h21 vRepair 0x10, r ;only allows lowercase letters
Gui, Add, Text, x40 y+10 w120 h13, Number of Actions:
Gui, Add, Edit, x40 y+5 w27 h21 vActions 0x2000, 3 ;only allows numbers
;Column Two
Gui, Add, Text, x240 y140 w150 h13, MineForward bind:
Gui, Add, Edit, x240 y+10 w150 h21 vMine 0x10, m ;only allows lowercase letters
;Tab 2 - What scripts to run
Gui, Tab, 2
Gui, Add, Text, x40 y120 w400 h13, Script Mode (Pick One):
Gui, Add, DropDownList, x40 y+10 w120 h21 r6 gToolbeltConfig gSMode vScriptMode Sort, Improving|Gathering|World Interaction
Gui, Add, Text, x40 y170 w400 h13 vImpTypeText Hidden, Improvement Type (Pick One):
Gui, Add, DropDownList, x40 y+10 w120 h21 r6 gToolbeltConfig vImpType Sort Hidden, Carpentry|Cloth Tailoring|Leatherworking|Masonry|Smithing|Pottery
Gui, Add, Text, x40 y170 w400 h13 vGatherTypeText Hidden, Gathering Type (Pick One):
Gui, Add, DropDownList, x40 y+10 w120 h21 r6 vGatherType Sort Hidden, Wall Miner|Dig To Pile
Gui, Add, Text, x40 y220 w400 h13 vImpStyleText Hidden, Improvement Style (Pick One):
Gui, Add, DropDownList, x40 y+10 w120 h21 r3 vImpStyle Sort Hidden, Pile of Same Items|Singular Item|World Item
;Tab 3
Gui, Tab, 3
Gui, Add, CheckBox, x40 y120 w400 h13 vAutismMode gAutism, Autism Mode
Gui, Add, GroupBox, x40 y140 w400 h100 vContainerBox
Gui, Add, Text, x60 y170 w21 h13 vTesting, Testing
;need to add some sort of way to disable everything in container if autismmode is checked
;im thinking you can set a short medium and long break in ms
;Tab 4 - Toolbelt Configuration
Gui, Tab, 4
;Column One
Gui, Add, Text, x40 y120 w400 h13, Toolbelt Slot 1:
Gui, Add, DropDownList, x40 y+10 w120 h21 r6 vSlotOne, %miscTools%
Gui, Add, Text, x40 y170 w400 h13, Toolbelt Slot 2:
Gui, Add, DropDownList, x40 y+10 w120 h21 r6 vSlotTwo, %miscTools%
Gui, Add, Text, x40 y220 w400 h13, Toolbelt Slot 3:
Gui, Add, DropDownList, x40 y+10 w120 h21 r6 vSlotThree, %miscTools%
Gui, Add, Text, x40 y270 w400 h13, Toolbelt Slot 4:
Gui, Add, DropDownList, x40 y+10 w120 h21 r6 vSlotFour, %miscTools%
;Column Two
Gui, Add, Text, x180 y120 w400 h13, Toolbelt Slot 5:
Gui, Add, DropDownList, x180 y+10 w120 h21 r6 vSlotFive, %miscTools%
Gui, Add, Text, x180 y170 w400 h13, Toolbelt Slot 6:
Gui, Add, DropDownList, x180 y+10 w120 h21 r6 vSlotSix, %miscTools%
Gui, Add, Text, x180 y220 w400 h13, Toolbelt Slot 7:
Gui, Add, DropDownList, x180 y+10 w120 h21 r6 vSlotSeven, %miscTools%
Gui, Add, Text, x180 y270 w400 h13, Toolbelt Slot 8:
Gui, Add, DropDownList, x180 y+10 w120 h21 r6 vSlotEight, %miscTools%
;need to check out ini files, save curent selections and stuff to a file, and load configs back out again
;Tab 5 - About
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
switch ScriptMode { ;needs AHK [v1.1.31+] to work
    case "Improving":
        GuiControl, Show Enable, ImpTypeText
        GuiControl, Show Enable, ImpType
        GuiControl, Hide Disable, GatherTypeText
        GuiControl, Hide Disable, GatherType
        GuiControl, Show Enable, ImpStyleText
        GuiControl, Show Enable, ImpStyle
    case "Gathering":
        GuiControl, Hide Disable, ImpTypeText
        GuiControl, Hide Disable, ImpType
        GuiControl, Show Enable, GatherTypeText
        GuiControl, Show Enable, GatherType
        GuiControl, Hide Disable, ImpStyleText
        GuiControl, Hide Disable, ImpStyle
    case "World Interaction":
        GuiControl, Hide Disable, ImpTypeText
        GuiControl, Hide Disable, ImpType
        GuiControl, Hide Disable, GatherTypeText
        GuiControl, Hide Disable, GatherType
        GuiControl, Hide Disable, ImpStyleText
        GuiControl, Hide Disable, ImpStyle
    default:
        Msgbox Scriptmode unable to define itself properly
}
Return

;For configuring your own toolbelt for script use!
;The tool lists are located at start of the script
ToolbeltConfig:
GuiControlGet, ScriptMode
GuiControlGet, ImpType
switch ScriptMode { ;needs AHK [v1.1.31+] to work. This also determines the scriptmode, similar to above and changes toolbelt accordingly. If imping, it will look at subskill. If gathering, it will use the miscTools instead.
;It won't overwrite it if you previously select an improving subskill, need to find a way to clear a field on the fly.
    case "Improving":
        switch ImpType {
            case "Carpentry":
                GuiControl,,SlotOne, %carpTools%
                GuiControl,,SlotTwo, %carpTools%
                GuiControl,,SlotThree, %carpTools%
                GuiControl,,SlotFour, %carpTools%
                GuiControl,,SlotFive, %carpTools%
                GuiControl,,SlotSix, %miscTools%
                GuiControl,,SlotSeven, %miscTools%
                GuiControl,,SlotEight, %miscTools%
            case "Cloth Tailoring":
                GuiControl,,SlotOne, %clothTools%
                GuiControl,,SlotTwo, %clothTools%
                GuiControl,,SlotThree, %clothTools%
                GuiControl,,SlotFour, %clothTools%
                GuiControl,,SlotFive, %miscTools%
                GuiControl,,SlotSix, %miscTools%
                GuiControl,,SlotSeven, %miscTools%
                GuiControl,,SlotEight, %miscTools%
            case "Leatherworking":
                GuiControl,,SlotOne, %lwTools%
                GuiControl,,SlotTwo, %lwTools%
                GuiControl,,SlotThree, %lwTools%
                GuiControl,,SlotFour, %lwTools%
                GuiControl,,SlotFive, %lwTools%
                GuiControl,,SlotSix, %miscTools%
                GuiControl,,SlotSeven, %miscTools%
                GuiControl,,SlotEight, %miscTools%
            case "Masonry":
                GuiControl,,SlotOne, %masonTools%
                GuiControl,,SlotTwo, %masonTools%
                GuiControl,,SlotThree, %miscTools%
                GuiControl,,SlotFour, %miscTools%
                GuiControl,,SlotFive, %miscTools%
                GuiControl,,SlotSix, %miscTools%
                GuiControl,,SlotSeven, %miscTools%
                GuiControl,,SlotEight, %miscTools%
            case "Smithing":
                GuiControl,,SlotOne, %smithTools%
                GuiControl,,SlotTwo, %smithTools%
                GuiControl,,SlotThree, %smithTools%
                GuiControl,,SlotFour, %smithTools%
                GuiControl,,SlotFive, %smithTools%
                GuiControl,,SlotSix, %miscTools%
                GuiControl,,SlotSeven, %miscTools%
                GuiControl,,SlotEight, %miscTools%
            case "Pottery":
                ;wtf does this even use
            default:
                MsgBox, Not able to fetch appropriate ImpType for ToolbeltConfig
        }
    case "Gathering":
        GuiControl,,SlotOne, %miscTools%
        GuiControl,,SlotTwo, %miscTools%
        GuiControl,,SlotThree, %miscTools%
        GuiControl,,SlotFour, %miscTools%
        GuiControl,,SlotFive, %miscTools%
        GuiControl,,SlotSix, %miscTools%
        GuiControl,,SlotSeven, %miscTools%
        GuiControl,,SlotEight, %miscTools%
    default:
        Msgbox Unable to define appropriate toolbelt per Scriptmode
}
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


GuiClose:
ExitApp
Return
ButtonOK:
GuiEscape:
Gui, Submit
;Saves all .ini settings
;Could possibly set it up so each tab is under a different section, but was too lazy.
varSaver := "Username,Improve,Repair,Mine,Actions,ImpType,GatherType,ImpStyle" ;THIS MUST BE THE SAME IN EVERY SCRIPT THAT WILL READ THIS INI!!!! VERY IMPORTANT. NO SPACES
loop, parse, varSaver, `,
{
    IniWrite, % %A_LoopField%, %A_ScriptDir%\include\config.ini, Setup, % A_LoopField
}
varSaverBelt := "SlotOne,SlotTwo,SlotThree,SlotFour,SlotFive,SlotSix,SlotSeven,SlotEight" ;THIS MUST BE THE SAME IN EVERY SCRIPT THAT WILL READ THIS INI!!!! VERY IMPORTANT. NO SPACES
loop, parse, varSaverBelt, `,
{
    IniWrite, % %A_LoopField%, %A_ScriptDir%\include\config.ini, Toolbelt, % A_LoopField
}
;MsgBox Actions = %Actions%, Improve = %Improve%, Repair = %Repair%, Username = %Username%, ImproveType = %ImpType%, ImproveMode = %ImpStyle% ;Debug for verifying variables saved appropriately

;Launches script based on setting
If (ScriptMode = "Improving") {
    Run Imper.ahk
}
If (ScriptMode = "Gathering") {
    Run Gatherer.ahk
}
If (ScriptMode = "World Interaction") {
    Run WorldInt.ahk
}
ExitApp

F12::
Run RUNTHISFIRST.ahk
Return