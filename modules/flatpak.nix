 { sys, pkgs, ... }: {
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    remotes = [ { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; } ];
  };
  home-manager.users."${sys.username}" = {
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      remotes = [ { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; } ];
    };
    home.packages = with pkgs; [ flatpak ];
  };
 }

 # To use:
 # For system packages:
 # services.flatpak.packages = [ "com.myproject.app/arch/branch" ];
 # For user packages:
 # home-manager.users."${sysVars.username}".services.flatpak.packages = [ "com.myproject.app/arch/branch" ];
