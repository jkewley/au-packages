$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-modeler'
$url32       = 'https://camunda.org/release/camunda-modeler/1.7.2/camunda-modeler-1.7.2-win32-ia32.zip'
$url64       = 'https://camunda.org/release/camunda-modeler/1.7.2/camunda-modeler-1.7.2-win32-x64.zip'
$checksum32  = '2b93a937556d97c1b8df6da5cf77f014a01dc90eed58bd478e3819f0bba48e67'
$checksum64  = '8f8ae32c5aaa2516f74a8942bd84c2292d7af5fbee0673874b43f41fece600d7'

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
