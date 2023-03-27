#!/bin/bash
# this script converts the output of the "forge tps" command (in the form of the .forgetps file) into json for sending to influxdb
# by default it reads from stdin and outputs to a .forgetps.json file
while IFS= read -r line; do
  if [ "$line" != "" ]; then
    DIM=$(echo -n "$line" | awk '{print $2}')
    if [ "$DIM" = "Mean" ]; then
      DIM="Overall"
    fi
    TPT=$(echo "$line" | grep -oE 'Mean tick time: .+ms' | awk '{print $4}')
    TPS=$(echo "$line" | grep -oE 'Mean TPS: .+' | awk '{print $3}')
    JSON+=\{$(echo \"dim\":\"$DIM\",\"tpt\":$TPT,\"tps\":$TPS)\}, 
  fi
#done < .forgetps # inputs from .forgetps file
done <$1 # inputs from file passed via stdin
JSON=$(echo ${JSON} | sed 's/,$//')

#echo [${JSON}] >&1 # outputs to stdout
echo [${JSON}] > .forgetps.json # uncomment this to output to file
