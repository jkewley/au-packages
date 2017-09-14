$ErrorActionPreference = 'Stop'

$PackageName = 'kafka'
$url32       = 'http://mirror.jax.hugeserver.com/apache/kafka/0.11.0.1/kafka_2.11-0.11.0.1.tgz'
$checksum32  = '0da77e1e542cf097d6025309bc996c10ceda394839c041934b86d8729ab574f1'

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = Split-Path $MyInvocation.MyCommand.Definition
}
Install-ChocolateyZipPackage @packageArgs
$File = Get-ChildItem -File -Path $env:ChocolateyInstall\lib\$packageName\tools\ -Filter *.tar
Get-ChocolateyUnzip -fileFullPath $File.FullName -destination $env:ChocolateyInstall\lib\$packageName\tools\

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

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "tools\kafka_2.11-$PackageVersion\bin\windows\kafka-server-start.bat") $(Join-Path $env:chocolateyPackageFolder "tools\kafka_2.11-$PackageVersion\config\server.properties")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm

$ServiceName = 'kafka-zookeeper-service'

Invoke-StopAndDeleteService -ServiceName $ServiceName

Write-Host "Installing service"

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "tools\kafka_2.11-$PackageVersion\bin\windows\zookeeper-server-start.bat") $(Join-Path $env:chocolateyPackageFolder "tools\kafka_2.11-$PackageVersion\config\zookeeper.properties")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
