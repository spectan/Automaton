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
Gui, Add, Tab3,, Config|Type and Mode
Gui, Tab, Config ;Config tab. The variables below are written as "vVARIABLENAME" but will be stored as the variable but minus the V, so if you wanted to reference it, just %VARIABLENAME%
Gui, add, Text,, Num of Actions:
Gui, Add, Edit, vActions, 3
Gui, add, Text,, Improve Bind:
Gui, Add, Hotkey, vImprove, i
Gui, add, Text,, Repair Bind:
Gui, Add, Hotkey, vRepair, r
Gui, add, Text,, Username
Gui, Add, ComboBox, r5 vUsername Sort Choose1, Auto Detect
Gui, Tab, Type and Mode ;Improvement type and mode tab
Gui, add, Text,, Improvement Type (Pick One):
Gui, Add, DropDownList, r5 vImpType Choose1 Sort, Carpentry|Cloth Tailoring|Leatherworking|Masonry|Smithing
Gui, add, Text,, Improvement Mode (Pick One):
Gui, Add, DropDownList, r3 vImpMode Choose2 Sort, Pile of Same Items|Singular Item|Autism Mode
Gui, Tab  ;Ends the tabs so what's after this doesn't align into the "backplate" of the menu

Gui, Add, Button, default xm, OK

Gui, Show,, Improver
Return

ButtonOK:
GuiClose:
GuiEscape:
Gui, Submit  ; Saves the contents above to the variables specified.
;MsgBox Actions = %Actions%, Improve = %Improve%, Repair = %Repair%, Username = %Username%, ImproveType = %ImpType%, ImproveMode = %ImpMode% ;Debug for verifying variables saved appropriately
Return ;This will be ExitApp, just return for ease of testing.

;END OF SETUP
;

F5::
;Toolbelt Selector, set by the GUI.
;Toolbelts (need to add a better way to configure this in the future)
carpentryToolbelt := {"log": 1, "carving": 2, "pelt": 3, "file": 4, "mallet": 5}
smithToolbelt := {"lump": 1, "hammer": 2, "pelt": 3, "whetstone": 4, "water": 5}
tailorToolbelt := {"string": 1, "needle": 2, "scissors": 3, "water": 4}
lwingToolbelt := {"leather": 1, "needle": 2, "lknife": 3, "mallet": 4, "awl": 5}
masonryToolbelt := {"rockshard": 1, "chisel": 2}
Toolbelt := 0
if ImpType = Carpentry
{
    Toolbelt := carpentryToolbelt
}
if ImpType = Cloth Tailoring
{
    Toolbelt := tailorToolbelt
}
if ImpType = Leatherworking
{
    Toolbelt := lwingToolbelt
}
if ImpType = Masonry
{
    Toolbelt := masonryToolbelt
}
if ImpType = Smithing
{
    Toolbelt := smithToolbelt
}
;Debug for testing array properly assigns to the variable
/*
For index, value in Toolbelt
    MsgBox % "Item " index " is '" value "'"
*/


F6::
Run Imper.ahk
Return

F12::
ExitApp