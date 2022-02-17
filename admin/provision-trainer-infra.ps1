[CmdletBinding()]
param (
)

. $PSScriptRoot\testing\load-config.ps1

$popLoc = Get-Location
Set-Location "$PSScriptRoot\tf-azure"

# Remove any existing TF state (should only apply to testing)
Remove-Item *.tfstate*
if (-not(Test-Path -PathType Container .terraform)) {
	& terraform init
}
& terraform apply -auto-approve `
	-var="az_tenant_id=$azTenantId" -var="az_subscription=$azSubscriptionId" `
	-var="az_app_id=$azUser" -var="az_sp_secret=$azSecret" `
	-var="az_location=$azLocation" -var="az_resource_group_name=$azResourceGroupName" `
	-var="az_app_service_plan_name=$azWebAppServicePlan" `
	-var="student_slug=octopus-trainer" `

$tfOutputs = terraform output -json | ConvertFrom-Json
Set-Location $popLoc

foreach ($env in @("dev", "test", "prod")) {
	$url = $tfOutputs."web_site_$env".value.default_site_hostname
	Write-Host "Dev site: $url"
}