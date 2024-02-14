#!/bin/vbash

if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

source /opt/vyatta/etc/functions/script-template

configure

echo "===== Configure firewall... ====="
{ 
    source firewall.sh 
} || { 
    echo "===== Failed to configure firewall =====" 
}

echo "===== Configure interfaces... ====="   
{ 
    source interfaces.sh 
} || { 
    echo "===== Failed to configure interfaces =====" 
}

echo "===== Configure NAT... ====="
{ 
    source nat.sh 
} || { 
    echo "===== Failed to configure NAT =====" 
}

echo "===== Configure QoS... ====="
{ 
    source qos.sh 
} || { 
    echo "===== Failed to configure QoS =====" 
}


echo "===== Configure services... ====="
{ 
    source service.sh 
} || { 
    echo "===== Failed to configure services =====" 
}


echo "===== Configure system... ====="
{ 
    source system.sh 
} || { 
    echo "===== Failed to configure system =====" 
}


compare

{ # try commit, save
    commit && save
} || { # catch, exit discard and print a very basic error message
    exit discard
    echo "Failed to commit and save the configuration."
}

exit
