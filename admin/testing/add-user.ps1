[CmdletBinding()]
param (
	[Parameter(Mandatory)] [string] $userName,
	[Parameter(Mandatory=$true)] [string] $userEmail
)

. "$PSScriptRoot\load-config.ps1"

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey }

#$studentDisplayName = "Student - $studentName"
$randomId = [System.Guid]::NewGuid()

$newUser = @{
	DisplayName = $userName
	EmailAddress = $userEmail
	Username = $userEmail
	IsService = $false
	IsActive = $true
	Password = $randomId
} | ConvertTo-Json
Write-Host $newUser

$response = (Invoke-WebRequest "$octopusURL/api/users" -Headers $odHeaders -Method Post -Body $newUser -ErrorVariable octoError)
$newUser = $response.Content | ConvertFrom-Json
#$userId = $newUser.Id
Write-Output $response.Content
