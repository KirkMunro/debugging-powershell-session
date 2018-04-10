##################################
#
# PSv5: Editing and debugging jobs
#
##################################

# First let me get a few jobs running
$sandbox = Join-Path -Path $([Environment]::GetFolderPath('Desktop')) -ChildPath 'PowerShell.org/2018/debugging'
$fileOne = Get-Command -Name "${sandbox}/2 - Entering the debugger without breakpoints.ps1"
$fileTwo = Get-Command -Name "${sandbox}/3 - Entering the debugger with Wait-Debugger.ps1"
$jobs = @()
$jobs += Start-Job -ScriptBlock $fileOne.ScriptBlock
$jobs += Start-Job -ScriptBlock $fileTwo.ScriptBlock

# Now let's have a look at the currently running jobs (one of them
# will eventually hit a breakpoint)
$jobs

# Debugging a job is easy with Debug-Job
Debug-Job -Job $jobs[0]

# Notice the (d) detach command in the debugger commands

# From the debugger, use d to detach and let the job continue,
# or q to quit the debugger and stop the job in its tracks

# Notice where the debugger starts when you enter one that internally
# used Wait-Debugger
Debug-Job -Job $jobs[1]

# Detach from the job to let it continue

# Now let's clean up our jobs
$jobs | Stop-Job -PassThru | Remove-Job
Remove-Variable -Name jobs