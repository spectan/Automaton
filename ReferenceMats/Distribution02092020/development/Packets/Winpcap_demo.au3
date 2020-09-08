; Winpcap autoit3 UDF demo - V1.2c
; Copyleft GPL3 Nicolas Ricquemaque 2009-2011

#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiListView.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>

#include <Winpcap.au3>

$winpcap=_PcapSetup()
If ($winpcap=-1) Then
	MsgBox(16,"Pcap error !","WinPcap not found !")
	exit
EndIf

$pcap_devices=_PcapGetDeviceList()
If ($pcap_devices=-1) Then
	MsgBox(16,"Pcap error !",_PcapGetLastError())
	exit
EndIf

GUICreate("Packet capture", 500, 350)
$interface=GUICtrlCreateCombo("", 80, 15, 400,default,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Pcap capture file")
For $i = 0 to Ubound($pcap_devices)-1
	GUICtrlSetData(-1, $pcap_devices[$i][1])
Next
$filter=GUICtrlCreateInPut ("", 80, 45, 300) 
$promiscuous=GUICtrlCreateCheckbox ( "promiscuous", 400, 45)
$start=GUICtrlCreateButton ( "Start", 20, 310, 60)
$stop=GUICtrlCreateButton ( "Stop", 110, 310,60) 
GUICtrlSetState (-1, $GUI_DISABLE )
$clear=GUICtrlCreateButton ( "Clear", 200, 310,60) 
$stats=GUICtrlCreateButton ( "Stats", 290, 310,60) 
GUICtrlSetState (-1, $GUI_DISABLE )
$save=GUICtrlCreateCheckbox ( "Save packets", 395, 310,90,30)
GUICtrlSetStyle(GUICtrlCreateLabel ( "Interface :", 10, 20, 60),$SS_RIGHT)
GUICtrlSetStyle(GUICtrlCreateLabel ( "Filter :", 10, 50, 60),$SS_RIGHT)
$packetwindow = GUICtrlCreateListView("No|Time|Len|Packet", 10, 90, 480, 200)
_GUICtrlListView_SetColumn($packetwindow,0,"No",40,1)
_GUICtrlListView_SetColumnWidth($packetwindow, 1, 80)
_GUICtrlListView_SetColumn($packetwindow,2,"Len",40,1)
_GUICtrlListView_SetColumnWidth($packetwindow, 3, 300)

GUISetState()

$i=0
$pcap=0
$packet=0
$pcapfile=0

Do
	$msg = GUIGetMsg()
	
	If ($msg=$start) Then
		If GUICtrlRead($promiscuous)=$GUI_CHECKED Then
			$prom=1
		Else
			$prom=0
		EndIf		
		$int=""
		If (GUICtrlRead($interface)="Pcap capture file") Then
			$file=FileOpenDialog ( "Pcap file to open ?", ".", "Pcap (*.pcap)|All files (*.*)" ,1 )
			If $file="" Then ContinueLoop
			$int="file://"&$file
		Else			
			For $n = 0 to Ubound($pcap_devices)-1
				If $pcap_devices[$n][1]=GUICtrlRead($interface) Then
					$int=$pcap_devices[$n][0]
					ExitLoop
				EndIf
			Next
		EndIf
		$pcap=_PcapStartCapture($int,GUICtrlRead($filter),$prom)
		If ($pcap=-1) Then
			MsgBox(16,"Pcap error !",_PcapGetLastError())
			ContinueLoop
		EndIf
		$linktype=_PcapGetLinkType($pcap)	
		If ($linktype[1]<>"EN10MB") Then
			MsgBox(16,"Pcap error !","This example only works for Ethernet captures")
			ContinueLoop
		Endif
		If GUICtrlRead($save)=$GUI_CHECKED Then
			$file=FileSaveDialog ( "Pcap file to write to ?", ".", "Pcap (*.pcap)" ,16 )
			If ($file<>"") Then 
				If StringLower(StringRight($file,5))<>".pcap" Then $file&=".pcap"
				$pcapfile=_PcapSaveToFile($pcap,$file)
				If ($pcapfile=0) Then MsgBox(16,"Pcap error !",_PcapGetLastError())
			EndIf
		EndIf		
		GUICtrlSetState ($stop, $GUI_ENABLE)
		GUICtrlSetState ($stats, $GUI_ENABLE)
		GUICtrlSetState ($start, $GUI_DISABLE)
		GUICtrlSetState ($save, $GUI_DISABLE)
	EndIf
	
	If ($msg=$stop) Then
		If IsPtr($pcapfile) Then 
			_PcapStopCaptureFile($pcapfile)
			$pcapfile=0
		EndIf
		if Not IsInt($pcap) Then _PcapStopCapture($pcap)
		$pcap=0
		GUICtrlSetState ($stop, $GUI_DISABLE)
		GUICtrlSetState ($stats, $GUI_DISABLE)
		GUICtrlSetState ($start, $GUI_ENABLE)
		GUICtrlSetState ($save, $GUI_ENABLE)
	EndIf
	
	If ($msg=$clear) Then
		_PcapGetStats($pcap)
		_GUICtrlListView_DeleteAllItems($packetwindow)
		$i=0
	EndIf
	
	If ($msg=$stats) Then
		$s=_PcapGetStats($pcap)
		_ArrayDisplay($s,"Capture statistics")
	EndIf
	
	If IsPtr($pcap) Then 	; If $pcap is a Ptr, then the capture is running
		$time0=TimerInit()
		While (TimerDiff($time0)<500) ; Retrieve packets from queue for maximum 500ms before returning to main loop, not to "hang" the window for user
			$packet=_PcapGetPacket($pcap)
			If IsInt($packet) Then ExitLoop
			GUICtrlCreateListViewItem($i&"|"&StringTrimRight($packet[0],4)&"|"&$packet[2]&"|"&MyDissector($packet[3]), $packetwindow)
			$data=$packet[3]
			_GUICtrlListView_EnsureVisible($packetwindow, $i)
			$i+=1
			If IsPtr($pcapfile) Then _PcapWriteLastPacket($pcapfile)
		Wend
	EndIf
	
Until $msg=$GUI_EVENT_CLOSE

If IsPtr($pcapfile) Then _PcapStopCaptureFile($pcapfile)	; A file is still open: close it
if IsPtr($pcap) Then _PcapStopCapture($pcap)	; A capture is still running: close it
_PcapFree()	

Exit


Func MyDissector ($data) ; Quick example packet dissector....
	Local $macdst=StringMid ($data,3,2)&":"&StringMid ($data,5,2)&":"&StringMid ($data,7,2)&":"&StringMid ($data,9,2)&":"&StringMid ($data,11,2)&":"&StringMid ($data,13,2)
	Local $macsrc=StringMid ($data,15,2)&":"&StringMid ($data,17,2)&":"&StringMid ($data,19,2)&":"&StringMid ($data,21,2)&":"&StringMid ($data,23,2)&":"&StringMid ($data,25,2)
	Local $ethertype=BinaryMid ( $data, 13 ,2 )
	
	If $ethertype="0x0806" Then return "ARP "&$macsrc&" -> "&$macdst

	If $ethertype="0x0800" Then
		Local $src=Number(BinaryMid ($data, 27 ,1))&"."&Number(BinaryMid ($data, 28 ,1))&"."&Number(BinaryMid ($data, 29 ,1))&"."&Number(BinaryMid ($data, 30 ,1))
		Local $dst=Number(BinaryMid ($data, 31 ,1))&"."&Number(BinaryMid ($data, 32 ,1))&"."&Number(BinaryMid ($data, 33 ,1))&"."&Number(BinaryMid ($data, 34 ,1))
		Switch BinaryMid ($data, 24 ,1)
			Case "0x01"
			   return "ICMP "&$src&" -> "&$dst
			Case "0x02"
			   return "IGMP "&$src&" -> "&$dst
			Case "0x06"
				Local $srcport=Number(BinaryMid ($data, 35 ,1))*256+Number(BinaryMid ($data, 36 ,1))
				Local $dstport=Number(BinaryMid ($data, 37 ,1))*256+Number(BinaryMid ($data, 38 ,1))
				Local $flags=BinaryMid ($data, 48 ,1)
				Local $f=""
				If BitAND($flags,0x01) Then $f="Fin "
				If BitAND($flags,0x02) Then $f&="Syn "
				If BitAND($flags,0x04) Then $f&="Rst "
				If BitAND($flags,0x08) Then $f&="Psh "
				If BitAND($flags,0x10) Then $f&="Ack "
				If BitAND($flags,0x20) Then $f&="Urg "
				If BitAND($flags,0x40) Then $f&="Ecn "
				If BitAND($flags,0x80) Then $f&="Cwr "
				$f=StringTrimRight(StringReplace($f," ",","),1)		
				return "TCP("&$f&") "&$src&":"&$srcport&" -> "&$dst&":"&$dstport
			Case "0x11"
				Local $srcport=Number(BinaryMid ($data, 35 ,1))*256+Number(BinaryMid ($data, 36 ,1))
				Local $dstport=Number(BinaryMid ($data, 37 ,1))*256+Number(BinaryMid ($data, 38 ,1))
				return "UDP "&$src&":"&$srcport&" -> "&$dst&":"&$dstport
			Case Else
				return "IP "&BinaryMid ($data, 24 ,1)&" "&$src&" -> "&$dst
		EndSwitch
		return BinaryMid ( $data, 13 ,2 )&" "&$src&" -> "&$dst
	EndIf

	If $ethertype="0x8137" OR $ethertype="0x8138" OR $ethertype="0x0022" OR $ethertype="0x0025" OR $ethertype="0x002A" OR $ethertype="0x00E0" OR $ethertype="0x00FF" Then
		return "IPX "&$macsrc&" -> "&$macdst
	EndIf

	return "["&$ethertype&"] "&$macsrc&" -> "&$macdst
EndFunc