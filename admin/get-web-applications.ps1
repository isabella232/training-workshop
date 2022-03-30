. "$PSScriptRoot\shared-config.ps1"

Write-Verbose "Getting Azure Web Apps for resource group '$azResourceGroupName'"
$webApps = Get-AzWebApp -ResourceGroupName $azResourceGroupName

$displayItems = $webApps | Select-Object -Property Name,DefaultHostName

Write-Host "##octopus[stdout-highlight]"
foreach ($item in $displayItems) {
	Write-Host "$($item.Name) ($($item.DefaultHostName))"
}
Write-Host "##octopus[stdout-default]"