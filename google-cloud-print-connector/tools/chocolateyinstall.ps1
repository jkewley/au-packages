$ErrorActionPreference = 'Stop'

$PackageName = 'google-cloud-print-connector'
$url32       = 'https://github.com//google/cloud-print-connector/releases/download/v1.13/windows-connector-1.13.msi'
$checksum32  = '93672ee361db7e6f6baa6b5db6578169ff707b3ce856d476e5662a8629f83fd2'

$packageArgs = @{
  packageName   = $PackageName
  fileType      = 'msi'
  url           = $url32
  silentArgs    = "/qn /i$(if($env:chocolateyPackageParameters){" $env:chocolateyPackageParameters"})"
  checksum      = $checksum32
  checksumType  = 'sha256'
}

Install-ChocolateyPackage @packageArgs
