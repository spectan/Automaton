#SingleInstance force

Gui, +AlwaysOnTop
Gui, Add, Text, , TextToSpeech
Gui, Add, Edit, w170 vTextToSpeech
Gui, Add, Button, Default gSpeak, OK
Gui, Show, w200 h90
Return

Speak:
GuiControlGet, TextToSpeech
Say(TextToSpeech)
Return

Say(speech="")
{
	Send, {ScrollLock down}
	ComObjCreate("SAPI.SpVoice").Speak(speech)
	Send, {ScrollLock up}
}
