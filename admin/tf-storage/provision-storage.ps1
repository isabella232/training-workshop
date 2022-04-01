
. "$PSScriptRoot/../shared-config.ps1"

. "$PSScriptRoot/../testing/load-config.ps1"

#Remove-Item *.tfstate*
if (-not(Test-Path -PathType Container .terraform)) {
	& terraform init
}

# 
& terraform apply -auto-approve `
	-var="az_tenant_id=$azTenantId" -var="az_subscription=$azSubscriptionId" `
	-var="az_app_id=$azUser" -var="az_sp_secret=$azSecret" `
	-var="az_location=$azLocation" -var="az_resource_group_name=$azResourceGroupName" `
