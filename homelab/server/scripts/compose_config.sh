#!/bin/bash

FAIL=""
PASS=""

echo "=============================="
echo "========== STARTING =========="
echo "=============================="
for servicedir in /home/joey/homelab/server/config/*
do 
    service="$(basename $servicedir)"
    echo "===== CHECKING $service"
    cd $servicedir 
    {
        docker-compose config > /dev/null 2>&1 &&
        PASS+="$service\n"
    } || {
        FAIL+="$service\n"
    }
done

echo "=============================="
echo "========== ALL DONE =========="
echo "=============================="

echo "========== PASSED ============"
echo -e "$PASS"

echo "========== FAILED ============"
echo -e "$FAIL"