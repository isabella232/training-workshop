[CmdletBinding()]
param (
	[switch] $skipAzure,
	[switch] $skipUserDelete,

	# Use flag to purge all students. If false, only purges auto generated students.
	[switch] $allStudents
)

. $PSScriptRoot\load-config.ps1 

# this script already filters down to general student workspaces
$spaces = .$PSScriptRoot\get-workshop-spaces.ps1 
if (!$allStudents) {
	# further limit to just the ones with the generated student name
	$spaces = $spaces | Where-Object { $_.Name -like "Student*" }
}
#$spaces | ConvertTo-Json
Write-Host "Generated student spaces to purge: $($spaces.Count)"
foreach ($space in $spaces) {
	Write-Host "Purging resources. Slug: $($space.Name)"
	.$PSScriptRoot\deprovision-student.ps1 -studentSlug $space.Name -skipAzure:$skipAzure -skipOctopus:$skipOctopus
}

if (!$skipUserDelete) {
	$users = .$PSScriptRoot\get-users.ps1
	$users = $users | Where-Object { $_.DisplayName -like "*Student - *" }

	if (!$allStudents) {
		$users = $users | Where-Object { $_.DisplayName -like "* - Student*" }
	}
#	$users | ConvertTo-Json
	
	Write-Host "Users to purge: $($users.Count)"
	foreach ($user in $users) {
		Write-Host "Purging student: $($user.DisplayName)"
		.$PSScriptRoot\delete-user.ps1 -userid $user.id
	}
}