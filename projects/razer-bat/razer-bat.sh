#!/bin/bash
# Customize the four variables below for your setup.
###############################
PATH="$PATH:$HOME/.local/bin" #
WIRELESS_DEVICE_NAME=''       #
WIRED_DEVICE_NAME=''          #
SYNC='true'                   #
###############################

# Init
WIRELESS_DEVICE_NAME=${WIRELESS_DEVICE_NAME:-'Razer Viper Ultimate'} # required, non-sane default
WIRED_DEVICE_NAME=${WIRED_DEVICE_NAME:-'Razer Mouse Dock'} # required, sane default

if [[ $SYNC == 'true' ]]; then
    SYNC="--sync"
else
    SYNC=""
fi

echo "WIRELESS_DEVICE_NAME: $WIRELESS_DEVICE_NAME"
echo "WIRED_DEVICE_NAME: $WIRED_DEVICE_NAME"

# Function to calculate color between two colors by percentage
# Takes 
#     COLOR_PERCENTAGE=$1 # required
# Returns
#     Space-separated RGB value like: 123 134 0
function get_intermediate_color() {
    local COLOR_PERCENTAGE=$1

    IFS=',' read -r -a start_color <<< "255,0,0"
    IFS=',' read -r -a end_color <<< "0,255,0"
    local steps=4

    local step_r=$(( (end_color[0] - start_color[0]) / (steps + 1) ))
    local step_g=$(( (end_color[1] - start_color[1]) / (steps + 1) ))
    local step_b=$(( (end_color[2] - start_color[2]) / (steps + 1) ))

    local intermediate_colors=()
    for ((i = 1; i <= steps; i++)); do
        local r=$(( start_color[0] + step_r * i ))
        local g=$(( start_color[1] + step_g * i ))
        local b=$(( start_color[2] + step_b * i ))
        local intermediate_colors+=("$r $g $b")
    done
    local index=$(( ( $COLOR_PERCENTAGE / (100 / $steps ) ) ))
    if [[ $index -gt $(( ${#intermediate_colors[@]} - 1 )) ]]; then
        echo "COLOR: ${end_color[@]}" >&2
        echo "${end_color[@]}"
    elif [[ $index -eq 0 ]]; then
        echo "COLOR: ${start_color[@]}" >&2
        echo "${start_color[@]}"
    else
        echo "COLOR: ${intermediate_colors[$index]}" >&2
        echo ${intermediate_colors[$index]}
    fi
}

# Function to read mouse charge level and return it as percentage
# Takes
#     WIRELESS_DEVICE_NAME=$1
# Returns
#     Percentage battery charge value between 0 and 100
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
    echo "CHARGE: $CHARGE" >&2
    echo "$CHARGE"
}

# Main
razer-cli -d "$WIRED_DEVICE_NAME" -c $(get_intermediate_color "$(get_charge_percentage "$WIRELESS_DEVICE_NAME")") $SYNC
