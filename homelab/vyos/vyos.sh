#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Returns saved config file
function get_config_saved () {
  ssh vyos@192.168.1.1 'cat /config/config.boot'
}

# Returns active config file
function get_config_active () {
  scp -q ./get_config.sh vyos@192.168.1.1:/home/vyos/get_config.sh
  ssh vyos@192.168.1.1 'chmod +x /home/vyos/get_config.sh; /home/vyos/get_config.sh; rm /home/vyos/get_config.sh'
}

# Push local ./config.boot to remote /home/vyos/config.boot
function post_config () {
  scp -q ./config.boot vyos@192.168.1.1:/home/vyos/config.boot
}

function load_config () {
  scp -q ./load_config.sh vyos@192.168.1.1:/home/vyos/load_config.sh
  ssh vyos@192.168.1.1 'chmod +x /home/vyos/load_config.sh; /home/vyos/load_config.sh; rm /home/vyos/load_config.sh'
}

function save_config () {
  scp -q ./save_config.sh vyos@192.168.1.1:/home/vyos/save_config.sh
  ssh vyos@192.168.1.1 'chmod +x /home/vyos/save_config.sh; /home/vyos/save_config.sh; rm /home/vyos/save_config.sh'
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

"$1"