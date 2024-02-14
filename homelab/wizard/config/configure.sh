#!/bin/vbash

if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

source /opt/vyatta/etc/functions/script-template
source vyos_secrets.env

configure

echo "===== Configure firewall... ====="
{ 
    source firewall.sh > /dev/null
} || { 
    echo "===== Failed to configure firewall =====" 
}

echo "===== Configure interfaces... ====="   
{ 
    source interfaces.sh > /dev/null
} || { 
    echo "===== Failed to configure interfaces =====" 
}

echo "===== Configure NAT... ====="
{ 
    source nat.sh > /dev/null
} || { 
    echo "===== Failed to configure NAT =====" 
}

echo "===== Configure QoS... ====="
{ 
    source qos.sh > /dev/null
} || { 
    echo "===== Failed to configure QoS =====" 
}


echo "===== Configure services... ====="
{ 
    source service.sh > /dev/null
} || { 
    echo "===== Failed to configure services =====" 
}


echo "===== Configure system... ====="
{ 
    source system.sh > /dev/null
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
