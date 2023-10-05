#!/bin/sh
FROM_DIR=$1 # trailing slash
TO_DIR=$2 # no trailing slash

cp -rv $FROM_DIR $TO_DIR > copy.tmp

# If filesize is less than 23 million bytes (21.93 MiB) 
# Gives generous headroom for Gmail max attachment size
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
    rm copy.tmp
else
   echo "Filesize too large to attach. See log file for details." | mail -s "Copy $FROM_DIR to $TO_DIR operation complete." root
   mv copy.tmp copy_$(date +"%y-%m-%d").log
fi