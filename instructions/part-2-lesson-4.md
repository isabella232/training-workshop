[Previous Lesson](part-2-lesson-3.md)

# Part 2 - Lesson 4: Scoped Variables
- Time: ~15 mins

[Presentation Slides](https://docs.google.com/presentation/d/1RE1cpKfioSquK9h-HH6jxqrbRpw4WQff4TxOJTCD2ww/edit#slide=id.g1181244db34_0_195)

## Objective
- Understand how variables can have different results based on specific contexts

## Task
- Add a scoped Project variable
- Create and deploy a new release
- Verify changes to web sites

## Achievement
- Your websites show the environment in which each is running

# Exercise

## Add a scoped Project variable

From [your project overview](https://octopus-training.octopus.app/app#//projects/workshop-application/deployments)
- Click on `Variables`
- Under the `Name` column, in the `Enter new variable` field, enter the following:
```
Project:Workshop:Environment
```
- Under the `Value` column, in the `Enter value` field, enter the following: 
```
Development
```
- Under `Scope`, click `Define scope`
- From the `Select environments` dropdown, select `Development`
- Click on some empty space outside the dropdown
- Click `Add Another Value`
- On the new row, under the `Value` column, in the `Enter value` field, enter the following: 

```
Test
```
- Set the `Scope` to the `Test` Environment
- Repeat `Add Another Value` for
```
Production
```
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
