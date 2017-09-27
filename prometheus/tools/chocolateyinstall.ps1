$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus'
$url32       = 'https://github.com/prometheus/prometheus/releases/download/v1.7.2/prometheus-1.7.2.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/prometheus/releases/download/v1.7.2/prometheus-1.7.2.windows-amd64.tar.gz'
$checksum32  = '753636733d479c47e7ea0f47cdb477fb96a769f84963e95d05adc57bdc0a0377'
$checksum64  = '294a23d9a6d39a60e6043fe26d8a4a0f9e994325af48f5198cd17fb2a68ff702'

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
