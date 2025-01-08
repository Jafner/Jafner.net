{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lutris-unwrapped
    protonup-ng
    vulkan-tools
    mangohud
  ];
  programs.steam.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true; 
  };
}