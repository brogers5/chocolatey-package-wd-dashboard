## Western Digital Dashboard

The Western Digital Dashboard helps users maintain peak performance of Western Digital drives in Windows® operating systems with a user-friendly graphical interface. The Western Digital Dashboard includes tools for analysis of the disk (including the disk model, capacity, firmware version, and SMART attributes) and firmware updates.

Enhance your gaming station with fully customizable RGB lighting on supported WD_BLACK products, designed to match your style with various colors and thirteen different LED pattern effects to choose from. Or, seamlessly integrate with your existing ASUS Aura Sync on Armoury Crate, GIGABYTE RGB Fusion 2.0, MSI Mystic Light, or Razer Chroma™ RGB ecosystem.

![Dashboard Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-wd-dashboard@549dc3ff1dd1bae64a9e5e5bd81d49816f2a46b5/Screenshot.png)

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
choco install wd-dashboard --params="'/language:Español'"
```

```shell
choco install wd-dashboard --params="'/language:fr-FR'"
```

```shell
choco install wd-dashboard --params="'/start'"
```

```shell
choco install wd-dashboard --params="'/language:Deutsch /start'"
```

## [Package Notes](https://github.com/brogers5/chocolatey-package-wd-dashboard/blob/v4.2.2.5/PACKAGE-NOTES.md)
