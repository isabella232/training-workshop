[Previous Lesson](part-2-lesson-1.md)

# Part 2 - Lesson 2: Variables
- Time: ~45 - 60 mins

## Objective
- Understand the use of variables

## Task
- Add a Project variable
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