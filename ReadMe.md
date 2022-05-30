# <img src="https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-wd-dashboard@822fda585aebfa11c51fc1ff3dd6390195f458a5/wd-dashboard.png" width="48" height="48"/> Chocolatey Package: [Western Digital Dashboard](https://community.chocolatey.org/packages/wd-dashboard/)
[![Chocolatey package version](https://img.shields.io/chocolatey/v/wd-dashboard.svg)](https://community.chocolatey.org/packages/wd-dashboard/)
[![Chocolatey package download count](https://img.shields.io/chocolatey/dt/wd-dashboard.svg)](https://community.chocolatey.org/packages/wd-dashboard/)

## Install
[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved version on the Chocolatey Community Repository:
```shell
choco install wd-dashboard
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-wd-dashboard/releases). The `nupkg` can be installed from the current directory as follows:

```shell
choco install wd-dashboard -s .
```

## Build
[Install Chocolatey](https://chocolatey.org/install), clone this repository, and run the following command in the cloned repository:
```shell
choco pack
```

A successful build will create `wd-dashboard.w.x.y.z.nupkg`, where `w.x.y.z` should be the Nuspec's `version` value at build time.

Note that Chocolatey package builds are non-deterministic. Consequently, an independently built package will fail a checksum validation against officially published packages.

## Update
This package should be automatically updated by the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au). If it is outdated by more than a few days, please [open an issue](https://github.com/brogers5/chocolatey-package-wd-dashboard/issues).

AU expects the parent directory that contains this repository to share a name with the Nuspec (`wd-dashboard`). Your local repository should therefore be cloned accordingly:
```shell
git clone git@github.com:brogers5/chocolatey-package-wd-dashboard.git wd-dashboard
```

Alternatively, a junction point can be created that points to the local repository (preferably within a repository adopting the [AU packages template](https://github.com/majkinetor/au-packages-template)):
```shell
mklink /J wd-dashboard ..\chocolatey-package-wd-dashboard
```

Once created, simply run `update.ps1` from within the created directory/junction point. Assuming all goes well, all relevant files should change to reflect the latest version available. This will also build a new package version using the modified files.

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.
