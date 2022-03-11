[CmdletBinding()]
param (
	[string] $instructionDocsDir,
	[Object] $studentInfo,
	[string] $studentSpaceId,
	[string] $studentName,
	[string] $githubActionsFile
)

# update the instructions file with their specific info
$instructionDocFiles = Get-ChildItem -Path $instructionDocsDir -Recurse -File -Filter *.md
foreach ($instructionDocFile in $instructionDocFiles) {
	$fileText = Get-Content $instructionDocFile
	$fileText = $fileText.Replace("[student-slug]", $studentInfo.StudentSlug)
	$fileText = $fileText.Replace("[space-id]", $studentSpaceId)
	$fileText = $fileText.Replace("[student-name]", $studentName)

	foreach ($studentAppInfo in $studentInfo.AzureApps) {
		$token = "[student-app-url-$($studentAppInfo.AppEnvironment)]"
		$fileText = $fileText.Replace($token, $studentAppInfo.AppURL)
	}

	Out-File -Force -FilePath $instructionDocFile -InputObject $fileText
	#Get-Content $instructionsDocFile
	& git add $instructionDocFile
}

# update the GitHub actions file with their space
$fileText = Get-Content $githubActionsFile
$fileText = $fileText.Replace("Spaces-1", $studentSpaceId)
Out-File -Force -FilePath $githubActionsFile -InputObject $fileText
# make sure the CICD parts are commented
."$PSScriptRoot\ensure-yaml-comments.ps1" -yamlFile $githubActionsFile -startBeacon "<cd-start>" -endBeacon "<cd-end>"
& git add $githubActionsFile

& git commit -m "Save student specific content for $studentName"
& git push origin $studentBranch