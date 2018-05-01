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
    
    $DownloadPage = Invoke-WebRequest -Uri "https://github.com/google/cloud-print-connector/releases"

    #windows-connector-1.13.msi
    $regex  = "windows-connector-.+.msi"
    $url = $DownloadPage.links | ? href -match $regex | select -First 1 -expand href

    $Version = $url -split "-" | select -Last 1 -Skip 1
    $url32 = "https://github.com$url"

    $Latest = @{ URL32 = $url32; Version = $version }
    return $Latest
}

update
