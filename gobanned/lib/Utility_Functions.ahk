GetPlayerName()
{
	WinGetActiveTitle, title
	playerName := SubStr(title, 2, InStr(title, ")") - 2)
	
	return playerName
}

TypeInput(inputVar)
{
	inputStr := "" . inputVar
	
	Loop, Parse, inputStr
	{
		key := A_LoopField
		DoKey(key)
	}
}

MouseWithinRadiusOfPoint(radius, x, y)
{
	MouseGetPos, mX, mY
	
	xWithin := mX >= x-radius AND mX <= x+radius
	yWithin := mY >= y-radius AND mY <= y+radius
	
	return xWithin AND yWithin
}

SevereAlarm(title="SEVERE ALARM", message="")
{
	global severeAlarmPlaying
	severeAlarmPlaying := 1
	SetTimer, SevereAlarmThread, 100
	MsgBox, 4096, %title%, %message%
	ExitApp
}

SleepRandom(minSleep, maxSleep)
{
	Random, rand, %minSleep%, %maxSleep%
	Sleep, %rand%
}

PlaySound(soundName)
{
	global alarmOnlyMode
	If (alarmOnlyMode = 1 AND soundName != "Alarm")
	{
		return
	}
	sound := A_WorkingDir . "\sounds\" . soundName . ".mp3"
	SoundPlay, %sound%
}

Say(speech="")
{
	global alarmOnlyMode, Voice
	If (!alarmOnlyMode)
	{
		ComObjCreate("SAPI.SpVoice").Speak(speech)
	}
}

TakeScreenshot(fileName="screenshot")
{
	screenshotFile := A_WorkingDir . "\screenshots\" . fileName . ".png"
	Run, nircmd.exe savescreenshot %screenshotFile%
}

DoAttentionLapse()
{
	global attentiveMode

	Random, laziness, 0, 100
	
	If (attentiveMode)
	{
		laziness := laziness - 10
	}
	
	If (laziness > 97)
	{
		SleepRandom(8000, 15000)
	}
	Else If (laziness > 95)
	{
		SleepRandom(5000, 8000)
	}
	Else If (laziness > 90)
	{
		SleepRandom(3000, 5000)
	}
	Else If (laziness > 85)
	{
		SleepRandom(2000, 3000)
	}
	Else If (laziness > 80)
	{
		SleepRandom(1000, 2000)
	}
}

