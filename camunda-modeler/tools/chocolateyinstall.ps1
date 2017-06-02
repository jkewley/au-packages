$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.8.1/camunda-modeler-1.8.1-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.8.1/camunda-modeler-1.8.1-win32-x64.zip'
$checksum32  = 'd9243baa81511e3a558fa62915288548f32d3c66c1b05f2e9795b0f1e8bf5ac9'
$checksum64  = '389905773c284737c1915135ca1b060ba276702125d468ed9c0448afe25d43b6'

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
