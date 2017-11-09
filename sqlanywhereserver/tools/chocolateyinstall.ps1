$ErrorActionPreference = 'Stop'

$PackageName = 'sqlanywhereclient'
$url32       = 'http://d5d4ifzqzkhwt.cloudfront.net/sqla12client/SQLA1201_Client.exe'
$url64       = 'http://d5d4ifzqzkhwt.cloudfront.net/sqla12client/SQLA1201_Client.exe'
$checksum32  = 'b4288b1acb939b30beaa61323666a280a31e8f32d7147a556804425e8106daed'
$checksum64  = 'b4288b1acb939b30beaa61323666a280a31e8f32d7147a556804425e8106daed'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$downloadArgs = @{
    packageName = $packageName
    fileFullPath = "$env:temp\SA12.exe"
    url = $url32
    checksum = $checksum32
    checksumType = "SHA256"
}

$unzipArgs = @{
    fileFullPath = "$env:temp\SA12.exe"
    destination = "$env:temp\SA12\"
}

$packageArgs = @{
    packageName = $packageName
    file = "$env:temp\SA12\setup.exe"
    fileType = 'EXE'
    silentArgs = '/S "/v /qn SA32=1 SA64=1"'
}

Get-ChocolateyWebFile @downloadArgs
Get-ChocolateyUnzip @unzipArgs
Install-ChocolateyInstallPackage @packageArgs
