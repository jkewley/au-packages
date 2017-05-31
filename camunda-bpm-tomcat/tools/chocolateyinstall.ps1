$ErrorActionPreference = 'Stop'

$PackageName = 'camunda-bpm-tomcat'
$url32       = 'https://camunda.org/release/camunda-bpm/tomcat/7.7/camunda-bpm-tomcat-7.7.0.zip'
$url64       = 'https://camunda.org/release/camunda-bpm/tomcat/7.7/camunda-bpm-tomcat-7.7.0.zip'
$checksum32  = 'd0e39200c05ffc93e070c4973cc9f6eccae02c75da709163d443acc97c18b93b'
$checksum64  = 'd0e39200c05ffc93e070c4973cc9f6eccae02c75da709163d443acc97c18b93b'

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
