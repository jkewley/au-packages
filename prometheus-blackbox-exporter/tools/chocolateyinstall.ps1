$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus-blackbox-exporter'
$url32       = 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.5.0/blackbox_exporter-0.5.0.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.5.0/blackbox_exporter-0.5.0.windows-amd64.tar.gz'
$checksum32  = 'ffe93f87062ddd3b6085baa6eb7b10f55a389076ecac8dc8b62c9f7f69fb35a4'
$checksum64  = '65bee18b949f0831e32dd1918b7745779037be584b99481028160b4df17f60b3'

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

$ServiceName = 'prometheus-blackbox-exporter'

Write-Host "Installing service"

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}

$ExporterExe = Get-ChildItem -File -Path $(Join-Path $File.DirectoryName $File.BaseName) -Filter *.exe
Start-ChocolateyProcessAsAdmin "install $ServiceName $($ExporterExe.FullName)" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
