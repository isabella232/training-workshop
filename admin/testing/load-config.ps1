if ( !$configLoaded) {
	Write-Host "Loading local configuration"
	. $baseScriptDir\config.local.ps1
	$configLoaded = $true
}