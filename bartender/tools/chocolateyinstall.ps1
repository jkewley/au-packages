$ErrorActionPreference = 'Stop'

$PackageName = 'Bartender'
$url32       = ''
$url64       = ''
$checksum32  = ''
$checksum64  = ''

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

#$PackageParameters = Get-PackageParameters # Doesn't seem to be compatible with AU

if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
        $arguments.Add(
            $_.Groups[$option_name].Value.Trim(),
            $_.Groups[$value_name].Value.Trim())
    }
    }
    else
    {
        Throw "Package Parameters were found but were invalid (REGEX Failure)"
    }
}

if ($arguments.ContainsKey("Edition")) { 
    $Edition = "EDITION=$($PackageParameters["Edition"])"
}
if ($arguments.ContainsKey("Remove")) { 
    $Remove = "REMOVE=$($PackageParameters["Remove"])"
}
if ($arguments.ContainsKey("PKC")) { 
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
