[CmdletBinding()]
param (
	#	[Parameter(Mandatory=$true)]
	[string] $studentName,
	[string] $studentEmail
)

if ($studentName.Length -eq 0) {
	Write-Host "################################################"
	Write-Host "## No student information supplied, generating random student identity"
	$randoId = [System.Guid]:: NewGuid()
	$studentName = "Z-Student " + $randoId.ToString().SubString(24)
	$studentEmail = "z-student+$($randoId.ToString().SubString(0, 8))@octopus.com"
	Write-Host "## Student Name: $studentName"
	Write-Host "## Student Email: $studentEmail"
	Write-Host "################################################"
}

$studentInfo = [StudentInfo]::new()

$studentInfo.StudentName = $studentName
$studentInfo.StudentEmail = $studentEmail
$studentInfo.StudentId = [System.Guid]::NewGuid()
$studentSuffix = $studentInfo.StudentId.ToString().Substring(0, 8)

$studentNamePrefix = $studentName.Replace(" ", "").Substring(0, [System.Math]::Min(9, $studentName.Length))
$studentSlug = "$studentNamePrefix-$studentSuffix"
$studentInfo.StudentSlug = $studentSlug
$studentInfo.DisplayName = "Student - $studentName"
$studentInfo.GitBranchName = $studentBranch = "student/$studentSlug"
$studentInfo.InstructionsUrl = "https://github.com/OctopusDeploy/training-workshop/blob/$studentBranch/instructions/README.md"

$appEnvs = @("dev", "test", "prod")

foreach ($appEnv in $appEnvs) {
	$appInfo = [StudentAppInfo]::new()
	$appInfo.AppEnvironment = $appEnv
	$appInfo.AppSlug = "$studentSlug-$appEnv"
	$appInfo.AppURL = "{student-app-url-$appEnv}"
	$studentInfo.AzureApps += $appInfo
}

Write-Host "Provisioning student"
Write-Host " - Name: $studentName ($studentEmail)"
Write-Host " - Slug: $studentSlug"

Write-Output $studentInfo