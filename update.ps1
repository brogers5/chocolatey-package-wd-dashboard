Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)

function global:au_BeforeUpdate ($Package)  {
    #Archive this version for future development, since Western Digital only keeps the latest version available
    $filePath = ".\DashboardSetupSA_$($Latest.Version).exe"
    Invoke-WebRequest -Uri $Latest.Url32 -OutFile $filePath
    
    #Avoid executing chocolateyInstall.ps1 to accommodate environments with the software installed
    $Latest.ChecksumType32 = 'sha256'
    $Latest.Checksum32 = (Get-FileHash -Path $filePath -Algorithm $Latest.ChecksumType32).Hash.ToLower()
    
    $installScriptPath = Join-Path -Path $currentPath -ChildPath 'tools' | Join-Path -ChildPath 'chocolateyInstall.ps1'
    $installScriptChecksum = (Select-String -Path $installScriptPath -Pattern "(^[$]?\s*checksum\s*=\s*)('(.*)')").Matches.Groups[3].Value
    if ($installScriptChecksum -eq $Latest.Checksum32)
    {
        Remove-Item -Path $filePath -Force
        throw "$($Latest.PackageName) v$($Latest.Version) has been published, but the binary used by the package hasn't been updated yet!"
    }

    Set-DescriptionFromReadme -Package $Package -ReadmePath '.\DESCRIPTION.md'
}

function global:au_AfterUpdate {

}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]softwareVersion\s*=\s*)'.*'"    = "`$1'$($Latest.Version)'"
            "(^[$]?\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^[$]?\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^[$]?\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32.ToLower())'"
        }
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)' = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(\<releaseNotes\>).*?(\</releaseNotes\>)' = "`${1}$($Latest.ReleaseNotes)`$2"
            '(<copyright>)[^<]*(</copyright>)' = "`$1(c) $($(Get-Date -Format yyyy)) Western Digital Corporation`$2"
        }
    }
}

function global:au_GetLatest {
    $uri = 'https://support.wdc.com/downloads.aspx?p=279'
    $userAgent = 'Update checker of Chocolatey Community Package ''wd-dashboard'''

    $page = Invoke-WebRequest -Uri $uri -UseBasicParsing -UserAgent $userAgent
    $url = $page.Links | Where-Object href -Match 'DashboardSetupSA.exe' | Select-Object -First 1 -ExpandProperty href

    $releaseNotes = $page.Links | Where-Object href -Match 'WesternDigitalDashboardReleaseNotes.pdf' | Select-Object -First 1 -ExpandProperty href

    $updateUri = 'https://wddashboarddownloads.wdc.com/wdDashboard/config/lista_updater.xml'
    $xmlDocument = Invoke-RestMethod -Uri $updateUri -UseBasicParsing -UserAgent $userAgent

    $version = $xmlDocument.lista.Application_Installer.version

    return @{
        URL32 = $url
        Version = $version
        ReleaseNotes = $releaseNotes
    }
}

try {
    Update-Package -ChecksumFor None -NoReadme
} catch {
    $ignore = 'the binary used by the package hasn''t been updated yet!'
    if ($_ -match $ignore) { Write-Warning $_ ; 'ignore' }  else { throw $_ }
}
