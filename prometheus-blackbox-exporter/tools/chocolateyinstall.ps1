$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus-blackbox-exporter'
$url32       = 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.6.0/blackbox_exporter-0.6.0.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.6.0/blackbox_exporter-0.6.0.windows-amd64.tar.gz'
$checksum32  = '9e68fd91ddf0c6891f53f6a0a8fdf70f49c7b8e9d4fb7737a43a92ddd5ff7bbd'
$checksum64  = '8b72ef338f4204d571b924e338f68837a954d6fd47dabb77fbe28fdbfd028e43'

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

$ExporterExe = Get-ChildItem -File -Path $(Join-Path $File.DirectoryName $File.basename) -Filter *.exe
Start-ChocolateyProcessAsAdmin "install $ServiceName $($ExporterExe.FullName)" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
