$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.10.0/camunda-modeler-1.10.0-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.10.0/camunda-modeler-1.10.0-win32-x64.zip'
$checksum32  = 'ef8211fa2bfa8b9fc88dc9d77ff5fd5a24c019358801a562db954a67d604874d'
$checksum64  = '34a189de4613a1153d73fec8c0a0f6f4253720778fff28327afab8dbb2d177af'

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
