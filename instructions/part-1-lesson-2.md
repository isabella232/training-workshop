# Part 1 - Lesson 2: Infrastructure and Environments
- Time: ~45 - 60 min

## Objective
- Understand the concept of “infrastructure awareness”
- Understand the purpose of target roles

## Tasks
- Verify your workshop development app is running
- Configure your development environment
- Register the development web site target
- Verify infrastructure configuration

## Achievement
- Environment and Target is configured and visible in the overview

# Lesson

## Verify your workshop development app is running

- Browse to your development web site: [student-app-url-dev]
- Verify that it is running with the default Azure web service application. They might look something like this:
![](assets/1-2/empty-web-site.png)

## Configure your development environment

- In Octopus Deploy, navigate to `Infrastructure` > `Environments`
![](assets/1-2/environments.png)

You can get there directly: https://octopus-training.octopus.app/app#/[space-id]/infrastructure/environments

- Click `Add Environment` button
- In the `Add environment` dialog box, click the `Development` link
- Click `Save`

## Configure your development target
- Click `Add Deployment Target` button
- Click `Azure`
- Click `Add` button over the `Azure Web App` box
- Enter a display name such as `Azure Dev Service`
- Verify the `Environments` section already has `Development` in it.
- Enter the target role: `workshop-app-service`
- Click `"workshop-app-service" (add new role)`
- Under `Account` section, click the dropdown and select `Workshop Azure Account`
- Under `Azure Web App`, click the dropdown and select the item that starts with: `[student-slug]-dev` (this is *your* development environment app service)
- Click `Save` button

## Verify infrastructure configuration

- From the top Octopus menu, click `Infrastructure`
- Verify your Overview contains the following:
  - Environments (1)
    - Development 1
  - Deployment Targets (1)
    - Azure Web App 1
  - Target Status (1)
    - Healthy 1
  - Target Roles (1)
    - `workshop-app-service`

# Lesson Complete
On to the next lesson: [Project Setup and First Deployment](part-1-lesson-3.md)