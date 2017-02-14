$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus'
$url32       = 'https://camunda.org/release/camunda-bpm/tomcat/7.6/camunda-bpm-tomcat-7.6.0.zip'
$url64       = 'https://camunda.org/release/camunda-bpm/tomcat/7.6/camunda-bpm-tomcat-7.6.0.zip'
$checksum32  = '4f08e0c14d29e3bd9dd6dbe1d4f0c369ad2065ad80973f61a774a816476f110b'
$checksum64  = '4f08e0c14d29e3bd9dd6dbe1d4f0c369ad2065ad80973f61a774a816476f110b'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  url64Bit       = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs

$ServiceName = 'prometheus-service'

Write-Host "Installing service"

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "prometheus-$PackageVersion.windows-amd64\prometheus.exe")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
