###############################
#
# PSv3+: Debugging with DebugPx
#
###############################

$i = 0

while ($true)
{
    $processes = Get-Process | Where-Object {![string]::IsNullOrEmpty($_)} | Group-Object -Property name

    $heavyweights = $processes | Where-Object Count -ge 5
    Write-Output $heavyweights.Count

    breakpoint # This comes from DebugPx

    $middleweights = $processes | Where-Object {$_.Count -ge 2 -and $_.Count -lt 5}
    Write-Output $middleweights.Count

    $featherweights = $processes | Where-Object Count -lt 2
    Write-Output $featherweights.Count

    $i++

    Start-Sleep -Seconds 2
}