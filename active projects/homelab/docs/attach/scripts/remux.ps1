foreach( $input in $args ) {
    $output = ("$input").TrimEnd(".mkv .mp4") + ".mp4"
    ffmpeg -i "$input" -c copy $output 
    if ($?) {
        Remove-Item $input
    }
}