$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

$softwareName = 'Dashboard'
$softwareVersion = '3.6.2.7'
$shouldInstall = Get-ShouldInstall -Version $softwareVersion

if (!$shouldInstall -and !$env:ChocolateyForce)
{
  Write-Output "$softwareName v$softwareVersion is already installed."
  Write-Output "Skipping download and execution of installer."
}
else
{
  $installedVersion = Get-CurrentVersion
  if ([Version] $installedVersion -ge [Version] $softwareVersion)
  {
    Write-Output "Current installed version (v$installedVersion) is newer or similar, uninstalling it first"
    Uninstall-CurrentVersion
  }

  $pp = Get-PackageParameters

  $ahkArgList = New-Object Collections.Generic.List[string]
  $ahkArgList.Add($(Join-Path -Path $toolsDir -ChildPath 'install.ahk'))
  if ($pp.Language)
  {
    $ahkArgList.Add("/language:$($pp.Language)")
  }
  if ($pp.Start)
  {
    $ahkArgList.Add("/start")
  }
  
  Start-Process -FilePath 'AutoHotKey.exe' -ArgumentList $ahkArgList

  $packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileType      = 'EXE'
    url           = 'https://wddashboarddownloads.wdc.com/wdDashboard/DashboardSetupSA.exe'
    softwareName  = $softwareName
    checksum      = '51609d35e122d2a1bf3c8ac86ac92b84aaf10e0b8804f3a2f750bff81fc21c6e'
    checksumType  = 'sha256'
    silentArgs    = ''
    validExitCodes= @(0)
  }

  Install-ChocolateyPackage @packageArgs
}
