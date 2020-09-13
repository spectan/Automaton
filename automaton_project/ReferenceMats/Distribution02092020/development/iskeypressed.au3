#include <Misc.au3>


While 1
    If _IsPressed("05") Then
        ConsoleWrite("_IsPressed - X1 mouse was pressed." & @CRLF)
        ; Wait until key is released.
        While _IsPressed("05")
            Sleep(250)
        WEnd
        ConsoleWrite("_IsPressed - X1 mouse was released." & @CRLF)
    ElseIf _IsPressed("1B") Then
        MsgBox(0, "_IsPressed", "The Esc Key was pressed, therefore we will close the application.")
        ExitLoop
    EndIf
    Sleep(250)
WEnd