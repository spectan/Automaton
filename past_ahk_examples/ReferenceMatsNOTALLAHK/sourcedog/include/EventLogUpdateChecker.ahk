Class EventLogUpdateChecker
{
	eventLogFile         := ""
	eventLogLineCount    := 0
	console              := ""
	
	__New(eventLogFile)
	{
		console.log(eventLogFile)
		this.console := new Console
		this.eventLogFile := eventLogFile
		this.eventLogLineCount := this.countLines()
	}
	
	checkForUpdate()
	{
		updatedLines := Object()
		
		curEventLogLineCount := this.countLines()
		if(curEventLogLineCount > this.eventLogLineCount)
		{
			updatedLines := this.getLines(curEventLogLineCount - this.eventLogLineCount)
			
			this.eventLogLineCount := curEventLogLineCount
		}
		
		return updatedLines
	}
	
	countLines()
	{
		FileRead, f1, % this.eventLogFile
		StringReplace,OutputVar,f1,`n,`n,useerrorlevel
		return (ErrorLevel + 1)
	}
	
	getLines(linesNum)
	{
    	Lines := Object()
		
		FileRead text, % this.eventLogFile
		
		Loop Parse, text, `n
			maxLinesNum++
		
		Loop Parse, text, `n
		{
			If (A_Index < maxLinesNum - linesNum)
			Continue
			
			Lines.Insert(A_LoopField)
		}
		
		Return Lines
	}
	
	getLineCount()
	{
		return this.eventLogLineCount
	}
}