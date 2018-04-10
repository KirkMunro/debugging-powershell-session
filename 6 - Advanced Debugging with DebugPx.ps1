########################################
#
# PSv3+: Advanced Debugging with DebugPx
#
########################################

# Create a test module
New-Module -Name DebugTest {
    Export-ModuleMember

    $hiddenSecretCounter = 0

    function Set-InternalStuff {
        [CmdletBinding()]
        [System.Diagnostics.DebuggerHidden()]
        param(
            [Parameter(Position=0, Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]
            $Value
        )
        $script:hiddenSecretCounter++
        $internalStuff = $Value
    }

    function Invoke-ScriptBlock {
        [CmdletBinding()]
        [System.Diagnostics.DebuggerStepThrough()]
        param(
            [Parameter(Position=0, Mandatory=$true)]
            [ValidateNotNull()]
            [ScriptBlock]
            $ScriptBlock
        )
        Set-InternalStuff 'It is easy to really confuse users of your functions.'
        Set-InternalStuff 'Especially if their breakpoints trip on your internals.'

        & $ScriptBlock

        Set-InternalStuff 'Just say no. Make debugging easier for your users.'
    }
    Export-ModuleMember -Function Invoke-ScriptBlock
} | Import-Module

# Look at the exports
Get-Command -Module DebugTest

# Note that there is no hiddenSecretCounter variable here, but there was one
# in the module, and it was already incremented
Get-Variable -Name hiddenSecretCounter

# Imagine you wanted to peek inside your module and look around in that scope
# to check the state of variables in the module from the debugger
Debug-Module -Name DebugTest

# Does the variable exist in this scope?
$hiddenSecretCounter

# And to confirm we're in the right scope
Get-Variable -Name hiddenSecretCounter -Scope 0

# Now let's detach our debugger
d

# How do you help your end users do easier debugging of *their* code?
# By hiding the internals from the debugger.
Set-PSBreakpoint -Command Set-InternalStuff
Invoke-ScriptBlock {
    'Inside my script block'
}

# How about debugging inside of *your* script block?
Invoke-ScriptBlock {
    'I can debug this'
    breakpoint
}

# Then detach
d

# And remove the test module and cleanup
Remove-Module -Name DebugTest
Remove-Module -Name DebugPx
Get-PSBreakpoint | Remove-PSBreakpoint