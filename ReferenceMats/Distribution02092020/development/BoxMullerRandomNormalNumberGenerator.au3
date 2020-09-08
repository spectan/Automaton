#include <Array.au3>
#include <File.au3>

$Mean = 150
$StandardDeviation = 10.0

Dim $GaussianData[501]

For $i = 1 to (UBound($GaussianData) - 1)
    $GaussianData[$i] = _Random_Gaussian(150,10,2)
Next

_ArrayDisplay($GaussianData)

Func _Random_Gaussian($nMean,$nSD,$iDP)
;******************************************
; Box-Muller polar transform gaussian RND
;******************************************
; $iMean = The mean of the distribution
; $iSD = desired standard deviation
; $iDP = data precision (d.p.)
    Do
        $nX = ((2 * Random()) - 1)
        $nY = ((2 * Random()) - 1)
        $nR = ($nX^2) + ($nY^2)
    Until $nR < 1
    $nGaus = ($nX * (Sqrt((-2 * (Log($nR) / $nR)))))
    Return StringFormat("%." & $iDP & "f",($nGaus * $nSD) + $nMean)
EndFunc