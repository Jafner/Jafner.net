Write-Host @"
Select a supported transcode profile:

1) CRF 21 (~19.9 Mb/s)
2) CRF 27 (~10.3 Mb/s)
3) 1080p CRF 21 (11.9 Mb/s)
4) 1080p CRF 27 (6.2 Mb/s)
5) 720p CRF 21 (6.3 Mb/s)
6) 720p CRF 27 (3.3 Mb/s)
"@

$profile = Read-Host -Prompt 'Select a profile [2]'

Switch ($profile) {
    "" {
    $profile = "CRF_27"
    $ffmpeg_arguments='-metadata comment="x264 CRF 27" -movflags +faststart -c:v libx264 -preset slower -crf 27'.Split(" ") 
    }
    "1" {
    $profile = "CRF_21"
    $ffmpeg_arguments='-metadata comment="x264 CRF 21" -movflags +faststart -c:v libx264 -preset slower -crf 21'.Split(" ") 
    }
    "2" {
    $profile = "CRF_27"
    $ffmpeg_arguments='-metadata comment="x264 CRF 27" -movflags +faststart -c:v libx264 -preset slower -crf 27'.Split(" ") 
    } 
    "3" {
    $profile = "1080p_CRF_21"
    $ffmpeg_arguments='-metadata comment="x264 1080p CRF 21" -movflags +faststart -vf scale=1920:1080 -c:v libx264 -preset slower -crf 21'.Split(" ") 
    }
    "4" {
    $profile = "1080p_CRF_27"
    $ffmpeg_arguments='-metadata comment="x264 1080p CRF 27" -movflags +faststart -vf scale=1920:1080 -c:v libx264 -preset slower -crf 27'.Split(" ") 
    }
    "5" {
    $profile = "720p_CRF_21"
    $ffmpeg_arguments='-metadata comment="x264 720p CRF 21" -movflags +faststart -vf scale=1280:720 -c:v libx264 -preset slower -crf 21'.Split(" ") 
    }
    "6" {
    $profile = "720p_CRF_27"
    $ffmpeg_arguments='-metadata comment="x264 720p CRF 27" -movflags +faststart -vf scale=1280:720 -c:v libx264 -preset slower -crf 27'.Split(" ") 
    }
    Default {
        echo "Is it that hard to just enter a number?"
        pause
        exit
    }

}

foreach( $input in $args ) {
    $output = [System.IO.Path]::GetDirectoryName("$input") + "\" + [System.IO.Path]::GetFileNameWithoutExtension("$input") + "-$profile" + [System.IO.Path]::GetExtension("$input")
    ffmpeg -i "$input" $ffmpeg_arguments "$output" 
}

pause