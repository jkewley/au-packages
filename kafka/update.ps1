import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}


function global:au_GetLatest {   
    $download_page = Invoke-WebRequest -Uri "https://kafka.apache.org/downloads"

    #kafka_2.11-0.10.1.1.tgz
    $regex  = "kafka_2.11-.+.tgz$"
    $MirrorPageURL = $download_page.links | ? href -match $regex | select -expand href | select -First 1

    $version = $MirrorPageURL -split "/" | select -Last 1 -Skip 1

    $MirrorPage = Invoke-WebRequest -Uri $MirrorPageURL

    $url = $MirrorPage.links | ? href -match $regex | select -expand href | select -First 1
    $url32 = $url

    $Latest = @{ URL32 = $url32; Version = $version }
    return $Latest
}

update
