if ((Get-OSArchitectureWidth -Compare 64)) {
    $registrySubkey = 'HKLM:\SOFTWARE\WOW6432Node\Western Digital\SSD Dashboard'
}
else {
    $registrySubkey = 'HKLM:\SOFTWARE\Western Digital\SSD Dashboard'
}

function Get-InstallPath {
    return Get-RegistryValue -ValueName 'InstallPath'
}

function Get-RegistryValue($ValueName) {
    if (Test-Path -Path $registrySubkey) {
        if ((Get-ItemProperty $registrySubkey).PSObject.Properties.Name -contains $ValueName) {
            return (Get-ItemProperty -Path $registrySubkey -Name $ValueName).$ValueName
        }
    }
  
    return $null
}

function Set-LanguageConfiguration($Language) {
    $supportedLanguages = @{
        Čeština    = 'cs-CZ'
        Dansk      = 'da-DK'
        Deutsch    = 'de-DE'
        English    = 'en-US'
        Español    = 'es-ES'
        Françias   = 'fr-FR'
        Italiano   = 'it-IT'
        日本語        = 'ja-JP'
        한국어        = 'ko-KR'
        Nederlands = 'nl-NL'
        Polski     = 'pl-PL'
        Português  = 'pt-PT'
        Pусский    = 'ru-RU'
        Svenska    = 'sv-SE'
        Türkçe     = 'tr-TR'
        简体中文       = 'zh-CN'
        繁體中文       = 'zh-TW'
    }

    if ($supportedLanguages.ContainsKey($Language)) {
        #Map to underlying locale for backward compatibility with passing UI string selection
        $localeString = $supportedLanguages[$Language]
    }
    elseif ($supportedLanguages.ContainsValue($Language)) {
        $localeString = $Language
    }
    else {
        throw "`"$Language`" is not a supported language configuration!"
    }

    if (!(Test-Path -Path $registrySubkey)) {
        New-Item -Path $registrySubkey -Force | Out-Null
    }

    New-ItemProperty -Name 'CurrentCulture' -Path $registrySubkey -PropertyType String -Value $localeString -Force | Out-Null
}

function Get-ShouldInstall($Version) {  
    if (Test-Path -Path $registrySubkey) {
        if (((Get-ItemProperty $registrySubkey).PSObject.Properties.Name -contains 'IsInstalled') -and `
            ((Get-CurrentVersion) -eq $version)) {
            return $false
        }
    }
  
    return $true
}

function Get-CurrentVersion {
    return Get-RegistryValue -ValueName 'CurrentVersion'
}

function Uninstall-CurrentVersion {
    $packageArgs = @{
        packageName    = $env:ChocolateyPackageName
        softwareName   = 'Dashboard'
        fileType       = 'EXE'
        silentArgs     = '-uninstall'
        validExitCodes = @(0)
    }

    [array] $keys = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

    if ($keys.Count -eq 1) {
        $sanitizedUninstallString = $keys[0].UninstallString.TrimEnd(' -uninstall')

        #When started from Program Files, the binary shells itself out to TEMP,
        #spawns a new process, then terminates. Kick off the shell operation first.
        Start-ChocolateyProcessAsAdmin -ExeToRun $sanitizedUninstallString -ValidExitCodes (-1, 0)

        $processName = [System.IO.Path]::GetFileNameWithoutExtension($sanitizedUninstallString)

        $tempProcess = Get-Process -Name $processName

        #Grab the temp copy's path, kill it, then restart it from Chocolatey
        $tempProcessInfo = Get-Process -Id $tempProcess.Id -FileVersionInfo
        $filePath = $tempProcessInfo.FileName
        $packageArgs['file'] = $filePath

        Stop-Process -InputObject $tempProcess -Force
        
        $installedVersion = Get-CurrentVersion
        if ([Version] $installedVersion -lt [Version] '3.7.2.4') {
            #Dashboard did not support a silent (un)install for this version.
            #Script an unattended uninstall with AutoHotkey.
            $ahkVersion = (Get-Command -Name 'AutoHotKey.exe' -CommandType Application).Version
            if ($ahkVersion -lt '2.0.0') {
                $ahkScriptPath = Join-Path -Path $toolsDir -ChildPath 'uninstall_v1.ahk'
            }
            else {
                $ahkScriptPath = Join-Path -Path $toolsDir -ChildPath 'uninstall_v2.ahk'
            }

            Start-Process -FilePath 'AutoHotKey.exe' -ArgumentList $ahkScriptPath
        }
        else {
            $packageArgs['silentArgs'] += ' -silent'
        }

        Uninstall-ChocolateyPackage @packageArgs

        #Clean up the temp file copy to prevent disk bloat
        Remove-Item -Path $filePath -Force -ErrorAction SilentlyContinue
    }
    elseif ($keys.Count -eq 0) {
        Write-Warning "$packageName has already been uninstalled by other means."
    }
    elseif ($keys.Count -gt 1) {
        Write-Warning "$($keys.Count) matches found!"
        Write-Warning 'To prevent accidental data loss, no programs will be uninstalled.'
        Write-Warning 'Please alert package maintainer the following keys were matched:'
        $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
    }
}
