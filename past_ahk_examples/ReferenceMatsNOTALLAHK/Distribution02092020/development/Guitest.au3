#include <Misc.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

HotKeySet("{;}", "Guiconfig")
HotKeySet("{ESC}", "_Exit")

#Region ### START Koda GUI section ### Form=
$guifrm = GUICreate("Gui Tester", 428, 352, 226, 158)
$Title = GUICtrlCreateLabel("GUI Tester", 32, 16, 144, 36)
GUICtrlSetFont(-1, 20, 800, 0, "MS Sans Serif")
$author = GUICtrlCreateLabel("~ Dissimulo Scripts", 143, 64, 138, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$gobut = GUICtrlCreateButton("Start Script", 148, 296, 129, 41)
$soundchk = GUICtrlCreateCheckbox("", 200, 264, 105, 17)
$improveimp = GUICtrlCreateInput("", 200, 200, 113, 21)
$repairinp = GUICtrlCreateInput("", 200, 232, 113, 21)
$subtitle = GUICtrlCreateLabel("Do I even need this thing", 192, 24, 218, 29)
GUICtrlSetFont(-1, 16, 400, 0, "MS Sans Serif")
$actionlbl = GUICtrlCreateLabel("Actions", 144, 168, 41, 17)
$improvelbl = GUICtrlCreateLabel("Improve bind", 120, 200, 65, 17)
$repairlbl = GUICtrlCreateLabel("Repair bind", 128, 232, 58, 17)
$soundlbl = GUICtrlCreateLabel("Don't play sound?", 104, 264, 86, 17)
$pauselbl = GUICtrlCreateLabel("Pause hot key: ' ; '", 170, 104, 101, 17)
$exitlbl = GUICtrlCreateLabel("Exit hot key: ' Esc '", 169, 128, 103, 17)
$actioncmb = GUICtrlCreateCombo("", 200, 168, 113, 25)
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


Func _Exit()
	Exit
EndFunc

Func Guiconfig()
	Sleep(50)
EndFunc



While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $gobut
	EndSwitch
WEnd
