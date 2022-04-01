# Helpers for running things in both Octopus and locally

$isRunbook = $null -ne $OctopusParameters
function Write-RunbookHeader(){
	if ($isRunbook) {
		Write-Host "##octopus[stdout-highlight]"
	}
}

function Write-RunbookFooter(){
	if ($isRunbook) {
		Write-Host "##octopus[stdout-default]"
	}
}