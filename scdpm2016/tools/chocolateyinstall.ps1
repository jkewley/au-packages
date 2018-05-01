$ErrorActionPreference = 'Stop';

$packageName = 'SCDPM2016'
$packageVersion = "$Version"

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$setupPackageArgs = @{
  packageName = $packageName
  fileType = "EXE"
  file = "\\tervis.prv\applications\Installers\Microsoft\SCDPM2016\Setup.exe"
  silentArgs = "$PackageParameters"
}

Install-ChocolateyInstallPackage @setupPackageArgs