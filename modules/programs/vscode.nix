{ pkgs, config, ... }:
let
  cfg = config.modules.programs.vscode;
in
{
  options = with pkgs.lib; {
    modules.programs.vscode = {
      enable = mkEnableOption "vscode";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [
        nixd
        sops
      ];
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          signageos.signageos-vscode-sops
          adzero.vscode-sievehighlight
        ];
        userSettings = {
          "editor.fontFamily" = pkgs.lib.mkDefault "'DejaVu Sans Mono'"; # Potentially collides with Stylix
          "nix.serverPath" = "nixd";
          "nix.enableLanguageServer" = true;
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmDelete" = false;
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;
          "security.workspace.trust.untrustedFiles" = "open";
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "terminal.integrated.fontFamily" = pkgs.lib.mkDefault "'DejaVu Sans Mono'"; # Potentially collides with Stylix
          "terminal.integrated.profiles.linux.zsh.path" = "/usr/bin/zsh";
          "diffEditor.maxComputationTime" = 0;
        };
      };
    };
  };
}
