$baseScriptDir = $PSScriptRoot

. $baseScriptDir\load-config.ps1

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey }

$response = (Invoke-WebRequest "$octopusURL/api/spaces" -Headers $odHeaders -Method Get -ErrorVariable octoError)

$spacesInfo = $response.Content | ConvertFrom-Json

Write-Output $spacesInfo.Items | Where-Object { $_.Description -like "*for workshop student*" }
