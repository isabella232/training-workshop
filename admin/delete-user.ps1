[CmdletBinding()]
param (
	[Parameter(Mandatory = $true)][string]$userId
)

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey }

$response = (Invoke-WebRequest "$octopusURL/api/users/$userId" -Headers $odHeaders -Method Delete -ErrorVariable octoError)

Write-Output $response