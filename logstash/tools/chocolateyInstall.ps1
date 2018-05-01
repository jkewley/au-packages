$ErrorActionPreference = 'Stop'

$PackageName = 'logstash'
$url32       = 'https://artifacts.elastic.co/downloads/logstash/logstash-6.2.4.zip'
$checksum32  = '2c15d40f23979566b79ad57b86c8a953099c2a36ad34e987d0295ad803ad3c1d'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
