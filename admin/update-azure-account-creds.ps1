[CmdletBinding()]
param (
	[switch] $noBlobUpdate
)

. "$PSScriptRoot\shared-octo-utils.ps1"
. "$PSScriptRoot\shared-config.ps1"
. "$PSScriptRoot\shared-types.ps1"

if (!$configLoaded) {
	. $PSScriptRoot\testing\load-config.ps1
}

UseOctoClient

$accountName = "Workshop Azure Account"

if(!$noBlobUpdate){
	UpdateLocalStudentData
}

$studentFiles = Get-ChildItem "$dataFolder\*.json"

Write-Host "Creating Octopus Client..."
$endpoint = New-Object Octopus.Client.OctopusServerEndpoint($octopusURL, $octopusKey)
$repository = New-Object Octopus.Client.OctopusRepository($endpoint)
$client = New-Object Octopus.Client.OctopusClient($endpoint)
$password = New-Object Octopus.Client.Model.SensitiveValue

foreach ($studentFile in $studentFiles) {
	$studentInfo = Get-Content $studentFile | ConvertFrom-Json
	Write-Host "--------------------------------------------------------------------------------"
	Write-Host "Updating student: $($studentInfo.StudentName)"
	Write-Host "Getting space $($studentInfo.SpaceId)..."
	$space = $repository.Spaces.Get($studentInfo.SpaceId);
	$spaceRepo = $client.ForSpace($space);

	Write-Host "Getting account..."
	$account = $spaceRepo.Accounts.FindByName($accountName);
	$password.NewValue = $azSecret;
	$account.Password = $password;

	Write-Host "Updating account..."
	$spaceRepo.Accounts.Modify($account);
}
