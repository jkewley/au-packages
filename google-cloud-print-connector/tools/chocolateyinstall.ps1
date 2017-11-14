$ErrorActionPreference = 'Stop'

$PackageName = 'google-cloud-print-connector'
$url32       = 'https://github.com//google/cloud-print-connector/releases/download/v1.13/windows-connector-1.13.msi'
$checksum32  = ''

$packageArgs = @{
  packageName   = $PackageName
  fileType      = 'msi'
  url           = $url32
  silentArgs    = "/qr /i$(if($env:chocolateyPackageParameters){" $env:chocolateyPackageParameters"})"
  checksum      = $checksum32
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
