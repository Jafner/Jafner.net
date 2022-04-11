#!/bin/sh
FROM_DIR=$1 # trailing slash
TO_DIR=$2 # no trailing slash

cp -rv $FROM_DIR $TO_DIR > copy.tmp

(   echo "Subject: Copy Operation Complete"
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