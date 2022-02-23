# Testing Readme

To run/test locally, you'll need this local file:
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

# Running

## `provision-student.ps1`
Provisioning performs actions on a cloned Git repository and purges the directory so it needs to be run outside of this repo dir.

Run the scripts from a directory called `workspace` that's next to the checkout root of this repo.

Example directory structure:
```
./repo  <== this repository
./workspace  <== working directory
```

```
..\repo\admin\testing\provision-student.ps1 -studentName "name" -studentEmail "email"
```

## `purge-students.ps1`
This will DELETE all students, their workshop spaces, and any Azure resources provisioned for them.

**Use it carefully.**
```
..\repo\admin\testing\purge-students.ps1
```

This uses `deprovision-student.ps1` and `delete-user.ps1`

## `deprovision-student.ps1`
This will delete an individual student's space and any Azure resources provisioned for them.
```
deprovision-student.ps1 -studentSlug "student slug"
```

## `delete-user.ps1`
This deletes a single user from Octopus.
```
delete-user.ps1 -userid {octopus user id}
```
