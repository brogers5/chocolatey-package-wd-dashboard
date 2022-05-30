
---
### [choco://wd-dashboard](choco://wd--dashboard)
To use choco:// protocol URLs, install [(unofficial) choco:// Protocol support](https://chocolatey.org/packages/choco-protocol-support)

---

The Western Digital Dashboard helps users maintain peak performance of Western Digital drives in Windows® operating systems with a user-friendly graphical interface. The Western Digital Dashboard includes tools for analysis of the disk (including the disk model, capacity, firmware version, and SMART attributes) and firmware updates.

Enhance your gaming station with fully customizable RGB lighting on supported WD_BLACK products, designed to match your style with various colors and thirteen different LED pattern effects to choose from. Or, seamlessly integrate with your existing ASUS Aura Sync on Armoury Crate, GIGABYTE RGB Fusion 2.0, MSI Mystic Light, or Razer Chroma™ RGB ecosystem.

![Dashboard Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-wd-dashboard@1f424def2cab249062aa43fe1a4ae88d54f2507f/Screenshot.png)

## Package Parameters

* `/language:LANGUAGE_STRING` - Overrides the default language configuration.

    Supported languages include:

    |Language String|Language Name|
    |-|-|
    |Čeština|Czech|
    |Dansk|Danish|
    |Deutsch|German|
    |English|English|
    |Español|Spanish|
    |Françias|French|
    |Italiano|Italian|
    |日本語|Japanese|
    |한국어|Korean|
    |Nederlands|Dutch|
    |Polski|Polish|
    |Português|Portuguese|
    |Pусский|Russian|
    |Svenska|Swedish|
    |Türkçe|Turkish|
    |简体中文|Simplified Chinese|
    |繁體中文|Traditional Chinese|

* `/start` - Automatically start Dashboard after the installation completes.

### Examples

```
choco install wd-dashboard --params "/language:Español"
```

```
choco install wd-dashboard --params "/start"
```

```
choco install wd-dashboard --params "/language:Deutsch /start"
```

## Package Notes
Western Digital does not provide a versioned download URL. This means the installer binary's checksum will periodically change, and a newly released software version will break this package version. Consequently, older package versions should generally be considered obsolete and unsupported.

Consider [internalizing this package](https://docs.chocolatey.org/en-us/guides/create/recompile-packages) if you require a stable binary, or the ability to install this specific version after a new version is released.

---

The installer does not support a silent installation option. This package depends on [AutoHotkey](https://community.chocolatey.org/packages/autohotkey) to implement a best-effort workaround of scripting an unattended installation via GUI automation. GUI automation is not 100% reliable, and may occasionally fail to honor package parameters or require manual input to complete.

---

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:
```
choco feature enable -n=useRememberedArgumentsForUpgrades
```
