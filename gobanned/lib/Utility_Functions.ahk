GetPlayerName()
{
	WinGetActiveTitle, title
	playerName := SubStr(title, 2, InStr(title, ")") - 2)
	
	return playerName
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

