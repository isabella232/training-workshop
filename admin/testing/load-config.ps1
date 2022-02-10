if ( !$configLoaded) {
	Write-Host "Loading local configuration"
	. $PSScriptRoot\config.local.ps1
	$configLoaded = $true
}