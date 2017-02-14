$ErrorActionPreference = 'Stop'

$PackageName = 'kibana'
$url32       = 'https://artifacts.elastic.co/downloads/kibana/kibana-5.2.1-windows-x86.zip'
$checksum32  = '8753db954a89a7a5c19a2c93886b523d1f8054bd31ce24c772bd873555a949d8'

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
