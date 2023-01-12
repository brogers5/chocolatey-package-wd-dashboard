
---

### [choco://wd-dashboard](choco://wd--dashboard)

To use choco:// protocol URLs, install [(unofficial) choco:// Protocol support](https://community.chocolatey.org/packages/choco-protocol-support)

---

## Western Digital Dashboard

The Western Digital Dashboard helps users maintain peak performance of Western Digital drives in Windows® operating systems with a user-friendly graphical interface. The Western Digital Dashboard includes tools for analysis of the disk (including the disk model, capacity, firmware version, and SMART attributes) and firmware updates.

Enhance your gaming station with fully customizable RGB lighting on supported WD_BLACK products, designed to match your style with various colors and thirteen different LED pattern effects to choose from. Or, seamlessly integrate with your existing ASUS Aura Sync on Armoury Crate, GIGABYTE RGB Fusion 2.0, MSI Mystic Light, or Razer Chroma™ RGB ecosystem.

![Dashboard Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-wd-dashboard@1f424def2cab249062aa43fe1a4ae88d54f2507f/Screenshot.png)

## Package Parameters

* `/language:UI_STRING_OR_LANGUAGE_TAG` - Overrides the default language configuration.

    Supported languages include:

    |UI String|Language Tag|Language Name|
    |-|-|-|
    |Čeština|cs-CZ|Czech|
    |Dansk|da-DK|Danish|
    |Deutsch|de-DE|German|
    |English|en-US|English|
    |Español|es-ES|Spanish|
    |Françias|fr-FR|French|
    |Italiano|it-IT|Italian|
    |日本語|ja-JP|Japanese|
    |한국어|ko-KR|Korean|
    |Nederlands|nl-NL|Dutch|
    |Polski|pl-PL|Polish|
    |Português|pt-PT|Portuguese|
    |Pусский|ru-RU|Russian|
    |Svenska|sv-SE|Swedish|
    |Türkçe|tr-TR|Turkish|
    |简体中文|zh-CN|Simplified Chinese|
    |繁體中文|zh-TW|Traditional Chinese|

* `/start` - Automatically start Dashboard after the installation completes.

### Examples

```shell
choco install wd-dashboard --params "/language:Español"
```

```shell
choco install wd-dashboard --params "/language:fr-FR"
```

```shell
choco install wd-dashboard --params "/start"
```

```shell
choco install wd-dashboard --params "/language:Deutsch /start"
```

## Package Notes

Western Digital does not provide a versioned download URL. This means the installer binary's checksum will periodically change, and a newly released software version will break this package version. Consequently, older package versions should generally be considered obsolete and unsupported.

Consider [internalizing this package](https://docs.chocolatey.org/en-us/guides/create/recompile-packages) if you require a stable binary, or the ability to install this specific version after a new version is released.

---

Legacy versions of Western Digital Dashboard's installer (i.e. prior to installer version 5.3.2.2 and application version 3.7.2.5) did not support a silent (un)installation option. Upgrade operations will typically require the currently installed version to be uninstalled first. To ensure compatibility with legacy versions, the package depends on [AutoHotkey](https://community.chocolatey.org/packages/autohotkey.portable) to implement a best-effort workaround of scripting an unattended installation via GUI automation. GUI automation is not 100% reliable, and may occasionally fail or require manual input to complete.

---

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:

```shell
choco feature enable -n=useRememberedArgumentsForUpgrades
```
