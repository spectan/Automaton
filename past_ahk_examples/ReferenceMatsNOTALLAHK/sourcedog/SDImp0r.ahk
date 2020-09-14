#Include %A_ScriptDir%\include

#Include ArrayExtensions.ahk
#Include Console.ahk
#Include Config.ahk
#Include EventLogUpdateChecker.ahk
#Include EventLogParser.ahk
#Include QLParser.ahk

SetTitleMatchMode, 2

startExecution = 0
curItemPos := ""

itemPositions         := []
console               := new Console
config                := new Config
eventLogParser        := new EventLogParser(config)
qlParser              := new QLParser(config)

FormatTime, eventLogTimeString, , yyyy-MM
eventLogFolder := config.getEventLogFolder()
eventLogFile    = %eventLogFolder%_Event.%eventLogTimeString%.txt
eventLogUpdateChecker := new EventLogUpdateChecker(eventLogFile)

improveButton := config.getImproveButton()
examineButton := config.getExamineButton()
repairButton  := config.getRepairButton()

maxItemQl     := config.getMaxItemQl()

console.log("Please mark items to improve by hovering the mouse over each one and pressing SHIFT+SPACE")
console.log("Start execution with SHIFT+ESC when ready")
console.log("Once running, press SHIFT+ESC to go back to idle, press ESC to stop entirely")

Idle:
Loop 													
{
    if(startExecution == 1)
    {
        console.log("Starting up... Event log size is " . eventLogUpdateChecker.getLineCount() . " line(s)")
        break   
    }
    sleep 500
}

if(curItemPos == "")
{
    curItemPos := itemPositions.shift()
    MouseMove, curItemPos["x"], curItemPos["y"]
    Send, {LButton}
    Send {%repairButton% down}
    Sleep 6000
}

MouseMove, curItemPos["x"], curItemPos["y"]
Send, {LButton}
Send {%examineButton% down}

Loop
{
    newLines := eventLogUpdateChecker.checkForUpdate()
    if(newLines.MaxIndex() > 0)
    {
        console.log("")
        console.log("Update in event log found!")
        for index, element in newLines
        {
            keyToPress := eventLogParser.parseString(element)
            
            WinActivate, Wurm Unlimited
            
            if(keyToPress == repairButton)
                delay := 6000
            else
                delay := 0
            
            if(keyToPress != "" && keyToPress != repairButton)
            {
                console.log("Getting item QL...")
                itemQl := qlParser.getItemQl(curItemPos["x"], curItemPos["y"])
                console.log("Item QL: " . itemQl)
                if(itemQl >= maxItemQl)
                    keyToPress := "next"
            }
            
            if(keyToPress == "next")
            {
                if(itemPositions.length() <= 0)
                {
                    console.log("Ran out of items to improve. Going idle...")
                    startExecution = 0
                    Goto, Idle 
                }
                curItemPos := itemPositions.shift()
                MouseMove, curItemPos["x"], curItemPos["y"]
                Send, {LButton}
                Send {%repairButton% down}
                Sleep 6000
                Send {%examineButton% down}
                continue
            }
            else
            {
                MouseMove, curItemPos["x"], curItemPos["y"]
                Send, {LButton}
            }
            
            if(keyToPress == "halt")
            {
                console.log("Cannot proceed, going back to idle")
                startExecution = 0
                Goto, Idle
            }
            
            if(keyToPress != "")
            {
                console.log("Sending Keypress " . keyToPress)
                Send {%keyToPress% down}
                Sleep 50
                console.log("Sending Keypress " . improveButton)
                Send {%improveButton% down}
                sleep %delay%
            }
        }
    }
}

esc::exitapp

+esc::
    if(startExecution == 1)
    {
        startExecution := 0
        Goto, Idle
    }
    else
    {
        startExecution := 1   
    }
return

+space::
    if(startExecution == 0)
    {
        console.log("Recording item position...")
        WinActivate, Wurm Unlimited
        MouseGetPos, PosX, PosY
        mousePos := Object()
        mousePos["x"] := PosX
        mousePos["y"] := PosY
        
        itemPositions.push(mousePos)
    }
return

f11::listvars

f12::reload

#singleinstance force