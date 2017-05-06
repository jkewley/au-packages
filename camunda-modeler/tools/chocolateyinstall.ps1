$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.8.0/camunda-modeler-1.8.0-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.8.0/camunda-modeler-1.8.0-win32-x64.zip'
$checksum32  = '69d70c479b5caec4efebbdd6af526c6f986da82001befb7bac29927fe2d941b3'
$checksum64  = '2f8717a5c25da0a7f9dd2db4cf4dfda8ebd8e20f001eb7e8b050c425b5ac478c'

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
