﻿$ErrorActionPreference = 'Stop'

# command line call: `choco install kibana --params "'/UnzipTo:value'"`
$pp = Get-PackageParameters

$PackageName = 'kibana'
$url32       = 'https://artifacts.elastic.co/downloads/kibana/kibana-6.2.4-windows-x86_64.zip'
$checksum32  = 'd9fe5dcb8d4d931317d25c16ccaf2e8dbc6464eb1dd22d081c33822d2993dab4'
if (!$pp['UnzipTo']) { $pp['UnzipTo'] = Split-Path $MyInvocation.MyCommand.Definition }

#create specified directory
if (!(Test-Path $pp['UnzipTo']))
{
  #create dir as admin
  $psCreate = "New-Item -Path $pp['UnzipTo'] -ItemType Directory"
  Start-ChocolateyProcessAsAdmin "& `'$psCreate`'"
}

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = $pp['UnzipTo']
}
Install-ChocolateyZipPackage @packageArgs

$ServiceName = 'kibana-service'

Write-Host "Installing service"

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:ChocolateyPackageInstallLocation "tools\kibana-$PackageVersion-windows-x86\bin\kibana.bat")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
