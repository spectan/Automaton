class Config
{
	__New()
	{
		this.console    := new Console
		this.configData := Object()

		configFile = %A_ScriptDir%\config.ini

		IniRead, tmpConfigFile, % configFile, GENERAL, EVENTLOG_FOLDER
		this.configData["eventLogFolder"] := tmpConfigFile

		IniRead, tmpConfigSkill, % configFile, GENERAL, USE
		this.configData["skill"] := tmpConfigSkill

		IniRead, tmpMaxItemQl, % configFile, GENERAL, MAX_ITEM_QL
		this.configData["maxitemql"] := tmpMaxItemQl

		;;; Actions ;;;
		actions := Object()
		
		; Improve
		IniRead, tmpConfigButton, % configFile, ACTIONS, ACTION_IMPROVE
		actions["improve"] := tmpConfigButton
		
		; Examine
		IniRead, tmpConfigButton, % configFile, ACTIONS, ACTION_EXAMINE
		actions["examine"] := tmpConfigButton
		
		; Repair
		IniRead, tmpConfigButton, % configFile, ACTIONS, ACTION_REPAIR
		actions["repair"] := tmpConfigButton
		
		this.configData["actions"] := actions

		;;; Special ;;;
		special := Object()
		
		; Tool is empty / broken
		IniRead, tmpConfigMessage, % configFile, SPECIAL, MESSAGE_TOOL_EMPTY
		special[tmpConfigMessage] := "halt"
		
		; Tool needs to be repaired
		IniRead, tmpConfigMessage, % configFile, SPECIAL, MESSAGE_NEEDS_REPAIR
		IniRead, tmpConfigButton, % configFile, ACTIONS, ACTION_REPAIR
		special[tmpConfigMessage] := tmpConfigButton

		this.configData["special"] := special

		;;; Metalworking ;;;
		metalWorking := Object()
		
		; Lump cannot be used to improve any further, jump to next target
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_LUMP_POOR_SHAPE
		metalWorking[tmpConfigMessage] := "next"
		
		; Something has cooled down too much, halt
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NOT_GLOWING
		metalWorking[tmpConfigMessage] := "halt"
		
		; Not enough water to proceed, halt
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NO_WATER
		metalWorking[tmpConfigMessage] := "halt"
		
		; Hammer
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_HAMMER
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_HAMMER
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		; Lump
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_LUMP
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_LUMP
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_MORELUMP
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_LUMP
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		; Water
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_WATER
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_WATER
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		; Whetstone
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_WHETSTONE
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_WHETSTONE
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		; Pelt
		IniRead, tmpConfigMessage, % configFile, METALWORKING, MESSAGE_NEEDS_PELT
		IniRead, tmpConfigSlot, % configFile, METALWORKING, TOOLBELT_PELT
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		metalWorking[tmpConfigMessage] := tmpConfigButton
		
		this.configData["metalworking"] := metalWorking
		
		;;; Leatherworking ;;;
		leatherWorking := Object()
		
		; Leather cannot be used to improve any further, jump to next target
		IniRead, tmpConfigMessage, % configFile, LEATHERWORKING, MESSAGE_LEATHER_POOR_SHAPE
		leatherWorking[tmpConfigMessage] := "next"
		
		; Leather
		IniRead, tmpConfigMessage, % configFile, LEATHERWORKING, MESSAGE_NEEDS_LEATHER
		IniRead, tmpConfigSlot, % configFile, LEATHERWORKING, TOOLBELT_LEATHER
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		leatherWorking[tmpConfigMessage] := tmpConfigButton
		
		IniRead, tmpConfigMessage, % configFile, LEATHERWORKING, MESSAGE_NEEDS_MORELEATHER
		IniRead, tmpConfigSlot, % configFile, LEATHERWORKING, TOOLBELT_LEATHER
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		leatherWorking[tmpConfigMessage] := tmpConfigButton
		
		; Mallet
		IniRead, tmpConfigMessage, % configFile, LEATHERWORKING, MESSAGE_NEEDS_MALLET
		IniRead, tmpConfigSlot, % configFile, LEATHERWORKING, TOOLBELT_MALLET
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		leatherWorking[tmpConfigMessage] := tmpConfigButton
		
		; Awl
		IniRead, tmpConfigMessage, % configFile, LEATHERWORKING, MESSAGE_NEEDS_AWL
		IniRead, tmpConfigSlot, % configFile, LEATHERWORKING, TOOLBELT_AWL
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		leatherWorking[tmpConfigMessage] := tmpConfigButton
		
		; Leatherknife
		IniRead, tmpConfigMessage, % configFile, LEATHERWORKING, MESSAGE_NEEDS_KNIFE
		IniRead, tmpConfigSlot, % configFile, LEATHERWORKING, TOOLBELT_KNIFE
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		leatherWorking[tmpConfigMessage] := tmpConfigButton
		
		; Needle
		IniRead, tmpConfigMessage, % configFile, LEATHERWORKING, MESSAGE_NEEDS_NEEDLE
		IniRead, tmpConfigSlot, % configFile, LEATHERWORKING, TOOLBELT_NEEDLE
		IniRead, tmpConfigButton, % configFile, TOOLBELT, TOOLBELT_SLOT_%tmpConfigSlot%
		leatherWorking[tmpConfigMessage] := tmpConfigButton
	
		this.configData["leatherworking"] := leatherWorking
	}
	
	getEventLogFolder()
	{
		return this.configData["eventLogFolder"]
	}
	
	getMetalworkingConfig()
	{
		return this.configData["metalworking"]
	}
	
	getLeatherworkingConfig()
	{
		return this.configData["leatherworking"]	
	}
	
	getSpecialConfig()
	{
		return this.configData["special"]
	}
	
	getImproveButton()
	{
		return this.configData["actions"]["improve"]
	}
	
	getExamineButton()
	{
		return this.configData["actions"]["examine"]
	}
	
	getRepairButton()
	{
		return this.configData["actions"]["repair"]
	}
	
	getSkill()
	{
		return this.configData["skill"]
	}
	
	getMaxItemQl()
	{
		return this.configData["maxitemql"]
	}
}