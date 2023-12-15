# Package Notes

Western Digital does not provide a versioned download URL. This means the installer binary's checksum will periodically change, and a newly released software version will break this package version. Consequently, FOSS users should generally consider older package versions to be obsolete and unsupported. Obsolete package versions may be unlisted if the Chocolatey CDN has not cached the download before obsoletion.

Consider [internalizing this package](https://docs.chocolatey.org/en-us/guides/create/recompile-packages) if you require a stable binary, or the ability to install this specific version after a new version is released.

---

Legacy versions of Western Digital Dashboard's installer (i.e. prior to installer version 5.3.2.2 and application version 3.7.2.5) did not support a silent (un)installation option. Upgrade operations will typically require the currently installed version to be uninstalled first. To ensure compatibility with legacy installations, the package depends on [AutoHotkey](https://community.chocolatey.org/packages/autohotkey.portable) to implement a best-effort workaround of scripting an unattended uninstallation via GUI automation. GUI automation is not 100% reliable, and may occasionally fail or require manual input to complete.

---

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:

```shell
choco feature enable --name="'useRememberedArgumentsForUpgrades'"
```
