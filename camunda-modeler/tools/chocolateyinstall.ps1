$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.7.1/camunda-modeler-1.7.1-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.7.1/camunda-modeler-1.7.1-win32-x64.zip'
$checksum32  = '26dc0acca44bc735818b044b6a7c9a4a68681b76b9bd7ae9aecc77f8b7adf12d'
$checksum64  = 'efb94faa597844f11eeaa07689fa4126c716a6bb597df83673222179127e8eb1'

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
