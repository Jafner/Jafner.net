# Razer-bat - Update dock status color based on battery level
This script uses [razer-cli](https://github.com/lolei/razer-cli) and standard bash utilities to set the RGB LEDs of your Razer wireless dock to reflect the battery level of your wireless mouse (or keyboard).

# Installation & Usage
Before installing, we need to install some dependencies:
1. Install razer-cli: [instructions](https://github.com/lolei/razer-cli?tab=readme-ov-file#installation).
2. Download this script and make it executable: `curl -s https://gitea.jafner.tools/Jafner/Jafner.net/raw/branch/main/projects/razer-bat/razer-bat.sh > ./ && chmod +x ./razer-bat.sh`.
3. Set the `WIRELESS_DEVICE_NAME` and `WIRED_DEVICE_NAME` variables at the top of the script.
   1. Set `WIRELESS_DEVICE_NAME` with the name of your wireless mouse, keyboard, or whatever you want to monitor the battery level of. (Tip: You can find it by running `razer-cli -ls`).
   2. Set `WIRED_DEVICE_NAME` with the name of your wired charging dock, or whatever device whose RGB you want to reflect the battery level of your wireless device.
   3. If you installed `razer-cli` to somewhere other than `$HOME/.local/bin/razer-cli`, update that variable to the path of `razer-cli`. Use `which razer-cli` to find the path.
4. Run the script once: `./razer-bat.sh`. Verify everything is working properly.
5. Move the script to somewhere safe. For example: `mv ./razer-bat.sh $HOME/.local/bin/razer-bat`
6. Create a cronjob for the script: `echo "*/15 * * * * $HOME/.local/bin/razer-bat" | crontab -`

# Tips & Troubleshooting
- To monitor cron logs, use: `sudo tail -f /var/log/cron`
- You can run the script more or less often by adjusting the cron interval. Use `crontab -e` to edit the cron table. E.g. to run the script every minute, use `*/1 * * * * $HOME/.local/bin/razer-bat`
- You can add additional lighting logic at the bottom of the script, below `# Main`. Assume `"$(get_charge_percentage "$WIRELESS_DEVICE_NAME")"` will return the battery level (`0 <= CHARGE <= 100`) when the wireless device is awake, and 0 when it is asleep.

# Tested With
```
razer-cli: 2.2.1
python3-openrazer: 3.8.0
openrazer-daemon: 3.8.0
Python: 3.12.3
```