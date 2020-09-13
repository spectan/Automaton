#include<Date.au3>

; this is an automated macro for mining in a straight line forward for a really long time. If you break through a tile, it will automatically walk
; you forward for a while and then continue mining. If you run into an ore vein the macro will choke after mining 100 units of ore and clogging up
; the tile underneath you. If you have food and water you can have the macro automatically eat and drink for you, but it's a little unreliable and
; may require tweaking some of the definitions. This macro will also automatically repair your pickaxe, but I've never ran this macro long enough to
; see a pickaxe in danger of breaking, so I can't guarantee that part works perfectly

; make sure you have keybinds defined for the following actions and change the values according to your preference. You may want to rebind the
; key you're using for the mine command to mine_forward, mine_up, or mine_down depending on the situation
$mine = "h"
$repair = "r"

; these values control which rows of the right-click menus will be clicked on when attempt to automatically eat and drink.
; if the macro is clicking the "rename" command instead of the "eat" or "drink" command then you will need to tweak these
; values until it works. Owning a pet will mess with the number of options on the right-click menus and probably require
; you to change these values
$foodOffset = 5
$waterOffset = 7

; Set this to true if you have food and water and want to automatically eat and drink. Be aware that running out of food or water can mess up the positioning of things
; in your inventory, so I recommend binding your food and water to a toolbelt if available
$autoEatDrink = True

; set your in-game user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

Mining()

Func Mining()
	OpenLogFile()
	SetRequiredPosition()
	If $autoEatDrink = True Then
	   SetOptionalPosition()
    EndIf

	$repair = Random(30,50,1)
	$food = Random(60,120,1)

	$answer = MsgBox(0,"Mining Macro", "Mouse over the rock wall in front of you with your pickaxe activated.")
	Sleep(4000)

    If $autoEatDrink = True Then
		 Eat()
	  EndIf

	While 1 = 1
		WaitForStamina()
		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(4000,7000,1)
		Else
			$wait = Random(1,1500,1)
		EndIf
		Sleep($wait)
		WaitForAction()
		$repair = $repair - 1
		$food = $food - 1
		If $repair = 0 Then
			Repair()
			$repair = Random(20,40,1)
		EndIf
		If $food = 0 Then
			If $autoEatDrink = True Then
			   Eat()
			EndIf
			$food = Random(60,120,1)
		EndIf
	WEnd
EndFunc

Func OpenLogFile()
	$fileName = $wurmPath & "\players\" & $userName & "\test_logs\_Event." & @YEAR & "-" & @MON & ".txt"
	Global $logFile = FileOpen($fileName,0)
	If $logFile = -1 Then
		MsgBox(0, "Error","Unable to open file. Terminating script.")
		Exit
	EndIf
EndFunc

Func SetRequiredPosition()
	$answer = MsgBox(0,"Mining Macro","1. Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	Global $staminaPosition = MouseGetPos()
    Global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])

	$answer = MsgBox(0,"Mining Macro","2. Move your mouse cursor to your pickaxe.")
	Sleep(4000)
	Global $pickaxePosition = MouseGetPos()

 EndFunc

Func SetOptionalPosition()
    $answer = MsgBox(0,"Mining Macro","3. Move your mouse cursor to your water.")
	Sleep(4000)
	Global $waterPosition = MouseGetPos()
	$answer = MsgBox(0,"Mining Macro","4. Move your mouse cursor to your food.")
	Sleep(4000)
	Global $foodPosition = MouseGetPos()
EndFunc

Func WaitForStamina()
	$done = False
	$wait = 0
	While $done = False
		$coord = PixelSearch($staminaPosition[0],$staminaPosition[1],$staminaPosition[0] + 1,$staminaPosition[1] + 1,$staminaColor,25)
		If Not @error Then
			$done = True
			$wait = 0
		Else
			Sleep(500)
			$wait = $wait + 1
			If $wait > 40 Then
			    Eat()
				Sleep(3000)
				$staminaColor = PixelGetColor($staminaPosition[0]-100,$staminaPosition[1])
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc

Func WaitForAction()
	$done = False
	Local $result = FileSetPos($logFile,0,$FILE_END)
	Send($mine)
	Sleep(3000)
	$wait = 0
	While $done = False
		Sleep(40)
		$line = FileReadLine($logFile)
		If StringInStr($line,"You mine some") > 0 Then
			$done = True
		ElseIf StringInStr($line,"cannot keep mining") > 0 Then
			Beep()
			MsgBox(0,"Mining Macro","This wall cannot be mined further.")
			$done = True
		ElseIf StringInStr($line,"no space") > 0 Then
			Beep()
			MsgBox(0,"Mining Macro","The floor is too full to keep mining.")
			$done = True
		ElseIf StringInStr($line,"wall breaks") > 0 Or StringInStr($line,"too hard to") > 0 Then
			$done = True
			Send("{w down}")
			$wait = Random(2300,4100,1)
			Sleep($wait)
			Send("{w up}")
			$wait = Random(1,1500,1)
			Sleep($wait)
		Else
			$wait = $wait + 1
			If $wait > 1150 Then
				Beep()
				MsgBox(0,"Mining Macro","Your last action doesn't seem to be executing.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc

Func Eat()
	$targetPosition = MouseGetPos()

	MouseMove($foodPosition[0], $foodPosition[1])
	MouseClick("right")
	$wait = Random(2000,4000,1)
	Sleep ($wait)
	MouseMove($foodPosition[0] + 40, $foodPosition[1] + 16 * $foodOffset)
	$wait = Random(500,2000,1)
	Sleep ($wait)
	MouseClick("left")
    Sleep(3000)
	Send("{Enter}")
	Sleep(1000)
	MouseClick("left")
	Sleep(100)

	MouseMove($waterPosition[0], $waterPosition[1])
	MouseClick("right")
	$wait = Random(2000,4000,1)
	Sleep ($wait)
	MouseMove($waterPosition[0] + 40, $waterPosition[1] + 16 * $foodOffset)
	$wait = Random(500,2000,1)
	Sleep ($wait)
	MouseClick("left")
    Sleep(3000)
	Send("{Enter}")
	Sleep(1000)
	MouseClick("left")
	$wait = Random(4000,8000,1)
	Sleep ($wait)

	MouseMove($targetPosition[0],$targetPosition[1],0)
 EndFunc

Func Repair()
	$targetPosition = MouseGetPos()
	MouseMove($pickaxePosition[0],$pickaxePosition[1],0)
	Sleep(200)
	Send($repair)
	Sleep(200)
	MouseMove($targetPosition[0],$targetPosition[1],0)
	Sleep(200)
 EndFunc

 Func WaitForMessage($message, $timeout)
   Local $result = FileSetPos($logFile,0,$FILE_END)
   $delay = 0

   While $delay * 40 < $timeout
	  Sleep(40)
	  $line = FileReadLine($logFile)
	  If StringInStr($line,$message) > 0 Then
		 return True
	  Else
		 $delay = $delay + 1
	  EndIf
   WEnd

   return False
EndFunc