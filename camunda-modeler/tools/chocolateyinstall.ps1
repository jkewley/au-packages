$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.8.2/camunda-modeler-1.8.2-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.8.2/camunda-modeler-1.8.2-win32-x64.zip'
$checksum32  = '9c3689385247ea7856f0426c108bac1e5e9ac542f7e0fd9cd06631c4ede041e2'
$checksum64  = '392f7aac4a7b1652175b676a3179c6e0a778885491cf621622cce41fbb3a9f68'

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
