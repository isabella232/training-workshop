# [CmdletBinding()]
# param (
# 	[Parameter(Mandatory=$true)]
# 	[string] $From,

# 	[Parameter(Mandatory=$true)]
# 	[String] $To,

# 	[Parameter(Mandatory=$true)]
# 	[string] $ApiKey,

# 	[Parameter(Mandatory=$true)]
# 	[string] $instructionsLink
# )

. "$PSScriptRoot/testing/load-config.ps1"

$From = "peter.lanoie@octopus.com"
$To = "planoie@gmail.com"
$ApiKey = $sendGridApiKey

$instructionsLink = "some link"

$Subject = "Octopus hands-on workshop session info"

$bodyFile = "$PSScriptRoot/email-template.txt"

$Body = Get-Content $bodyFile

$Body = $Body.Replace("[instruction-link]", $instructionsLink)
$Body = $Body.Replace("[classroom-link]", $classroomLink)
$Body = $Body.Replace("[classroom-passcode]", $classroomPassword)

$headers = @{}
$headers.Add("Authorization","Bearer $apiKey")
$headers.Add("Content-Type", "application/json")

$jsonRequest = [ordered]@{
	personalizations= @(@{
		to = @(@{email =  "$To"})
		bcc = @(@{email =  "$From"})
		subject = "$SubJect" })
		from = @{email = "$From"}
		content = @( @{ type = "text/plain"
					value = "$Body" }
)} | ConvertTo-Json -Depth 10
Invoke-RestMethod   -Uri "https://api.sendgrid.com/v3/mail/send" -Method Post -Headers $headers -Body $jsonRequest 
