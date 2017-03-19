$ErrorActionPreference = 'Stop'

$PackageName = 'Bartender'
$url32       = 'http://downloads.seagullscientific.com/BarTender/10.0/BT100_2868_Suite.exe'
$url64       = 'http://downloads.seagullscientific.com/BarTender/10.0/BT100_2868_Suite.exe'
$checksum32  = 'af95ffe21c75569805e865aec3d419399a0540dfaf9bacbb507d205782ba9a72'
$checksum64  = 'af95ffe21c75569805e865aec3d419399a0540dfaf9bacbb507d205782ba9a72'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

try {
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
} catch {
    Write-Warning "Error parsing package parameters. Continuing with default (trial) install of Bartender."
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
