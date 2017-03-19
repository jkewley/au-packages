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
    $download_page = Invoke-WebRequest -Uri "https://www.seagullscientific.com/support/service-releases-legacy-versions/v100/" -UseBasicParsing

    #SQLA1201_Client.exe
    $regex  = "BT100_2868_Suite.exe"
    $url = $download_page.links | ? href -match $regex | select -expand href

    $version = "10.0.2868"
    $url32 = $url
    $url64 = $url

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update
