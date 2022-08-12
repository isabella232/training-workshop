[CmdletBinding()]
param (
	[Parameter(Mandatory = $true)]
	[object] $studentInfo,

	[string] $azTenantId,
	[string] $azUser,
	[string] $azSecret,
	[string] $azSubscriptionId
)

. "$PSScriptRoot\shared-config.ps1"

try {
	$popLoc = Get-Location
	Write-Host "Setting location to $tfAzureFolder"
	Set-Location $tfAzureFolder

	# Remove any existing TF state (should only apply to testing)
	Remove-Item *.tfstate*
	if (-not(Test-Path -PathType Container .terraform)) {
		& terraform init -reconfigure | Write-Host
	}
	# & terraform plan `
	& terraform apply -auto-approve `
		-var="az_tenant_id=$azTenantId" -var="az_subscription=$azSubscriptionId" `
		-var="az_app_id=$azUser" -var="az_sp_secret=$azSecret" `
		-var="az_location=$azLocation" -var="az_resource_group_name=$azResourceGroupName" `
		-var="az_app_service_plan_name=$azWebAppServicePlan" `
		-var="student_slug=$($studentInfo.StudentSlug)" `
		| Write-Host

	$tfOutputs = terraform output -json | ConvertFrom-Json

	foreach ($studentAppInfo in $studentInfo.AzureApps) {
		$resourceData = $tfOutputs."web_site_$($studentAppInfo.AppEnvironment)".value
		$studentAppInfo.AppURL = "https://" + $resourceData.default_site_hostname
		$studentAppInfo.ResourceId = $resourceData.id
	}
}
finally {
	Set-Location $popLoc
	Write-Output $studentInfo
}