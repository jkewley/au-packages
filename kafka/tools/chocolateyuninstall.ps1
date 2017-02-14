$PackageName="kafka"

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

$ServiceName="kafka-service"
Invoke-StopAndDeleteService -ServiceName $ServiceName

$ServiceName = "kafka-zookeeper-service"
Invoke-StopAndDeleteService -ServiceName $ServiceName
