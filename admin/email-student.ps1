[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)]
	[String] $to,

	[Parameter(Mandatory=$true)]
	[string] $mailAccount,

	[Parameter(Mandatory=$true)]
	[string] $mailSecret,

	[Parameter(Mandatory=$true)]
	[string] $smtpServer,

	[Parameter(Mandatory=$true)]
	[string] $instructionsLink,

	[Parameter(Mandatory=$false)]
	[string] $from
)

$Subject = "Octopus hands-on workshop session info"

$bodyFile = "$PSScriptRoot/email-template.txt"

$Body = Get-Content $bodyFile

$Body = $Body.Replace("[instruction-link]", $instructionsLink)
$Body = $Body.Replace("[classroom-link]", $classroomLink)
$Body = $Body.Replace("[classroom-passcode]", $classroomPassword)

$mailSecretSecure = ConvertTo-SecureString -String $mailSecret -AsPlainText -Force

$mailCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $mailAccount, $mailSecretSecure

Send-MailMessage `
	-Body "$Body" `
	-BodyAsHtml `
	-From $From `
	-Bcc $From `
	-To $To `
	-Subject $Subject `
	-SmtpServer $smtpServer `
	-UseSsl `
	-Credential $mailCredential `
