$ErrorActionPreference = 'Stop'

$PackageName = 'Bartender'
$url32       = 'http://downloads.seagullscientific.com/BarTender/11.0/BT2016_R4_3127_Full.exe'
$url64       = 'http://downloads.seagullscientific.com/BarTender/11.0/BT2016_R4_3127_Full_x64.exe'
$checksum32  = '9998d4dd9d34fa4de4aacdd3ad6b8a70ca0dc8f2dce2d42ca57c07be3d3dd518'
$checksum64  = '435c74495f45324c4bde6d1eee2573cf246166486ade5a129399be748999c297'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$silentArgs = "/S /v`"/qn $(if ($env:chocolateyPackageParameters) {"$env:chocolateyPackageParameters"}else{"EDITION=B"})`""

Write-Debug "This would be the Chocolatey Silent Arguments: $silentArgs"

$packageArgs = @{
    packageName  = $packageName
    fileType = 'EXE' 
    url = $url32
    Url64bit = $url64
    softwareName = 'bartender*'
    checksum = $checksum32
    checksumType = 'sha256'
    Checksum64 = $checksum64
    ChecksumType64 = 'sha256'
    silentArgs = $silentArgs
}

Install-ChocolateyPackage @packageArgs
