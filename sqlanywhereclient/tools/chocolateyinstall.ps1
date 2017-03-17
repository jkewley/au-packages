$ErrorActionPreference = 'Stop'

$PackageName = 'sqlanywhereclient'
$url32       = 'https://github.com/prometheus/prometheus/releases/download/v1.5.2/prometheus-1.5.2.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/prometheus/releases/download/v1.5.2/prometheus-1.5.2.windows-amd64.tar.gz'
$checksum32  = 'cbf4028b62eb0bb36459ec87cf8d793ec417a874124b8c67f8b75911043f3787'
$checksum64  = '8518df8ad210a3d988c5de82b419375021f3fcc76ccb23bd1c130c870af81af2'

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