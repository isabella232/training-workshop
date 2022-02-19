function Write-HighLight {
	param ([string] $message)
	Write-Host "## octopus highlight: $message"
}

Write-Host "Test present case..."
$OctopusParameters = @{
	"Project:Workshop:StudentName" = "test student"
}
. .\PreDeploy.ps1


Write-Host "Test missing case..."
$OctopusParameters = @{ }
. .\PreDeploy.ps1
