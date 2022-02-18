[CmdletBinding()]
param (
	[Parameter(Position=0)] [string] $releaseNumber = "unknown release number",
	[Parameter(Position=1)] [string] $releaseLinkSegment = "#app"
)

class ReleaseInfo
{
	[string]$ReleaseNumber
	[string]$ReleaseLinkSegment
}

$info = [ReleaseInfo]::New()

$info.ReleaseNumber = $releaseNumber
$info.ReleaseLinkSegment = $releaseLinkSegment

Write-Host "Provided values:"
Write-Host "  - Release number: $($info.ReleaseNumber)"
Write-Host "  - Link segment: $($info.ReleaseLinkSegment)"

$infoFile = "$PSScriptRoot\release-info.json"

$json = $info | ConvertTo-Json
Write-Host "Release info to write:"
Write-Host "----------------------------------------"
Write-Host $json
Write-Host "----------------------------------------"

Write-Host "Writing release info to '$infoFile'"
$json | Out-File -FilePath $infoFile