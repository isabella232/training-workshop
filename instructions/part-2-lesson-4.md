[Previous Lesson](part-2-lesson-3.md)

# Part 2 - Lesson 4: Scoped Variables
- Time: ~30 mins

## Objective
- Understand how variables can have different results based on specific contexts

## Task
- Add a scoped Project variable
- Create and deploy release
- Verify changes to web sites

## Achievement
- Your website shows the environment in which it is running

# Lesson

## Add a scoped Project variable

From [your project overview](https://octopus-training.octopus.app/app#/[space-id]/projects/workshop-application/deployments)
- Click on `Variables`
- Under the `Name` column, `Enter new variable`: `Project:Workshop:Environment`
- Under the `Value` column, `Enter value`: `Development`
- Under `Scope`, click `Define scope`
- From the `Select environments` dropdown, select `Development`
- Click on some empty space outside the dropdown
- Click `Add Another Value`
- On the new row, in the `Value` column, `Enter value`: `Test`
- Set the `Scope` to the `Test` Environment
- Repeat `Add Another Value` for `Production`
- Click `Save` button

## Create and deploy release
Using what you've already learned
- Create a new release and deploy to `Development` and `Test` environments

## Verify changes to web sites

- Browse to your web sites:
  - `Development`: [student-app-url-dev]
  - `Test`: [student-app-url-test]
- Observe that your web sites now display the appropriate environment names

# Lesson Completed!
On to the next lesson: [Library Variable Set](part-2-lesson-5.md)

# Double Bonus Challenge
(Be sure you've done the [Lesson 2 Bonus Challenge](part-2-lesson-2.md#bonus-challenge) first.)

- Make the manual intervention step run on the `Test` environment as well as `Production`.
- Make two different manual intervention instructions appear for `Test` and `Production`. (*Hint: use the variable row's overflow menu (3 dots).*)