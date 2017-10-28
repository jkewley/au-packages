$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.11.2/camunda-modeler-1.11.2-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.11.2/camunda-modeler-1.11.2-win32-x64.zip'
$checksum32  = 'f89c2c6981f3ebd7473a7ecfd40d648814016e3e15098ec28aaed7c7635e4d9c'
$checksum64  = 'ac59b5ba6a4e377b633c03b76385049f45175a9316eb3e4a823b97bf5526e9cf'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
