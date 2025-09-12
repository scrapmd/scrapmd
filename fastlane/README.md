fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios set_build_number

```sh
[bundle exec] fastlane ios set_build_number
```

Set Build Number to GITHUB_RUN_ID

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Run tests

### ios create_ci_keychain

```sh
[bundle exec] fastlane ios create_ci_keychain
```

Create keychain

### ios beta_build

```sh
[bundle exec] fastlane ios beta_build
```

Build app for beta

### ios beta_match

```sh
[bundle exec] fastlane ios beta_match
```

Match Ad-Hoc Provisioning Profiles

### ios release_match

```sh
[bundle exec] fastlane ios release_match
```

Match App Store Provisioning Profiles

### ios release_build

```sh
[bundle exec] fastlane ios release_build
```

Build app for beta

### ios release_upload

```sh
[bundle exec] fastlane ios release_upload
```

Publish app to App Store

### ios release_slack

```sh
[bundle exec] fastlane ios release_slack
```

Notify to Slack

### ios release_submit

```sh
[bundle exec] fastlane ios release_submit
```



### ios release_metadata

```sh
[bundle exec] fastlane ios release_metadata
```

Upload metadata to App Store

### ios release_screenshots

```sh
[bundle exec] fastlane ios release_screenshots
```

Upload screenshots to App Store

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Take screenshots

### ios increment_minor_version

```sh
[bundle exec] fastlane ios increment_minor_version
```

Increment minor version

### ios increment_patch_version

```sh
[bundle exec] fastlane ios increment_patch_version
```

Increment patch version

### ios send_coveralls

```sh
[bundle exec] fastlane ios send_coveralls
```

Upload Coverage data to Coveralls

----


## Mac

### mac develop_match

```sh
[bundle exec] fastlane mac develop_match
```

Match App Store Provisioning Profiles

### mac beta_match

```sh
[bundle exec] fastlane mac beta_match
```

Import code sign certificate from Base64 encoded env vars (for now)

### mac release_match

```sh
[bundle exec] fastlane mac release_match
```

Match App Store Provisioning Profiles

### mac release_build

```sh
[bundle exec] fastlane mac release_build
```

Build app for release

### mac beta_build

```sh
[bundle exec] fastlane mac beta_build
```

Build app for preview

### mac release_upload

```sh
[bundle exec] fastlane mac release_upload
```

Publish app to App Store

### mac beta_upload

```sh
[bundle exec] fastlane mac beta_upload
```

upload app to GitHub releases

### mac release_metadata

```sh
[bundle exec] fastlane mac release_metadata
```

Upload metadata to App Store

### mac release_screenshots

```sh
[bundle exec] fastlane mac release_screenshots
```

Upload screenshots to App Store

### mac release_submit

```sh
[bundle exec] fastlane mac release_submit
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
