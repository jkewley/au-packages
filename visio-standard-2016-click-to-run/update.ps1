import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]PackageVersion\s*=\s*)('.*')" = "`$1'$($Latest.Version)'"
        }
    }
}

function global:au_GetLatest {
    function ConvertFrom-StringUsingRegexCaptureGroup {
        param (
            [Regex]$Regex,
            [Parameter(ValueFromPipeline)]$Content
        )
        process {
            $Match = $Regex.Match($Content)
            $Object = [pscustomobject]@{} 
        
            foreach ($GroupName in $Regex.GetGroupNames() | select -Skip 1) {
                $Object | 
                Add-Member -MemberType NoteProperty -Name $GroupName -Value $Match.Groups[$GroupName].Value 
            }
            $Object
        }
    }

    $download_page = Invoke-WebRequest -Uri "https://www.microsoft.com/en-us/download/details.aspx?id=49117" -UseBasicParsing

    $Regex  = "Version (?'Version'16\.0\.[0-9]+\.[0-9]+)"
    
    $Version = $download_page.content | 
    ConvertFrom-StringUsingRegexCaptureGroup -Regex $Regex | 
    Select-Object -ExpandProperty Version
    
    $VersionSegments = $Version.Split(".")

    #Download URL format: https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_7614-3602.exe
    $URLRoot = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_"
    $URLWithDashVersionSeperator = "$URLRoot$($VersionSegments[2])-$($VersionSegments[3]).exe"
    $URLWithDashVersionSeperatorResult = try{Invoke-WebRequest -Uri $URLWithDashVersionSeperator -Method Head}catch{}

    $URLWithDotVersionSeperator = "$URLRoot$($VersionSegments[2]).$($VersionSegments[3]).exe"
    $URLWithDotVersionSeperatorResult = try{Invoke-WebRequest -Uri $URLWithDotVersionSeperator -Method Head}catch{}

    $Url = if ($URLWithDashVersionSeperatorResult) {
        $URLWithDashVersionSeperator
    } elseif ($URLWithDotVersionSeperatorResult) {
        $URLWithDotVersionSeperator
    } else {
        throw "Neither recognized URL format with dot or with dash succeeded"
    }

    $url32 = $url    

    $Latest = @{ URL32 = $url32; Version = $version }
    return $Latest
}

update
