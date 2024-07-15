1. Edit the contents of `/etc/apt/sources.list` as sudo. Make it match the [default Debian 11 sources.list](https://wiki.debian.org/SourcesList#Example_sources.list), using the contrib, non-free additional components.
2. Run `sudo apt update && sudo apt upgrade`
3. Run `sudo apt full-upgrade`
4. Reboot.