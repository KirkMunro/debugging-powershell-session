###############################
#
# Debugging basics: hard skills
#
###############################

function C {
    $x = 3
    Write-Host 'About to get the directory name...' -ForegroundColor Cyan
    [System.IO.Path]::GetDirectoryName($null)
    Write-Host 'Why doesn''t this message show up?' -ForegroundColor Cyan
}
function B {
    $x = 2
    C
}
function A {
    try {
        $x = 1
        B
    } catch {
        # In practice, you should almost never do this! Empty
        # catch blocks like this swallow _all_ errors!
    }
}
A

# TIP! After learning visual line breakpoints, experiment with more advanced
# breakpointing features like command and variable breakpoints (visible in
# VS Code, not visible in ISE), and making breakpoints conditional. See
# Get-Help Set-PSBreakpoint -Full for more details about these important
# capabilities.