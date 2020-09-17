;random sleep
randSleep(minSleep=300, maxSleep=500)
{
    Random, rand, minSleep, maxSleep
    Sleep, rand
}
;antimacro -- rolls to see if youre "afk"
antiMacro()
{
    Random, rand, 0, 100
    If (rand > 90) 
    {
        randSleep(30000,60000)
    }
        else if (rand > 75) 
        {
        randSleep(5000,15000)
        }
        else if (rand > 50) 
        {
        randSleep(2000, 8000)
        }
        else if (rand > 0) 
        {
        randSleep(250, 750)
        }
}

;Use keys with delay
doKey(key)
{
    Send {%key% down}
    randSleep(15,45)
    Send {%key% up} 
}
;Left click with a delay
doClick()
{
Send {Click down}
randSleep(50, 150)
Send {Click up}
randSleep(50, 150)
}
;Right click with a delay
doRightClick()
{
Send {Click, down, right}
randSleep(50, 150)
Send {Click, up, right}
randSleep(50, 150)
}

;Generates random movement pattern
RandomBezier( X0, Y0, Xf, Yf, O="" ) {
    Time := RegExMatch(O,"i)T(\d+)",M)&&(M1>0)? M1: 200
    RO := InStr(O,"RO",0) , RD := InStr(O,"RD",0)
    N:=!RegExMatch(O,"i)P(\d+)(-(\d+))?",M)||(M1<2)? 2: (M1>19)? 19: M1
    If ((M:=(M3!="")? ((M3<2)? 2: ((M3>19)? 19: M3)): ((M1=="")? 5: ""))!="")
        Random, N, %N%, %M%
    OfT:=RegExMatch(O,"i)OT(-?\d+)",M)? M1: 100, OfB:=RegExMatch(O,"i)OB(-?\d+)",M)? M1: 100
    OfL:=RegExMatch(O,"i)OL(-?\d+)",M)? M1: 100, OfR:=RegExMatch(O,"i)OR(-?\d+)",M)? M1: 100
    MouseGetPos, XM, YM
    If ( RO )
        X0 += XM, Y0 += YM
    If ( RD )
        Xf += XM, Yf += YM
    If ( X0 < Xf )
        sX := X0-OfL, bX := Xf+OfR
    Else
        sX := Xf-OfL, bX := X0+OfR
    If ( Y0 < Yf )
        sY := Y0-OfT, bY := Yf+OfB
    Else
        sY := Yf-OfT, bY := Y0+OfB
    Loop, % (--N)-1 {
        Random, X%A_Index%, %sX%, %bX%
        Random, Y%A_Index%, %sY%, %bY%
    }
    X%N% := Xf, Y%N% := Yf, E := ( I := A_TickCount ) + Time
    While ( A_TickCount < E ) {
        U := 1 - (T := (A_TickCount-I)/Time)
        Loop, % N + 1 + (X := Y := 0) {
            Loop, % Idx := A_Index - (F1 := F2 := F3 := 1)
                F2 *= A_Index, F1 *= A_Index
            Loop, % D := N-Idx
                F3 *= A_Index, F1 *= A_Index+Idx
            M:=(F1/(F2*F3))*((T+0.000001)**Idx)*((U-0.000001)**D), X+=M*X%Idx%, Y+=M*Y%Idx%
        }
        MouseMove, %X%, %Y%, 0
        Sleep, 1
    }
    MouseMove, X%N%, Y%N%, 0
    Return N+1
}

;Function for bezier
MoveMouseHumanlike(x, y, mouseTime=0)
{
	If (mouseTime = 0)
	{
		MouseGetPos, mouseX, mouseY
		a2 := (x - mouseX) ** 2
		b2 := (y - mouseY) ** 2
		c := Sqrt(a2 + b2)
 
		Random, randDist, c*.9, c*1.1
		If (randDist > 50)
		{
			mouseTime := Max(randDist, 50000/randDist)
		}
		Else
		{
			Random, mouseTime, 300, 600
		}
	}
	RandomBezier(0, 0, x, y, "T" . mouseTime . " RO P3")
	randSleep(200, 500)
}
