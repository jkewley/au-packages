$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus'
$url32       = 'https://github.com/prometheus/prometheus/releases/download/v1.7.0/prometheus-1.7.0.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/prometheus/releases/download/v1.7.0/prometheus-1.7.0.windows-amd64.tar.gz'
$checksum32  = 'd5cf76b4038e7ee255f296779f3f26423a0ce1212ea3c4e3f98103578f70bcc8'
$checksum64  = '99d390645fc1abbc36aaa7837852e8380fb0bf1559a3b18a92120d80e015e0e3'

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
$File = Get-ChildItem -File -Path $env:ChocolateyInstall\lib\$packageName\tools\ -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $env:ChocolateyInstall\lib\$packageName\tools\

$ServiceName = 'prometheus-service'

Write-Host "Installing service"

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "tools\prometheus-$PackageVersion.windows-amd64\prometheus.exe")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
