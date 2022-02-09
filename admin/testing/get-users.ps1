$baseScriptDir = $PSScriptRoot 

. $baseScriptDir\config.local.ps1 

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey } 

$response = (Invoke-WebRequest "$octopusURL/api/users" -Headers $odHeaders -Method Get -ErrorVariable octoError)

$result = $response.Content | ConvertFrom-Json

Write-Output $result.Items