[Previous Lesson](part-2-lesson-2.md)

# Part 2 - Lesson 3: Application Variables
- Time: ~30 mins

## Objective
- Understand how variables can affect the application

## Task
- Add a Project variable
- Modify the process to use the variable
- Create and deploy a new release
- Verify change to web site

## Achievement
- Your website shows your name

# Lesson

## Add a Project variable

From your project overview: https://octopus-training.octopus.app/app#/[space-id]/projects/workshop-application/deployments
- Click on `Variables`
- Under the `Name` column, `Enter new variable`: `Project:Workshop:ConfigFile`
- Under the `Value` column, `Enter value`: `appsettings.json`
- Click the `Save` button

## Modify the process to use the variable

- Click on `Process` under `Deployments`
- Click on the `Deploy an Azure App Service` step
- Locate the `Configuration files` > `Structured Configuration Variables` section, click to expand it
- Next to `Target files` click on `#{}`
- Locate `Project:Workshop:ConfigFile` at the top of the list and select it
- Click `Save`

## Create and deploy release
Using what you've already learned
- Create a new release and deploy to `Development`

## Verify change to web site
- Browse to your `Development` web site: [student-app-url-dev]
- Observe that your web site now displays your name

# Lesson Completed!
On to the next lesson: [Scoped Variables](part-2-lesson-4.md)