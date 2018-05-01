$ErrorActionPreference = 'Stop'

$PackageName = 'prometheus'
$url32       = 'https://github.com/prometheus/prometheus/releases/download/v2.2.1/prometheus-2.2.1.windows-386.tar.gz'
$url64       = 'https://github.com/prometheus/prometheus/releases/download/v2.2.1/prometheus-2.2.1.windows-amd64.tar.gz'
$checksum32  = '4cc3e6d176cd41d6d28b0c47b146157972cca2485e41861f0a10630a68330737'
$checksum64  = '03cf9f24a160944333e4db4358182b9e2d713872d27f126f7493e574493ae2c2'

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
