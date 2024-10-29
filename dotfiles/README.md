## Dotfiles TODO

### TODO
- Write a shell application to manage display brightness on laptop. Use `brightnessctl`. Call the script via hyprland bindings.
- Devise a maximally-portable method to get "autofill" from Bitwarden vault. (E.g. "Ctrl+Super+P" -> Search+Select app -> Automatically fills username, password, copies TOTP to clipboard).
- Determine how to facilitate theme hotswapping. Hyprpaper? Stylix?
- Polish waybar appearance. Add some transparency, improve handling of dark vs. light polarities. Add widget for Spotify playback.
- Migrate flatpak apps to native if possible (Zen for laptop, everything listed in `services.flatpak.packages` for desktop).
- Reorganize nix files such that "roles" or "tasks" are tightly coupled (e.g. "games" should contain all system and hm options necessary to do games), and common (i.e. always wanted) configuration options are consolidated.
- Look into [impermanence](https://nixos.wiki/wiki/Impermanence) for maximal reproducibility. 
- Migrate desktop to nixos.
- Build declarative browser configuration (possible with Zen?).
- Build specialization for professional work.
