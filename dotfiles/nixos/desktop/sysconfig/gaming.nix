{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    lutris-unwrapped
    protonup-ng
    vulkan-tools
    mangohud
  ];
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [];
  };
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true; 
  };
}