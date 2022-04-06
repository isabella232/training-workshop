[CmdletBinding()]
param (
	#	[Parameter(Mandatory=$true)]
	[string] $studentName,
	[string] $studentEmail,

	[string] $githubUrl,
	[string] $githubSecurity,

	[string] $octopusUrl,
	[string] $octopusKey,

	[string] $azTenantId,
	[string] $azUser,
	[string] $azSecret,
	[string] $azSubscriptionId,
	[string] $azLocation,
	[string] $azResourceGroupName,
	[string] $azWebAppServicePlan,

	[string] $slackUrl,
	
	[switch] $skipGit,
	[switch] $skipOctopus,
	[switch] $skipAzure,
	[switch] $skipUser,

	[string] $relativeDepth = "..\.."
)

. "$PSScriptRoot\shared-octo-utils.ps1"
. "$PSScriptRoot\shared-types.ps1"
. "$PSScriptRoot\shared-config.ps1"

if (!$skipGit) {
	if (!(EnsureInGitWorkspace)) {
		exit
	}
} else {
	Write-Warning "Skipping Git operation, skipping run location safety check and workspace dir cleanup."
}

$studentInfo = . "$PSScriptRoot\provision-student-init.ps1"

if (-not $skipOctopus) {

	$studentInfo = . "$PSScriptRoot\provision-student-octopus.ps1" `
		-studentInfo $studentInfo `
		-octopusUrl $octopusUrl -octopusKey $octopusKey `
		-azSubscriptionId $azSubscriptionId -azTenantId $azTenantId `
		-azUser $azUser -azSecret $azSecret `
		-slackUrl $slackUrl `
}
else {
	Write-Warning "Space creation skipped."
}

if (!$skipAzure) {
	$studentInfo = . "$PSScriptRoot\provision-student-azure.ps1" `
		-studentInfo $studentInfo `
		-azTenantId $azTenantId -azUser $azUser -azSecret $azSecret -azSubscriptionId $azSubscriptionId `
} else {
	Write-Warning "Azure resource creation skipped."
}

if (!$skipGit) {
	. "$PSScriptRoot\provision-student-git.ps1" `
		-studentInfo $studentInfo `
		-githubUrl $githubUrl `
		-githubSecurity $githubSecurity `
		-relativeDepth $relativeDepth `
}
else {
	Write-Warning "Git branch creation skipped."
}

Write-Host "Finalizing student provisioning..."
. "$PSScriptRoot\provision-student-finalize.ps1" -studentInfo $studentInfo `
