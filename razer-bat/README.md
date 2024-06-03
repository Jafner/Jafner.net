# Razer Battery Level RGB
Set the RGB color of your device based on your Razer device's battery level.

# Installation
Before installing, we need to install some dependencies:
1. Install razer-cli: [instructions](https://github.com/lolei/razer-cli?tab=readme-ov-file#installation).
2. Download this script and make it executable: `curl -s https://raw.githubusercontent.com/Jafner/Razer-BatteryLevelRGB/master/Razer-BatteryLevelRGB.sh > ./ && chmod +x ./Razer-BatteryLevelRGB.sh`.
3. Edit the script 
   1. Replace the device name with your device's name (you can find it by running `razer-cli -ls`).
   2. Set the low-charge and full-charge color codes to your liking. Defaults to red and green respectively.
4. Run the script: `./Razer-BatteryLevelRGB.sh`. 

# Tested With
```
razer-cli: 2.2.1
python3-openrazer: 3.8.0
openrazer-daemon: 3.8.0
Python: 3.12.3
```