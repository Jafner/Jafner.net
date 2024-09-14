{ pkgs, ... }:

{
  services.flatpak.enable = true;
  services.flatpak.packages = [ { appId = "io.github.zen_browser.zen"; origin = "flathub"; } ];
  services.flatpak.update.onActivation = true;
}
