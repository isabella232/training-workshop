[CmdletBinding()]
param (
	[string] $yamlFile,
	[string] $startBeacon,
	[string] $endBeacon,
	[switch] $quiet
)

$filePath = Resolve-Path -Path $yamlFile
$fileLines = [System.IO.File]::ReadAllLines($filePath)

$checkLine = $false
for ($i = 0; $i -lt $fileLines.Count; $i++) {
	$line = $fileLines[$i]
	if ($line.Contains("<cd-start>")) {
		$checkLine = $true
	}
	if ($line.Contains("<cd-end>")) {
		$checkLine = $false
	}
	if ($checkLine) {
		if (!$line.StartsWith("#")) {
			$fileLines[$i] = $line = "#" + $line
			if (!$quiet) {
				Write-Host "Updated line $($i+1): $line"
			}
		}
	}
}

$fileLines | Out-File -FilePath $yamlFile