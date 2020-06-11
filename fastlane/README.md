fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios set_build_number
```
fastlane ios set_build_number
```
Set Build Number to GITHUB_RUN_ID
### ios tests
```
fastlane ios tests
```
Run tests
### ios create_ci_keychain
```
fastlane ios create_ci_keychain
```
Create keychain
### ios beta_build
```
fastlane ios beta_build
```
Build app for beta
### ios beta_upload
```
fastlane ios beta_upload
```
Upload app to Firebase Distribution
### ios beta_match
```
fastlane ios beta_match
```
Match Ad-Hoc Provisioning Profiles
### ios release_match
```
fastlane ios release_match
```
Match App Store Provisioning Profiles
### ios release_build
```
fastlane ios release_build
```
Build app for beta
### ios release_upload
```
fastlane ios release_upload
```
Publish app to App Store
### ios release_submit
```
fastlane ios release_submit
```

### ios release_metadata
```
fastlane ios release_metadata
```
Upload metadata to App Store
### ios release_screenshots
```
fastlane ios release_screenshots
```
Upload screenshots to App Store
### ios screenshots
```
fastlane ios screenshots
```
Take screenshots
### ios increment_minor_version
```
fastlane ios increment_minor_version
```
Increment minor version
### ios increment_patch_version
```
fastlane ios increment_patch_version
```
Increment patch version
### ios send_coveralls
```
fastlane ios send_coveralls
```
Upload Coverage data to Coveralls

----

## Mac
### mac develop_match
```
fastlane mac develop_match
```
Match App Store Provisioning Profiles
### mac beta_match
```
fastlane mac beta_match
```
Import code sign certificate from Base64 encoded env vars (for now)
### mac release_match
```
fastlane mac release_match
```
Match App Store Provisioning Profiles
### mac release_build
```
fastlane mac release_build
```
Build app for release
### mac beta_build
```
fastlane mac beta_build
```
Build app for preview
### mac release_upload
```
fastlane mac release_upload
```
Publish app to App Store
### mac beta_upload
```
fastlane mac beta_upload
```
upload app to GitHub releases
### mac release_metadata
```
fastlane mac release_metadata
```
Upload metadata to App Store
### mac release_screenshots
```
fastlane mac release_screenshots
```
Upload screenshots to App Store
### mac release_submit
```
fastlane mac release_submit
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
