$ErrorActionPreference = 'Stop'

$PackageName = 'kibana'
$url32       = 'https://artifacts.elastic.co/downloads/kibana/kibana-5.6.1-windows-x86.zip'
$checksum32  = 'a1182d55793cb421771feeb265af1b8f4e7a0cb27ea6d1ff002d41172afe7c64'

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
