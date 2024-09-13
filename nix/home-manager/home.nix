{ config, pkgs, ... }:

{
  home.username = "joey";
  home.homeDirectory = "/home/joey";
  home.stateVersion = "24.05";
  home.packages = [
    pkgs.fastfetch
  ];
  home.file = {};
  home.sessionVariables = {};
  
  # Programs
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };
      "$mod" = "SUPER";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, ALT, mouse:272, resizewindow"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Joey Hafner";
    userEmail = "joey@jafner.net";
    extraConfig = { 
      core.sshCommand = "ssh -i /home/joey/.ssh/joey@joey-laptop"; 
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
  };
  
  programs.home-manager = {
    enable = true;
  };
}
