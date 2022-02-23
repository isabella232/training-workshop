# Part 1 - Lesson 5: Package and Release Versions
- Time: ~30 min

## Objective
- Understand the purpose of multiple application versions
- Understand the relationship of multiple application versions and releases

## Tasks
- Build the sample application again
- Verify the new application package in the repository
- Create a new release
- Deploy the new release

## Achievement
- Observe multiple packages, releases, and their deployments on the dashboard matrix
- Observe newer versions running on the web sites

# Lesson

## Build the sample application again

- Browse to your `Development` environment web site: [student-app-url-dev]
- Note the `Application version:` number
- Return to the GitHub actions page: https://github.com/OctopusDeploy/training-workshop/actions/workflows/build-application.yml
- Click `Run workflow`
- Select your student branch: `student/[student-slug]`
- Click `Run workflow`

Once the workflow starts (you'll see your name in the entry)
- Click the run item in the list
- Note the number following `Build Application #`

## Verify the new application package in the repository 

- Navigate to your space's package repository using the `Library` menu item or ([go directly there](https://octopus-training.octopus.app/app#/[space-id]/library/builtinrepository))
- Click on the `workshop-app` package name
- Observe you now have 2 versions of the application package. The most recent should have the number from your GitHub action build.

## Create a new release

- Navigate to [your project overview](https://octopus-training.octopus.app/app#/[space-id]/projects/workshop-application/deployments).
- Click `Create Release`
- Click anywhere on the `Packages` row to expand the section 
- Notice the package version listed under `Latest` for the `workshop-app` entry. This should match your recent application build number.
- Click `Save` button
- Click `Overview` in the project menu
- Notice the dashboard grid showing the completed deployments of the first release you created and the undeployed second release

## Deploy the new release

- Using what you've learned so far, deploy the new release to `Development`
- Browse to your `Development` environment web site: [student-app-url-dev]
- Verify that it's now running the new application version (check the number displayed)

Verify the old versions are still running on the other environments:
- Browse to your `Test` environment web site: [student-app-url-test]
- Browse to your `Production` environment web site: [student-app-url-prod]
- Check the `Application version` numbers on each to see that they are different from what you just deployed to `Development`

# Lesson Complete
Time for some practice demos!