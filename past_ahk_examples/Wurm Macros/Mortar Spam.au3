#include<Date.au3>

; this is a specialized version of the Bin Item Spam macro for making mortar out of clay and sand. You will need a bulk storage bin with
; a large amount of sand and clay for this macro to work. It is also very important that the sand and mortar in your inventory be the last
; items listed in your inventory. This macro will not eat and drink for you, but it will dump your created mortar in the bin and get more
; sand and clay automatically

; make sure you have keybinds defined for the following actions and change the values according to your preference
$activate = "b"
$drop = "e"
$examine = "o"
$combine = "t"

; set your in-game user name and Wurm installation path here
$userName = "Gmjohnnyrascal"
$wurmPath = "E:\Steam\SteamApps\common\Wurm Unlimited\WurmLauncher\PlayerFiles\"

ItemSpam()

Func ItemSpam()
	global $wait = 0
	OpenLogFile()
	SetRequiredPosition()

	While 1 = 1
		WaitForStamina()

		$wait = Random(0,12,1)
		If $wait = 12 Then
			$wait = Random(3000,6000,1)
		Else
			$wait = Random(300,1300,1)
		EndIf
		Sleep($wait)

		MakeItem()
	WEnd

	FileClose($logFile)
EndFunc

Func OpenLogFile()
	$fileName = $wurmPath & "\players\" & $userName & "\test_logs\_Event." & @YEAR & "-" & @MON & ".txt"
	global $logFile = FileOpen($fileName,0)
	If $logFile = -1 Then
		MsgBox(0, "Error","Unable to open file. Terminating script.")
		Exit
	EndIf
EndFunc

Func SetRequiredPosition()
   	$answer = MsgBox(0,"Mortar Spam Macro","1. Move your mouse cursor to the rightmost edge of your stamina bar.")
	Sleep(4000)
	global $staminaPosition = MouseGetPos()
	global $staminaColor = PixelGetColor($staminaPosition[0],$staminaPosition[1])

	$answer = MsgBox(0,"Mortar Spam Macro","2. Move your mouse cursor to the clay combine button on the crafting GUI")
	Sleep(4000)
	global $claySlotPosition = MouseGetPos()

    $answer = MsgBox(0,"Mortar Spam Macro","3. Move your mouse cursor to your sand combine button on the crafting GUI")
	Sleep(4000)
	global $sandSlotPosition = MouseGetPos()

    $answer = MsgBox(0,"Mortar Spam Macro","4. Select the mortar item on the recipe list and move your mouse cursor to the create button on the crafting GUI.")
	Sleep(4000)
	global $createPosition = MouseGetPos()

    $answer = MsgBox(0,"Mortar Spam Macro","6. Move your mouse cursor to the clay in your bulk storage bin")
	Sleep(4000)
	global $clayDepotPosition = MouseGetPos()

    $answer = MsgBox(0,"Mortar Spam Macro","7. Move your mouse cursor to the sand in your bulk storage bin")
	Sleep(4000)
	global $sandDepotPosition = MouseGetPos()

	$answer = MsgBox(0,"Mortar Spam Macro","8. Move your mouse cursor to the first raw material in your inventory")
	Sleep(4000)
	global $materialPosition = MouseGetPos()
EndFunc

Func MakeItem()
	$completed = False
	$attempts = 0
	$fuckups = 0

	While $completed = False
		$done = False
		Local $result = FileSetPos($logFile,0,$FILE_END)
		$delay = 0

		MouseMove($createPosition[0], $createPosition[1])
		Sleep(40)
		MouseClick("left")

		While $done = False
			Sleep(40)
			$line = FileReadLine($logFile)
			If StringInStr($line,"You create") > 0 Then
				$completed = True
				$done = True
			ElseIf StringInStr($line,"almost made it") > 0 Then
				$completed = True
				$done = True
			ElseIf StringInStr($line,"too little material") > 0 Then
				GetMoreMaterials()
				$done = True
			ElseIf StringInStr($line,"too low") > 0 Then
				GetMoreMaterials()
				$done = True
			ElseIf StringInStr($line,"You start") > 0 Then
				Sleep(5000)
			Else
				$delay = $delay + 1
				If $delay > 300 Then
					If $attempts > 1 Then
						$fuckups = $fuckups + 1
						If $fuckups > 1 Then
							Beep()
							MsgBox(0,"Mortar Spam Macro","You are out of raw materials.")
							$fuckups = 0
						EndIf
						GetMoreMaterials()
						$done = True
						$attempts = 0
					EndIf
					$done = True
					$delay = 0
					$attempts = $attempts + 1
				EndIf
			EndIf
		WEnd
	WEnd
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
EndFunc

Func GetMoreMaterials()
	 MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $clayDepotPosition[0], $clayDepotPosition[1], 20)
	 $wait = Random(500,1500,1)
	 Sleep($wait)
     MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $clayDepotPosition[0], $clayDepotPosition[1], 20)
	 $wait = Random(500,1500,1)
	 Sleep($wait)
     MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $clayDepotPosition[0], $clayDepotPosition[1], 20)
	 $wait = Random(500,1500,1)
	 Sleep($wait)

	 MouseClickDrag("left", $clayDepotPosition[0], $clayDepotPosition[1], $materialPosition[0], $materialPosition[1], 20)
	 $wait = Random(1000,2000,1)
	 Sleep($wait)
	 Send("30")
	 Sleep(400)
	 Send('{ENTER}')
	 Sleep(100)
     MouseClickDrag("left", $sandDepotPosition[0], $sandDepotPosition[1], $materialPosition[0], $materialPosition[1], 20)
	 $wait = Random(1000,2000,1)
	 Sleep($wait)
	 Send("3")
	 	 Sleep(400)
	 Send('{ENTER}')
	 Sleep(100)

	 MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $claySlotPosition[0] - 40, $claySlotPosition[1] - 16, 20)
	 $wait = Random(600,1200,1)
	 Sleep($wait)
     MouseClickDrag("left", $materialPosition[0], $materialPosition[1] + 16, $sandSlotPosition[0] - 40, $sandSlotPosition[1] - 16, 20)
	 $wait = Random(600,1200,1)
	 Sleep($wait)

     MouseMove($claySlotPosition[0], $claySlotPosition[1])
	 Sleep(200)
	 MouseClick("left")
	 MouseMove($sandSlotPosition[0], $sandSlotPosition[1])
	 Sleep(200)
	 MouseClick("left")
	 $wait = Random(600,1200,1)
	 Sleep($wait)

     MouseClickDrag("left", $materialPosition[0], $materialPosition[1], $claySlotPosition[0] - 40, $claySlotPosition[1] - 16, 20)
	 $wait = Random(600,1200,1)
	 Sleep($wait)
     MouseClickDrag("left", $materialPosition[0], $materialPosition[1] + 16, $sandSlotPosition[0] - 40, $sandSlotPosition[1] - 16, 20)
	 $wait = Random(600,1200,1)
	 Sleep($wait)

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
				Beep()
				MsgBox(0,"Mortar Spam Macro","Your stamina appears to have stopped regenerating.")
				$wait = 0
			EndIf
		EndIf
	WEnd
EndFunc