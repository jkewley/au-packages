$ErrorActionPreference = 'Stop'

$PackageName = 'Bartender'
$url32       = 'https://github.com/prometheus/prometheus/releases/download/v1.5.2/prometheus-1.5.2.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/prometheus/releases/download/v1.5.2/prometheus-1.5.2.windows-amd64.tar.gz'
$checksum32  = 'cbf4028b62eb0bb36459ec87cf8d793ec417a874124b8c67f8b75911043f3787'
$checksum64  = '8518df8ad210a3d988c5de82b419375021f3fcc76ccb23bd1c130c870af81af2'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$PackageParameters = Get-PackageParameters

if ($PackageParameters["Edition"]) { 
    $Edition = "EDITION=$($PackageParameters["Edition"])"
}
if ($PackageParameters["Remove"]) { 
    $Remove = "REMOVE=$($PackageParameters["Remove"])"
}
if ($PackageParameters["PKC"]) { 
    $PKC = "PKC=$($PackageParameters["PKC"])"
}

$silentArgs = "/S /v`"/qn $Edition $Remove $PKC`""

Write-Debug "This would be the Chocolatey Silent Arguments: $silentArgs"

$packageArgs = @{
    packageName  = $packageName
    fileType = 'EXE' 
    url = $url32
    softwareName = 'bartender*'
    checksum = $checksum32
    checksumType = 'sha256'
    silentArgs = $silentArgs
}

Install-ChocolateyPackage @packageArgs
