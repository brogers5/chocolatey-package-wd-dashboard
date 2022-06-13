if ((Get-OSArchitectureWidth -Compare 64))
{
    $registrySubkey = 'HKLM:\SOFTWARE\WOW6432Node\Western Digital\SSD Dashboard'
}
else
{
    $registrySubkey = 'HKLM:\SOFTWARE\Western Digital\SSD Dashboard'
} 

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

function Set-LanguageConfiguration()
{
    param (
        [Parameter(Mandatory = $true)]
        [string] $Language
    )

    $supportedLanguages = @{
        Čeština = 'cs-CZ'
        Dansk = 'da-DK'
        Deutsch = 'de-DE'
        English = 'en-US'
        Español = 'es-ES'
        Françias = 'fr-FR'
        Italiano = 'it-IT'
        日本語 = 'ja-JP'
        한국어 = 'ko-KR'
        Nederlands = 'nl-NL'
        Polski = 'pl-PL'
        Português = 'pt-PT'
        Pусский = 'ru-RU'
        Svenska = 'sv-SE'
        Türkçe = 'tr-TR'
        简体中文 = 'zh-CN'
        繁體中文 = 'zh-TW'
    }

    if ($supportedLanguages.ContainsKey($Language))
    {
        #Map to underlying locale for backward compatibility with passing UI string selection
        $localeString = $supportedLanguages[$Language]
    }
    elseif ($supportedLanguages.ContainsValue($Language))
    {
        $localeString = $Language
    }
    else
    {
        throw "`"$Language`" is not a supported language configuration!"
    }

    if (!(Test-Path -Path $registrySubkey))
    {
        New-Item -Path $registrySubkey -Force | Out-Null
    }

    New-ItemProperty -Name 'CurrentCulture' -Path $registrySubkey -PropertyType String -Value $localeString -Force | Out-Null
}

function Get-ShouldInstall()
{
    param (
        [Parameter(Mandatory = $true)]
        [string] $version
    )
  
    if (Test-Path -Path $registrySubkey)
    {
        if (((Get-ItemProperty $registrySubkey).PSObject.Properties.Name -contains 'IsInstalled') -and `
            ((Get-CurrentVersion) -eq $version))
        {
            return $false
        }
    }
  
    return $true
}

function Get-CurrentVersion()
{
    if (Test-Path -Path $registrySubkey)
    {
        if ((Get-ItemProperty $registrySubkey).PSObject.Properties.Name -contains 'CurrentVersion')
        {
            return (Get-ItemProperty -Path $registrySubkey -Name 'CurrentVersion').CurrentVersion
        }
    }

    return $null
}

function Uninstall-CurrentVersion()
{
    $packageArgs = @{
        packageName   = $env:ChocolateyPackageName
        softwareName  = 'Dashboard'
        fileType      = 'EXE'
        silentArgs    = '-uninstall'
        validExitCodes= @(0)
    }

    [array] $keys = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

    if ($keys.Count -eq 1)
    {
        #When started from Program Files, the binary shells itself out to TEMP,
        #spawns a new process, then terminates. Kick off the shell operation first.
        $installSource = $keys[0].UninstallString.TrimEnd(' -uninstall')
        Start-ChocolateyProcessAsAdmin -ExeToRun $installSource

        $processName = [System.IO.Path]::GetFileNameWithoutExtension($installSource)

        $tempProcess = Get-Process -Name $processName -ErrorAction SilentlyContinue

        #Grab the temp copy's path, kill it, then restart it from Chocolatey
        $tempProcessInfo = Get-Process -Id $tempProcess.Id -FileVersionInfo
        $filePath = $tempProcessInfo.FileName
        $packageArgs['file'] = $filePath

        Stop-Process -InputObject $tempProcess -Force

        $ahkScriptPath = Join-Path -Path $toolsDir -ChildPath 'uninstall.ahk'
        Start-Process -FilePath 'AutoHotKey.exe' -ArgumentList $ahkScriptPath

        Uninstall-ChocolateyPackage @packageArgs

        #Clean up the temp file copy to prevent disk bloat
        Remove-Item -Path $filePath -Force -ErrorAction SilentlyContinue
    }
    elseif ($keys.Count -eq 0)
    {
        Write-Warning "$packageName has already been uninstalled by other means."
    }
    elseif ($keys.Count -gt 1)
    {
        Write-Warning "$($keys.Count) matches found!"
        Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
        Write-Warning "Please alert package maintainer the following keys were matched:"
        $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
    }
}