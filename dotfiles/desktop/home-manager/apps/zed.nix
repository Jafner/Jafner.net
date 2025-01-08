{ ... }: {
  programs.zed-editor = {
    # https://mynixos.com/home-manager/options/programs.zed-editor
    enable = true;
    extensions = [ "Nix" "Catppuccin" ];
    userSettings = {
      languages."Nix" = {
        "language_servers" = [ "!nil" "nixd" ];
        "tab_size" = 2;
      };
      theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Mocha";
      };
      terminal = {
        # using bash as a workaround.
        # zsh in the integrated terminal misbehaves.
        # seems to render multiple characters with every keystroke (incl. backspace)
        shell = { program = "bash"; };
      };
    };
  };
}
