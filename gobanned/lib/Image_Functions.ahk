ScreenSearch(imageName, variance=5, trans="", x1=0, y1=0, x2=1920, y2=1080)
{
	global FoundX, FoundY
	
	;Get the actual max bounds for the window
	WinGetPos, x, y, w, h, Wurm Online
	If (x2 = 1920)
	{
		x2 := w
	}
	If (y2 = 1080)
	{
		y2 := h
	}
	
	img := A_WorkingDir . "\images\" . imageName . ".png"
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, x1, y1, x2, y2, %trans% *%variance% %img%
	If ErrorLevel = 0
	{
		ret := 1
	}
	Else
	{
		ret := 0
	}
	;MsgBox, %FoundX%, %FoundY%, %imageName%, %ret%
	return ret
}

FindImageVersion(imageName="",numVersions=0)
{
	i := 1
	foundImageName := imageName
	If (numVersions > 0)
	{
		Loop %numVersions%
		{
			imageVersionName := "" . imageName . i
			
			foundImage := GetImageCoords(imageVersionName)
			If (foundImage[1])
			{
				foundImageName := foundImageName . i
				break
			}
			i += 1
		}

	}
	return foundImageName
}

GetImageCoords(imageName="", x1=0, y1=0, x2=1920, y2=1080, transMode="*TransWhite", variance=5)
{
	ret := []
	ret[1] := 0
	ret[2] := 0
	ret[3] := 0
	
	;Get the actual max bounds for the window
	WinGetPos, x, y, w, h, Wurm Online
	If (x2 = 1920)
	{
		x2 := w
	}
	If (y2 = 1080)
	{
		y2 := h
	}
	
	img := A_WorkingDir . "\images\" . imageName . ".png"
	CoordMode, Pixel, Window
	ImageSearch, foundX, foundY, x1, y1, x2, y2, %transMode% *%variance% %img%
	If ErrorLevel = 0
	{
		ret[1] := 1
		ret[2] := foundX
		ret[3] := foundY
	}
	return ret
}

HasItemBelow()
{
	itemLineTopY := GetItemLineTop()
	itemLineBottomY := itemLineTopY + 18
	nextItemLineBottomY := itemLineBottomY + 18

	CoordMode, Pixel, Window
	MouseGetPos, mouseX, mouseY
	img := A_WorkingDir . "\images\whitetext.png"
	ImageSearch, FoundX, FoundY, mouseX-200, itemLineBottomY, mouseX+400, nextItemLineBottomY, *3 %img%
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

IsImpItem(imageName)
{
	itemLineTopY := GetItemLineTop()
	itemLineBottomY := itemLineTopY + 18
	
	CoordMode, Pixel, Window
	MouseGetPos, mouseX, mouseY
	img := A_WorkingDir . "\images\" . imageName . ".png"
	ImageSearch, FoundX, FoundY, mouseX, itemLineTopY, mouseX+400, itemLineBottomY, *5 *TransWhite %img%
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

FindInLine(imageName, itemLineTopY=0, mouseX=0, transMode="*TransWhite")
{
	If (itemLineTopY = 0)
	{
		itemLineTopY := GetItemLineTop()
	}
	itemLineBottomY := itemLineTopY + 18
	
	CoordMode, Pixel, Window
	If (mouseX = 0)
	{
		MouseGetPos, mouseX, mouseY
	}
	img := A_WorkingDir . "\images\" . imageName . ".png"
	ImageSearch, FoundX, FoundY, mouseX, itemLineTopY, mouseX+400, itemLineBottomY, *5 %transMode% %img%
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

;Find by upper right x (can run into other windows)
GetMenuCoords(menuHeaderImageName="")
{
	global stopLoop, stopReason
	
	menuFound := []
	menuFound[1] := 0
	menuFound[2] := 0
	menuFound[3] := 0
	menuFound[4] := 0
	menuFound[5] := 0
	
	menuHeader := GetImageCoords(menuHeaderImageName)
	
	If (menuHeader[1])
	{
		menuFound[2] := menuHeader[2]
		menuFound[3] := menuHeader[3]
		
		menuX := GetImageCoords("menux", menuFound[2], menuFound[3])
		
		If (menuX[1])
		{
			menuXX := menuX[2]
			menuXY := menuX[3]
			
			menuCorner := GetImageCoords("menucorner", menuXX-20, menuXY, menuXX+20)
			
			If (menuCorner[1])
			{
				menuFound[4] := menuCorner[2]
				menuFound[5] := menuCorner[3]
				
				menuFound[1] := 1
			}
			Else
			{
				;stopLoop := 1
				;stopReason := "Unable to find menu corner " . menuHeaderImageName
			}
		}
		Else
		{
			;stopLoop := 1
			;stopReason := "Unable to find menux for " . menuHeaderImageName
		}
	}
	Else
	{
		;stopLoop := 1
		;stopReason := "Unable to find menu " . menuHeaderImageName
	}
	
	;MsgBox % "found=" . menuFound[1] . " x1=" . menuFound[2] . " y1=" . menuFound[3] . " x2=" . menuFound[4] . " y2=" . menuFound[5]
	return menuFound
}

;Find by bottom left corner (bounds a column for the bottom left corner)
GetMenuCoords2(menuHeaderImageName="")
{
	global stopLoop, stopReason
	
	menuFound := []
	menuFound[1] := 0
	menuFound[2] := 0
	menuFound[3] := 0
	menuFound[4] := 0
	menuFound[5] := 0
	
	menuHeader := GetImageCoords(menuHeaderImageName)
	
	If (menuHeader[1])
	{
		menuFound[2] := menuHeader[2]
		menuFound[3] := menuHeader[3]

		size := GetImageSize(menuHeaderImageName)
		
		menuBottomLeft := GetImageCoords("menubottomleft", menuFound[2]-20, menuFound[3], menuFound[2] + size[1])
		
		If (menuBottomLeft[1])
		{
			menuBottomLeftX := menuBottomLeft[2]
			menuBottomLeftY := menuBottomLeft[3]
			
			size := GetImageSize("menuBottomLeft")
			
			menuCorner := GetImageCoords("menucorner", menuBottomLeftX, menuBottomLeftY)
			
			If (menuCorner[1])
			{
				menuFound[4] := menuCorner[2]
				menuFound[5] := menuCorner[3]
				
				menuFound[1] := 1
			}
			Else
			{
				;stopLoop := 1
				;stopReason := "Unable to find menu corner " . menuHeaderImageName
			}
		}
		Else
		{
			;stopLoop := 1
			;stopReason := "Unable to find menubottomleft for " . menuHeaderImageName
		}
	}
	Else
	{
		;stopLoop := 1
		;stopReason := "Unable to find menu " . menuHeaderImageName
	}
	
	;MsgBox % "stopReason=" . stopReason . " found=" . menuFound[1] . " x1=" . menuFound[2] . " y1=" . menuFound[3] . " x2=" . menuFound[4] . " y2=" . menuFound[5]
	return menuFound
}

GetItemLineTop(mouseX=0, mouseY=0)
{
	global stopLoop, stopReason, impWorldObject
	ret := 0
	variant := 1
	
	Loop
	{
		If (ret > 0 OR variant > 3)
		{
			Break
		}
		CoordMode, Pixel, Window
		If (mouseX = 0 OR mouseY = 0)
		{
			MouseGetPos, mouseX, mouseY
		}
		img := A_WorkingDir . "\images\itemline" . variant . ".png"
		ImageSearch, FoundX, FoundY, mouseX-200, mouseY-20, mouseX+400, mouseY+20, *10 %img%
		If ErrorLevel = 0
		{
			ret := FoundY
		}
		Else
		{
			ret := 0
		}
		variant += 1
	}
	
	If (!ret)
	{
		stopLoop := 1
		stopReason := "GetItemLineTop failure"
	}
	return ret
}

FindInMenu(menuName="", targetName="", transMode="*TransWhite")
{
	global stopLoop, stopReason
	
	notFound := []
	notFound[1] := 0

	menuCoords := GetMenuCoords2(menuName)
	
	If (menuCoords[1])
	{
		return GetImageCoords(targetName, menuCoords[2], menuCoords[3], menuCoords[4], menuCoords[5], transMode)
	}
	Else
	{
		;stopLoop := 1
		;stopReason := "Unable to find menu " . menuHeaderImageName	
		return notFound
	}
}

GetImageBounds(imageName="", leftX=0, topY=0)
{
	bound := []
	bound[1] := 0
	bound[2] := 0
	bound[3] := 0
	bound[4] := 0
	bound[5] := 0
	
	found := GetImageCoords(imageName, leftX, topY)
	
	If (found[1])
	{
		size := GetImageSize(imagename)
		
		bound[1] := 1
		bound[2] := found[2]
		bound[3] := found[3]
		bound[4] := found[2] + size[1]
		bound[5] := found[3] + size[2]
	}
	
	return bound
}

FindImageInImage(imageB="", imageA="", leftX=0, topY=0)
{
	global stopLoop, stopReason
	
	notFound := []
	notFound[1] := 0

	imageABounds := GetImageBounds(imageA, leftX, topY)
	
	If (imageABounds[1])
	{
		imageBCoords := GetImageCoords(imageB, imageABounds[2], imageABounds[3], imageABounds[4], imageABounds[5])
		
		If (imageBCoords[1])
		{
			size := GetImageSize(imageB)
		
			imageBBounds := []
			imageBBounds[1] := 1
			imageBBounds[2] := imageBCoords[2]
			imageBBounds[3] := imageBCoords[3]
			imageBBounds[4] := imageBCoords[2] + size[1]
			imageBBounds[5] := imageBCoords[3] + size[2]
		
			return imageBBounds
		}
		Else
		{
			stopLoop := 1
			stopReason := "FindImageInImage could not find imageB " . imageB . " within imageA " . imageA
		}
	}
	Else
	{
		stopLoop := 1
		stopReason := "FindImageInImage could not find imageA " . imageA
	}
	
	return notFound
}

MenuAHasMoreThan100KgOfItemX(menuName="", targetName="")
{
	foundItem := FindInMenu(menuName, targetName)
	
	If (foundItem[1])
	{
		itemX := foundItem[2]
		itemY := foundItem[3]
		
		lineY := itemY - 5
		
		is100kg := 0
		variant := 1
		
		Loop
		{
			If (is100kg = 1 OR variant > 3)
			{
				Break
			}
			
			imgName := "100kg" . variant
			
			found100kg := FindInLine(imgName, lineY, itemX, "*TransBlack")
			
			If (found100kg)
			{
				is100kg := 1
			}

			variant += 1
		}
		
		If (is100kg)
		{
			return 1
		}
	}
	return 0
}

MenuAHasLessThan10KgOfItemX(menuName="", targetName="")
{
	foundItem := FindInMenu(menuName, targetName)
	
	If (foundItem[1])
	{
		itemX := foundItem[2]
		itemY := foundItem[3]
		
		lineY := itemY - 5
		
		isSub10kg := 0
		variant := 1
		
		Loop
		{
			If (isSub10kg = 1 OR variant > 3)
			{
				Break
			}
			
			imgName := "sub10kg" . variant
			
			foundSub10kg := FindInLine(imgName, lineY, itemX, "*TransWhite")
			
			If (foundSub10kg)
			{
				isSub10kg := 1
			}

			variant += 1
		}
		
		If (isSub10kg)
		{
			return 1
		}
	}
	return 0
}

GetImpItem(impItemCsv)
{
	ret := "none"
	impItemArray := StrSplit(impItemCsv, ",")
	
	Loop % impItemArray.MaxIndex()
	{
		impItem := impItemArray[A_Index]
		If (IsImpItem(impItem))
		{
			ret := impItem
		}
	}
	return ret
}

MouseIsOnImage(imageName="")
{
	ret := 0
	MouseGetPos, mouseX, mouseY
	imageSize := GetImageSize(imageName)

	imageCoords := GetImageCoords(imageName, mouseX - imageSize[1], mouseY - imageSize[2])
	If (imageCoords[1])
	{
		If ((mouseX > imageCoords[2] AND mouseX < imageCoords[2] + imageSize[1]) AND (mouseY > imageCoords[3] AND mouseY < imageCoords[3] + imageSize[2]))
		{
			ret := 1
		}
	}
	
	return ret
}

GetImageSize(imageName="")
{
	imagefile := A_WorkingDir . "\images\" . imageName . ".png"
	GDIPToken := Gdip_Startup()
	pBM := Gdip_CreateBitmapFromFile(imagefile)
	W:= Gdip_GetImageWidth(pBM)
	H:= Gdip_GetImageHeight(pBM)
	Gdip_DisposeImage(pBM)
	Gdip_Shutdown(GDIPToken)
	ret := []
	ret[1] := W
	ret[2] := H
	return ret
}