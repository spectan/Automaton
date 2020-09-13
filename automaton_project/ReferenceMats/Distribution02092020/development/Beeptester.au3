#include <Misc.au3>

HotKeySet("{;}", "Beeper")
HotKeySet("{ESC}", "_Exit")

Func _Exit()
	Exit
EndFunc

Func Beeper()
	SoundPlay('ding.wav')
EndFunc

While (1)
	Sleep(50)
WEnd