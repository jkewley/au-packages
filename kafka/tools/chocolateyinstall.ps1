$ErrorActionPreference = 'Stop'

$PackageName = 'kafka'
$url32       = 'https://github.com/prometheus/prometheus/releases/download/v1.5.2/prometheus-1.5.2.windows-386.tar.gz'
$checksum32  = 'cbf4028b62eb0bb36459ec87cf8d793ec417a874124b8c67f8b75911043f3787'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs

function Invoke-StopAndDeleteService {
    param (
        $ServiceName
    )
    if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
        if ($Service.Status -eq "Running") {
            Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
        }
        Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
    }
}

$ServiceName = 'kafka-service'

Invoke-StopAndDeleteService -ServiceName $ServiceName

Write-Host "Installing service"

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "kafka_2.11-$PackageVersion\bin\windows\kafka-server-start.bat") $(Join-Path $env:chocolateyPackageFolder "kafka_2.11-$PackageVersion\config\server.properties")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm

$ServiceName = 'kafka-zookeeper-service'

Invoke-StopAndDeleteService -ServiceName $ServiceName

Write-Host "Installing service"

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "kafka_2.11-$PackageVersion\bin\windows\zookeeper-server-start.bat") $(Join-Path $env:chocolateyPackageFolder "kafka_2.11-$PackageVersion\config\zookeeper.properties")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
