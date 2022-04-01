[CmdletBinding()]
param (
	# [Parameter(Mandatory=$true)] [string] $azTenantId,
	# [Parameter(Mandatory=$true)] [string] $azUser,
	# [Parameter(Mandatory=$true)] [string] $azSecret,
	[Parameter(Mandatory=$true)] [string] $azResourceGroupName,
	[Parameter(Mandatory=$true)] [string] $studentSlug
)

# $azSecureSecret = ConvertTo-SecureString -String $azSecret -AsPlainText -Force
# $azCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $azUser, $azSecureSecret

# (Connect-AzAccount -ServicePrincipal -Credential $azCredential -Tenant $azTenantId) | Out-Null

Write-Host "Looking for existing web apps..."
$studentWebApps = (Get-AzWebApp -ResourceGroupName $azResourceGroupName) | Where-Object { $_.Name.Contains($studentSlug) }

Write-Host "Web apps matching student: $($studentWebApps.Length)"
foreach ($webApp in $studentWebApps) {
	Write-Host "Removing student web app: $($webApp.Name)"
	Remove-AzWebApp $webApp -Force
}
