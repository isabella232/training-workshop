# Part 1 - Lesson 3: Project Setup and First Deployment
- Time: ~45 - 60 min

## Objective
- Understand the basics of deployment process setup
- Complete a deployment
- Observe deploy state in overview

## Tasks
- Create a project
- Add a step to its deployment process
- Create a release
- Deploy release to one environment

## Achievement
- Visit your development web site and see the deployed app running

# Lesson

## Set up project
- From the Octopus menu, click on `Projects`

![](assets/1-3/projects.png)

You can get there directly: https://octopus-training.octopus.app/app#/[space-id]/projects

- Click `Add Project` button
- Enter project name: `Workshop Application`

## Create deployment process

- Click `Define Your Deployment Process` button
- Click `Add Step` button
- Click on the `Azure` box
- Under `Installed Step Templates` click `Deploy an Azure App Service`
- Scroll down to `On Behalf Of`
- From the dropdown, select `workshop-app-service`
- Scroll down to the `Deployment` section
- Under `Package` click in the `Package ID` entry and select `workshop-app` from the list
- Click `Save` button

## Create release

- Click the `Create Release` button
- Click `Save button`

## Deploy the application

- Click the `Deploy to Development...` button
- Click the `Deploy` button
- Click the `Task Log` tab to see the details

Once the deployment has completed running
- Verify there's a big green box with a checkmark at the top
- Navigate to your development web site: [student-app-url-dev]
- Verify that the workshop sample application is running. It should look similar to this:

![](assets/1-3/dev-app-first-run.png)

## Observe Project Overview

- Navigate to the project overview
  - Click `Projects` then `Workshop Application` or
  - [Go directly there](https://octopus-training.octopus.app/app#/[space-id]/projects/workshop-application/deployments)
- Observe the project dashboard showing the release deployed to development

# Lesson Complete

On to the next lesson: [Lifecycle enforcement and progression](part-1-lesson-4.md)

