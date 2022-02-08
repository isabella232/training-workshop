[CmdletBinding()]
param (
	[string] $octopusUrl,
	[string] $octopusKey,
	[string] $azSubscription,
	[string] $azTenantId,
	[string] $azClientId,
	[string] $azSecret,
	[string] $spaceId
)

$ErrorActionPreference = "Stop";

# Define working variables
$header = @{ "X-Octopus-ApiKey" = $octopusKey }

# Octopus Account details
$accountName = "Workshop Azure Account"
$accountDescription = "Workshop Azure Account"
$accountTenantParticipation = "Untenanted"
$accountTenantTags = @()
$accountTenantIds = @()
$accountEnvironmentIds = @()

# Create JSON payload
$jsonPayload = @{
    AccountType = "AzureServicePrincipal"
    AzureEnvironment = ""
    SubscriptionNumber = $azSubscription
    Password = @{
        HasValue = $true
        NewValue = $azSecret
    }
    TenantId = $azTenantId
    ClientId = $azClientId
    ActiveDirectoryEndpointBaseUri = ""
    ResourceManagementEndpointBaseUri = ""
    Name = $accountName
    Description = $accountDescription
    TenantedDeploymentParticipation = $accountTenantParticipation
    TenantTags = $accountTenantTags
    TenantIds = $accountTenantIds
    EnvironmentIds = $accountEnvironmentIds
} | ConvertTo-Json -Depth 10

# Add Azure account
Invoke-RestMethod -Method Post -Uri "$octopusUrl/api/$spaceId/accounts" -Body $jsonPayload -Headers $header

