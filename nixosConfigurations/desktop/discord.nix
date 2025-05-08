{ pkgs
, username
, ... }: {
  home-manager.users.${username} = {
    #home.packages = with pkgs; [ vesktop ];
    programs.nixcord = {
      enable = true;
      discord.enable = false;
      vesktop.enable = true;
      config = {
        useQuickCss = false;
        frameless = true;
        transparent = true;
        themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css" ];
        enabledThemes = [ ];
        plugins = {
          ignoreActivities = {
            enable = true;
            ignorePlaying = true;
            ignoreWatching = true;
          };
          betterFolders.enable = true;
          betterUploadButton.enable = true;
        };
      };
    };
  };
}
