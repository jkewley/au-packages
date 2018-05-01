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
    
    $download_page = Invoke-WebRequest -Uri "https://www.elastic.co/downloads/kibana" -UseBasicParsing

    #kibana-5.1.1-windows-x86.zip
    $regex  = "kibana-.+-windows-x86_64.zip"
    $url = $download_page.links | ? href -match $regex | select -First 1 -expand href

    $version = $url -split '-' | select -First 1 -Skip 1
    $url32 = $url

    $Latest = @{ URL32 = $url32; Version = $version }
    return $Latest
}

update
