[CmdletBinding()]
param (
	[object] $studentInfo,

	[string] $octopusUrl,
	[string] $octopusKey,

	[string] $azTenantId,
	[string] $azUser,
	[string] $azSecret,
	[string] $azSubscriptionId,

	[string] $slackUrl
)

. "$PSScriptRoot\shared-config.ps1"

$description = "Space for workshop student $studentName."

try {
	$popLoc = Get-Location
	Write-Host "Setting location to $tfOctopusFolder"
	Set-Location $tfOctopusFolder
#	Get-Location

	$varSetName = "Slack Variables"
	$varSetDesc = "Variables used for posting to Slack"
	
	# Remove any existing TF state (should only apply to testing)
	Remove-Item *.tfstate*
	if (-not(Test-Path -PathType Container .terraform)) {
		& terraform init -reconfigure | Write-Host
	}

	#	& terraform plan `
	& terraform apply -auto-approve `
		-var="serverURL=$octopusURL" -var="apiKey=$octopusKey" `
		-var="azure_tenant_id=$azTenantId" `
		-var="azure_subscription=$azSubscriptionId" `
		-var="azure_app_id=$azUser" `
		-var="student_display_name=$($studentInfo.DisplayName)" -var="student_email=$($studentInfo.studentEmail)" `
		-var="student_username=$($studentInfo.studentEmail)" -var="student_password=$($studentInfo.StudentId)" `
		-var="space_name=$($studentInfo.StudentSlug)" -var="space_description=$description" `
		-var="automation_userid=$automationUserId" `
		-var="azure_sp_secret=$azSecret" `
		-var="variableSetName=$varSetName" -var="description=$varSetDesc" `
		-var="slack_url=$slackUrl" `
		| Write-Host

	$tfOutputs = terraform output -json | ConvertFrom-Json
	
	$studentInfo.SpaceId = $tfOutputs.student_space.value.id
	$studentInfo.SpaceUrl = "$octopusURL/app#/$($studentInfo.SpaceId)"
	$studentInfo.OctopusUserId = $tfOutputs.new_student_id.value
	
#	Copy-Item "terraform.tfstate" "$dataFolder\$($studentInfo.StudentSlug)-od.tfstate"
}
finally {
	Write-Host "Setting location to $popLoc"
	Set-Location $popLoc
	Write-Output $studentInfo
}


