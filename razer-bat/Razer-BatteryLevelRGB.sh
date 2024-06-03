#!/bin/bash

debug=false # set to true if you want to see debug messages
# Find your values from the output of `razer-cli -ls`

# These devices are queried for the charge value used to set the RGB color
device_name="Razer Viper Ultimate (Wireless)"
device_name_alternate="Razer Viper Ultimate (Wired)"

# This device gets its RGB set based on the charge value.
# This *can* be the same as one of the above, but I like to see the RGB on my dock.
# You could also use a non-Razer device by changing the command at the end of 
# the set_color_from_charge function to one which works for your device.
dock_name="Razer Mouse Dock" 

# Set how often to check the new battery level.
polling_interval=600

# Set the colors to use for full charge and low charge below. 
# These are used to create a gradient to represent partial charge levels.
# E.g. if full charge is green and low charge is red, 50% charge will be yellow
# Or e.g. if full charge is purple (102, 0, 255) and low charge is cyan (0, 255, 255)
# then 50% charge will be a sky blue (51, 127, 255).
# You can use the rgb output of a tool like this:
# https://www.w3schools.com/colors/colors_picker.asp
full_charge_color_code="85 255 0" 
low_charge_color_code="255 0 0"  


# Razer devices often have different names when they're plugged in.
# But we still want to know the charge level while we're charging, so we query both names.
low_charge_percent=$(razer-cli -d "$device_name" --battery low | grep "low threshold" | tr -s ' ' | cut -d' ' -f 4)
if  [[ -z $low_charge_percent ]]; then
    low_charge_percent=$(razer-cli -d "$device_name_alternate" --battery low | grep "low threshold" | tr -s ' ' | cut -d' ' -f 4)
fi

# This is just for the math to get the color gradients.
charge_range=$((100 - $low_charge_percent))
full_r=$(echo "$full_charge_color_code" | cut -d' ' -f 1)
low_r=$(echo "$low_charge_color_code" | cut -d' ' -f 1)
color_range_r=$(($full_r - $low_r))

full_g=$(echo "$full_charge_color_code" | cut -d' ' -f 2)
low_g=$(echo "$low_charge_color_code" | cut -d' ' -f 2)
color_range_g=$(($full_g - $low_g))

full_b=$(echo "$full_charge_color_code" | cut -d' ' -f 3)
low_b=$(echo "$low_charge_color_code" | cut -d' ' -f 3)
color_range_b=$(($full_b - $low_b))

# Some debug echoes.
if [[ $debug -eq "true" ]]; then 
    echo "full_r: $full_r, low_r: $low_r, color_range_r: $color_range_r"
    echo "full_g: $full_g, low_g: $low_g, color_range_g: $color_range_g"
    echo "full_b: $full_b, low_b: $low_b, color_range_b: $color_range_b"
fi

# Our function for setting the new RGB color 
# Uses a gradient between the "full" and "low" charge colors.
function set_color_from_charge () {
    charge_scaled=$(($(($(($1 - $low_charge_percent)) * 100)) / $charge_range))
    r=$(($low_r + $(($(($charge_scaled * $color_range_r)) / 100))))
    g=$(($low_g + $(($(($charge_scaled * $color_range_g)) / 100))))
    b=$(($low_b + $(($(($charge_scaled * $color_range_b)) / 100))))

    if [[ $debug -eq "true" ]]; then 
        echo "charge scaled: $charge_scaled"
        echo "new color: $r, $g, $b"
    fi
    razer-cli -d $dock_name -c $r $g $b
}

# Our main loop. Get current charge level. 
# If it's reporting zero, we assume it's asleep.
# If it's reporting at or below the low battery threshold, we use the low battery color
# If it's reporting above the low battery threshold, we set the RGB color based on our gradient
# Consider adding logic to handle distinction between discharging (normal) and charging.
while true; do
    charge=$(razer-cli -d "$device_name" --battery print | grep charge | tr -s ' ' | cut -d' ' -f 3)
    if [[ $debug -eq "true" ]]; then
        echo "charge: $charge"
    fi
    if [[ $charge -eq 0 ]]; then
        echo "Device charge 0. Assuming the device is sleeping. Do nothing."
    elif [[ $charge -lt $low_charge_percent ]]; then
        razer-cli -d $dock_name -c $full_charge_color_code
    else
        set_color_from_charge $charge
    fi
    sleep $polling_interval
done