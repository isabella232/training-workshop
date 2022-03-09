
# Only do something if we're actually running from a deployment
if ($null -ne $OctopusParameters) {
	$studentName = $OctopusParameters["Project:Workshop:StudentName"]
	# Check that the student name var is present
	if ($null -ne $studentName) {
		Write-Highlight "WOOHOO!! Found a student name: $studentName"
	}
	$environmentName = $OctopusParameters["Project:Workshop:Environment"]
	# Check that the environment name var is present
	if ($null -ne $environmentName) {
		Write-Highlight "WOOHOO!! I found the environment name: $environmentName"
	}
	$slackUrl = $OctopusParameters["Space:Workshop:SlackUrl"]
	# Check that the slack var is present
	if ($null -ne $slackUrl) {
		Write-Highlight "WOOHOO!! I found the Slack URL variable: $slackUrl"
	}
} else {
	Write-Warning "You can't run this script outside of Octopus."
}