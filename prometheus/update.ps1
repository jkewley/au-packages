import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}


function global:au_GetLatest {
    
    $download_page = Invoke-WebRequest -Uri "https://prometheus.io/download/"

    #prometheus-1.5.2.windows-386.tar.gz
    $regex  = "prometheus-1.5.2.windows-.+.tar.gz"
    $urls = $download_page.links | ? href -match $regex | select -expand href

    $version = ($urls -split "-" | select -First 1 -Skip 1) -split "\.windows" | select -First 1
    $url32 = $urls -match "386"
    $url64 = $urls -match "amd64"

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update
