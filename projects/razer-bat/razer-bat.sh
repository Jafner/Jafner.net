#!/bin/bash

WIRELESS_DEVICE_NAME=''
WIRED_DEVICE_NAME=''
# Init
WIRELESS_DEVICE_NAME=${WIRELESS_DEVICE_NAME:-'Razer Viper Ultimate'} # required, non-sane default
WIRED_DEVICE_NAME=${WIRED_DEVICE_NAME:-'Razer Mouse Dock'} # required, sane default

SYNC_ALL_DEVICES=${SYNC_ALL_DEVICES:-'false'} # optional; default false; applies color to all found devices
START_COLOR=${START_COLOR:-'255 0 0'} # optional; TODO
END_COLOR=${END_COLOR:-'0 255 0'} # optional; TODO
STEPS=${STEPS:-'20'} # optional; can be any factor of 100

# echo "WIRELESS_DEVICE_NAME: $WIRELESS_DEVICE_NAME"
# echo "WIRED_DEVICE_NAME: $WIRED_DEVICE_NAME"
# echo "SYNC_ALL_DEVICES: $SYNC_ALL_DEVICES"
# echo "START_COLOR: $START_COLOR"
# echo "END_COLOR: $END_COLOR"
# echo "STEPS: $STEPS"

# Function to calculate color between two colors by percentage
# Takes 
    # COLOR_PERCENTAGE=$1 # required
    # START_COLOR_RANGE=$2 # default '255 0 0' (pure red)
    # END_COLOR_RANGE=$3 # default '0 255 0' (pure green)
    # STEPS=$4 # default 20
# Returns
    # Space-separated RGB value like: 123 134 0
function get_intermediate_color() {
    local COLOR_PERCENTAGE=$1
    local START_COLOR_RANGE=${2:-255,0,0} 
    local END_COLOR_RANGE=${3:-0,255,0} 
    local STEPS=${4:-20} 
    
    IFS=',' read -r -a start_color <<< "$START_COLOR_RANGE"
    IFS=',' read -r -a end_color <<< "$END_COLOR_RANGE"
    local steps=$STEPS
    local charge=$COLOR_PERCENTAGE

    local step_r=$(( (end_color[0] - start_color[0]) / (steps + 1) ))
    local step_g=$(( (end_color[1] - start_color[1]) / (steps + 1) ))
    local step_b=$(( (end_color[2] - start_color[2]) / (steps + 1) ))

    local intermediate_colors=()
    for ((i = 1; i <= steps; i++)); do
        local r=$(( start_color[0] + step_r * i ))
        local g=$(( start_color[1] + step_g * i ))
        local b=$(( start_color[2] + step_b * i ))
        intermediate_colors+=("$r $g $b")
    done
    
    local index=$(( ( $charge / (100 / $steps ) ) ))
    if [[ $index -gt ${#intermediate_colors[@]} ]]; then
        index=${#intermediate_colors[@]}
    fi

    echo ${intermediate_colors[$index]}
}

# Function to read mouse charge level and return it as percentage
# Takes
    # WIRELESS_DEVICE_NAME=$1
# Returns
    # Percentage value between 0 and 100
function get_charge_percentage() {
    local WIRELESS_DEVICE_NAME=$1
    local CHARGE=$(\
        razer-cli -d "$(\
            echo "$(\
                razer-cli -ls
            )" |\
            grep "$WIRELESS_DEVICE_NAME" |\
            sed 's/://'
        )" --battery print |\
        grep charge |\
        tr -s ' ' |\
        cut -d' ' -f3
    )
    echo "$CHARGE"
}

# Our function for setting the new RGB color 
# Takes
    # WIRED_DEVICE_NAME=$1
    # COLOR=$2 # space-separated
function set_dock_color () {
    local WIRED_DEVICE_NAME=\"$1\"
    local COLOR="$2"
    echo razer-cli -d $WIRED_DEVICE_NAME -c $COLOR 
    razer-cli -d $WIRED_DEVICE_NAME -c $COLOR 
    
}

# Main
set_dock_color "$WIRED_DEVICE_NAME" "$(get_intermediate_color "$(get_charge_percentage "$WIRELESS_DEVICE_NAME")")" &&\
    echo "Updated \"$WIRED_DEVICE_NAME\" \($(get_charge_percentage "$WIRELESS_DEVICE_NAME")% battery)"
