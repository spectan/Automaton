superhax is a Life is Feudal MMO macro for gathering and combat training

Requirements:
Autohotkey
https://autohotkey.com/download/
1920x1080 resolution monitor? (untested on other resolutions)

Ingame Requirements:
Health/Stamina/Food bars must be at or near the default size for correct detection
Rest bound to 9
Perform/Attack bound to E
Inventory locked

Requirements for tool/weapon actions:
Set up a toolbar with your tool/weapon's default equip slot on the first button
Unequip anything from this equip slot
Ensure that no other equip slots are on the toolbar
Bind the first toolbar button to Numpad0
Check the example toolbar image for further clarification

To use:
Run superhax.ahk macro as Administrator
Press F5 to start macroing
Press F6 to restart
Press F12 to exit entirely

Gather functionality:
This macro will check your hard health, hard stamina, and food. 
Additionally, the wild plant macro will equip new sickles for you.
When necessary, it will:
	wait to heal if low on hard health
	rest for 1.5 minutes if low on hard stam
	eat food from your inventory
When all status bars are in good condition, it will perform a gather action

Suggested uses:
Tracking
Gather taproot
Gather mushroom
Gather flintstone
Gather plant fibre
Gather wild plants

Combat functionality:
This macro will check your equipped weapon, hard stamina, and food. 
When necessary, it will:
	equip a weapon from your inventory
	drop broken weapons
	rest for 1.5 minutes
	eat food from your inventory.
When all status bars are in good condition and a weapon is equipped, it will perform a swing

Suggested uses: 
Dummy training
Sling training