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
    $download_page = Invoke-WebRequest -Uri "https://wiki.scn.sap.com/wiki/display/SQLANY/SAP+SQL+Anywhere+Database+Client+Download" -UseBasicParsing

    #SQLA1201_Client.exe
    $regex  = "SQLA1201_Client.exe"
    $url = $download_page.links | ? href -match $regex | select -expand href

    $version = "12.0.1"
    $url32 = $url
    $url64 = $url

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

#update
