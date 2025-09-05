fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android test

```sh
[bundle exec] fastlane android test
```

Runs all the tests

### android deployInternal

```sh
[bundle exec] fastlane android deployInternal
```

Submit a new Internal Testing Beta

### android deployBeta

```sh
[bundle exec] fastlane android deployBeta
```

Submit a new Open Testing Beta

### android deployRelease

```sh
[bundle exec] fastlane android deployRelease
```

Deploy a new version to the Google Play

### android bundle

```sh
[bundle exec] fastlane android bundle
```

build bundle

### android betaApk

```sh
[bundle exec] fastlane android betaApk
```

build apk

### android betaApkToSlack

```sh
[bundle exec] fastlane android betaApkToSlack
```

build apk

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
