$ErrorActionPreference = 'Stop'

$PackageName = 'logstash'
$url32       = 'https://artifacts.elastic.co/downloads/logstash/logstash-5.2.1.zip'
$checksum32  = '14093855a8a3a4f27a2b4e461ee70697fff527eece70d5d58f1015cf5103f77e'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
