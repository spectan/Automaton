;Author: Splash
;Web: http://meadiciona.com.br/cemim

;Required:
#include <Process.au3>
#include "Winpcap.au3"

;Description
;Try to find a device with internet connection avaliable.

;Parameters
;None.

;Return Value
;Sucess: Device number.
;Error: False.

Func _FindDevice()
    $device_number = 0
    $connection = False
    $pcap = _PcapSetup()
    $devices = _PcapGetDeviceList()

    While $connection == False and $device_number < Ubound($devices)
        $capture = _PcapStartCapture($devices[$device_number][0], "icmp and dst host google.com", 1, 65536, 524288, 0)
        _RunDos("ping google.com")
        $packet = _PcapGetPacket($capture)

        If IsArray($packet) Then
            If ($packet[2] > 0) Then
                $connection = True
                _PcapStopCapture($capture)
                _PcapFree()
                Return $device_number
            EndIf
        EndIF

        _PcapStopCapture($capture)
        $device_number = $device_number + 1
    WEnd

    Return False
EndFunc

_FindDevice()