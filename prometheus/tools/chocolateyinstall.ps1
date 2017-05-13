$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus'
$url32       = 'https://github.com/prometheus/prometheus/releases/download/v1.6.2/prometheus-1.6.2.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/prometheus/releases/download/v1.6.2/prometheus-1.6.2.windows-amd64.tar.gz'
$checksum32  = '2693867b59512eee39475102f650af3bcb538ae75ade0d8c03da913bd147f766'
$checksum64  = '8a125bd83aa816404c0be21fd1711c088d455f78fbc55e1a39c34d82e50f9a8b'

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
