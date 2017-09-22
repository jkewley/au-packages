$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus-blackbox-exporter'
$url32       = 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.9.1/blackbox_exporter-0.9.1.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.9.1/blackbox_exporter-0.9.1.windows-amd64.tar.gz'
$checksum32  = '740b4894a1ac8e633789ca4f9055c3ee3139346565df884b10fda48293b327a4'
$checksum64  = '8b2aab266888b0996015e47afab440ed6539dac029d85fb0acc1c9b6593ac326'

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
