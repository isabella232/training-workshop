[Previous Lesson](part-2-lesson-1.md)

# Part 2 - Lesson 2: Variables
- Time: ~45 - 60 mins

[Presentation Slides](https://docs.google.com/presentation/d/1RE1cpKfioSquK9h-HH6jxqrbRpw4WQff4TxOJTCD2ww/edit#slide=id.g1181244db34_0_137)

## Objective
- Understand the use of variables

## Task
- Add a Project variable
- Modify a deployment step
- Create a new release
- Deploy the release

## Achievement
- Your name appears in the activity log

# Exercise

## Add a project variable

From [your project overview](https://octopus-training.octopus.app/app#/[space-id]/projects/workshop-application/deployments)
- Click on `Variables`
- Under the `Name` column, `Enter new variable`:  `Project:Workshop:StudentName`
- Under the `Value` column, `Enter value`: your name
- Click `Save` button

## Modify a deployment step

- Go to your [project's Process](https://octopus-training.octopus.app/app#/[space-id]/projects/workshop-application/deployments/process)
- Click on the `Run a Script` step
- Under `Inline Source Code` update the script to the following text (exactly as it appears here):
```
Write-Highlight "Hi, my name is #{Project:Workshop:StudentName}"
```
- Click `Save`

## Create release and deploy
Using what you've already learned
- Create a new release and deploy to `Development`

## Verify new behavior
In the `Task Summary`
- Verify that a message appears with the name you entered

# Lesson Completed!
On to the next lesson: [Application Variables](part-2-lesson-3.md)

# Bonus Challenge
- Change the manual intervention step to use a Project Variable for its message.
(*Hint: use a different instruction message so you know the change worked.*)