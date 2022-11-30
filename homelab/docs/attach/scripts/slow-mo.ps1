foreach( $input in $args ) {
    $extension = [System.IO.Path]::GetExtension("$input")
    if ($extension -ne ".mp4") {
        echo "Video must use mp4 container!"
        pause
        exit
    }
    Set-Location -Path ([System.IO.Path]::GetDirectoryName("$input"))
    $output = [System.IO.Path]::GetDirectoryName("$input") + "\" + [System.IO.Path]::GetFileNameWithoutExtension("$input") + "-slow-mo" + [System.IO.Path]::GetExtension("$input")
    echo $output
    ffmpeg -i "$input" -map 0:v -c:v copy -bsf:v h264_mp4toannexb 'raw.h264' 
    if ($?) {
        ffmpeg -fflags +genpts -r 60 -i raw.h264 -c:v copy -movflags faststart "$output"    
    }
    Remove-Item raw.h264
    
}

pause