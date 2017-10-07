$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus'
$url32       = 'https://github.com/prometheus/prometheus/releases/download/v1.8.0/prometheus-1.8.0.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/prometheus/releases/download/v1.8.0/prometheus-1.8.0.windows-amd64.tar.gz'
$checksum32  = '32aa3e108224d7212a6f46449fc2ccbd66a5b54d806b570547c202e6080ca89f'
$checksum64  = 'ce2ade048cc2c32d8bc8f2193ec4ef2e339194ceb53e8b303a296f859b3a86c8'

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
