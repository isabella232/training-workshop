$baseScriptDir = $PSScriptRoot 

. $baseScriptDir\config.local.ps1 

$users = .$baseScriptDir\get-users.ps1

$users = $users | Where-Object { $_.DisplayName -like "*Student*" }

foreach ($user in $users) {
	Write-Host "Purging student: $($user.DisplayName)"
	.$baseScriptDir\delete-user.ps1 -userid $user.id
}

$spaces = .$baseScriptDir\get-workshop-spaces.ps1 
foreach ($space in $spaces) {
	Write-Host "Purging resources. Slug: $($space.Name)"
	. $baseScriptDir\deprovision-student.ps1 -IstudentSlug $space.Name
}

