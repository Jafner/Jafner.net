#! bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SSH_CMD=${SSH_CMD:-"ssh"}
SCP_CMD=${SCP_CMD:-"scp -q"}
VYOS_TARGET=${VYOS_TARGET:-"vyos@192.168.1.1"}

echo "SSH_CMD: $SSH_CMD"
echo "SCP_CMD: $SCP_CMD"
echo "VYOS_TARGET: $VYOS_TARGET"

# Returns saved config file
function get_config_saved () {
  $SSH_CMD $VYOS_TARGET 'cat /config/config.boot'
}

# Returns active config file
function get_config_active () {
  $SCP_CMD ./get_config.sh $VYOS_TARGET:/home/vyos/get_config.sh
  $SSH_CMD $VYOS_TARGET 'chmod +x /home/vyos/get_config.sh; /home/vyos/get_config.sh; rm /home/vyos/get_config.sh'
}

# Push local ./config.boot to remote /home/vyos/config.boot
function post_config () {
  $SCP_CMD ./config.boot $VYOS_TARGET:/home/vyos/config.boot
}

function load_config () {
  $SCP_CMD ./load_config.sh $VYOS_TARGET:/home/vyos/load_config.sh
  $SSH_CMD $VYOS_TARGET 'chmod +x /home/vyos/load_config.sh; /home/vyos/load_config.sh; rm /home/vyos/load_config.sh'
}

function save_config () {
  $SCP_CMD ./save_config.sh $VYOS_TARGET:/home/vyos/save_config.sh
  $SSH_CMD $VYOS_TARGET 'chmod +x /home/vyos/save_config.sh; /home/vyos/save_config.sh; rm /home/vyos/save_config.sh'
}

function get_dhcp_leases () {
  $SCP_CMD ./op.sh $VYOS_TARGET:/home/vyos/op.sh
  $SSH_CMD $VYOS_TARGET 'chmod +x /home/vyos/op.sh; /home/vyos/op.sh "show dhcp server leases"; rm /home/vyos/op.sh'
}

function update_public_ip () {
  $SCP_CMD ./update_public_ip.sh $VYOS_TARGET:/home/vyos/update_public_ip.sh
  $SSH_CMD $VYOS_TARGET 'chmod +x /home/vyos/update_public_ip.sh; /home/vyos/update_public_ip.sh; rm /home/vyos/update_public_ip.sh'
}

function cfddns () {
  $SCP_CMD ./cfddns.sh $VYOS_TARGET:/home/vyos/cfddns.sh
  $SCP_CMD ./cloudflare.token $VYOS_TARGET:/home/vyos/cloudflare.token
  $SSH_CMD $VYOS_TARGET 'chmod +x /home/vyos/cfddns.sh; /home/vyos/cfddns.sh "jafner.net" "$(cat /home/vyos/cloudflare.token)"; rm /home/vyos/cfddns.sh /home/vyos/cloudflare.token'
}

function run_script () {
  SCRIPT="$1"
  $SCP_CMD $SCRIPT $VYOS_TARGET:/home/vyos/$SCRIPT
  $SSH_CMD $VYOS_TARGET "chmod +x /home/vyos/$SCRIPT; /home/vyos/$SCRIPT; rm /home/vyos/$SCRIPT"
}

function op () {
  command="$@"
  $SCP_CMD ./op.sh $VYOS_TARGET:/home/vyos/op.sh
  $SSH_CMD $VYOS_TARGET "chmod +x /home/vyos/op.sh; /home/vyos/op.sh $command; rm /home/vyos/op.sh"
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
