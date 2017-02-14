$ErrorActionPreference = 'Stop'

$PackageName = 'kafka'
$url32       = 'http://mirrors.advancedhosters.com/apache/kafka/0.10.1.1/kafka_2.11-0.10.1.1.tgz'
$checksum32  = '1540800779429d8f0a08be7b300e4cb6500056961440a01c8dbb281db76f0929'

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
C:\ProgramData\chocolatey\lib\kafka\tools\kafka_2.11-0.10.1.1\bin\windows\kafka-server-start.bat
Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "tools\kafka_2.11-$PackageVersion\bin\windows\kafka-server-start.bat") $(Join-Path $env:chocolateyPackageFolder "tools\kafka_2.11-$PackageVersion\config\server.properties")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm

$ServiceName = 'kafka-zookeeper-service'

Invoke-StopAndDeleteService -ServiceName $ServiceName

Write-Host "Installing service"

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "tools\kafka_2.11-$PackageVersion\bin\windows\zookeeper-server-start.bat") $(Join-Path $env:chocolateyPackageFolder "tools\kafka_2.11-$PackageVersion\config\zookeeper.properties")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
