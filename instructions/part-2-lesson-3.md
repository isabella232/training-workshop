[Previous Lesson](part-2-lesson-2.md)

# Part 2 - Lesson 3: Application Variables
- Time: ~30 mins

[Presentation Slides](https://docs.google.com/presentation/d/1RE1cpKfioSquK9h-HH6jxqrbRpw4WQff4TxOJTCD2ww/edit#slide=id.g1181244db34_0_148)

## Objective
- Understand how variables can affect the application

## Task
- Modify the process to manipulate the application configuration
- Create and deploy a new release
- Verify change to web site

## Achievement
- Your website shows your name

# Exercise

## Modify the process to use the variable

From your project overview: https://octopus-training.octopus.app/app#/[space-id]/projects/workshop-application/deployments
- Click on `Process` under `Deployments`
- Click on the `Deploy an Azure App Service` step
- Locate the `Configuration files` > `Structured Configuration Variables` section, click to expand it
- In `Target files` enter:
```
appsettings.json
```
- Click `Save`

## Create and deploy release
Using what you've already learned
- Create a new release and deploy to `Development`
- After deployment is complete, click on the `Task Log` tab
- Scroll to the bottom and look for `Structured variable replacement succeeded...`
- This serves as confirmation that the configuration file was found and modified

## Verify change to web site
- Browse to your `Development` web site: [student-app-url-dev]
- Observe that your web site now displays your name

# Lesson Completed!
On to the next lesson: [Scoped Variables](part-2-lesson-4.md)