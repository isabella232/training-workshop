[Previous Lesson](part-1-lesson-5.md)

# Part 1 - Lesson 6: Package and Release Versions
- Time: ~15 min

[Presentation Slides](https://docs.google.com/presentation/d/1RE1cpKfioSquK9h-HH6jxqrbRpw4WQff4TxOJTCD2ww/edit#slide=id.g1185db482c1_0_44)

## Objective
- Understand the purpose of multiple application versions
- Understand the relationship of application versions and releases

## Tasks
- Build the sample application again
- Verify the new application package is in the repository
- Create a new release
- Deploy the new release

## Achievement
- Observe multiple packages, releases, and their deployments on the dashboard matrix
- Observe newer versions running on the web sites

# Exercise

## Build the sample application again

- Browse to your `Development` environment web site: [student-app-url-dev]
- Note the `Application version:` number
- Return to the GitHub actions `build application` workflow page: https://github.com/OctopusDeploy/training-workshop/actions/workflows/build-application.yml
- Run the workflow, using your student branch: `student/`

Once the workflow starts (you'll see your name in the entry)
- Click the run item in the list
- Note the number following `Build Application #`
- Wait for the workflow to finish

## Verify the new application package in the repository 

- Navigate to your Octopus Space's package repository using the `Library` menu item or ([go directly there](https://octopus-training.octopus.app/app#//library))
- Click on the `workshop-app` package name
- Observe you now have 2 versions of the application package. The most recent should have the number from your GitHub action build you did.

## Create a new release

- Navigate to [your project overview](https://octopus-training.octopus.app/app#//projects/workshop-application/deployments).
- Click `Create Release`
- Click anywhere on the `Packages` row to expand the section 
- Notice the package version listed under `Latest` for the `workshop-app` entry. This should include your recent application build number.
- Click the `Save` button
- Click `Overview` in the project menu
- Notice the dashboard grid showing the completed deployments of the first release you created and the undeployed second release

## Deploy the new release

- Using what you've learned so far, deploy the new release to `Development`
- Browse to your `Development` environment web site: [student-app-url-dev]
- Verify that it's now running the new `Application version:` (check the number displayed)

Verify the old versions are still running on the other environments:
- Browse to your other environment web sites:
  - `Test`: [student-app-url-test]
  - `Production`: [student-app-url-prod]
- Check the `Application version` numbers on each to see that they are different from what you just deployed to `Development`

# Lesson Completed!
Time for some [practice demos](part-1-student-demos.md)!
