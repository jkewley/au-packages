$ErrorActionPreference = 'Stop'

$PackageName = 'kafka'
$url32       = 'http://mirrors.koehn.com/apache/kafka/1.0.0/kafka_2.11-1.0.0.tgz'
$checksum32  = 'b5b535f8db770cda8513e391917d0f5a35ef24c537ef3d29dcd9aa287da529f5'

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
