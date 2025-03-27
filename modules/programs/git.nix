{ pkgs, config, ... }: let cfg = config.modules.programs.git; in {
  options = with pkgs.lib; {
    modules.programs.git = {
      enable = mkEnableOption "Git";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      realname = mkOption {
        type = types.str;
        default = null;
        description = "Name to use in `git config user.name`";
        example = "John Nixos";
      };
      email = mkOption {
        type = types.str;
        default = null;
        description = "Name to use in `git config user.email`";
        example = "john@example.com";
      };
      sshPrivateKeyPath = mkOption {
        type = types.str;
        default = ".ssh/id_ed_25519";
        description = "Path to private key to use for age. Relative to home of primary user.";
        example = ".ssh/me@example.tld";
      };
      sshPublicKeyPath = mkOption {
        type = types.str;
        default = "${cfg.sshPrivateKeyPath}.pub";
        description = "Path to public key to use in `git config user.signingKey`. Relative to home of primary user.";
        example = ".ssh/key.pub";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    home-manager.users.${cfg.username}.programs.git = {
      enable = true;
      userName = "${cfg.realname}";
      userEmail = "${cfg.email}";
      extraConfig = {
        init.defaultBranch = "main";
        core.sshCommand = "ssh -i $HOME/${cfg.sshPrivateKeyPath}";
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
        user.signingKey = "${cfg.sshPublicKeyPath}";
      };
      delta.enable = true;
      delta.options.side-by-side = true;
    };
  };
}
