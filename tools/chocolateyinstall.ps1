$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

$softwareName = 'Dashboard'
$softwareVersion = '3.8.2.8'
$shouldInstall = Get-ShouldInstall -Version $softwareVersion

if (!$shouldInstall -and !$env:ChocolateyForce)
{
  Write-Output "$softwareName v$softwareVersion is already installed."
  Write-Output "Skipping download and execution of installer."
}
else
{
  $installedVersion = Get-CurrentVersion
  if ($null -ne $installedVersion)
  {
    Write-Output "Current installed version (v$installedVersion) must be uninstalled first..."
    Uninstall-CurrentVersion
  }

  $pp = Get-PackageParameters
  if ($pp.Language)
  {
    Set-LanguageConfiguration -Language $pp.Language
  }

  $packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileType      = 'EXE'
    url           = 'https://wddashboarddownloads.wdc.com/wdDashboard/DashboardSetupSA.exe'
    softwareName  = $softwareName
    checksum      = 'dce31ab11c3259dbc1febf6d1696f738cfa3c9346fca0415b488be91d374098d'
    checksumType  = 'sha256'
    silentArgs    = '-silent'
    validExitCodes= @(0)
  }

  Install-ChocolateyPackage @packageArgs

  if ($pp.Start)
  {
    $installPath = Get-InstallPath
    if ($null -eq $installPath)
    {
      Write-Warning "Cannot find install path - will not try to start $softwareName"
    }
    else
    {
      try
      {
        $exePath = Join-Path -Path $installPath -ChildPath "$softwareName.exe"
        Start-Process -FilePath $exePath -ErrorAction Continue
      }
      catch
      {
        Write-Warning "$softwareName failed to start, please try to manually start it instead."
      }
    }
  }
}
