#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Change this to the user, host, (and optionally port) of your VyOS target.
VYOS_TARGET="vyos@192.168.1.1"

# Returns saved config file
function get_config_saved () {
  ssh $VYOS_TARGET 'cat /config/config.boot'
}

# Returns active config file
function get_config_active () {
  scp -q ./get_config.sh $VYOS_TARGET:/home/vyos/get_config.sh
  ssh $VYOS_TARGET 'chmod +x /home/vyos/get_config.sh; /home/vyos/get_config.sh; rm /home/vyos/get_config.sh'
}

# Push local ./config.boot to remote /home/vyos/config.boot
function post_config () {
  scp -q ./config.boot    :/home/vyos/config.boot
}

function load_config () {
  scp -q ./load_config.sh $VYOS_TARGET:/home/vyos/load_config.sh
  ssh $VYOS_TARGET 'chmod +x /home/vyos/load_config.sh; /home/vyos/load_config.sh; rm /home/vyos/load_config.sh'
}

function save_config () {
  scp -q ./save_config.sh $VYOS_TARGET:/home/vyos/save_config.sh
  ssh $VYOS_TARGET 'chmod +x /home/vyos/save_config.sh; /home/vyos/save_config.sh; rm /home/vyos/save_config.sh'
}

function get_dhcp_leases () {
  scp -q ./op.sh $VYOS_TARGET:/home/vyos/op.sh
  ssh $VYOS_TARGET 'chmod +x /home/vyos/op.sh; /home/vyos/op.sh "show dhcp server leases"; rm /home/vyos/op.sh'
}

function op () {
  command="$@"
  scp -q ./op.sh $VYOS_TARGET:/home/vyos/op.sh
  ssh $VYOS_TARGET "chmod +x /home/vyos/op.sh; /home/vyos/op.sh $command; rm /home/vyos/op.sh"
}

function pull () {
  get_config_saved > config.boot
}

function push () {
  post_config
  load_config
  save_config
}

function edit () {
  get_config_saved > $SCRIPT_DIR/config.boot
  vim $SCRIPT_DIR/config.boot
  push
}

"$@"

# Fair warning, this script is trash.