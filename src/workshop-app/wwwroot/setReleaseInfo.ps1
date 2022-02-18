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

$infoFile = "$PSScriptRoot/release-info.json"

$info | ConvertTo-Json | Out-File -FilePath $infoFile

