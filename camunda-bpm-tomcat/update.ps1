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
    
    $download_page = Invoke-WebRequest -Uri "https://camunda.org/download/"

    #camunda-bpm-tomcat-7.6.0.zip
    $regex  = "camunda-bpm-tomcat-.+.zip"
    $url = $download_page.links | ? href -match $regex | select -expand href

    $version = ($url -split "-" | select -Last 1) -split ".zip" | select -First 1
    $url32 = "https:$url"
    $url64 = $url32

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update
