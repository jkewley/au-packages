$ErrorActionPreference = 'Stop'

$PackageName = 'google-cloud-print-connector'
$url32       = 'https://github.com/google/cloud-print-connector/releases/download/v1.16/windows-connector-1.16-i686.msi'
$checksum32  = '8a7dc02416ae290db8e11839480e158f8d89b07c882be18b6cc1f34872444f62'

$packageArgs = @{
  packageName   = $PackageName
  fileType      = 'msi'
  url           = $url32
  silentArgs    = "/qn /i$(if($env:chocolateyPackageParameters){" $env:chocolateyPackageParameters"})"
  checksum      = $checksum32
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
