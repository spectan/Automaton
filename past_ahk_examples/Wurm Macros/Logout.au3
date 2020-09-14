#include<Date.au3>

$userName = "Hempfire"
$wurmPath = "C:\Downloads\Wurm"

LogOut()

Func LogOut()
	global $wait = 3200000

	$answer = MsgBox(0,"Logout Macro","Move your mouse cursor to your escape window.")
	Sleep(4000)
	global $escapePosition = MouseGetPos()

	$answer = MsgBox(0,"Logout Macro","Move your mouse cursor to your yes button")
	Sleep(4000)
	global $yesPosition = MouseGetPos()

	MsgBox(0,"Logout Macro","Okay macro is ready")
	Sleep($wait)

	Send("o")
	Sleep(1000)
	MouseClick("left")
	Sleep(1000)

	MouseMove($escapePosition[0], $escapePosition[1])
	Sleep(1000)
	MouseClick("left")
	Sleep(1000)

	MouseMove($yesPosition[0], $yesPosition[1])
	Sleep(1000)
	MouseClick("left")
	Sleep(1000)
EndFunc