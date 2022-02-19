
# Only do something if we're actually running from a deployment
if ($null -ne $OctopusParameters) {
	$studentName = $OctopusParameters["Project:Workshop:StudentName"]
	# Check that the student name var is present
	if ($null -ne $studentName) {
		Write-Highlight "Found a student name: $studentName"
	}
} else {
	Write-Warning "You can't run this script outside of a Octopus."
}