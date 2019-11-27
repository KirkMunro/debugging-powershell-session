####################################
#
# PSv3+: More Debugging with DebugPx
#
####################################

function Debug-This {
    [CmdletBinding()]
    param()

    $i = 0

    while ($true)
    {
        $processes = Get-Process | Where-Object {![string]::IsNullOrEmpty($_)} | Group-Object -Property name

        $heavyweights = $processes | Where-Object Count -ge 5
        Write-Output $heavyweights.Count
    
        ifdebug {
            $debugInfo = $heavyweights.Group | Format-List * | Out-String
            $debugInfo -replace '^\s+|\s+$' -split "`n" | Write-Debug
        }

        breakpoint {$i -ge 1}

        $middleweights = $processes | Where-Object {$_.Count -ge 2 -and $_.Count -lt 5}
        Write-Output $middleweights.Count
    
        $featherweights = $processes | Where-Object Count -lt 2
        Write-Output $featherweights.Count
    
        $i++

        Start-Sleep -Seconds 2
    }
}

# The -Debug parameter normally leaves a lot to be desired.
# DebugPx fixes this.
# It also works better in PowerShell 7 and later.
Debug-This -Debug