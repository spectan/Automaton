Class EventLogParser
{
	__New(config)
	{
		this.console := new Console
		this.config  := config
	}
	
	parseString(line)
	{
		specialConfig      := this.config.getSpecialConfig()
		for index, element in specialConfig
        {
			If InStr(line, index)
				return element
		}
		
		skillToUse := this.config.getSkill()
		if(skillToUse == "metalworking")
			skillConfig := this.config.getMetalworkingConfig()	
		else if(skillToUse == "leatherworking")
			skillConfig := this.config.getLeatherworkingConfig()	
		
		skillConfig := this.config.getMetalworkingConfig()
		
		for index, element in skillConfig
        {
			If InStr(line, index)
				return element
		}
		
		return ""
	}
}