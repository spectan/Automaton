class QLParser
{
	__New(config)
	{
		this.console := new Console
		this.config  := config
	}
	
	getItemQl(PosX, PosY)
	{
		Send, {LButton}
		Send {F1}
		Send setoption gui_opacity 4
		Send {Enter}
		Send {F1}
		
		MouseMove, 0, 0

		; Find upper limit
		upperPosX := PosX
		upperPosY := PosY
		Loop
		{
			PixelSearch, , , upperPosX, upperPosY, upperPosX, upperPosY, 0x12171C, 10, Fast
			if(ErrorLevel)
			{
				upperPosY--
			}
			else
			{
				Loop
				{
					PixelSearch, , , upperPosX, upperPosY, upperPosX, upperPosY, 0x12171C, 10, Fast
					if(ErrorLevel)
					{
						upperPosX := upperPosX + 25
						break 
					}
					else
					{
						upperPosX := upperPosX - 25
					}
				}
				break
			}
		}
		
		; Find lower limit
		lowerPosX := PosX
		lowerPosY := PosY
		Loop
		{
			PixelSearch, , , lowerPosX, lowerPosY, lowerPosX, lowerPosY, 0x12171C, 10, Fast
			if(ErrorLevel)
			{
				lowerPosY++ 
			}
			else
			{
				Loop
				{
					PixelSearch, , , lowerPosX, lowerPosY, lowerPosX, lowerPosY, 0x12171C, 10, Fast
					if(ErrorLevel)
					{
						lowerPosX := lowerPosX - 25
						break 
					}
					else
					{
						lowerPosX := lowerPosX + 25
					}
				}
				break
			}
		}
		
		;upperPosY := upperPosY - 7
		;lowerPosY := lowerPosY - 7
		
		RunWait, Capture2Text.exe %upperPosX% %upperPosY% %lowerPosX% %lowerPosY%, %A_ScriptDir%\lib\Capture2Text\

		MouseMove, PosX, PosY
		
		Send {F1}
		Send setoption gui_opacity 3
		Send {Enter}
		Send {F1}
		
		FileRead, ocrResult, %A_ScriptDir%\lib\Capture2Text\Output\ocr.txt
		
		qlStartingPos := RegExMatch(ocrResult, "([0-9]+,[0-9]+)") 
		itemQl := SubStr(ocrResult, qlStartingPos, 2)
		itemQl := StrReplace(itemQl, ",", "")
		
		return itemQl
	}
}