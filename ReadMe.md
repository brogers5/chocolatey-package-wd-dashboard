[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

# ⛔️ DEPRECATED

As a result of Western Digital having spun off its flash storage line of business, [development and support for Western Digital Dashboard has been discontinued](https://support-en.wd.com/app/answers/detailweb/a_id/52335) as of January 23rd, 2025.

Its successor is [SanDisk Dashboard (`sandisk-dashboard`)](https://community.chocolatey.org/packages/sandisk-dashboard), a rebranded version of Western Digital Dashboard that supports Western Digital's legacy flash-storage products (including those carrying either SanDisk or WD branding), but with HDD-related features removed.

As the upstream software has been superseded, this Chocolatey package has therefore been deprecated.

If you require an alternative solution for Western Digital Dashboard's HDD-related features, consider installing [Western Digital Kitfox (`wd-kitfox`)](https://community.chocolatey.org/packages/wd-kitfox).

This repository will remain online only for archival purposes.

>[!Warning]
>Western Digital never provided a versioned download URL for Western Digital Dashboard, and its historical download URL at the time of deprecation mirrored the initial release of SanDisk Dashboard. Given that the Community Repository's CDN cache never cached the package's installer, any legacy package versions are unlikely to install successfully.

---

# Chocolatey Package: [Western Digital Dashboard](https://community.chocolatey.org/packages/wd-dashboard)

[![Chocolatey package version](https://img.shields.io/chocolatey/v/wd-dashboard.svg)](https://community.chocolatey.org/packages/wd-dashboard)
[![Chocolatey package download count](https://img.shields.io/chocolatey/dt/wd-dashboard.svg)](https://community.chocolatey.org/packages/wd-dashboard)

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved stable version from the Chocolatey Community Repository:

```shell
choco install wd-dashboard --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-wd-dashboard/releases). The `nupkg` can be installed from the current directory (with dependencies sourced from the Community Repository) as follows:

```shell
choco install wd-dashboard --source="'.;https://community.chocolatey.org/api/v2/'"
```

## Build

[Install Chocolatey](https://chocolatey.org/install), clone this repository, and run the following command in the cloned repository:

```shell
choco pack
```

A successful build will create `wd-dashboard.w.x.y.z.nupkg`, where `w.x.y.z` should be the Nuspec's `version` value at build time.

Note that Chocolatey package builds are non-deterministic. Consequently, an independently built package will fail a checksum validation against officially published packages.

## Update

This package has an update script implemented with the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), but [as of January 23rd 2025, the project is no longer maintained](https://support-en.wd.com/app/answers/detailweb/a_id/52335), so it is not included with my normally scheduled update runs. If the project has a new release, please [open an issue](https://github.com/brogers5/chocolatey-package-wd-dashboard/issues).

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
