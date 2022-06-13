Import-Module au

function global:au_BeforeUpdate ($Package)  {
    #Avoid executing chocolateyInstall.ps1 to accommodate environments with the software installed
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32

    Set-DescriptionFromReadme -Package $Package -ReadmePath ".\DESCRIPTION.md"
}

function global:au_AfterUpdate ($Package) {

}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]softwareVersion\s*=\s*)'.*'"    = "`$1'$($Latest.Version)'"
            "(^[$]?\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^[$]?\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $uri = 'https://support.wdc.com/downloads.aspx?p=279'
    $userAgent = "Update checker of Chocolatey Community Package 'wd-dashboard'"

    $page = Invoke-WebRequest -Uri $uri -UseBasicParsing -UserAgent $userAgent
    $url = $page.Links | Where-Object href -Match "DashboardSetupSA.exe" | Select-Object -First 1 -ExpandProperty href

    $releaseNotes = $page.Links | Where-Object href -Match "WesternDigitalDashboardReleaseNotes.pdf" | Select-Object -First 1 -ExpandProperty href

    $updateUri = 'https://wddashboarddownloads.wdc.com/wdDashboard/config/lista_updater.xml'
    $page = Invoke-WebRequest -Uri $updateUri -UseBasicParsing -UserAgent $userAgent

    $version = ([xml] $page.Content).lista.Application_Installer.version

    return @{
        URL32 = $url
        Version = $version
        ReleaseNotes = $releaseNotes
    }
}

Update-Package -ChecksumFor None -NoReadme
