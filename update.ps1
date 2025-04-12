Import-Module au

function global:au_BeforeUpdate ($Package) {
    $descriptionRelativePath = '.\DESCRIPTION.md'
    Set-DescriptionFromReadme -Package $Package -ReadmePath $descriptionRelativePath
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)' = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<copyright>)[^<]*(</copyright>)'               = "`$1(c) $($(Get-Date -Format yyyy)) Western Digital Corporation`$2"
        }
    }
}

function global:au_GetLatest {
    return @{
        Version = '5.0.2.3'
    }
}

Update-Package -ChecksumFor None -NoReadme -NoCheckUrl
