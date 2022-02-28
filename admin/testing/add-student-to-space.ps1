[CmdletBinding()]
param (
	[Parameter(Mandatory)] [string] $studentName,
	[Parameter(Mandatory=$true)] [string] $studentEmail
#	[Parameter(Mandatory=$true)] [string] $spaceId,
)

. "$PSScriptRoot\load-config.ps1"

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey }

$studentDisplayName = "Student - $studentName"
$studentId = [System.Guid]::NewGuid()

$newUser = @{
	DisplayName = $studentDisplayName
	EmailAddress = $studentEmail
	Username = $studentEmail
	IsService = $false
	IsActive = $true
	Password = $studentId
} | ConvertTo-Json
Write-Host $newUser

$response = (Invoke-WebRequest "$octopusURL/api/users" -Headers $odHeaders -Method Post -Body $newUser -ErrorVariable octoError)
$newUser = $response.Content | ConvertFrom-Json
#$userId = $newUser.Id
Write-Output $response.Content
