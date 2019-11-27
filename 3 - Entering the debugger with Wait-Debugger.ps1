################################################
#
# PSv5: Entering the debugger with Wait-Debugger
#
################################################

$i = 0
while ($true)
{
    $i++

    $processes = Get-Process | Where-Object {![string]::IsNullOrEmpty($_)} | Group-Object -Property name

    $heavyweights = $processes | Where-Object Count -ge 5
    Write-Output $heavyweights.Count

    if ($i -ge 5) {
        Wait-Debugger
    }

    $middleweights = $processes | Where-Object {$_.Count -ge 2 -and $_.Count -lt 5}
    Write-Output $middleweights.Count

    $featherweights = $processes | Where-Object Count -lt 2
    Write-Output $featherweights.Count

    Start-Sleep -Seconds 1
}