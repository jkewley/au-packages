$ErrorActionPreference = 'Stop'

$PackageName = 'kibana'
$url32       = 'https://artifacts.elastic.co/downloads/kibana/kibana-5.1.1-windows-x86.zip'
$checksum32  = '24e640c5b44688f08a5707a9197c3da93aae3be8c85b8d942b71b752bc4b662c'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
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

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "kibana-$PackageVersion-windows\bin\kibana.bat")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
