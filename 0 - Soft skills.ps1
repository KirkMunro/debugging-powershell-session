###############################
#
# Debugging basics: soft skills
#
###############################

function Reset-Error {
   $global:Error.Clear()
   # TODO: Update how this color gets set when Visual Studio Code supports it via script
   # $psISE.Options.ErrorForegroundColor = '#FFFF0000'
   $global:ErrorView = 'NormalView'
}
Reset-Error

# Generate an error
function Show-Error {Get-Item C:\doesNotExist.txt}
Show-Error

# Make errors easier to read by changing the color
$psISE.Options.ErrorForegroundColor = [System.Windows.Media.Colors]::Chartreuse
Show-Error

# Talk to the bear! (or rubber duck or Xamarin monkey or whatever other stuffed
# animal you keep hidden in your office)

# This is a *proven* technique, and it really, really works.
# Seriously.
# There's a reason why people talk to themselves.

# Priming the pump
function Initialize-Error {
    $Error.Clear()
    (1..20).foreach{
        switch (1..3 | Get-Random) {
            1 {
                Get-Process -Name DoesNotExist
            }
            2 {
                function C {
                    [System.IO.Path]::GetDirectoryName($null)
                }
                function B {
                    C
                }
                function A {
                    try {
                        B
                    } catch {
                    }
                }
                A
            }
            3 {
                $ErrorActionPreference = 'SilentlyContinue'
                Get-Process $pid
            }
        }
    }
}
Initialize-Error *> $null

# All errors are stored in:
$Error

# How to make it less overwhelming (and prioritized and actionable)
$Error `
    | Group-Object `
    | Sort-Object -Property Count -Descending `
    | Format-Table -Property Count,Name -AutoSize

# What about specific error details?
$Error[0] | Format-List *

# Use the Force, Luke!
$Error[0] | fl * -Force

# When the top level information isn't clear, go deep
$Error[0].Exception
$Error[0].Exception | fl * -Force
$Error[0].Exception.InnerException | fl * -Force

# If you don't like having to use -Force all the time,
# community modules like my FormatPx can help

# Leverage the stack traces
$Error[0].ScriptStackTrace # For locations in PowerShell functions/scripts
$Error[0].Exception.StackTrace # For locations in compiled cmdlets/dlls

# Clean up behind yourself as you deal with errors
$Error.Remove($Error[0]) # Remove a specific error
$Error.RemoveAt(0) # Remove by index
$Error.RemoveRange(0,10) # Remove by index + count
$Error.Clear() # Clear the $Error collection

# An important note about error handling: use try/catch to ensure terminating
# errors actually terminate.
1/0; Write-Host 'Will this run?' -ForegroundColor Cyan
function Test-Something {
    [cmdletbinding()]
    param()
    $callerErrorActionPreference = $ErrorActionPreference
    try {
        1/0; Write-Host 'Will this run?' -ForegroundColor Cyan
    } catch {
        Write-Error -ErrorRecord $_ -ErrorAction $callerErrorActionPreference
    }
}
function Test-Something2 {
    [cmdletbinding()]
    param()
    try {
        1/0; Write-Host 'Will this run?' -ForegroundColor Cyan
    } catch {
        throw
    }
}
# Compare Test-Something (clean error identifying the source line where it happened in the calling script)
Test-Something
# to Test-Something2 (error showing internals that doesn't identify the source line at all)
Test-Something2
# Now compare ErrorAction control over the Test-Something function
Test-Something -ErrorAction SilentlyContinue; Write-Host 'This should appear' -ForegroundColor Green
Test-Something -ErrorAction Stop; Write-Host 'This should not appear' -ForegroundColor Cyan
# to the same control over Test-Something2
Test-Something2 -ErrorAction SilentlyContinue; Write-Host 'This should appear' -ForegroundColor Green
Test-Something2 -ErrorAction Stop; Write-Host 'This should not appear' -ForegroundColor Cyan
