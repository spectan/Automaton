;TODO
;Change free mouse detection to not be picture based
;Add food and weapon options
;Finish gui to prompt for food/weapon
;Add gui option to select action (attack/gather)
;Add gui option to select gather cooldown
;Add gui option/functionality for selecting and requipping broken tools


#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1


;Configuration
FoodImg := "eat.png"
WeaponImg := "weapon.png"
SwingHold := 50
SwingCooldown := 1500
Action := Attack
ActionDelay := 6000
ToolAction := 0



;Food Select
Gui, Food:add, Radio, vFRadios ,Taproot
Gui, Food:add, Radio, ,Boiled Chicken
Gui, Food:add, Radio, ,Bread
Gui, Food:add, Radio, ,Boiled Potatoes
Gui, Food:add, Radio, ,Cabbage Stew
Gui, Food:add, Radio, ,Codfish with Cabbage
Gui, Food:add, Radio, ,Wild Soup

Gui, Food:add, Button, gFOOD_BTN, Choose food
Gui, Food:show, W300 Center, Food
Return


FOOD_BTN:
	global FoodImg, Action
    Gui,Food:submit
	If FRadios = 1 
    {
		FoodImg := "taproot.png"
    }
	If FRadios = 2 
    {
		FoodImg := "boiledchicken.png"
    }
	If FRadios = 3 
    {
		FoodImg := "bread.png"
    }
	If FRadios = 4 
    {
		FoodImg := "boiledpotatoes.png"
    }
	If FRadios = 5 
    {
		FoodImg := "cabbagestew.png"
    }
	If FRadios = 6 
    {
		FoodImg := "codfishwithcabbage.png"
    }
	If FRadios = 7 
    {
		FoodImg := "wildsoup.png"
    }

	
	
	Gui, Action:add, Radio, vARadios ,Attack
	Gui, Action:add, Radio, ,Block
	Gui, Action:add, Radio, ,Gather 3s (Sling ammo)
	Gui, Action:add, Radio, ,Gather 6s (Taproot,Track,Mushroom,Fiber,Flint)
	Gui, Action:add, Radio, ,Gather Wild Plant

	Gui, Action:add, Button, gACT_BTN, Choose action
	Gui, Action:show, W300 Center, Action
	
Return


ACT_BTN:
	global Action, ActionDelay,ToolAction
    Gui,Action:submit
	Action = Attack
	If ARadios = 1
	{
		Action = Attack
		
		;Weapon Select
		Gui, Weapon:add, Radio, vWRadios ,Practice Axe
		Gui, Weapon:add, Radio, ,Staff
		Gui, Weapon:add, Radio, ,Practice Longsword
		Gui, Weapon:add, Radio, ,Sling
		Gui, Weapon:add, Radio, ,Punch
		Gui, Weapon:add, Radio, ,Practice Sword

		Gui, Weapon:add, Button, gWEP_BTN, Choose weapon
		Gui, Weapon:show, W300 Center, Weapon
	}
	Else if ARadios = 2
	{
		Action = Block
		ToolAction = 1
		
		Gui, Shield:add, Radio, vSRadios ,Primitive Shield
		
		Gui, Shield:add, Button, gSHIELD_BTN, Choose shield
		Gui, Shield:show, W300 Center, Shield

	}
	Else if ARadios = 3
	{
		Action = Gather
		ActionDelay := 3000
		ToolAction = 0
		MsgBox, 0, , 
		(LTrim
		INSTRUCTIONS:
		   -Set the action you want to perform to be done +1 time
		   -Set the action as default for the tile you want to gather from
		   -Bind Perform/Attack to E
		   
		   -Press F5, and wait for the macro to start.
		)
	}
	Else if ARadios = 4
	{
		Action = Gather
		ActionDelay := 6000
		ToolAction = 0
		MsgBox, 0, , 
		(LTrim
		INSTRUCTIONS:
		   -Set the action you want to perform to be done +1 time
		   -Set the action as default for the tile you want to gather from
		   -Bind Perform/Attack to E
		   
		   -Press F5, and wait for the macro to start.
		)
	}
	Else if ARadios = 5
	{
		Action = Gather
		ToolAction := 1
		
		Gui, Tool:add, Radio, vTRadios ,Primitive Sickle
		Gui, Tool:add, Radio, ,Iron Sickle
		
		Gui, Tool:add, Button, gTOOL_BTN, Choose tool
		Gui, Tool:show, W300 Center, Tool
		

	}	
Return

SHIELD_BTN:
	global WeaponImg
	Gui,Shield:submit
	WeaponImg := "primitiveshield.png"
	If SRadios = 1 
    {
		WeaponImg := "primitiveshield.png"
    }
	
	MsgBox, 0, , 
	(LTrim
	INSTRUCTIONS:
	   -Check which equip slot your shield gets equipped to when double clicked.
	   -Put that equip slot on your first toolbar button, and bind it to Numpad0.
	   -Remove all other equip slots from your toolbar, and unequip your shield
	   
	   -Press F5, and wait for the macro to start.
	)
	
Return


TOOL_BTN:
	global WeaponImg,ActionDelay
	Gui,Tool:submit
	WeaponImg := "primitivesickle.png"
	ActionDelay := 15000
	If TRadios = 1 
    {
		WeaponImg := "primitivesickle.png"
		ActionDelay := 15000
    }
    Else if TRadios = 2 
    {
		WeaponImg := "ironsickle.png"
		ActionDelay := 10000
    }
	
	MsgBox, 0, , 
	(LTrim
	INSTRUCTIONS:
	   -Make a toolbar tab with Left Waist in the first slot, bound to Numpad0
	   -Make sure no other equip slots are on the toolbar
	   -Unequip anything you have in the Left Waist slot
	   -Fill your inventory with spare sickles
	   -Set gather wild plants 1 time as your default action
	   -Aim yourself at the tile you want to gather from
	   
	   -Press F5, and wait for the macro to start.
	)
	
Return

WEP_BTN:
	global WeaponImg, SwingHold, SwingCooldown
    Gui,Weapon:submit
	ToolAction = 1
	WeaponImg := "practiceaxe.png"
	SwingHold := 50
	SwingCooldown := 1500
    If WRadios = 1 
    {
		ToolAction = 1
		WeaponImg := "practiceaxe.png"
		SwingHold := 50
		SwingCooldown := 1500
    }
    Else if WRadios = 2 
    {
		ToolAction = 1
		WeaponImg := "staff.png"
		SwingHold := 50
		SwingCooldown := 1600
    }
	Else if WRadios = 3
    {
		ToolAction = 1
		WeaponImg := "practicelongsword.png"
		SwingHold := 50
		SwingCooldown := 2000
    }
	Else if WRadios = 4
    {
		ToolAction = 1
		WeaponImg := "sling.png"
		SwingHold := 1400
		SwingCooldown := 1000
    }
	Else if WRadios = 5
    {
		ToolAction = 0
		SwingHold := 50
		SwingCooldown := 1500
    }
	Else if WRadios = 6
    {
		ToolAction = 1
		WeaponImg := "practicesword.png"
		SwingHold := 50
		SwingCooldown := 1500
    }
	
	MsgBox, 0, , 
	(LTrim
	INSTRUCTIONS:
	   -Check which equip slot your weapon gets equipped to when double clicked.
	   -Put that equip slot on your first toolbar button, and bind it to Numpad0.
	   -Remove all other equip slots from your toolbar, and unequip your weapon
	   
	   -Press F5, and wait for the macro to start.
	)
Return



F5::
Macro1:

WinActivate, ahk_class LifeIsFeudalWindow
Sleep, 333
FoodX := 0
FoodY := 0
EquipX := 0
EquipY := 0
WeapX := 0
WeapY := 0
InvX := 0
InvY := 0
HealthX := 0
HealthY := 0
StamX := 0
StamY := 0
HungerX := 0
HungerY := 0

SysGet, wy1, 17

WMidY := Floor(wy1/2) + (A_ScreenHeight - wy1)
WMidX := Floor(A_ScreenWidth / 2)

StopLoop := 0

If (!FindInv())
{
	Output("Inventory not found. Stopping...")
	StopLoop := 1
}

If (ToolAction && !StopLoop)
{
	FindEquip()

	If (!IsEquipped() && !StopLoop)
	{
		EquipNew()
	}
	If (!IsEquipped() && !StopLoop)
	{
		Output("Wrong equip slot on first toolbar button. Stopping...")
		StopLoop := 1
	}

}

Loop
{
	If (StopLoop = 1)
	{
		Break
	}
    IfWinActive, ahk_class LifeIsFeudalWindow
    {
        If (IsFull())
        {
            If (IsRested())
            {
				DoAction()
            }
            Else
            {
                Rest()
            }
        }
        Else
        {
			If (HasFood())
			{
				Eat()
			}
			Else
			{
				Output("No food while hungry. Stopping...")
				StopLoop := 1
				Break
			}
        }
    }
}
Return


FindInv()
{
	global InvX, InvY
	
	MouseFree()
	
	x1 := 0
	x2 := A_ScreenWidth
	y1 := 0
	y2 := A_ScreenHeight
	
	inventory := A_WorkingDir . "\images\inventory.png"
	
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, %inventory%
	If ErrorLevel = 0
	{
		InvX := FoundX
		InvY := FoundY
		ret := 1
	}
	Else 
	{
		ret := 0
	}



	InvX -= 100
	InvY -= 550
	
	return ret
}

MouseFree()
{
	If (!IsMouseFree())
	{
		ToggleMouse()
	}
}

MouseLock()
{
	If (IsMouseFree())
	{
		ToggleMouse()
	}
}

CombatExit()
{
	If (!IsNonCombat())
	{
		Engage("r")
	}
}

CombatEnter()
{
	If (IsNonCombat())
	{
		Engage("Numpad0")
	}
}

IsNonCombat()
{
	global WMidX,WMidY
    reticle := A_WorkingDir . "\images\reticle.png"
    HalfXL := WMidX - 5
    HalfYU := WMidY - 5
    HalfXR := WMidX + 5
    HalfYD := WMidY + 5
    CoordMode, Pixel, Screen
    ImageSearch, FoundX, FoundY, %HalfXL%, %HalfYU%, %HalfXR%, %HalfYD%, *TransBlack %reticle%
    If ErrorLevel = 0
    {
        ret := 1
    }
    Else
    {
        ret := 0
    }
	ret := ret && !IsRanged()
    return ret
}

IsRanged()
{
	global WMidX,WMidY
    ranged := A_WorkingDir . "\images\ranged.png"
    HalfXL := WMidX - 5
    HalfYU := WMidY - 100
    HalfXR := WMidX + 5
    HalfYD := WMidY
    CoordMode, Pixel, Screen
    ImageSearch, FoundX, FoundY, %HalfXL%, %HalfYU%, %HalfXR%, %HalfYD%, *TransBlack %ranged%
    If ErrorLevel = 0
    {
        ret := 1
    }
    Else
    {
        ret := 0
    }
    return ret
}

Engage(key)
{
    Sleep, 50
    Send, {%key% Down}
    Sleep, 50
    Send, {%key% Up}
    Sleep, 1000
}

Rest()
{
	CombatExit()
    Sleep, 300
    Send, {9 Down}
    Sleep, 50
    Send, {9 Up}
    Sleep, 25
    Sleep, 90000
    Sleep, 25
    Send, {9 Down}
    Sleep, 50
    Send, {9 Up}
    Sleep, 25
    Sleep, 5550
}

DoAction()
{
	global Action
    %Action%()
}

Gather()
{
	global ActionDelay,ToolAction
	If (IsHealthy())
	{
		If ToolAction
		{
			If (!IsEquipped() && !StopLoop)
			{
				EquipNew()
			}
			If (IsEquipped())
			{
				CombatExit()
				MouseFree()
				PressE()
				Sleep, %ActionDelay%
			}		
		}
		Else
		{
			CombatExit()
			MouseFree()
			PressE()
			Sleep, %ActionDelay%
		}
	}
}

Block()
{
	global StopLoop
	If (!IsEquipped() && !StopLoop)
	{
		EquipNew()
	}
	If (IsEquipped())
	{
		MouseLock()
		CombatEnter()
	}
}

Attack()
{
	global ToolAction, StopLoop
	If ToolAction
	{
		If (!IsEquipped() && !StopLoop)
		{
			EquipNew()
		}
		If (IsEquipped())
		{
			MouseLock()
			CombatEnter()
			Swing()
		}		
	}
	Else
	{
		MouseLock()
		CombatEnter()
		Swing()
	}
}

Swing()
{
	global SwingHold, SwingCooldown
    Sleep, 50
    Click, Left, , Down
    Sleep, %SwingHold%
    Click, Left, , Up
    Sleep, %SwingCooldown%
}

PressE()
{
    Sleep, 50
    Send, {e Down}
    Sleep, 25
    Send, {e Up}
    Sleep, 50
}

ToggleMouse()
{
    Sleep, 300
    Send, {Tab Down}
    Sleep, 25
    Send, {Tab Up}
    Sleep, 300
}

Output(out)
{
	MsgBox, 0, , 
	(LTrim
	%out%
	)
}

IsMouseFree()
{
	If A_cursor = Arrow
	{
		ret := 1
	}
	Else
	{
		ret := 0
	}
	
	return ret
}

IsFull()
{
	global HungerX, HungerY
	x1 := HungerX - 50
	x2 := HungerX + 400
	If HungerX = 0
	{
		x2 := A_ScreenWidth
	}
	y1 := HungerY - 50
	y2 := HungerY + 100
	If HungerY = 0
	{
		y2 := A_ScreenHeight
	}
	food := A_WorkingDir . "\images\food.png"
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, %food%
	If ErrorLevel = 0
	{
		ret := 1
	}
	Else 
	{
		ret := 0
	}
	return ret
}

IsRested()
{
	global StamX, StamY
	x1 := StamX - 50
	x2 := StamX + 400
	If StamX = 0
	{
		x2 := A_ScreenWidth
	}
	y1 := StamY - 50
	y2 := StamY + 100
	If StamY = 0
	{
		y2 := A_ScreenHeight
	}
	stamina := A_WorkingDir . "\images\stamina.png"
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, %stamina%
	If ErrorLevel = 0
	{
		ret := 1
	}
	Else
	{
		ret := 0
	}
	return ret
}

IsHealthy()
{
	global HealthX, HealthY
	x1 := HealthX - 50
	x2 := HealthX + 400
	If HealthX = 0
	{
		x2 := A_ScreenWidth
	}
	y1 := HealthY - 50
	y2 := HealthY + 100
	If HealthY = 0
	{
		y2 := A_ScreenHeight
	}
	health := A_WorkingDir . "\images\health.png"
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, %health%
	If ErrorLevel = 0
	{
		ret := 1
	}
	Else
	{
		ret := 0
	}
	return ret
}

HasFood()
{
	global FoodX, FoodY, InvX, InvY, FoodImg
	x1 := InvX - 100
	x2 := InvX + 500
	y1 := InvY - 100
	y2 := InvY + 700
	eat := A_WorkingDir . "\images\" . FoodImg
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *20 %eat%
	If ErrorLevel = 0
	{
		FoodX := FoundX
		FoodY := FoundY
		ret := 1
	}
	Else
	{
		ret := 0
	}
	return ret
}



HasWeapon()
{
	global WeapX, WeapY, InvX, InvY, WeaponImg
	x1 := InvX - 100
	x2 := InvX + 500
	y1 := InvY - 100
	y2 := InvY + 700
	weapon := A_WorkingDir . "\images\" . WeaponImg

	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *TransWhite *20 %weapon%
	If ErrorLevel = 0
	{
		WeapX := FoundX
		WeapY := FoundY
		ret := 1
	}
	Else
	{
		ret := 0
	}

	return ret
}

WeaponBroken()
{
	global WeapX, WeapY
	
	CombatExit()
	MouseFree()
	
	MouseMove, WeapX, WeapY, 0
	Sleep, 1500


	x1 := WeapX - 400
	x2 := WeapX + 400
	y1 := WeapY - 400
	y2 := WeapY + 400
	
	broken := A_WorkingDir . "\images\broken.png"
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *20 %broken%
	If ErrorLevel = 0
	{
		ret := 1
	}
	Else 
	{
		ret := 0
	}
	return ret
}

WeaponDrop()
{
	global WeapX,WeapY,WMidX,WMidY
	MouseFree()
	
	MouseMove, WeapX, WeapY, 0
	Sleep, 25
	Click, %WeapX%, %WeapY% Left, Down
	Sleep, 25
	MouseMove, WMidX, WMidY, 100
	Sleep, 25
	Click, %WMidX%, %WMidY% Left, Up
	Sleep, 3000
	Sleep, 25
	MouseLock()
}

WeaponEquip()
{
	global WeapX,WeapY,WMidX,WMidY
	MouseFree()
	MouseMove, WeapX, WeapY, 0
	Sleep, 25
	Click, %WeapX%, %WeapY% Left, Down
	Sleep, 25
	Click, %WeapX%, %WeapY% Left, Up
	Sleep, 25
	Click, %WeapX%, %WeapY% Left, Down
	Sleep, 25
	Click, %WeapX%, %WeapY% Left, Up
	Sleep, 6000
	Click, %WMidX%, %WMidY%, 0
	Sleep, 25
	MouseLock()
}

Eat()
{
	global FoodX, FoodY,WMidX,WMidY
	CombatExit()
	MouseFree()
	Sleep, 25
	Click, %FoodX%, %FoodY% Left, Down
	Sleep, 25
	Click, %FoodX%, %FoodY% Left, Up
	Sleep, 25
	Click, %FoodX%, %FoodY% Left, Down
	Sleep, 25
	Click, %FoodX%, %FoodY% Left, Up
	Sleep, 5550
	Click, %WMidX%, %WMidY%, 0
	Sleep, 25
	MouseLock()
}

IsEquipped()
{
	ret := 0 
	If (!HasEmptyEquip())
	{
		ret := 1
	}

	return ret
}

FindEquip()
{
	global EquipX, EquipY, StopLoop
	ret := 0
	ll := A_WorkingDir . "\images\ll.png"
	lr := A_WorkingDir . "\images\lr.png"
	ul := A_WorkingDir . "\images\ul.png"
	ur := A_WorkingDir . "\images\ur.png"
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransBlack %ll%
	If ErrorLevel = 0
	{	
		EquipX := FoundX
		EquipY := FoundY
		ret := 1
	}
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransBlack %lr%
	If ErrorLevel = 0
	{
		EquipX := FoundX
		EquipY := FoundY
		ret := 1
	}
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransBlack %ul%
	If ErrorLevel = 0
	{
		EquipX := FoundX
		EquipY := FoundY
		ret := 1
	}
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransBlack %ur%
	If ErrorLevel = 0
	{
		EquipX := FoundX
		EquipY := FoundY
		ret := 1
	}
	If ret = 0
	{
		Output("No empty equip slot on first toolbar button. Stopping...")
		StopLoop := 1
	}

	return ret
}

HasEmptyEquip()
{
	global EquipX, EquipY
	x1 := EquipX - 100
	x2 := EquipX + 100
	y1 := EquipY - 100
	y2 := EquipY + 100
	
	ret := 0
	unequip := A_WorkingDir . "\images\unequip.png"
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *TransWhite %unequip%
	If ErrorLevel = 0
	{
		ret := 1
	}
	return ret
}

EquipNew()
{

	global StopLoop, InvX, InvY
	MouseFree()
	while (HasWeapon())
	{
		If (WeaponBroken())
		{
			WeaponDrop()
		}
		Else 
		{
			WeaponEquip()
			Break
		}
	}

}


F6::
Run superhax.ahk
Return

F12::
ExitApp
