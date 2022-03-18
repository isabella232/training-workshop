[CmdletBinding()]
param (
)

. $PSScriptRoot\testing\load-config.ps1

$slug = "octopus-trainer"

$popLoc = Get-Location
Set-Location "$PSScriptRoot\tf-azure"

try {
	# Remove any existing TF state
	Remove-Item *.tfstate*
	if (-not(Test-Path -PathType Container .terraform)) {
		& terraform init
	}

	$stateFile = "$PSScriptRoot/data/_$slug.tfstate"
	if (Test-Path -Path $stateFile) {
		Write-Host "Found existing TF state file, doing teardown first"
		Copy-Item $stateFile ./terraform.tfstate

		& terraform destroy -auto-approve `
			-var="az_tenant_id=$azTenantId" -var="az_subscription=$azSubscriptionId" `
			-var="az_app_id=$azUser" -var="az_sp_secret=$azSecret" `
			-var="az_location=$azLocation" -var="az_resource_group_name=$azResourceGroupName" `
			-var="az_app_service_plan_name=$azWebAppServicePlan" `
			-var="student_slug=$slug" `
	}

	& terraform apply -auto-approve `
		-var="az_tenant_id=$azTenantId" -var="az_subscription=$azSubscriptionId" `
		-var="az_app_id=$azUser" -var="az_sp_secret=$azSecret" `
		-var="az_location=$azLocation" -var="az_resource_group_name=$azResourceGroupName" `
		-var="az_app_service_plan_name=$azWebAppServicePlan" `
		-var="student_slug=$slug" `

	$tfOutputs = terraform output -json | ConvertFrom-Json

	Copy-Item -Path terraform.tfstate -Destination $stateFile

	foreach ($env in @("dev", "test", "prod")) {
		$url = $tfOutputs."web_site_$env".value.default_site_hostname
		Write-Host "$env site: $url"
	}
}
finally {
	Set-Location $popLoc
}