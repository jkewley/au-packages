$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.6.0/camunda-modeler-1.6.0-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.6.0/camunda-modeler-1.6.0-win32-x64.zip'
$checksum32  = '1efb2e9e543e8da2938b14dfa5c41b417d62e7fee43f21d1d2bc1a8b706a48ae'
$checksum64  = '5e24830fa1fa8faa041edba254aa9b9705adf5a75ea49b4198750da72009f685'

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
