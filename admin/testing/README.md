# Testing Readme

To test locally, you'll need this local file:
```
config.local.ps1
```

The file needs to contain these URLs and secret keys:
```
$githubUrl = "{Octopus training GitHub repo URL}"
$octopusURL = "{Octopus training Cloud instance URL}"

$githubPAT = ConvertTo-SecureString "{github PAT}" -asplaintext -force
$octopusKey = "API-XXXXXXXXXXXXXXXXXXXXXXXX"
$azSubscriptionId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
$azTenantId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
$azUser = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
$azSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

# Running tests
Provisioning performs actions on a cloned Git repository and purges the directory.

Run the scripts from a directory called `workspace` that's next to the checkout root of this repo.

Example directory structure:
```
./repo  <== this repository
./workspace  <== working directory