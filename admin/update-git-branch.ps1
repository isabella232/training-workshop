[CmdletBinding()]
param (
	[Object] $studentInfo
)

. "$PSScriptRoot\shared-types.ps1"
. "$PSScriptRoot\shared-config.ps1"

if(!(EnsureInGitWorkspace)){
	exit
}

# update the instructions file with their specific info
$instructionDocFiles = Get-ChildItem -Path $instructionDocsDir -Recurse -File -Filter *.md
foreach ($instructionDocFile in $instructionDocFiles) {
	$fileText = Get-Content $instructionDocFile
	$fileText = $fileText.Replace("[student-slug]", $studentInfo.StudentSlug)
	$fileText = $fileText.Replace("[space-id]", $studentInfo.SpaceId)
	$fileText = $fileText.Replace("[student-name]", $studentInfo.StudentName)

	foreach ($studentAppInfo in $studentInfo.AzureApps) {
		$token = "[student-app-url-$($studentAppInfo.AppEnvironment)]"
		$fileText = $fileText.Replace($token, $studentAppInfo.AppURL)
	}

	Out-File -Force -FilePath $instructionDocFile -InputObject $fileText
	#Get-Content $instructionsDocFile
	& git add $instructionDocFile | Write-Host
}

# update the GitHub actions file with their space
$fileText = Get-Content $githubActionsFile
$fileText = $fileText.Replace("Spaces-1", $studentSpaceId)
Out-File -Force -FilePath $githubActionsFile -InputObject $fileText
# make sure the CICD parts are commented
."$PSScriptRoot\ensure-yaml-comments.ps1" -yamlFile $githubActionsFile -startBeacon "<cd-start>" -endBeacon "<cd-end>"
& git add $githubActionsFile | Write-Host

& git commit -m "Save student specific content for $($studentInfo.StudentName)" | Write-Host
& git push origin $studentInfo.GitBranchName | Write-Host