#!/usr/bin/env sh

SMARTCTL=/usr/local/sbin/smartctl

DISKS=$(/sbin/sysctl -n kern.disks | cut -d= -f2)

for DISK in ${DISKS}
do
  TEMP=$(${SMARTCTL} -l scttemp /dev/${DISK} | grep '^Current Temperature:' | awk '{print $3}')
  HEALTH=$(${SMARTCTL} -H /dev/${DISK} | grep 'test result:' | cut -d: -f2 | sed 's/^[ \t]*//')
  if [ -z != ${TEMP} ] && [ -z != ${HEALTH} ]
  then
    JSON=$(echo ${JSON}{\"disk\":\"${DISK}\",\"health\":\"${HEALTH}\",\"temperature\":${TEMP}},)
  fi
done

JSON=$(echo ${JSON} | sed 's/,$//')

echo [${JSON}] >&1
