Import-Module au

function global:au_BeforeUpdate ($Package)  {
    #Archive this version for future development, since Western Digital only keeps the latest version available
    $filePath = ".\DashboardSetupSA_$($Latest.Version).exe"
    Invoke-WebRequest -Uri $Latest.Url32 -OutFile $filePath
    
    #Avoid executing chocolateyInstall.ps1 to accommodate environments with the software installed
    $Latest.ChecksumType32 = 'sha256'
    $Latest.Checksum32 = (Get-FileHash -Path $filePath -Algorithm $Latest.ChecksumType32).Hash.ToLower()

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
            "(^[$]?\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32.ToLower())'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "<packageSourceUrl>[^<]*</packageSourceUrl>" = "<packageSourceUrl>https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)</packageSourceUrl>"
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
