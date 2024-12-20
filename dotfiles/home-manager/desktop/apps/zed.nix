{ ... }: {
  programs.zed-editor = {
    # https://mynixos.com/home-manager/options/programs.zed-editor
    enable = true;
    extensions = [ "Nix" "Catppuccin" ];
    userSettings = {
      languages."Nix"."language_servers" = [ "!nil" "nixd" ];
      theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Mocha";
      };
    };
  };
}
