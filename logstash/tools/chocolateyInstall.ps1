$ErrorActionPreference = 'Stop'

$PackageName = 'logstash'
$url32       = 'https://artifacts.elastic.co/downloads/logstash/logstash-5.2.0.zip'
$checksum32  = '875b5dab32a801ad489088fd4da5c2c18bf6292f58e7d17499b83fb9041a6d57'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
