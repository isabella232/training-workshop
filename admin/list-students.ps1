. "$PSScriptRoot\shared-config.ps1"

$files = Get-ChildItem $dataFolder\*.json 
# | `
# 	Select-Object { $_.Name, $_.Name }

foreach ($file in $files) {
	$slug = $file.Name.Replace(".json","")
	Write-Host "$slug | ..\repo\admin\testing\deprovision-student.ps1 -studentSlug $slug | ..\repo\admin\testing\update-existing-git-branch.ps1 -studentSlug $slug"
}