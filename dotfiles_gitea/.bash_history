sudo dmesg
ps aux | grep -i pavu
ps aux | grep -i pulse
ps aux | grep -i control
amdgpu_top
sudo dnf info gamescope
xrandr
xeyes
systemctl status pipewire
systemctl --user status pipewire
cd Games/
ls
cd overwatch-2
ls
cd jafner/
ls
cat dxvk.conf 
neofetch
dnf info mutter
sudo dnf search systemsettings
sudo dnf info plasma-systemsettings
sudo dnf install kwin plasma-systemsettings
kwin --replace
kwin --help
sudo dnf group list -v --available | grep desktop
sudo dnf install @kde-desktop-environment
sudo dnf install switchdesk switchdesk-gui
switchdesk --help
switchdesk 
switchdesk kde
chsh joey
zsh
full_charge_color_code_dec="85 255 0" 
low_charge_color_code_dec="255 0 0"  
full_r=$(echo "$full_charge_color_code_dec" | cut -d' ' -f 1)
low_r=$(echo "$low_charge_color_code_dec" | cut -d' ' -f 1)
color_range_r=${$(($full_r - $low_r))#-}
color_range_r=$(($full_r - $low_r))
color_range_r=${$color_range_r#-}
echo $color_range
echo $color_range_r
echo "${color_range_r/#-}"
color_range_r=${color_range_r/#-}
echo $color_range_r
full_r=$(echo "$full_charge_color_code_dec" | cut -d' ' -f 1)
low_r=$(echo "$low_charge_color_code_dec" | cut -d' ' -f 1)
color_range_r=$(($full_r - $low_r))
color_range_r=${$color_range_r/#-}
color_range_r=$(($full_r - $low_r))
echo $color_range_4
echo $color_range_r
color_range_r=$(($full_r - $low_r))
color_range_r=${color_range_r/#-}
echo $color_range_r
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
razer-cli -d $device_name --battery print | grep charge | tr -s ' ' | cut -d' ' -f 3
device_name="Razer Viper Ultimate (Wireless)"
razer-cli -d $device_name --battery print | grep charge | tr -s ' ' | cut -d' ' -f 3
razer-cli --battery print | grep charge | tr -s ' ' | cut -d' ' -f 3
razer-cli -d "$device_name" --battery print | grep charge | tr -s ' ' | cut -d' ' -f 3
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
razer-cli -ll
./RazerViperUltimate-IndicateBatteryOnDock.sh 
full_r="85"
low_r="255"
color_range=$(( $full_r - $low_r ))
echo $color_range
if [ $color_range < 0 ]; then echo "true"; fi
if [[ $color_range < 0 ]]; then echo "true"; fi
if [[ $color_range -lt 0 ]]; then echo "true"; fi
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
./RazerViperUltimate-IndicateBatteryOnDock.sh 
cd ~/Git/Razer-BatteryLevelRGB/
ls
./Razer-BatteryLevelRGB.sh &>/dev/null & disown;
ps aux | grep Razer
ps aux | grep Razer
