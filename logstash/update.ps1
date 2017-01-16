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
    
    $download_page = Invoke-WebRequest -Uri "https://www.elastic.co/downloads/logstash"

    #logstash-5.1.2.zip
    $regex  = "logstash-.+.zip"
    $url = $download_page.links | ? href -match $regex | select -First 1 -expand href

    $version = ($url -split "-" | select -Last 1) -split ".zip" | select -First 1
    $url32 = $url

    $Latest = @{ URL32 = $url32; Version = $version }
    return $Latest
}

update
