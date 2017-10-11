$ErrorActionPreference = 'Stop'

$PackageName = 'kibana'
$url32       = 'https://artifacts.elastic.co/downloads/kibana/kibana-5.6.3-windows-x86.zip'
$checksum32  = '81f8a9375ec3a39507753164d3b97867c3647a4ed4659065b451bec825068066'

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

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "tools\kibana-$PackageVersion-windows-x86\bin\kibana.bat")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
