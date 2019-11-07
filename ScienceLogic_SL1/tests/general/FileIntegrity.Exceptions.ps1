# List of forbidden commands
$global:BannedCommands = @(
	'Write-Host',
	'Write-Verbose',
	'Write-Warning',
	'Write-Error',
	'Write-Output',
	'Write-Information',
	'Write-Debug'
)

<#
	Contains list of exceptions for banned cmdlets.
	Insert the file names of files that may contain them.
	
	Example:
	"Write-Host"  = @('Write-PSFHostColor.ps1','Write-PSFMessage.ps1')
#>
$global:MayContainCommand = @{
	"Write-Host"  = @()
	"Write-Verbose" = @('Invoke-SL1Request.ps1', 'Out-WebError.ps1')
	"Write-Warning" = @()
	"Write-Error"  = @('ScienceLogic_SL1.Build.ps1')
	"Write-Output" = @()
	"Write-Information" = @()
	"Write-Debug" = @()
}