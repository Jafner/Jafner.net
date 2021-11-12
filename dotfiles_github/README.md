# Cloning the repository
1. Get the SSH key. Save the content of the `.ssh/id_rsa` file to `~/.ssh/id_rsa`
2. Restrict the permissions for the file with `chmod 600 ~/.ssh/id_rsa`
3. Add the key to the agent:
```bash
eval $(ssh-agent -s) && \
ssh-add ~/.ssh/id_rsa
```
4. Clone the repo with `git clone git@github.com:Jafner/dotfiles.git ~/Git/dotfiles`
5. Place the dotfiles where they need to be with `chmod +x install_dotfiles.sh && ./install_dotfiles.sh`

# Other Stuff
## Autostart
1. Set Spotify, PulseEffects, and Ferdi to start automatically.
2. `chmod +x window_reposition.sh`
3. Run the window_reposition script at startup.


## Tiling and corner-snapping
Using GNOME, disable all extensions. Install [Tiling Assistant](https://extensions.gnome.org/extension/3733/tiling-assistant/)
Set Windows and Screen Edges gaps to 12px.

## Virtualization
Install `libvirt`.
`nano /etc/default/grub` and add `amd_iommu=on iommu=pt` to the `GRUB_CMDLINE_LINUX_DEFAULT` variable.
`sudo grub-mkconfig -o /boot/grub/grub.cfg` to update the bootloader.