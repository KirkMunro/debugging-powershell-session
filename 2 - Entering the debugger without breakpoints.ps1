#################################################
#
# PSv5: Entering the debugger without breakpoints
#
#################################################

while ($true)
{
    $processes = Get-Process | Where-Object {![string]::IsNullOrEmpty($_)} | Group-Object -Property name

    $heavyweights = $processes | Where-Object Count -ge 5
    Write-Output $heavyweights.Count

    $middleweights = $processes | Where-Object {$_.Count -ge 2 -and $_.Count -lt 5}
    Write-Output $middleweights.Count

    $featherweights = $processes | Where-Object Count -lt 2
    Write-Output $featherweights.Count

    Start-Sleep -Seconds 2
}

# Use F6 (VS Code) or Ctrl+B (PowerShell ISE) to break into a running script at any time