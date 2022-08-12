$instructionDocsDir = "./instructions"
$githubActionsFile = "./.github/workflows/build-application.yml"
$dataFolder = "$PSScriptRoot/data"

$automationUserId = "Users-23"
$instructorUserId = "Users-21"

$tfOctopusFolder = Resolve-Path "$PSScriptRoot/tf-octopus"
$tfAzureFolder = Resolve-Path "$PSScriptRoot/tf-azure"

$azResourceGroupName = "training-workshop"
$azWebAppServicePlan = "training-workshop-webapps"
$azLocation = "West US 2"

$azStorageAccount = "trainingworkshopdata"
$azStorageStudentContainer = "students"

$pathToODClient = "C:\Program Files\Octopus Deploy\Tentacle\Octopus.Client.dll"