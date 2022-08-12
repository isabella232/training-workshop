[CmdletBinding()]
param (
	[Parameter()]
	[string] $studentSlug = $null
)

. "$PSScriptRoot\shared-octo-utils.ps1"
. "$PSScriptRoot\shared-config.ps1"
. "$PSScriptRoot\shared-types.ps1"

UseOctoClient

if (!$studentSlug) {
	Write-Warning "Please provide a student slug. Here's the current student list."
	. "$PSScriptRoot\list-students.ps1" -ShortForm
	return
}

if (!$configLoaded) {
	. $PSScriptRoot\testing\load-config.ps1
}

$filePath = "$dataFolder\$studentSlug.json"

$studentInfo = Get-Content $filePath | ConvertFrom-Json

$envs = ("test", "prod") #

Write-Host "Creating Octopus Client..."
$endpoint = New-Object Octopus.Client.OctopusServerEndpoint($octopusURL, $octopusKey)
$repository = New-Object Octopus.Client.OctopusRepository($endpoint)
$client = New-Object Octopus.Client.OctopusClient($endpoint)

Write-Host "Getting student space '$($studentInfo.SpaceId)'..."
$space = $repository.Spaces.Get($studentInfo.SpaceId);
$spaceRepo = $client.ForSpace($space);

Write-Host "Getting machines..."
$machines = $spaceRepo.Machines.FindAll()

$devMachine = $machines | Where-Object { $_.Endpoint.WebAppName.Contains("-dev") } | Select-Object -First 1

foreach ($env in $envs) {
	Write-Host "--------------------------------------------------------------------------------"
	Write-Host "Updating machines for environment '$env'..."
	Write-Host "Updating Octopus machine entry..."
	$envMachine = $machines | Where-Object { $_.Endpoint.WebAppName.Contains("-$env") }
	if ($null -ne $envMachine) {
		$envMachine.Endpoint.WebAppName = $devMachine.Endpoint.WebAppName
		$spaceRepo.Machines.Modify($envMachine);
	} else {
		Write-Warning "No existing machine found for '$env'"
	}
	$azureResourceName = "$studentSlug-$env"
	Write-Host "Looking for Azure resource '$azureResourceName'..."
	$azureWebApp = Get-AzWebApp -ResourceGroupName $azResourceGroupName -Name $azureResourceName -ErrorAction SilentlyContinue
	if ($azureWebApp) {
		Write-Host "Removing Azure resource..."
		$azureWebApp | Remove-AzWebApp -Force
	} else {
		Write-Warning "No resource found for '$azureResourceName'"
	}
}
