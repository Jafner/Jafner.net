# Razer Battery Level RGB
See your mouse or keyboard's battery level on your wireless dock.

# Installation
Before installing, we need to install some dependencies:
1. Install razer-cli: [instructions](https://github.com/lolei/razer-cli?tab=readme-ov-file#installation).
2. Download this script and make it executable: `curl -s https://raw.githubusercontent.com/Jafner/Razer-BatteryLevelRGB/master/Razer-BatteryLevelRGB.sh > ./ && chmod +x ./Razer-BatteryLevelRGB.sh`.
3. Edit the script 
   1. Replace the device name with your device's name (you can find it by running `razer-cli -ls`).
   2. Set the low-charge and full-charge color codes to your liking. Defaults to red and green respectively.
4. Run the script: `./Razer-BatteryLevelRGB.sh`. 

- If you want to run the script in the background, refer to [this StackOverflow post](https://stackoverflow.com/questions/3683910/executing-shell-command-in-background-from-script).
- If you want to run the script with Systemd (as a background process), refer to [this StackEx post](https://unix.stackexchange.com/questions/47695/how-to-write-startup-script-for-systemd).

# Tested With
```
razer-cli: 2.2.1
python3-openrazer: 3.8.0
openrazer-daemon: 3.8.0
Python: 3.12.3
```