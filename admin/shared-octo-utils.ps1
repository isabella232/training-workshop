# Helpers for running things in both Octopus and locally

function EnableHighlight(){
	if ($null -ne $OctopusParameters) {
		Write-Host "Setting Octopus output to highlight"
		Write-Host "##octopus[stdout-highlight]"
	}
}

function DisableHighlight(){
	if ($null -ne $OctopusParameters) {
		Write-Host "##octopus[stdout-default]"
		Write-Host "Octopus output resetting to default"
	}
}