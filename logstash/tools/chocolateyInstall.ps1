$ErrorActionPreference = 'Stop'

$PackageName = 'logstash'
$url32       = 'https://artifacts.elastic.co/downloads/logstash/logstash-5.1.2.zip'
$checksum32  = '99fd514b6241310c78aefca2cd895c1cec4cd426aa08fccf7e8bba26567573c3'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
