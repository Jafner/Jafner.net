# Run a big copy operation with Rsync
Run below as root or superuser:

`rsync -avhW $FROM_DIR $TO_DIR > ~/copy.tmp`

- `-a` Archive mode (recursive, copy symlinks, preserve permissions, preserve modification times, preserve group, preserve owner, preserve device files).
- `-v` Verbose mode (print path of each file copied).
- `-h` Human readable (format numbers to be human-readable).
- `-W` Whole file (copy files whole, do not use transfer delta algorithm).
- `$FROM_DIR` Source directory, with trailing slash. E.g. `/mnt/Media/Media/`
- `$TO_DIR` Destination directory, with trailing slash. E.g. `/mnt/TEMP/Media/`
- `> ~/copy.tmp` Sends stdout to a file which can be used for scripting. 

# Send a brief email notification when copy complete

```
(   echo "Subject: Copy $FROM_DIR to $TO_DIR operation complete."
    echo "Mime-Version: 1.0"
    echo "Content-Type: multipart/mixed; boundary=\"d29a0c638b540b23e9a29a3a9aebc900aeeb6a82\""
    echo "Content-Transfer-Encoding: 7bit"
    echo ""
    echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82"
    echo "Content-Type: text/html; charset=\"UTF-8\""
    echo "Content-Transfer-Encoding: 7bit"
    echo "Content-Disposition: inline"
    echo ""
    echo "Copy $FROM_DIR to $TO_DIR complete. See attached log for details about what was copied."
    echo ""
    echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82"
    echo "Content-Type: text/plain"
    echo "Content-Transfer-Encoding: base64"
    echo "Content-Disposition: attachment; filename=\"log.txt\""
    echo ""
    base64 "copy.tmp"
    echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82--"
    ) | sendmail root
```

# Send a verbose email notification when copy complete
This should be set to run after the copy completes (e.g. in a script, or with an `&&`).
```
if [ $(ls -la copy.tmp | awk '{print $5}') -le 23000000 ]; then
  (   echo "Subject: Copy $FROM_DIR to $TO_DIR operation complete."
      echo "Mime-Version: 1.0"
      echo "Content-Type: multipart/mixed; boundary=\"d29a0c638b540b23e9a29a3a9aebc900aeeb6a82\""
      echo "Content-Transfer-Encoding: 7bit"
      echo ""
      echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82"
      echo "Content-Type: text/html; charset=\"UTF-8\""
      echo "Content-Transfer-Encoding: 7bit"
      echo "Content-Disposition: inline"
      echo ""
      echo "Copy $FROM_DIR to $TO_DIR complete. See attached log for details about what was copied."
      echo ""
      echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82"
      echo "Content-Type: text/plain"
      echo "Content-Transfer-Encoding: base64"
      echo "Content-Disposition: attachment; filename=\"log.txt\""
      echo ""
      base64 "copy.tmp"
      echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82--"

    ) | sendmail root
    rm /tmp/copy.tmp
else
   echo "Filesize too large to attach. See log file for details." | mail -s "Copy $FROM_DIR to $TO_DIR operation complete." root
   mv copy.tmp copy_$(date +"%y-%m-%d").log
fi
```