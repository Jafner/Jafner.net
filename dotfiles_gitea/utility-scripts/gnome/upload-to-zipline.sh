#!/bin/bash
#["Share to Zipline"]

# Assumes wayland for copying link after upload. 
#     Uses [wl-clipboard](https://github.com/bugaevc/wl-clipboard).
# Depends on `jq` to parse response.

echo "NAUTILUS_SCRIPT_SELECTED_FILE_PATHS = $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" >> ~/temp.txt

{
    ZIPLINE_HOST_ROOT=https://zipline.jafner.net
    echo "ZIPLINE_HOST_ROOT=$ZIPLINE_HOST_ROOT"
    TOKEN=$(cat ~/.zipline-auth)
    #echo "TOKEN=$TOKEN"
    for file in "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"; do
        echo "file=$file"
        LINK=$(curl \
            --header "authorization: $TOKEN" \
            $ZIPLINE_HOST_ROOT/api/upload -F "file=@$file" \
            --header "Content-Type: multipart/form-data" \
            --header "Format: name" \
            --header "Embed: true" \
            --header "Original-Name: true") 
        LINK=$(echo "$LINK" | jq -r .'files[0]')
        echo "$LINK" | wl-copy
        notify-send -t 4000 "Zipline - Upload complete." "Link copied to clipboard: $LINK"
    done
} > /dev/null # Replace with: `>> ~/uploaderscript.log 2>&1` for logging.

# Uploads via Curl will not be configured with a correct mimetype unles the server's `UPLOADER_ASSUME_MIMETYPES` env var is set to true.
