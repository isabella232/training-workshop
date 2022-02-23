[CmdletBinding()]
param (
	[switch] $skipAzure,
	[switch] $skipOctopus
)

. $PSScriptRoot\load-config.ps1 

$users = .$PSScriptRoot\get-users.ps1

$users = $users | Where-Object { $_.DisplayName -like "*Student*" }

$spaces = .$PSScriptRoot\get-workshop-spaces.ps1 
Write-Host "Student spaces to purge: $($spaces.Count)"
foreach ($space in $spaces) {
	Write-Host "Purging resources. Slug: $($space.Name)"
	.$PSScriptRoot\deprovision-student.ps1 -studentSlug $space.Name -skipAzure:$skipAzure -skipOctopus:$skipOctopus
}

if (!$skipOctopus) {
	Write-Host "Users to purge: $($users.Count)"
	foreach ($user in $users) {
		Write-Host "Purging student: $($user.DisplayName)"
		.$PSScriptRoot\delete-user.ps1 -userid $user.id
	}
}