$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

$softwareName = 'Dashboard'
$softwareVersion = '4.0.2.20'
$shouldInstall = Get-ShouldInstall -Version $softwareVersion

if (!$shouldInstall -and !$env:ChocolateyForce) {
  Write-Output "$softwareName v$softwareVersion is already installed."
  Write-Output 'Skipping download and execution of installer.'
}
else {
  $installedVersion = Get-CurrentVersion
  if ($null -ne $installedVersion) {
    Write-Output "Current installed version (v$installedVersion) must be uninstalled first..."
    Uninstall-CurrentVersion
  }

  $pp = Get-PackageParameters
  if ($pp.Language) {
    Set-LanguageConfiguration -Language $pp.Language
  }

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = 'https://wddashboarddownloads.wdc.com/wdDashboard/DashboardSetupSA.exe'
    softwareName   = $softwareName
    checksum       = '3bab9c85ebc1153717b901705ce7aa4831f60f9a38c6adcb7b6173bdf392d97e'
    checksumType   = 'sha256'
    silentArgs     = '-silent'
    validExitCodes = @(0)
  }

  Install-ChocolateyPackage @packageArgs

  if ($pp.Start) {
    $installPath = Get-InstallPath
    if ($null -eq $installPath) {
      Write-Warning "Cannot find install path - will not try to start $softwareName"
    }
    else {
      try {
        $exePath = Join-Path -Path $installPath -ChildPath "$softwareName.exe"
        Start-Process -FilePath $exePath -ErrorAction Continue
      }
      catch {
        Write-Warning "$softwareName failed to start, please try to manually start it instead."
      }
    }
  }
}
