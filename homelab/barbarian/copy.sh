#!/bin/sh
FROM_DIR=$1 # trailing slash
TO_DIR=$2 # trailing slash
LOG_FILE=/mnt/Tank/home/admin/copy.log

rsync -avhW $FROM_DIR $TO_DIR > $LOG_FILE

# If filesize is less than 23 million bytes (21.93 MiB) 
# Gives generous headroom for Gmail max attachment size
if [ $(ls -la $LOG_FILE | awk '{print $5}') -le 23000000 ]; then
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
      echo "Copy $FROM_DIR to $TO_DIR complete. See log at $LOG_FILE for details about what was copied."
      echo ""
      echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82"
      echo "Content-Type: text/plain"
      echo "Content-Transfer-Encoding: base64"
      echo "Content-Disposition: attachment; filename=\"$(basename $LOG_FILE)\""
      echo ""
      base64 "$LOG_FILE"
      echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82--"
      echo ""
      echo "--d29a0c638b540b23e9a29a3a9aebc900aeeb6a82--"
  ) | sendmail root
else
  echo "Filesize too large to attach. See log file at $LOG_FILE for details." | mail -s "Copy $FROM_DIR to $TO_DIR operation complete." root
fi