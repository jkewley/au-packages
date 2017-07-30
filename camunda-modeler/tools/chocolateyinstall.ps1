$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.9.0/camunda-modeler-1.9.0-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.9.0/camunda-modeler-1.9.0-win32-x64.zip'
$checksum32  = '7558fdec1962aa84189cebb26c31cb7fd01909e9cac114b6ad091b5dd0093714'
$checksum64  = 'e0be3c6747c7e7b888c254df3fa63c0707543b9de44b45eab4768ca88e347db8'

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
