{ pkgs
, username
, ... }: {
  chaotic.mesa-git = {
    enable = true;
    fallbackSpecialisation = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  home-manager.users.${username} = {
    nixGL = {
      vulkan.enable = true;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
  };
}
