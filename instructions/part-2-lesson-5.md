[Previous Lesson](part-2-lesson-4.md)

# Part 2 - Lesson 5: Library Variable Set
- Time: ~30 mins

[Presentation Slides](https://docs.google.com/presentation/d/1RE1cpKfioSquK9h-HH6jxqrbRpw4WQff4TxOJTCD2ww/edit#slide=id.g1181244db34_0_86)

## Objective
- Understand the concept of shared variables

## Task
- Verify Library Variable Set exists
- Link a Library Variable Set to your project
- Observe the items it contains
- Create and deploy a new release
- Complete tasks on your websites

## Achievement
- You complete an activity presented by your `Production` web site once they’ve finished all lessons

# Exercise

## Verify Library Variable Set exists
- Navigate to your Space's Library area: 
  - Click `Library` tab or 
  - [Go there directly](https://octopus-training.octopus.app/app#/[space-id]/library/builtinrepository)
- Click `Variable Sets`
- Verify a set exists called `Slack Variables`

## Link a Library Variable Set to your project
From [your project overview](https://octopus-training.octopus.app/app#/[space-id]/projects/workshop-application/deployments)
- Click `Variables`, then `Library Sets`
- Click `Include Library Variable Sets` button
- Tick off `Slack Variables`, and click `Save`

## Observe the items it contains
- Click the `Slack Variables` entry to expand it
- Observe it includes the item `Space:Workshop:SlackUrl`

## Create and deploy a new release
Using what you've already learned
- Create a new release and deploy to all environments

## Complete tasks on your websites
- Browse to your web sites:
  - `Development`: [student-app-url-dev]
  - `Test`: [student-app-url-test]
  - `Production`: [student-app-url-prod]

# Lesson Completed!
Time for some more [practice demos](part-2-student-demos.md)!